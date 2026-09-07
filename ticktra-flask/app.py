"""Ticktra Flask backend.

Serves the React (Babel, in-browser) frontend from templates/index.html
and provides a small JSON API backed by SQLite for auth and tickets.

Run:
    pip install -r requirements.txt
    python app.py
Then open http://127.0.0.1:5000
"""
import os
from datetime import timedelta

from flask import Flask, request, jsonify, session, send_from_directory

from models import db, User, Ticket, TicketMessage, KBArticle

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

app = Flask(__name__)
app.config["SECRET_KEY"] = os.environ.get("SECRET_KEY", "dev-secret-change-me")
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///" + os.path.join(BASE_DIR, "ticktra.db")
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.permanent_session_lifetime = timedelta(days=7)

db.init_app(app)


# ── helpers ──────────────────────────────────────────────────────────────
def current_user():
    uid = session.get("user_id")
    return User.query.get(uid) if uid else None


def next_ticket_id():
    count = Ticket.query.count()
    return f"TKT-{count + 1:03d}"


# ── seed data (first run only) ──────────────────────────────────────────
def seed():
    if User.query.first():
        return  # already seeded

    demo_password = "password123"

    admin = User(name="Priya Nair", email="priya.nair@acme.co.uk", role="Admin", dept="IT")
    admin.set_password(demo_password)

    agent = User(name="Alex Martinez", email="alex.martinez@acme.co.uk", role="Agent", dept="IT")
    agent.set_password(demo_password)

    sarah = User(name="Sarah Chen", email="sarah.chen@acme.co.uk", role="End User", dept="Finance")
    sarah.set_password(demo_password)

    db.session.add_all([admin, agent, sarah])
    db.session.commit()

    t1 = Ticket(id="TKT-001", title="Cannot access Outlook — locked out",
                category="Account Lockout", status="resolved", priority="P1",
                user_id=sarah.id, assigned="Alex M.")
    t1.messages = [
        TicketMessage(frm="user", name="Sarah Chen",
                      text="I've been locked out of Outlook since this morning. Can't access any emails."),
        TicketMessage(frm="agent", name="Alex M.",
                      text="Hi Sarah, I can see your account hit the failed login threshold. Resetting it now."),
        TicketMessage(frm="user", name="Sarah Chen", text="That worked, thank you!"),
    ]

    t2 = Ticket(id="TKT-002", title="Access request — SharePoint project site",
                category="Access Request", status="open", priority="P2", user_id=sarah.id)
    t2.messages = [
        TicketMessage(frm="user", name="Sarah Chen",
                      text="I need read access to the Q3 Planning SharePoint site."),
    ]

    db.session.add_all([t1, t2])

    kb_seed = [
        ("How to reset your Microsoft 365 password", "Account Access", 248, 94),
        ("Unlock your account after too many failed logins", "Account Access", 189, 91),
        ("Requesting access to a SharePoint site", "Account Access", 142, 88),
        ("Setting up Outlook on a new device", "Software", 312, 96),
        ("Connecting to the VPN from outside the office", "Software", 201, 89),
        ("Onboarding IT checklist for new starters", "Onboarding", 527, 97),
        ("Setting up MFA on your account", "Account Access", 410, 95),
    ]
    for title, cat, reads, helpful in kb_seed:
        db.session.add(KBArticle(title=title, cat=cat, reads=reads, helpful=helpful))

    db.session.commit()


# ── page ─────────────────────────────────────────────────────────────────
@app.route("/")
def index():
    # Served as a raw static file, NOT through Jinja: the JSX inside uses
    # `{{ }}` constantly for inline styles (e.g. style={{color:'red'}}),
    # which would collide with Jinja's own `{{ }}` template syntax. Data is
    # fetched separately by the browser from /api/bootstrap instead.
    return send_from_directory(app.static_folder, "index.html")


@app.get("/api/bootstrap")
def bootstrap():
    user = current_user()
    return jsonify({
        "tickets": [t.to_dict() for t in Ticket.query.order_by(Ticket.created.desc()).all()],
        "kb_articles": [k.to_dict() for k in KBArticle.query.all()],
        "users": [u.to_dict() for u in User.query.all()],
        "current_user": user.to_dict() if user else None,
    })


# ── auth ────────────────────────────────────────────────────────────────
@app.post("/api/auth/signup")
def signup():
    data = request.get_json(force=True) or {}
    name, email, company, password = data.get("name"), data.get("email"), data.get("company"), data.get("password")

    if not name or not email or not password or len(password) < 6:
        return jsonify({"error": "Please fill in all required fields (password min 6 chars)."}), 400
    if User.query.filter_by(email=email).first():
        return jsonify({"error": "An account with that email already exists."}), 409

    user = User(name=name, email=email, company=company, role="End User")
    user.set_password(password)
    db.session.add(user)
    db.session.commit()

    session.permanent = True
    session["user_id"] = user.id
    return jsonify({"user": user.to_dict()}), 201


@app.post("/api/auth/login")
def login():
    data = request.get_json(force=True) or {}
    email, password = data.get("email"), data.get("password")
    user = User.query.filter_by(email=email).first()

    if not user or not user.check_password(password):
        return jsonify({"error": "Invalid email or password."}), 401

    session.permanent = True
    session["user_id"] = user.id
    return jsonify({"user": user.to_dict()})


@app.post("/api/auth/logout")
def logout():
    session.clear()
    return jsonify({"ok": True})


@app.get("/api/me")
def me():
    user = current_user()
    return jsonify({"user": user.to_dict() if user else None})


# ── tickets ─────────────────────────────────────────────────────────────
@app.get("/api/tickets")
def list_tickets():
    user = current_user()
    if not user:
        return jsonify({"error": "Not signed in."}), 401

    query = Ticket.query
    if user.role == "End User":
        query = query.filter_by(user_id=user.id)
    tickets = query.order_by(Ticket.created.desc()).all()
    return jsonify({"tickets": [t.to_dict() for t in tickets]})


@app.post("/api/tickets")
def create_ticket():
    user = current_user()
    if not user:
        return jsonify({"error": "Not signed in."}), 401

    data = request.get_json(force=True) or {}
    title = data.get("title")
    if not title:
        return jsonify({"error": "Title is required."}), 400

    ticket = Ticket(id=next_ticket_id(), title=title, category=data.get("cat", "Other"),
                     status="open", priority="P2", user_id=user.id)
    ticket.messages = [TicketMessage(frm="user", name=user.name, text=data.get("desc") or title)]
    db.session.add(ticket)
    db.session.commit()
    return jsonify({"ticket": ticket.to_dict()}), 201


@app.post("/api/tickets/<ticket_id>/messages")
def add_message(ticket_id):
    user = current_user()
    if not user:
        return jsonify({"error": "Not signed in."}), 401

    ticket = Ticket.query.get_or_404(ticket_id)
    text = (request.get_json(force=True) or {}).get("text", "").strip()
    if not text:
        return jsonify({"error": "Message text is required."}), 400

    frm = "agent" if user.role in ("Agent", "Admin") else "user"
    db.session.add(TicketMessage(ticket_id=ticket.id, frm=frm, name=user.name, text=text))
    db.session.commit()
    return jsonify({"ticket": ticket.to_dict()})


@app.post("/api/tickets/<ticket_id>/resolve")
def resolve_ticket(ticket_id):
    ticket = Ticket.query.get_or_404(ticket_id)
    ticket.status = "resolved"
    db.session.commit()
    return jsonify({"ticket": ticket.to_dict()})


# ── knowledge base / users (read-only for now) ───────────────────────────
@app.get("/api/kb")
def list_kb():
    return jsonify({"articles": [k.to_dict() for k in KBArticle.query.all()]})


@app.get("/api/users")
def list_users():
    user = current_user()
    if not user or user.role != "Admin":
        return jsonify({"error": "Admin access required."}), 403
    return jsonify({"users": [u.to_dict() for u in User.query.all()]})


with app.app_context():
    db.create_all()
    seed()

if __name__ == "__main__":
    app.run(debug=True)

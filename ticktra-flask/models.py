"""SQLAlchemy models for Ticktra."""
from datetime import datetime, timedelta
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash

db = SQLAlchemy()


class User(db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    company = db.Column(db.String(120))
    dept = db.Column(db.String(80), default="—")
    role = db.Column(db.String(20), default="End User")  # End User | Agent | Admin
    status = db.Column(db.String(20), default="Active")  # Active | Invited | Disabled
    password_hash = db.Column(db.String(255), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def to_dict(self):
        return {
            "name": self.name,
            "email": self.email,
            "role": self.role,
            "dept": self.dept,
            "lastActive": "Just now",
            "status": self.status,
        }


class Ticket(db.Model):
    __tablename__ = "tickets"

    id = db.Column(db.String(20), primary_key=True)  # e.g. TKT-001
    title = db.Column(db.String(255), nullable=False)
    category = db.Column(db.String(80), default="Other")
    status = db.Column(db.String(20), default="open")  # open | in-progress | resolved
    priority = db.Column(db.String(5), default="P2")
    created = db.Column(db.DateTime, default=datetime.utcnow)
    sla = db.Column(db.DateTime, default=lambda: datetime.utcnow() + timedelta(hours=4))
    assigned = db.Column(db.String(120), nullable=True)

    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    user = db.relationship("User", backref="tickets")

    messages = db.relationship(
        "TicketMessage", backref="ticket", order_by="TicketMessage.time", cascade="all, delete-orphan"
    )

    def to_dict(self):
        return {
            "id": self.id,
            "title": self.title,
            "category": self.category,
            "status": self.status,
            "priority": self.priority,
            "created": self.created.isoformat() + "Z",
            "sla": self.sla.isoformat() + "Z",
            "user": {"name": self.user.name, "dept": self.user.dept},
            "assigned": self.assigned,
            "messages": [m.to_dict() for m in self.messages],
        }


class TicketMessage(db.Model):
    __tablename__ = "ticket_messages"

    id = db.Column(db.Integer, primary_key=True)
    ticket_id = db.Column(db.String(20), db.ForeignKey("tickets.id"), nullable=False)
    frm = db.Column("from", db.String(10), default="user")  # user | agent
    name = db.Column(db.String(120))
    time = db.Column(db.DateTime, default=datetime.utcnow)
    text = db.Column(db.Text)

    def to_dict(self):
        return {
            "from": self.frm,
            "name": self.name,
            "time": self.time.strftime("%H:%M"),
            "text": self.text,
        }


class KBArticle(db.Model):
    __tablename__ = "kb_articles"

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), nullable=False)
    cat = db.Column(db.String(80))
    reads = db.Column(db.Integer, default=0)
    helpful = db.Column(db.Integer, default=0)

    def to_dict(self):
        return {"id": self.id, "title": self.title, "cat": self.cat, "reads": self.reads, "helpful": self.helpful}

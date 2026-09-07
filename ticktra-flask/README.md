# Ticktra — Flask edition

Same UI you already had (React via Babel, in `static/index.html`), now
backed by a real Flask + SQLite API instead of hardcoded JS data.

## Run it

```bash
pip install -r requirements.txt
python app.py
```

Open http://127.0.0.1:5000

A `ticktra.db` SQLite file is created and seeded automatically on first run
with 3 demo accounts (password for all: `password123`):

| Email                         | Role     |
|-------------------------------|----------|
| priya.nair@acme.co.uk         | Admin    |
| alex.martinez@acme.co.uk      | Agent    |
| sarah.chen@acme.co.uk         | End User |

Or sign up as a brand-new user from the landing page — that goes through
the real `/api/auth/signup` endpoint and is stored in the database.

## What's real now vs. still a demo

**Real (persisted in SQLite):**
- Sign up / sign in / sign out (hashed passwords, sessions)
- Ticket creation, replies, and closing (End User portal)
- Ticket + KB + user lists on page load (`GET /api/bootstrap`)

**Still a front-end-only demo** (not wired to the backend — would be the
next things to build):
- Agent inbox / ticket assignment actions
- Admin analytics, integrations, settings pages
- "Continue with Microsoft" button (labelled as a demo bypass)

## Files

- `app.py` — Flask app, all routes
- `models.py` — SQLAlchemy models (User, Ticket, TicketMessage, KBArticle)
- `static/index.html` — the frontend (unchanged UI, data now comes from the API)
- `requirements.txt` — Flask + Flask-SQLAlchemy

## Why the frontend loads data via `/api/bootstrap` instead of Jinja

The JSX in `index.html` uses `{{ }}` constantly for inline styles
(`style={{color:'red'}}`), which collides with Jinja's own `{{ }}`
delimiters. Rather than fight that, the page is served as a static file
and fetches its data separately in JS.

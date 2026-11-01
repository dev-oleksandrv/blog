---
status: draft
date: 2026-11-01
verified-against: none
---

# System map

The whole of this document is proposed: no code exists yet, so nothing here is implemented. It
follows the stack of [ADR-0001](../decisions/0001-typescript-nextjs-neon-postgres-stack.md) and
serves the [requirements](../requirements/blog.md).

## Components

| Component | Proposed location | Owns | Serves |
| --- | --- | --- | --- |
| Public site | `src/app/` routes outside `admin/`: index, post by slug, tag page, feed, sitemap | rendering of published posts for readers | REQ-001, REQ-002, REQ-005, REQ-006, REQ-007 |
| Admin UI | `src/app/admin/` | the author's screens and actions to create, edit, publish, and unpublish posts | REQ-004 |
| Auth | `src/auth/` | GitHub sign-in through Auth.js and the check against `ADMIN_GITHUB_LOGIN` | REQ-003 |
| Posts domain | `src/lib/` | the rules about posts and tags: what is published, ordering, slugs | REQ-001 to REQ-007 |
| Data access | `src/db/` | the Drizzle schema, migrations, and the database client: Neon when deployed, PGlite in development and tests | storage for all |

## Dependency rules (proposed)

- Routes in `src/app/` call the posts domain and auth; they do not query the database directly.
- The posts domain depends on data access through functions it defines, so unit tests give it
  in-memory data or PGlite.
- Nothing outside `src/auth/` reads the auth settings.

Enforced by: none yet. A project check in `scripts/checks.d/` that enforces these rules is an
open question for when the code exists.

## Runtime

Proposed: one Next.js app deployed to Vercel; Postgres on Neon; GitHub as the OAuth provider.
Settings, by name only: `DATABASE_URL`, `AUTH_SECRET`, `AUTH_GITHUB_ID`, `AUTH_GITHUB_SECRET`,
`ADMIN_GITHUB_LOGIN`, `SITE_URL`.

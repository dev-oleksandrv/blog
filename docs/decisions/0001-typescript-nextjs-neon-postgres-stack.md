---
status: accepted
date: 2026-11-01
decision-makers: dev-oleksandrv (owner)
scope: stack
summary: "In the context of a personal blog with one author, an admin UI, and hosting on Vercel, facing the choice of language, framework, storage, and sign-in, we decided TypeScript with Next.js, Postgres on Neon through Drizzle ORM, and Auth.js with GitHub OAuth for one allowed account, and rejected SvelteKit, Astro, Prisma, SQLite on Turso, password sign-in, and Better Auth, to achieve one typed codebase native to Vercel without stored passwords, accepting a dependency on Neon and GitHub and the size of Next.js."
supersedes: []
---

# TypeScript, Next.js, Postgres on Neon with Drizzle, and Auth.js with GitHub

## Context and Problem Statement

acme is a server-rendered blog with public pages and an admin UI for one author
([requirements](../requirements/blog.md)), deployed to Vercel. Language, framework, storage, and
the sign-in model are costly to reverse once posts and code depend on them. The owner chose them
in the `afe-init` interview on 2026-11-01, from options with one-line reasons proposed there; the
reasons below are those proposals, chosen by the owner. Components and boundaries:
[system map](../architecture/system-map.md).

## Considered Options

* TypeScript with Next.js (App Router), on Node.js 24 LTS, with pnpm
* TypeScript with SvelteKit
* TypeScript with Astro
* Storage: Postgres on Neon with Drizzle ORM; Postgres on Neon with Prisma; SQLite or libSQL on
  Turso with Drizzle
* Sign-in: Auth.js with GitHub OAuth and an allowlist of one account; email and password with an
  argon2 hash; Better Auth

## Decision Outcome

Chosen option: "TypeScript with Next.js, Postgres on Neon with Drizzle, and Auth.js with GitHub
OAuth", because Next.js is Vercel's native framework and keeps server rendering, route handlers,
and the admin UI in one app; Neon is serverless Postgres from the Vercel marketplace; Drizzle
gives typed queries and SQL migrations; and GitHub sign-in stores no password, while the
allowlist lets only the configured account in (REQ-003). Local development and tests use PGlite,
Postgres compiled to WebAssembly and run inside Node.js, so no database server is installed and
tests stay offline. Tools: Vitest, ESLint, Prettier, `tsc --noEmit`, and Playwright for
end-to-end tests once the project leaves the starting stage.

Rejected: SvelteKit, a lighter runtime but not the owner's choice; Astro, content-first but the
admin UI needs more custom work; Prisma, heavier at build time with a generated client; SQLite on
Turso, smaller but not Postgres; email and password, which makes acme store a hash and own
password reset; Better Auth, newer and not the owner's choice.

### Consequences

* Good, because one language and one app cover the public site, the admin UI, and the data
  access, and the deployment target supports the framework without adapters.
* Good, because no password is stored and only one GitHub account can sign in.
* Bad, because the site depends on Neon for storage and on GitHub for sign-in.
* Bad, because PGlite in development and Neon in deployment are different Postgres runtimes;
  a behaviour that differs between them is caught only outside the unit tests.
* Not decided: the Auth.js version. On 2026-11-01 `next-auth@5` is published only as a beta
  (`5.0.0-beta.32`) and the latest stable is `4.24.15`; it is chosen with REQ-003.

### Confirmation

`package.json` and its lock file name Next.js, TypeScript, and the tools above, and
`scripts/check.sh` runs the formatter check, the linter, the type checker, and the unit tests.
Not checked yet: the storage and sign-in packages arrive with the first change that implements
REQ-001 to REQ-004 and REQ-003; the review of that change confirms them.

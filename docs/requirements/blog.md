# Blog requirements

What acme must do in its first version: a personal blog with one author and public readers
without accounts. The key words MUST, MUST NOT, SHOULD, and MAY are used as in RFC 2119. These
are requirements, not a claim that anything is built; the stack that implements them is
[ADR-0001](../decisions/0001-typescript-nextjs-neon-postgres-stack.md), and the components are in
the [system map](../architecture/system-map.md).

Each acceptance criterion names the check that will establish it. Unit tests run with Vitest
under `scripts/checks.d/30-test.sh` once that check exists; end-to-end tests with Playwright are
added when the project leaves the starting stage.

## REQ-001: Readers see the list of published posts

The public index page MUST list every published post, newest first by publication time, and
MUST NOT list drafts.

- status: approved
- source: owner, afe-init, 2026-11-01
- verification: unit test

Acceptance criteria:

- AC-01: Given published posts with different publication times, when a reader opens the index,
  then the posts appear newest first. Check: unit test.
- AC-02: Given a draft post, when a reader opens the index, then the draft is not listed. Check:
  unit test.
- AC-03: Given no published posts, when a reader opens the index, then the page shows an empty
  list, not an error. Check: unit test.

## REQ-002: Readers read a single post

Each published post MUST have its own public page, addressed by its slug, that shows its title
and its body rendered from Markdown.

- status: approved
- source: owner, afe-init, 2026-11-01
- verification: unit test

Acceptance criteria:

- AC-04: Given a published post, when a reader opens its slug, then the page shows the post's
  title and rendered body. Check: unit test.
- AC-05: Given the slug of a draft or of no post, when a reader opens it, then the response is
  not found (HTTP 404). Check: unit test.

## REQ-003: Only the author signs in to the admin UI

The admin UI MUST be reachable only by a session signed in with GitHub as the account named in
the `ADMIN_GITHUB_LOGIN` setting. Every other visitor and every other GitHub account MUST be
denied.

- status: approved
- source: owner, afe-init, 2026-11-01 (the owner chose an admin UI with GitHub sign-in limited
  to one account)
- verification: unit test

Acceptance criteria:

- AC-06: Given a session of the GitHub account named in `ADMIN_GITHUB_LOGIN`, when it opens the
  admin UI, then access is granted. Check: unit test.
- AC-07: Given a session of any other GitHub account, when it signs in, then sign-in is refused
  and the admin UI is not shown. Check: unit test.
- AC-08: Given no session, when a visitor opens any admin page or admin action, then access is
  denied and nothing changes. Check: unit test.

## REQ-004: The author writes and publishes posts

In the admin UI the author MUST be able to create a post with a title, a slug, tags, and a body
in Markdown; edit it; save it as a draft; publish it; and unpublish it, which makes it a draft
again.

- status: approved
- source: owner, afe-init, 2026-11-01
- verification: unit test

Acceptance criteria:

- AC-09: Given the signed-in author, when they save a new post without publishing, then it is
  stored as a draft and is not visible to readers. Check: unit test.
- AC-10: Given a draft, when the author publishes it, then it is visible to readers under its
  slug and in the index. Check: unit test.
- AC-11: Given a published post, when the author unpublishes it, then readers no longer see it.
  Check: unit test.
- AC-12: Given an existing post, when the author edits its title, body, or tags and saves, then
  readers see the new version. Check: unit test.
- AC-13: Given a slug that another post already uses, when the author saves, then the save is
  rejected with a message and nothing is stored. Check: unit test.

## REQ-005: Posts carry tags

A post MAY carry tags. A public page per tag MUST list the published posts with that tag, newest
first.

- status: approved
- source: owner, afe-init, 2026-11-01
- verification: unit test

Acceptance criteria:

- AC-14: Given published posts with and without a tag, when a reader opens that tag's page,
  then only the published posts with the tag are listed, newest first. Check: unit test.

## REQ-006: A feed of published posts

The site MUST publish a feed of its published posts that feed readers can subscribe to, with
absolute links built from the `SITE_URL` setting.

- status: approved
- source: owner, afe-init, 2026-11-01
- verification: unit test

Acceptance criteria:

- AC-15: Given published posts and drafts, when the feed is requested, then it contains exactly
  the published posts, newest first, each with its title, absolute link, and publication date.
  Check: unit test.
- AC-16: Given a post title with characters special in XML (`&`, `<`), when the feed is
  generated, then the feed is well-formed XML. Check: unit test.

## REQ-007: Search engines can index the site

Each published post page MUST carry a title and a description in its metadata, and the site
MUST publish a sitemap that lists the index, every published post, and every tag page, with
absolute URLs built from `SITE_URL`.

- status: approved
- source: owner, afe-init, 2026-11-01
- verification: unit test

Acceptance criteria:

- AC-17: Given a published post, when its page metadata is built, then it has the post's title
  and a description. Check: unit test.
- AC-18: Given published posts and drafts, when the sitemap is built, then it lists the index,
  every published post, and every tag page, and no draft. Check: unit test.

## Open questions

- OQ-1: Feed format: RSS 2.0, Atom, or both (REQ-006). Not decided.
- OQ-2: Whether the index and tag pages paginate, and how many posts per page (REQ-001,
  REQ-005). Not decided.
- OQ-3: Whether the author can delete a post, beyond unpublishing it (REQ-004). Not decided.
- OQ-4: Where a post's description comes from: a field the author writes, or an excerpt of the
  body (REQ-007). Not decided.
- OQ-5: Whether the slug is derived from the title or always typed by the author, and which
  characters it allows (REQ-002, REQ-004). Not decided.
- OQ-6: What a tag page returns when no published post carries the tag: not found or an empty
  list (REQ-005). Not decided.
- OQ-7: Which other fields a post page shows, such as the publication date and the tags
  (REQ-002). Not decided.

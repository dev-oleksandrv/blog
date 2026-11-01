import { describe, expect, it } from "vitest";

import { listPublishedPosts, type Post } from "./posts";

const post = (slug: string, publishedAt: string | null): Post => ({
  slug,
  title: `Title of ${slug}`,
  publishedAt: publishedAt === null ? null : new Date(publishedAt),
});

describe("REQ-001: readers see the list of published posts", () => {
  it("AC-01: lists published posts newest first by publication time", () => {
    const posts = [
      post("middle", "2026-02-01T00:00:00Z"),
      post("oldest", "2026-01-01T00:00:00Z"),
      post("newest", "2026-03-01T00:00:00Z"),
    ];

    expect(listPublishedPosts(posts).map((p) => p.slug)).toEqual([
      "newest",
      "middle",
      "oldest",
    ]);
  });

  it("AC-02: does not list drafts", () => {
    const posts = [
      post("draft", null),
      post("published", "2026-01-01T00:00:00Z"),
    ];

    expect(listPublishedPosts(posts).map((p) => p.slug)).toEqual(["published"]);
  });

  it("AC-03: gives an empty list when no post is published", () => {
    expect(listPublishedPosts([])).toEqual([]);
    expect(listPublishedPosts([post("draft", null)])).toEqual([]);
  });

  it("AC-01: keeps posts of the same publication time in their given order", () => {
    const posts = [
      post("first", "2026-01-01T00:00:00Z"),
      post("second", "2026-01-01T00:00:00Z"),
    ];

    expect(listPublishedPosts(posts).map((p) => p.slug)).toEqual([
      "first",
      "second",
    ]);
  });

  it("AC-01: does not change the list it is given", () => {
    const posts = [
      post("older", "2026-01-01T00:00:00Z"),
      post("newer", "2026-02-01T00:00:00Z"),
    ];

    listPublishedPosts(posts);

    expect(posts.map((p) => p.slug)).toEqual(["older", "newer"]);
  });
});

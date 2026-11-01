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

  it("AC-01: orders by the instant, not the written time, across time zones", () => {
    const posts = [
      post("earlier", "2026-01-01T01:00:00+02:00"),
      post("later", "2026-01-01T00:00:00Z"),
    ];

    expect(listPublishedPosts(posts).map((p) => p.slug)).toEqual([
      "later",
      "earlier",
    ]);
  });

  it("AC-02: does not list drafts", () => {
    const posts = [
      post("draft", null),
      post("published", "2026-01-01T00:00:00Z"),
    ];

    expect(listPublishedPosts(posts).map((p) => p.slug)).toEqual(["published"]);
  });

  it.each([
    { name: "no posts", posts: [] },
    { name: "only drafts", posts: [post("draft", null)] },
  ])("AC-03: gives an empty list for $name", ({ posts }) => {
    expect(listPublishedPosts(posts)).toEqual([]);
  });
});

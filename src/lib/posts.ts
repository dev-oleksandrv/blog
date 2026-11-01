/** A blog post; `publishedAt` is null while the post is a draft. */
export type Post = {
  slug: string;
  title: string;
  publishedAt: Date | null;
};

type PublishedPost = Post & { publishedAt: Date };

/**
 * The posts readers see on the index (REQ-001): only published posts, newest first by
 * publication time. Posts published at the same time keep their given order.
 */
export function listPublishedPosts(posts: readonly Post[]): PublishedPost[] {
  return posts
    .filter((post): post is PublishedPost => post.publishedAt !== null)
    .toSorted((a, b) => b.publishedAt.getTime() - a.publishedAt.getTime());
}

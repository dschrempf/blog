# Social preview image

Status: **open**. Blocked on making the actual image; the wiring is already done
(see `.ai/done/02-seo-meta.md`).

## What this is

The image a chat app, Mastodon client, or search result shows next to a link to
the site — the `og:image` / `twitter:image` card. Without one, a shared post
renders as a bare title and description; with one it gets a picture roughly the
width of the message. It is not a favicon and not part of the page: it is only
ever seen *outside* the site, in someone else's timeline or inbox.

## What such an image usually shows

Enough to identify the source at a glance, at thumbnail size:

- the site name (here: `Concept → IO ()`), set large — it is often displayed
  ~300 px wide, so body-copy-sized text is unreadable;
- the author name and/or an avatar;
- optionally the tagline, or a hint of the topic (Linux/Emacs/Haskell);
- a flat background — busy photos fight with the overlaid text.

Keep the important content away from the edges. Some clients crop to a square or
to 2:1, and Mastodon may show it letterboxed.

## Constraints

- 1200×630 px (1.91:1). This is what Open Graph consumers expect and what
  `summary_large_image` Twitter cards want.
- PNG (or JPEG). Scraper support for WebP/AVIF is uneven.
- Under ~1 MB, so slow scrapers don't give up.

## Wiring it up

1. Put the file in **both** `org/static/` and `hugo/static/` — they mirror each
   other for static assets.
2. Uncomment in `hugo/config.toml` under `[params]`:
   `images = ["og-image.png"]`
3. Rebuild and check `<meta property="og:image">` resolves to an absolute URL.
   `head-seo.html` switches the Twitter card to `summary_large_image` on its own
   once the param is set.

Per-post images work too — the partial prefers a page's own `images` over the
site default. From Org that is
`#+hugo_custom_front_matter: :images '("some-image.png")`. Only worth it for
posts with a strong lead image.

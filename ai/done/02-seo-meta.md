# Skeria — SEO and social metadata

Status: **done**. All of `<head>`'s metadata now lives in one partial,
`layouts/partials/head-seo.html`, which `baseof.html` includes. Title,
description, keywords, canonical URL, feed discovery, Open Graph, Twitter cards
and JSON-LD all derive from the same handful of variables computed at the top of
that partial, so each fact is stated once per page.

## What was implemented

1. **Open Graph + Twitter cards** — hand-written rather than via
   `_internal/opengraph.html` / `_internal/twitter_cards.html`. The internal
   templates fall back to `.Description | default .Summary` with no site-wide
   default, so the home page and every section list page (`/linux/`, `/coding/`,
   …) would have shipped with no `og:description` at all — none of them have a
   description of their own. Writing it out reuses the existing
   `defaultDescription` fallback and adds `article:published_time`,
   `article:modified_time`, `article:section` and `article:tag` for posts.
2. **Canonical URL** — `<link rel="canonical" href="{{ .Permalink }}">`.
3. **Feed auto-discovery** — plus the actual bug behind it: `[outputs].home` was
   `["HTML", "JSON"]`, which *overrides* Hugo's default `["HTML", "RSS"]`, so
   `/index.xml` was never generated. Section feeds existed, the site feed did
   not, and the RSS icon in `icons.html` hard-coded a link to the missing
   `/index.xml`. Fixed by adding RSS back to `home`, setting `rss = true`, and
   deriving both the `<head>` link and the icon's `href` from the RSS output
   format instead of a literal path.
   The `.AlternativeOutputFormats` snippet originally proposed here would also
   have advertised `index.json` — the search index — as a feed alternate, so the
   partial asks for `rss` by name and falls back to the home feed on pages that
   have none.
4. **`keywords` meta** — kept. Every Org post already sets `#+keywords`, the tag
   costs a few dozen bytes, and dropping it would gain nothing measurable.
5. **JSON-LD** — written by hand as well. `_internal/schema.html` emits microdata
   (`<meta itemprop>`), not JSON-LD, and does so in `<head>` with no enclosing
   `itemscope`, which makes it inert. The partial emits a real `WebSite` object
   on the home page and `BlogPosting` on each post, built with `dict` + `jsonify`
   so escaping is Hugo's problem, not ours.

## Fixed along the way

- `<html lang>` was hard-coded `en-us` while `config.toml` carried an unused
  `locale = "en-us"`. Both now come from `locale = "en-US"`, which also feeds
  `og:locale` (`en_US`). Note `locale` is current and `languageCode` is the
  deprecated spelling as of Hugo 0.158 — the opposite of what one would guess.
- `theme.toml` `min_version` raised 0.128.0 → 0.158.0, since the partial uses
  `.Language.Locale`.
- Theme README's config example listed `[author]` at the root, but the theme
  reads `.Site.Params.author.name`. Corrected, and the new params documented.

## Still open

- **No social preview image.** Open Graph and Twitter cards work without one, but
  shared links get a plain text preview. The plumbing is in place — `images` in
  front matter or under `[params]` (first entry wins, bare string accepted), and
  the Twitter card type switches to `summary_large_image` when set. It needs an
  actual ~1200×630 image; the config line is commented out until then.
- **`robots.txt`.** Not generated. `enableRobotsTXT = true` plus a template
  pointing at `/sitemap.xml` would help crawler discovery a little. Low value
  given the sitemap is already linked from Search Console-style tooling.
- **`/search/` is indexable.** The search page has no content of its own; a
  `noindex` robots meta for it would be tidier.

# Skeria — Documentation and config drift

Status: **proposed**. Low-risk doc fixes, grouped separately because they're
about the theme's `README.md` / examples rather than the live site.

## 1. README config example is stale

`README.md` "Configuration" section drifts from current Hugo and from the
theme's actual code:

- `disqusShortname` / `MetaDataFormat` — Disqus isn't used anywhere in the
  layouts; remove from the example.
- `paginate = 30` (Tips section) — replaced by the `[pagination] pagerSize`
  block, which the example itself already uses elsewhere. The Tips note
  contradicts the example.
- `googleplus` and `flattr` params — both services are dead and have now been
  removed from `partials/icons.html`. Drop from the README too.
- **Param name mismatch**: the README documents `privacyPolicy`, but
  `partials/footer.html` reads `.Site.Params.privacyNotice` (and the live
  `config.toml` uses `privacyNotice`). The documented name doesn't work.
  Align the README on `privacyNotice`.

## 2. README "Usage" layout note

The example layout tree and the "`menu = "main"` in front matter" tip predate
the current menu setup (the live site defines `menu.main` in `config.toml` and
`menu.about` / `menu.search` in page front matter, all rendered by
`partials/menus-topbar.html`). Worth a refresh so new users aren't misled.

## 3. theme.toml

- `min_version` was `0.14` (ancient); bumped to `0.128.0` in the safe-fix
  commits because the theme relies on the `[pagination]` config block. Revisit
  if any newer feature is adopted (e.g. asset fingerprinting → no extra floor,
  but class-based Chroma styles are fine on old versions too).
- `licenselink = "https://github.com/dschrempf/skeria/LICENSE"` is missing the
  `/blob/master/` path segment, so it 404s. Should be
  `.../skeria/blob/master/LICENSE`.

## 4. README external-libraries list

Lists MathJax, FontAwesome, jQuery, Fuse, Mark. If the search rewrite in
`04-search-modernization.md` lands and drops jQuery, update this list and the
`LICENSE-JQuery` reference accordingly.

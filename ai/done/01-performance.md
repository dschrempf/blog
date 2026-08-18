# Skeria — Performance improvements

Status: **implemented** (2026-06-11) in the Skeria theme — see
`layouts/_default/baseof.html` and `layouts/_default/search.html`.

Implementation notes:

- **1.** Took Option B (auto-detect, zero authoring overhead). The delimiter set
  was corrected to match MathJax's own defaults: `\(` (inlineMath), `\[` and
  `$$` (displayMath), **and** `\begin{` — because `processEnvironments` defaults
  to `true`, so MathJax renders bare LaTeX environments outside delimiters, and
  this blog's display math is written as `\begin{align}…\end{align}` (not
  `\[…\]`). Scanning `.Content` (the rendered HTML MathJax actually runs on) for
  these four triggers makes detection exactly as wide as MathJax's behaviour: a
  page loads MathJax iff MathJax would have something to do. Verified: exactly
  the 4 math posts load it; all other pages skip it.
- **2.** CSS/JS moved from `static/` to `assets/` and fingerprinted with SRI.
  `skeria.css` + `fonts.css` are concatenated into `css/skeria.bundle.css`
  (kept under `/css/` so `fonts.css`'s `../webfonts/` URLs still resolve).
  `font.awesome…css`, `mathjax…js`, and the search JS are fingerprinted too.
  `webfonts/` stays in `static/` (referenced by relative URL from the CSS).
- **3.** Inter + Lora (normal) woff2 are preloaded in `<head>`.

## 1. Load MathJax only on pages that need it (biggest win)

`layouts/_default/baseof.html` loads the full MathJax tex-svg bundle
(`js/mathjax.4.0.0.tex-svg.min.js`, ~1 MB) on **every** page via an
unconditional `<script>`. Most pages (home, lists, about, the majority of
posts) contain no math, so this is wasted bandwidth and parse time on nearly
every request.

### Option A — gate on a page param

Set a front-matter flag only on posts that use math. In ox-hugo this is a
header keyword, e.g.:

```org
#+hugo_custom_front_matter: :math true
```

Then in `baseof.html`, wrap the MathJax `<script>` block:

```go-html-template
{{ if .Params.math }}
  <script>MathJax = { /* ... */ };</script>
  <script src="{{ "js/mathjax.4.0.0.tex-svg.min.js" | absURL }}"></script>
{{ end }}
```

Pro: explicit and cheap. Con: you must remember to set the flag.

### Option B — auto-detect math delimiters in content

Avoids the manual flag by scanning the rendered HTML:

```go-html-template
{{ if or (strings.Contains .Content "\\(") (strings.Contains .Content "\\[") (strings.Contains .Content "$$") }}
  ... MathJax ...
{{ end }}
```

Pick the delimiters that match how ox-hugo emits math. Slightly more magical
but zero authoring overhead.

## 2. Fingerprint CSS/JS assets for cache-busting

Today CSS/JS are plain `static/` files referenced by fixed filename
(`/css/skeria.css`, etc.). Browsers can serve stale copies after an update
(you already bump font/FontAwesome versions periodically, so this is real).

Move them into Hugo's asset pipeline (`assets/` instead of `static/`) and
reference with a content hash:

```go-html-template
{{ with resources.Get "css/skeria.css" }}
  {{ $css := . | fingerprint }}
  <link rel="stylesheet" href="{{ $css.RelPermalink }}" integrity="{{ $css.Data.Integrity }}">
{{ end }}
```

Gives `skeria.<hash>.css` + Subresource Integrity. Combine the two small
stylesheets (`skeria.css` + `fonts.css`) with `resources.Concat` to drop one
request while you're at it.

## 3. Preload the two body fonts

`fonts.css` declares Inter + Lora + JetBrains Mono with `font-display: swap`
(good). Adding a `<link rel="preload" as="font" type="font/woff2" crossorigin>`
for the two fonts used above the fold (Inter normal, Lora normal) shaves the
flash-of-unstyled-text. Optional, minor.

## Notes

- jQuery/Fuse/Mark are already correctly scoped to the search page only (loaded
  in the `footerfiles` block in `search.html`), so no change needed there for
  perf — but see `04-search-modernization.md` for dropping jQuery entirely.

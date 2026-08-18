# Skeria — Search modernization

Status: **proposed**. The search works, but the implementation carries
significant cruft and a dependency (jQuery) that's no longer justified.

## Findings

### 1. Fuse options are for Fuse 2/3, but Fuse 7 is loaded

`static/js/search.js` `fuseOptions` sets `tokenize`, `maxPatternLength`,
`location`, `distance` — none of these exist in Fuse 7.x. Fuse silently
ignores them. The relevant modern options are `ignoreLocation`,
`useExtendedSearch`, `minMatchCharLength`, `threshold`.

### 2. A dead JS flag disables the snippet/highlight logic

`search.js:46` branches on `if (fuseOptions.tokenize)`. Since `tokenize: true`
is still present as a *plain JS property* (even though Fuse ignores it), the
`else` branch — which extracts a contextual snippet around the match and
collects per-match highlight ranges — **never runs**. The result: snippets are
always the first ~300 chars, and highlighting only marks the raw query string.

### 3. `threshold: 0.0`

Only near-exact matches surface. Surprisingly strict; `~0.3` is the usual
sweet spot for fuzzy blog search.

### 4. Stale, misleading comment

`layouts/_default/search.html:2` warns the scripts "only work with these
specific script versions and break with newer versions" — yet the repo has
since upgraded to Fuse 7.1 / jQuery 3.7 / mark 8.11. The comment is no longer
true and should be removed or corrected.

### 5. jQuery is overkill

jQuery (~30 KB min) is used only for `$.getJSON`, `$.each`, `.append`, `.val`,
and the `.mark()` plugin. All have trivial vanilla equivalents; mark.js ships a
standalone (non-jQuery) build.

### 6. `index.json` could be leaner and safer

`layouts/_default/index.json`:
- Uses the legacy `.Scratch` accumulator; modern Hugo prefers a plain slice +
  `newScratch`, or just building with `collections`/`append`.
- Indexes **all** `RegularPages` including the search page and standalone pages
  (about, license, privacy). Filtering to posts keeps the JSON smaller and the
  results relevant:
  ```go-html-template
  {{- range where .Site.RegularPages "Type" "post" -}}
  ```

### 7. Minor: globals + XSS surface

`summaryInclude`, `start`, `end` are declared without `var` (leak to global
scope). The `render()` function does raw string substitution of title/snippet
into HTML — low risk since content is the author's own, but a `<template>` +
`textContent` approach removes the concern entirely.

## Proposed rewrite (vanilla, ~50 lines)

Drop `jquery.3.7.1.min.js` from the `footerfiles` block in `search.html`, keep
Fuse 7 + mark.js (standalone build), and rewrite `search.js` along these lines:

```js
const RESULTS = document.getElementById("search-results");
const params  = new URLSearchParams(location.search);
const query   = params.get("s");

const fuse = (data) => new Fuse(data, {
  includeMatches: true,
  ignoreLocation: true,
  threshold: 0.3,
  minMatchCharLength: 2,
  keys: [
    { name: "title",      weight: 0.8 },
    { name: "contents",   weight: 0.5 },
    { name: "tags",       weight: 0.3 },
    { name: "categories", weight: 0.3 },
  ],
});

async function run(q) {
  const input = document.getElementById("search-query");
  if (input) input.value = q;
  const data = await fetch("/index.json").then((r) => r.json());
  const results = fuse(data).search(q);
  if (!results.length) { RESULTS.innerHTML = "<p>No matches found.</p>"; return; }

  const tmpl = document.getElementById("search-result-template").innerHTML;
  results.forEach(({ item }, i) => {
    const snippet = (item.contents || "").slice(0, 300);
    RESULTS.insertAdjacentHTML("beforeend", fill(tmpl, {
      key: i, title: item.title, link: item.permalink,
      tags: item.tags, categories: item.categories, snippet,
    }));
    new Mark(document.getElementById("summary-" + i)).mark(q);
  });
}

if (query) run(query);
else RESULTS.innerHTML = "<p>Please enter a word or phrase above.</p>";
```

(`fill()` = the existing `${isset x}…${end}` + `${x}` template logic, kept as a
small pure-string helper, or replaced with `<template>` cloning for safety.)

Net effect: one fewer dependency, options that actually take effect, real
snippet highlighting, and leaner index JSON.

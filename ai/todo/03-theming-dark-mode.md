# Skeria — CSS custom properties and dark mode

Status: **proposed**. Currently a design improvement, not a bug.

## Problem

`static/css/skeria.css` hardcodes the same handful of colours in many places:

- `#444c57` — bar background, post titles, label text (≈7 occurrences)
- `#eee` — backgrounds for code/labels/tables/blockquote borders (≈8)
- `#7a7a7a` — muted date text (2)
- `#21446a` — link colour
- `#fff` / `#000` — base

Changing the palette means hunting every occurrence, and there's no dark-mode
support.

## Step 1 — centralize with custom properties

```css
:root {
  --bg:        #fff;
  --fg:        #000;
  --muted:     #7a7a7a;
  --accent:    #21446a;   /* links */
  --bar-bg:    #444c57;   /* topbar/bottombar, titles */
  --bar-fg:    #fff;
  --surface:   #eee;      /* code, labels, table stripes, quote borders */
  --border:    #ddd;
}
```

Then replace literals with `var(--…)`. Behaviour is identical; the diff is
mechanical but touches many lines (hence not bundled into the safe-fix commits).

## Step 2 — dark mode

Once variables exist, a dark theme is a small block:

```css
@media (prefers-color-scheme: dark) {
  :root {
    --bg:      #1a1d21;
    --fg:      #e6e6e6;
    --muted:   #9aa0a6;
    --accent:  #8ab4f8;
    --surface: #2a2e34;
    --border:  #3a3f45;
    /* --bar-bg / --bar-fg can stay as-is; the bars are already dark */
  }
}
```

### Caveat: syntax highlighting

Code blocks use Chroma with `noClasses = true` and `style = "tango"`
(config.toml), which bakes **inline** light-theme colours into every `<pre>`.
A dark page background with light-baked code blocks looks broken. To do dark
mode properly for code you'd need to switch to class-based highlighting
(`noClasses = false`) and ship two Chroma stylesheets gated by
`prefers-color-scheme`. That's the bulk of the work — flagging it so the scope
is clear before committing to dark mode.

## Minor related items

- No global `box-sizing: border-box` (only `input` sets it). Adding
  `*, *::before, *::after { box-sizing: border-box; }` avoids width surprises.
- Topbar tagline text uses `rgba(255,255,255,.5)` on `#444c57` — borderline
  contrast. Fine for decorative tagline; revisit if it ever carries real text.

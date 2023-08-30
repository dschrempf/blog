+++
title = "Emacs Helm and Hydra minor modes"
author = ["Dominik Schrempf"]
description = "Incremental completion and bindings that stick around."
date = 2015-04-04T00:00:00+02:00
keywords = ["Incremental Completion", "Find", "Keybinding"]
categories = ["Emacs"]
type = "post"
draft = false
+++

Recently, I stumbled upon two nice Emacs minor modes.


## Helm mode {#helm-mode}

Helm mode offers an **incremental completion** and **selection narrowing**
framework.  It will help you to find what you're looking for in Emacs
(like buffers, files, commands etc).  Resources and discussions can be
found at the following homepages:

-   development and installation instructions at the [Helm mode GitHub page](https://github.com/emacs-helm/helm);
-   the Emacs initialization files and [configuration of the Helm maintainer](https://github.com/thierryvolpiatto/emacs-tv-config);
-   [a good overview of the features](http://tuhdo.github.io/helm-intro.html) and a sample configuration.

I can recommend to use the `TAB` key for completion and not for other
actions.  You can bind the `TAB` key back to
`helm-execute-persistent-action` with

```lisp
;; Bind TAB to complete stuff.
(define-key helm-map (kbd "TAB")         'helm-execute-persistent-action)
;; Rebind `helm-select-action' (originally bound to TAB).
(define-key helm-map (kbd "C-j")         'helm-select-action)
```

I had used [Ido mode](http://emacswiki.org/emacs/InteractivelyDoThings) extensively before I switched to Helm mode.  I
must admit that the first thought was: too heavy and, oh, I miss the
insertion with `RET` as well as that Ido remembers which files I had
visited earlier.  Also, completion cannot be used when looking for
commands with `helm-M-x`.  However, with Helm mode I enjoy most that I
get an overview of what is out there.  That is what I miss with Ido
mode.  Try it out yourself!


## Hydra mode {#hydra-mode}

Hydra mode makes Emacs key bindings stick around so that they can be
used without modifiers.  It also displays them on the screen, so that
rarely used shortcuts can be remembered without looking into the
configuration files again (and again and again).  It is very useful!

Check it out:

-   source code and introduction at [Hydra mode on GitHub](https://github.com/abo-abo/hydra);
-   some blog entries of the creator at [(or emacs irrelevant)](http://oremacs.com/archive/).

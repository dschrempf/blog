+++
title = "How to create this homepage"
author = ["Dominik Schrempf"]
date = 2014-12-26T00:00:00+01:00
keywords = ["Emacs", "", "", "Mode", "", "", "", ""]
lastmod = 2016-04-09
type = "post"
draft = false
+++

This homepage was created with Emacs and [Org mode](http://orgmode.org/). It is hosted at [github.io](https://pages.github.com/) and
comments can be done using [Disqus](https://disqus.com/). I assume a working Org mode setup and a
GitHub as well as a Disqus account.

<span class="timestamp-wrapper"><span class="timestamp">&lt;2015-03-26 Thu&gt; </span></span> Update; general revision of code and text.

<span class="timestamp-wrapper"><span class="timestamp">&lt;2016-04-09 Sat&gt; </span></span> Another update.


## General idea {#general-idea}

Org mode
: A great tool for taking notes and exporting them to
    all kind of formats.  One of this formats is **HTML**.  The idea
    here is to use the publishing capabilities of Org mode to create
    a very basic website that can be used to blog and publish
    articles.

GitHub
: Offers a freely available hosting service, a very easy way
    to make the website available.

Disqus
: Provides the ability to comment posts.

Many people also use [Jekyll](http://jekyllrb.com/) to create homepages and blogs together
with Org mode and GitHub.  This is certainly a very appealing
alternative but I prefer a setting that is easier to set up and has
fewer options.


## Folder structure {#folder-structure}

I decided to use the following folder structure; it is somehow
arbitrary but the Org mode publishing setup has to be adjusted
accordingly:

```text
/home/dominik/Shared/blog
├── dschrempf.github.io
└── org
    ├── css
    ├── js
    └── posts

8 directories
```

The folders `css` and `js` are self explanatory.  Good style sheets
are hard to get.  I use a [neat one](../../css/site.css) from [Worg](http://orgmode.org/worg/) with a few changes.  For
this setup, it has to be saved as `/blog/org/css/site.css`.
[dschrempf.github.io](https://github.com/dschrempf/dschrempf.github.io) is the git repository of the GitHub homepage
(there are detailed explanations on [GitHub](https://pages.github.com/) about how to set it up).
The posts created with Org mode reside in the `org` directory.  It is
important that you create an `index.org` file because GitHub is
looking for an `index.html` file and displays it as the main page.
You can use all capabilities of Org mode and its [export and publishing
framework](http://orgmode.org/manual/HTML-export.html#HTML-export).


## Org Mode publishing setup {#org-mode-publishing-setup}

This is the main step.  Org mode has to know how to export your Org
files so that they can be hosted by GitHub:

<a id="org514a548"></a>
```lisp
(setq org-publish-project-alist
      '(
        ;; Blog posts in Org mode that are exported to html and hosted
        ;; by GitHub.
        ("blog"
         ;; Directory with Org files.
         :base-directory "~/Shared/blog/org/"
         :base-extension "org"
         ;; Output directory for html files on GitHub.
         :publishing-directory "~/Shared/blog/dschrempf.github.io/"
         :publishing-function (org-html-publish-to-html)
         :html-extension "html"
         ;; Create a sitemap that contains all posts in
         ;; anti-chronological order.
         :auto-sitemap t
         :sitemap-filename "archive.org"
         :sitemap-title "Archive"
         :sitemap-sort-files anti-chronologically
         :sitemap-style list
         :recursive t
         :section-numbers nil
         :with-toc t
         ;; Do not include predefined header scripts.
         :html-head-include-default-style nil
         :html-head-include-scripts nil
         :html-head "<link rel='stylesheet' href='/css/site.css' type='text/css'/>
<meta name=\"viewport\" content=\"width=device-width\"/>"
         :html-preamble website-html-preamble
         :html-postamble website-html-postamble
         :html-link-home "http://dschrempf.github.io/"
         :html-link-use-abs-url nil)

        ("static"
         :base-directory "~/Shared/blog/org/"
         :base-extension "css\\|js\\|jpg\\|gif\\|png\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/Shared/blog/dschrempf.github.io/"
         :publishing-function org-publish-attachment
         :recursive t)

        ;; ("website" :components ("blog" "images" "js" "css"))))
        ("website" :components ("blog" "static"))))
```

This defines a set of projects that can be published simultaneously
with the project `website` (e.g. with `M-x org-publish website`).  The
preamble includes a small header; the postamble includes the Disqus
comment section and Google Analytics (make sure to replace you
user name and tracking ID).

<a id="org8702fc4"></a>
```lisp
;; BugFix: Manually disable home/up links in preamble.
(setq org-html-home/up-format "")

(defun website-html-preamble (info)
  "Org-mode website HTML export preamble."
  (format "<div class='nav'>
<ul>
<li><a href='/'>Home</a></li>
<li><a href='/archive.html'>Archive</a></li>
</ul>
</div>"))

(defun website-html-postamble (info)
  "Put Disqus into Org mode website postamble.  Do not show
   disqus for the Archive and the Index."
  (concat
   (cond ((string= (car (plist-get info :title)) "Archive") "")
         ((string= (car (plist-get info :title)) "Index") "")
         ((string= (car (plist-get info :title)) "GitHub -> IO ()") "")
         (t "<div id='disqus_thread'></div>
<script type='text/javascript'>
  // required: replace example with your forum shortname
  var disqus_shortname = 'YOUR DISQUS NAME HERE';
  (function() {
      var dsq = document.createElement('script');
      dsq.type = 'text/javascript'; dsq.async = true;
      dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
      (document.getElementsByTagName('head')[0] ||
       document.getElementsByTagName('body')[0]).appendChild(dsq);
  })();
</script>
<noscript><p>Please enable JavaScript to view the
  <a href='http://disqus.com/?ref_noscript'>comments powered by Disqus.</a></p>
</noscript>"))
   (format "<div class='footer'>
Copyright 2014 AUTHOR<br/>
Last updated %s <br/>
Built with %s <br/>
%s HTML
</div>
<script type='text/javascript'>
 (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
 (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
 m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
 })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

 ga('create', 'PUT YOUR TRACKING ID HERE', 'auto');
 ga('send', 'pageview');

</script>"
           (format-time-string "%Y-%m-%d")
           org-html-creator-string
           org-html-validation-link)))
```


## Workflow {#workflow}

Create your homepages with Emacs Org mode.  The `index.org` file can
include links to all blog articles.  Links, source blocks, images and
so on can be used everywhere.  This is explained in great detail on
the [Org mode homepage](http://orgmode.org/manual/HTML-export.html#HTML-export).  Publish the homepage with `org-publish` (i.e.,
bind this to a key) and push the changes to GitHub.  Voila!

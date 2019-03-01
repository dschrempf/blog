+++
title = "Zip folders with GNU Parallel"
author = ["Dominik Schrempf"]
description = "How to zip folders in parallel."
date = 2015-01-07T00:00:00+01:00
keywords = ["GNU Parallel", "Parallel", "Tar", "Zip"]
categories = ["Linux"]
type = "post"
draft = false
+++

Working with large files takes a long time. Sometimes, it is worth to zip
folders individually, so that a single archive does not get too large. [GNU
Parallel](http://www.gnu.org/s/parallel) is a shell tool to execute jobs in parallel. Here, I show one of
possibly many methods to use it to zip many folders (or files) in parallel.

1.  Create a file with all folders that you want to zip, e.g with:

```sh
ls -1 > folders
```

1.  Use GNU Parallel to zip them:

```sh
parallel -a folders "tar -czf {}.tar.gz {}"
```

In order to unzip many files at ones (this method can also be used to
zip the files if their names follow certain patterns):

```sh
parallel "tar -xzf {}" ::: *.tar.gz
```

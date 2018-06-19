+++
title = "Easy pretty print in Haskell"
author = ["Dominik Schrempf"]
description = "Use pretty-show to pretty print objects in GHCi."
date = 2014-12-23T00:00:00+01:00
keywords = ["Haskell", "", "Print", ""]
lastmod = 2018-06-18T11:50:00+02:00
type = "post"
draft = false
+++

I repeatedly struggle with GHCi when I want to print lists and maps and actually
look at them and analyze them. Today I came accross [pretty-show](https://hackage.haskell.org/package/pretty-show), a haskell
package that allows pretty printing of all objects that are instances of the
type class Show.

The usage is very straight forward:

```haskell
import qualified Text.Show.Pretty as Pr
```

This provides Pr.ppShow which can be used in GHCi (or other interpreters):

```haskell
putStrLn $ Pr.ppShow object
```

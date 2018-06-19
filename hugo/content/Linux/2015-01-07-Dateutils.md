+++
title = "Dateutils"
author = ["Dominik Schrempf"]
description = "Work with times and dates in the shell."
date = 2015-01-07T00:00:00+01:00
keywords = ["Dateutils", "", "", "", "", ""]
lastmod = 2018-06-19T11:45:00+02:00
type = "post"
draft = false
+++

Did you ever need to calculate the time difference between two consecutive time
stamps from a log file or something similar? Check out [dateutils](http://www.fresse.org/dateutils/), it is really
useful:

```sh
ddiff -i '%H:%M:%S' '19:09:43,683' '19:34:10,350'
```

+++
title = "exiv2 command line power"
author = ["Dominik Schrempf"]
description = "Manipulate multiple image files and their Exif data on the command line"
date = 2015-04-25T00:00:00+02:00
keywords = ["Image", "Picture", "Photo", "Exif", "Command Line", "Batch Manipulation", "Linux"]
categories = ["Linux"]
type = "post"
draft = false
+++

Does this sound familiar to you: You come back from a holiday with your family
or friends and want to merge photos taken with 4 different cameras. However,
somebody forgot to adjust the date (or did not set the daylight saving time
accordingly). Hmm.

This problem can be solved easily.  `exiv2` is a program to read and
write Exif image metadata and image comments.  It offers a very easy
command line interface and shortcuts to batch rename files (e.g., by
time and date) or to change Exif flags.

The [`exiv2` homepage](http://www.exiv2.org/).


## Examples from the manual {#examples-from-the-manual}

Some examples from the manual (`man exiv2`):

`exiv2 *.jpg`
: Prints a summary of the Exif information for all
    JPEG files in the directory.

`exiv2 rename img_1234.jpg`
: Renames `img_1234.jpg` (taken on
    13-Nov-05 at 22:58:31) to `20051113_225831.jpg`.

`exiv2 -r':basename:_%Y%m' rename img_1234.jpg`
: Renames
    `img_1234.jpg` to `img_1234_200511.jpg`.

`exiv2 -et img1.jpg img2.jpg`
: Extracts the Exif thumbnails from
    the two files into `img1-thumb.jpg` and `img2-thumb.jpg`.


## Adjust date and time {#adjust-date-and-time}

We use the adjust switch from above:

ad | adjust
: Adjust Exif time stamps by the given time.  Time
    adjustment is in the format `[-]HH[:MM[:SS]]`.  Examples: `1`
    adds one hour, `1:01` adds one hour and one minute, `-0:00:30`
    subtracts 30 seconds.

An example:

```bash
exiv2 adjust -a 1 *.jpg
```

adds one hour to the time stamp of all JPG files in the working
directory.


## Batch rename {#batch-rename}

After you have adjusted the time stamps of the different cameras, you
may want to rename the files, e.g.:

```bash
exiv2 rename *.jpg
```

renames all JPG files in the working directory to `date_time.jpg`,
something very useful.

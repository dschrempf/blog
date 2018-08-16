+++
title = "Get rid of Google"
author = ["Dominik Schrempf"]
description = "How to use your phone without Google applications"
date = 2016-08-05T00:00:00+02:00
keywords = ["Android", "", ""]
tags = ["Linux"]
type = "post"
draft = false
+++

I like a lot of stuff that Google is doing, especially that it
supports open source.  However, I really dislike their attitude
towards user privacy.  That is why I decided to get rid of Google on
my Android phone.  However, I had to solve some problems in order to
keep user-friendliness at a high level and to be able to use all
applications that I need.

The main issues are:

1.  Which [ROM](#cyanogenmod-without-open-gapps) do I use?
2.  How do I [install software](#application-management) and keep it up to date?
3.  How do I synchronize all my [contacts and calendar](#contact-and-calendar)?
4.  Can I [replace applications](#replacement-of-google-applications) that do not run without Google Play
    Services?

The answers are:


## Cyanogenmod without Open GApps {#cyanogenmod-without-open-gapps}

I have been using [Cyanogenmod](http://www.cyanogenmod.org/) for quite some time now and I am very
happy with it.  After a complete backup, I formatted every possible
partition on my phone and did a clean reinstall without Open GApps.
This left me with a Google-less Android install.


## Application management {#application-management}

Use [F-Droid](https://f-droid.org/).  For applications that are not available in F-Droid, use
a _service_ that provides APK files of Google Play Store applications.

This is the main drawback, because this _service_ has to be trusted in
that it does not alter the APK files in any way.  I decided to use
[APKPure](https://apkpure.com/) because it comes with an application that can update all
installed applications.  I compared the `md5` check sums of randomly
chosen APK files from _APKPure_ with the one from the Google Play
Store and could not find any differences.  This problem of completely
trusting an unknown organization is still bugging me but I did not
find another solution so far (especially because all application
stores are incomplete).


## Contact and calendar {#contact-and-calendar}

For contact and calendar synchronization, I use a Raspberry Pi with
[Nextcloud](https://nextcloud.com/) (or [Owncloud](https://owncloud.org/)) together with [DavDroid](https://davdroid.bitfire.at/) on the phone (which is
available on F-Droid).  I am sure there are other services available
that do not require an extensive server setup like this one.


## Replacement of Google applications {#replacement-of-google-applications}

I replaced Google Maps with OsmAnd; Gmail with the native Android mail
client; I never used Google Now nor Hangouts nor any other Google
application.

So far, this was way easier than I thought.  Ironically, a local
application that provides information about public transport was the
only one that complained about Google Play Services being
non-existent.  That's when I dived into this issue and found [microG](https://microg.org/),
an open source library that provides replacements for a lot of
functions usually provided by Google Play Services.


### microG {#microg}

The setup on Cyanogenmod with Android 6.0.1 is tough because system
spoofing needs to be available.  This can be done using Haystack or
Xposed (do not follow both instruction sets).


#### Installation of Haystack {#installation-of-haystack}

A detailed explanation can be found on the [GitHub page](https://github.com/Lanchon/haystack).


#### Installation of Xposed {#installation-of-xposed}

-   With F-Droid, install Xposed Downloader.
-   With Xposed Downloader, download the latest Xposed framework and the Xposed
    Installer.
-   In Recovery mode, install the latest Xposed framework (always wipe
    cache).
-   Wipe cache and reboot; check if the Xposed framework is working
    correctly (start Xposed installer).
-   With Xposed, download FakeGApps and activate it; reboot.


#### Installation of microG Services Core {#installation-of-microg-services-core}

-   With F-Droid, activate the [microG repository](https://microg.org/fdroid.html).
-   With F-Droid, install microG Services Core, microG Services
    Framework and a network location backend (e.g., MozillaNlpbackend).
-   With microG, open settings and check if spoofing support is enabled
    (Self-Check).
-   With microG, enable everything and also the network location
    provider backend.
-   And yea, it works!
-   If you have installed applications that use Google Cloud Messaging
    (like [Signal](https://whispersystems.org/)) before, you have to either reinstall them, or
    re-register to the Google servers, otherwise message delivery may be
    delayed.


## Conclusion {#conclusion}

Installing Android without Google Play Services was way easier than I
thought.  However, to enable applications that require certain
features like the messaging or the location interface of Google Play
Services, extensive tinkering is necessary.

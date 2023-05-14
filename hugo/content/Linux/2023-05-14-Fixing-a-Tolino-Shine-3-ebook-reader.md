+++
title = "Fixing a Tolino Shine 3 ebook reader"
author = ["Dominik Schrempf"]
description = "The software update failed and the recovery script is broken"
date = 2023-05-14T00:00:00+02:00
keywords = ["Tolino", "Android", "Ebook reader", "TWRP", "ADB"]
categories = ["Linux"]
type = "post"
draft = false
+++

An update of my Tolino Shine 3 reader failed. The system recovery did not work
aborting with the following error:

```text
Batterie fast leer! Ein-/Ausschalter druecken, Geraet mind. 2 h aufladen und neu starten.
Low battery! Press the power button, charge the device for a minimum of 2 hours and restart.
```

Weird. Charging did not help either. In fact, I am not [not the only one](https://test.freifunk-gera-greiz.de/namespace/reparatur-tolino-shine-3)
experiencing this problem. Be sure to read the linked blog post, it contains
important information. In particular, **the battery check is flawed and the
Tolino Shine 3 system recovery is broken**!

Luckily, opening the device is easy, and the Tolino Shine 3 uses a MicroSD card.
So a working SD card image is all I need to fix the reader. I contacted the
customer service; nope, they do not provide an image because there is a serial
number stored on the card, and everybody needs a different one. Send it in, 48
EUR. (That's actually quite cheap, but hey, they messed it up, not me. By the
way, supposedly, if you delete the SD card, there is no way they can repair your
Tolino).

Anyways. I managed to fix the device. Here is what I did:

1.  Open the Tolino. (It is quite easy using a thin plastic device; fun fact: I
    used a nose flute).
2.  Remove the SD card.
3.  Put the card into a computer; backup the complete SD card (e.g., using `dd`).
4.  If you like, create extra backups of partition 1 (boot), and partition 2
    (recovery).
5.  Download [TWRP for the Tolino Shine 3](https://github.com/Ryogo-Z/tolino_shine3_twrp).
6.  Place the `twrp.img` onto recovery partition 2 (e.g., using `dd`).
7.  Get the `update.zip` [from official Tolino website](https://mytolino.com/software-updates-for-tolino-ereaders/).
8.  Extract `update.zip`.
9.  Edit the script printing the "Low Battery" error (see above; `rg` for it).
10. Remove the infamous battery check.
11. Re-zip (use `zip -r ../update.zip *` to avoid the leading directory).
12. Restart device and boot into recovery (this was automatic for me, since the
    system was broken).
13. Use ADB to copy the patched zip file to the device (the internal memory was
    in `/sdcard1` in my case).
14. Install the zip file using TWRP. Like so, the signature is not checked and
    the "update" script succeeds.
15. Boot into the Tolino and check if everything works.
16. Create a backup of the _working_ SD card; and store it somewhere extremely
    safe.
17. Be happy and open a beer.

Links:

-   [The blog post that made it work for me](https://test.freifunk-gera-greiz.de/namespace/reparatur-tolino-shine-3). Thank you, Matthias!
-   The best forum I found is [MobileRead](https://www.mobileread.com/). See [my empty thread](https://www.mobileread.com/forums/showthread.php?t=353856) and another
    [hacking thread](https://www.mobileread.com/forums/showthread.php?t=327186).
-   [Tolino hacking (not Tolino Shine 3)](http://naberius.de/?s=tolino)
-   [Android tools (XDA)](https://forum.xda-developers.com/t/tool-android-image-kitchen-unpack-repack-kernel-ramdisk-win-android-linux-mac.2073775/) (which are not required but I had to use them to find the
    boot and recovery partitions).

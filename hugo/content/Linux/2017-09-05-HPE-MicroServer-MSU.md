+++
title = "Marvell Storage Utility on HPE ProLiant MicroServer Gen10"
author = ["Dominik Schrempf"]
description = "Adventures when using having to deal with proprietary drivers on Arch Linux."
date = 2017-09-05T00:00:00+02:00
keywords = ["MSU", "", "", "", "", "", "", "", ""]
lastmod = 2018-06-18T11:50:00+02:00
type = "post"
draft = false
+++

## Marvell SATA controller {#marvell-sata-controller}

Recently I purchased an HPE ProLiant MicroServer Gen10 which comes with the
Marvell SATA controller 88SE9230, also called Marvell Storage Utility (MSU). As
far as I know, this controller has an ARM chip to provide RAID 0 (non-redundant
combination of disks), RAID 1 (straight mirroring) or RAID 10 (a combination of
RAID 0 and RAID 1).

Neither Marvell nor HPE do provide drivers for generic Linux systems but they do
provide a package for ClearOS which uses the Red Hat Package Manager (RPM).

Initially, I tried to manage the RAID using the Marvell BIOS utility which can
be accessed by the EFI shell. The BIOS utility and the user guide can be
downloaded from the [HPE support center](https://www.hpe.com/us/en/support.html). However, this procedure is slow and
complicated, especially if the server is headless, as in my case. Furthermore,
monitoring the disks with SMART data is also impossible. So I decided to invest
some time in amending the ClearOS package for Arch Linux and provide an [AUR
package](https://aur.archlinux.org/packages/marvell-msu/).


## Marvell controller package {#marvell-controller-package}

I had serious trouble running the original scripts and daemons because they are
(a) written for ClearOS and (b) expect the generic but outdated SCSI kernel
module [sg](http://www.tldp.org/HOWTO/SCSI-2.4-HOWTO/sg.html) to be loaded. I provide replacements with the same functionality:

1.  [MSUAgent](https://aur.archlinux.org/cgit/aur.git/tree/MSUAgent?h=marvell-msu) - The MSU Event Manager.
2.  [MSUWebServer](https://aur.archlinux.org/cgit/aur.git/tree/MSUWebService?h=marvell-msu) - The MSU Web Server (manual access at port 8045).
3.  [MSUStart](https://aur.archlinux.org/cgit/aur.git/tree/MSUStart?h=marvell-msu) - A small script to access the web interface.

These scripts also pull the `sg` module in case it is not loaded.

For my purposes however (I do not need a web interface), the MSU client `mvcli`,
which is located in the folder `/opt/marvell/storage/cli` is all I need. Don't
forget to manually load the `sg` module, which sets up the SCSI devices for this
script, e.g., with

```text
sudo modprobe -a sg
```

Then, the SMART data can be retrieved, e.g., with

```text
sudo /opt/marvell/storage/cli/mvcli smart -p 0
```

Awesome :-)!

In the course of this project, I also stumbled upon other very useful SCSI
related software: `lsscsi`, `sg3_utils`, `sdparm`, `hdidle`.

I am still having trouble with monitoring temperature (e.g., CPU temperature),
please leave a note if you know an easy way to achieve this.

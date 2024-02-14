+++
title = "Monitoring a home server — Minimal setup with Nix and Monit"
author = ["Dominik Schrempf"]
description = "Minimal setup with Nix and Monit"
date = 2024-02-14T00:00:00+01:00
keywords = ["Nix", "Monit", "Monitoring", "SMART"]
categories = ["Linux"]
type = "post"
draft = false
+++

For a long time I have been thinking about possible monitoring solutions for my
home server. To me, it was important that the solution

-   has to be minimal and efficient;
-   can be configured in a declarative way.

Also on my wishlist but not a necessity was a dashboard.

While thinking about this, I was coming back to an interesting [NixOS Discourse
thread](https://discourse.nixos.org/t/recommended-monitoring-tools-for-nixos-servers/14848/1) again and again. In particular, @ryantm was praising the _minimalism of
[Monit](https://mmonit.com/)_. The home page of M/Monit is promising but, meh, the tool is behind a
paywall.

As it turns out, the tool `monit`, which is the main driver behind `M/Monit`, is

-   open source (see the [`monit` Git repository](https://bitbucket.org/tildeslash/monit/src)), and
-   has basic support in NixOS via [services.monit](https://search.nixos.org/options?show=services.monit).

However, configuration is manual, so I had to write a small NixOS module which I
am sharing here (see below). Further, documentation and other resources are
scattered around a bit, so here you go:

-   the [Monit manual](https://mmonit.com/monit/documentation/monit.html);
-   some [real world configuration examples](https://mmonit.com/wiki/Monit/ConfigurationExamples);
-   the [Arch Wiki entry on Monit](https://wiki.archlinux.org/title/Monit).

<!--listend-->

```nix
{ filesystems # List of monitored file system paths.
, drives      # List of monitored drives.
, allowIps    # Allow access from these IP addresses.
, openPort    # Open Monit TCP port in firewall?
}:

{ lib, pkgs, ... }:

let
  port = 2812;
  hdTemp = pkgs.writeShellScript "hd-temp" ''
    SMARTCTL_OUTPUT=$(${pkgs.smartmontools}/bin/smartctl --json=c --nocheck=standby -A "/dev/$1")
    if [[ "$?" = "2" ]]; then
        echo "STANDBY"
        exit 0
    fi
    TEMPERATURE=$(${pkgs.jq}/bin/jq '.temperature.current' <<< "$SMARTCTL_OUTPUT")
    echo "$TEMPERATURE"°C
    exit "$TEMPERATURE"
  '';
  hdStatus = pkgs.writeShellScript "hd-status" ''
    SMARTCTL_OUTPUT=$(${pkgs.smartmontools}/bin/smartctl --json=c --nocheck=standby -H "/dev/$1")
    if [[ "$?" = "2" ]]; then
        echo "STANDBY"
        exit 0
    fi
    PASSED=$(${pkgs.jq}/bin/jq '.smart_status.passed' <<< "$SMARTCTL_OUTPUT")
    if [ "$PASSED" = "true" ]
    then
        echo "PASSED"
        exit 0
    else
        echo "FAULTY"
        exit 1
    fi
  '';
  monitorGeneral = ''
    set daemon 60
    set httpd port ${builtins.toString port}
        allow localhost ${lib.strings.concatMapStringsSep " " (ip: "allow " + ip) allowIps}'';
  monitorSystem = ''
    check system $HOST
        if loadavg (15min) > 4 for 5 times within 15 cycles then alert
        if memory usage > 80% for 4 cycles then alert
        if swap usage > 20% for 4 cycles then alert'';
  monitorFilesystem = fs: ''
    check filesystem "path ${fs}" with path ${fs}
        if space usage > 90% then alert'';
  monitorFilesystems = lib.strings.concatMapStringsSep "\n" monitorFilesystem filesystems;
  monitorDriveTemperature = drive: ''
    check program "drive temperature: ${drive}" with path "${hdTemp} ${drive}"
       every 5 cycles
       if status > 40 then alert
       group health'';
  monitorDriveTemperatures = lib.strings.concatMapStringsSep "\n" monitorDriveTemperature drives;
  monitorDriveStatus = drive: ''
    check program "drive status: ${drive}" with path "${hdStatus} ${drive}"
       every 120 cycles
       if status > 0 then alert
       group health'';
  monitorDriveStatuses = lib.strings.concatMapStringsSep "\n" monitorDriveStatus drives;
in
{
  services.monit.enable = true;
  services.monit.config = lib.strings.concatStringsSep "\n" [
    monitorGeneral
    monitorSystem
    monitorFilesystems
    monitorDriveTemperatures
    monitorDriveStatuses
  ];
  networking.firewall.allowedTCPPorts =
    if openPort then [ port ] else [ ];
}
```

Please note the `--nocheck=standby` options for `smartctl`; they inhibit hard
drive spin ups. Pretty neat!

The module can be used in your NixOS configuration like so:

```nix
{
  imports = [
    (import ./path/to/monit.nix {
      filesystems = [ "/" "/nix" "/mnt/data" ... ];
      drives = [ "sda" "sdb" "sdc" "sdd" ... ];
      allowIps = [ "192.168.0.20" "10.0.0.2" ... ];
      openPort = true;
    })
  ];
}
```

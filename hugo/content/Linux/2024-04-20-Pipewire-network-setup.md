+++
title = "Pipewire network setup"
author = ["Dominik Schrempf"]
description = "Share audio devices managed by Pipewire on a network"
date = 2024-04-20T00:00:00+02:00
keywords = ["Pipewire", "Audio", "Network", "Sink", "Source", "Server", "Client", "Source", "Playback", "Linux", "NixOS"]
categories = ["Linux"]
type = "post"
draft = false
+++

My goal was to **play audio over the network**.

In detail, a computer with a sound card and speakers serves the audio device on
the network (referred to as _server_). Other computers (referred to as
_clients_) play audio which they send to the server to be played on the speakers
managed by the servers. Ideally, this happens in real time without delay.


## NixOS setup {#nixos-setup}

I had such a service set up using Pulseaudio a while ago, but it being
Pulseaudio I was eager to switch to [Pipewire](https://pipewire.org/) as soon as possible (Pipewire seems
to be the cool kid on the block). There are numerous sources available talking
about how easy a network setup was, however, I had trouble setting it up on
NixOS. So I thought sharing my configuration may be useful to others.


### Server NixOS module {#server-nixos-module}

```nix
_:

{
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.pulse.enable = true;

  # Publish audio sink on the local network.
  services.pipewire.extraConfig.pipewire-pulse."30-network-publish" = {
    "pulse.cmd" = [
      { cmd = "load-module"; args = "module-native-protocol-tcp"; }
      { cmd = "load-module"; args = "module-zeroconf-publish"; }
    ];
  };

  # Important: Open TCP port used by the Pulseaudio network sink.
  networking.firewall.allowedTCPPorts = [
    4713
  ];
}
```


### Client NixOS module {#client-nixos-module}

```nix
_:

{
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.pulse.enable = true;

  services.pipewire.extraConfig.pipewire-pulse."30-network-discover" = {
    "pulse.cmd" = [
      { cmd = "load-module"; args = "module-zeroconf-discover"; }
    ];
  };
}

```


### Avahi {#avahi}

Further, [Avahi](https://avahi.org/) needs to be enabled and corresponding ports need to be opened in
the firewall. I am not exactly sure how much of the following setup is required,
but here you go:

```nix
# I do not know how much of this is necessary, but that's what I have in my configuration.
services.avahi.enable = true;
services.avahi.openFirewall = true;
services.avahi.publish.enable = true;
services.avahi.publish.addresses = true;
services.avahi.publish.domain = true;
services.avahi.publish.userServices = true;
services.avahi.publish.workstation = true;
```


## Sources and links {#sources-and-links}

Sources I used to come up with this configuration:

-   [Arch Linux Wiki article about Pipewire](https://wiki.archlinux.org/title/PipeWire)
-   [Pipewire Wiki article about Network setup](https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Network)
-   [Pipewire Wiki article about Pulseaudio network setup](https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Guide-PulseAudio-Tricks#setup-tcp-network-streaming-between-machines)
-   [Help about Pipewire services provided by NixOS options](https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=services.pipewire)

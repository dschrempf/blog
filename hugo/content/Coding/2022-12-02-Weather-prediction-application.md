+++
title = "Weather prediction application"
author = ["Dominik Schrempf"]
description = "Proof of concept weather prediction web application"
date = 2022-12-02T00:00:00+01:00
keywords = ["Weather prediction", "Web application", "Frontend", "Backend", "Haskell", "Scotty", "Lucid", "Markov chain Monte Carlo", "MCMC", "Nix", "Nix Flakes"]
categories = ["Coding"]
type = "post"
draft = false
+++

I created a minimalist [weather predicition application](https://dschrempf.duckdns.org/) --- a short proof of
concept and stake.

The main elements of the Haskell tech stack are:

-   [Scotty](https://hackage.haskell.org/package/scotty): A web framework.
-   [Lucid](https://hackage.haskell.org/package/lucid): A domain specific language for HTML.
-   [Mcmc](https://hackage.haskell.org/package/mcmc): A Markov chain Monte Carlo sampler.

Other noteworthy components of this project:

-   The development environment is managed by the [Nix package manager](https://github.com/NixOS/nix).
-   The application is deployed using a [Nix Flake](https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html).

For details, have a look at the [project source code](https://github.com/dschrempf/webapp).

I deploy the application to my home server which is turned on roughly from 8am
to 10pm CET. I mean, who wants to predict the weather during the night?

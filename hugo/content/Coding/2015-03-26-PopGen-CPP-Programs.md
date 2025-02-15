+++
title = "Population genetics C++ programs"
author = ["Dominik Schrempf"]
description = "A collection of C++ programs about Markov chains and Population Genetics"
date = 2015-03-26T00:00:00+01:00
keywords = ["Population Genetics", "C++", "Markov Chain", "Probability", "Statistics"]
categories = ["Coding"]
type = "post"
draft = false
+++

I maintain a [Github repository](https://github.com/fazky/popgen-cpp-programs) that contains a bunch of very basic C++ programs
that use Markov chains and other types of simulations to infer basic statistical
parameters. The applications mainly focus on Population Genetics problems,
although this is not always the case. At the moment, the list of programs is:

`bookshelf.cpp`
: Bookshelf Markov chain

`brownian_motion_mcmc.cpp`
: Simulate standard Brownian motion
    (Wiener process)

`coin_toss_mcmc.cpp`
: Run a coin toss MCMC simulation

`cube_mcmc.cpp`
: Simulation of a Markov chain that moves around the
    eight vertices of a cube

`ehrenfest_mcmc.cpp`
: Simulate gas particles in a divided box

`general_discrete_distributions.cpp`
: Given K discrete events with
    different probabilities P[k], produce a random value k consistent
    with its probability

`general_discrete_markov_chain.cpp`
: Simulate a general discrete
    Markov chain with a given transition probability matrix P

`genetic_drift.cpp`
: Simulate genetic drift

`hitchhiking.c`
: Simulate hitchhiking along a positively selected locus

`stepping_stone_model.cpp`
: Simulate Stepping Stone Model with a
    Markov chain

Please check out the detailed [documentation on the github repository](https://github.com/fazky/popgen-cpp-programs/tree/master/doc/html).

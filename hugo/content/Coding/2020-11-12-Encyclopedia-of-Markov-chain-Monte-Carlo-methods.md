+++
title = "Encyclopedia of Markov chain Monte Carlo methods"
author = ["Dominik Schrempf"]
description = "In the MCMC community, many people call the same concepts by different names"
date = 2020-12-18T00:00:00+01:00
keywords = ["Markov chain Monte Carlo", "Metropolis-Hastings", "Metropolis-Hastings-Green", "Population based methods"]
categories = ["Coding"]
type = "post"
draft = false
+++

I started this encyclopedic overview because in the Markov chain Monte Carlo
(MCMC) community many people call the same or similar concepts by very different
names. Please let me know, if you have suggestions or comments, or if you would
like to add some definitions or synonyms to this overview.


## Bibliography {#bibliography}


### Books {#books}

-   The nomenclature here is taken from the excellent introduction to Markov chain
    Monte Carlo (MCMC) methods by Geyer, Charles J (2011), Chapter 1 in
    Brooks, Steve and Gelman, Andrew and Jones, Galin and Meng, Xiao-Li (2011).
-   More advanced topics such as population based MCMC methods are covered in
    Liang, Faming and Liu, Chuanhai and Carroll, Raymond (2011).
-   See Arnaud Doucet and Nando de Freitas and Neil Gordon (2001) for sequential Monte Carlo algorithms.


### Articles {#articles}

-   Walter R. Gilks and Carlo Berzuini (2001)
-   Del Moral, Pierre and Doucet, Arnaud and Jasra, Ajay (2006)
-   Andrieu, Christophe and Doucet, Arnaud and Holenstein, Roman (2010)
-   A. {Doucet} and A. M. {Johansen} (2011)
-   Chopin, N. and Jacob, P. E. and Papaspiliopoulos, O. (2012)
-   Heng, Jeremy and Bishop, Adrian N. and Deligiannidis, George and Doucet, Arnaud (2020)


### Articles tailored to a phylogenetic audience {#articles-tailored-to-a-phylogenetic-audience}

-   Bouchard-Côté, Alexandre and Sankararaman, Sriram and Jordan, Michael I. (2012)
-   Vu Dinh and Aaron E Darling and Frederick A Matsen IV (2018)
-   Mathieu Fourment and Brian C. Claywell and Vu Dinh and Connor McCoy and Frederick A. Matsen IV and Aaron E. Darling (2018)


## Necessary definitions {#necessary-definitions}

**Elementary updates** are instructions about how to advance a Markov chain so
that it possibly reaches a new state. That is, elementary updates specify how
the chain traverses the state space. Elementary updates cannot be decomposed
into smaller updates.

Elementary updates can be combined to form composite updates, a technique often
referred to as **composition**. We use the word **update** to refer to either an
elementary or a composite update.

Updates can also be executed in random order, a technique often referred to as
**mixture**. Here, the word mixture is used in the sense of mixture models, and
not in the sense of a chain reaching convergence.

The **composition** and **mixture** of elementary updates allows the specification
of all (Is this true?, Please correct me if it is not.) MCMC algorithms
involving a single chain. In particular, Gibbs samplers of all sorts can be
specified using this procedure.

Roughly, a **Markov kernel** is a map describing the probability density (for
continuous spaces) or the probability mass (for discrete spaces) of updating one
state to another.

The **Metropolis-Hasings-Green** algorithm specifies the acceptance probability of
updates so that the stationary distribution of the resulting Markov chain is the
desired posterior distribution.

Many methods to improve convergence of MCMC samplers have been designed. Most
notably, we have methods involving **auxiliary variables** and **population based**
methods running various MCMC samplers in parallel.


## Unnecessary synonyms {#unnecessary-synonyms}

Proposal
: Update.

Move
: Update.

Metropolis update
: Update with uniform Markov kernel.

Metropolis-Hastings update
: Update with arbitrary Markov kernel.


## Unnecessary synonyms and special cases of Metropolis-Hastings-Green MCMC methods {#unnecessary-synonyms-and-special-cases-of-metropolis-hastings-green-mcmc-methods}

Fixed scan algorithm
: MCMC sampler involving composition.

Random scan algorithm
: MCMC sampler involving mixture.

Random sequence scan algorithm
: MCMC sampler involving composition and mixture.

Gibbs update
: Update with Metropolis-Hastings ratio of 1.0. That is, Gibbs
    updates are always accepted. Gibbs updates can be designed using conditional
    Markov kernels.

Gibbs sampler
: MCMC sampler in which all of the elementary updates are
    Gibbs, combined either by composition (fixed scan), by mixture (random scan),
    or both (random sequence scan).

Metropolis algorithm
: MCMC sampler in which all of the elementary updates
    are Metropolis, combined either by composition, mixture, or both (and the same
    "scan" terminology is used).

Metropolis-Hastings algorithm
: MCMC sampler in which all of the elementary
    updates are Metropolis-Hastings, combined either by composition, mixture, or
    both (and the same "scan" terminology is used).

Metropolis-within-Gibbs sampler
: The same as the preceding item. This name
    makes no sense at all since Gibbs is a special case of Metropolis-Hastings.

Independence Metropolis-Hastings algorithm
: Special case of the
    Metropolis-Hastings algorithm in which the Markov kernel does not depend on
    the current state: \\(q(x, \cdot)\\) does not depend on \\(x\\).

Random-walk Metropolis-Hastings algorithm
: Special case of the
    Metropolis-Hastings algorithm in which the proposal has the form \\(x+e\\),
    where \\(e\\) is stochastically independent of the current state \\(x\\), so
    \\(q(x, y\\) has the form \\(f(y-x)\\).

Reversible jump MCMC algorithm
: MCMC sampler including updates between
    different models possibly having a different set of parameters. However, these
    updates are in no way special.


## Special cases of auxiliary variable MCMC methods {#special-cases-of-auxiliary-variable-mcmc-methods}

-   Data augmentation.
-   Simulated annealing.
-   Simulated tempering.


## Special cases of population based MCMC methods {#special-cases-of-population-based-mcmc-methods}

-   Sequential Monte Carlo.
-   Parallel tempering.
-   Metropolic-coupled MCMC (MC3) is Parallel tempering.

## References

A. {Doucet} and A. M. {Johansen} (2011). _A tutorial on particle filtering and smoothing: fifteen years later_, Oxford: Oxford University Press.

Andrieu, Christophe and Doucet, Arnaud and Holenstein, Roman (2010). _Particle Markov chain Monte Carlo methods_.

Bouchard-Côté, Alexandre and Sankararaman, Sriram and Jordan, Michael I. (2012). _Phylogenetic inference via sequential monte carlo_.

Chopin, N. and Jacob, P. E. and Papaspiliopoulos, O. (2012). _SMC2: an efficient algorithm for sequential analysis of state space models_.

Del Moral, Pierre and Doucet, Arnaud and Jasra, Ajay (2006). _Sequential Monte Carlo samplers_.

Geyer, Charles J (2011). _Introduction to Markov Chain Monte Carlo_, CRC press.

Heng, Jeremy and Bishop, Adrian N. and Deligiannidis, George and Doucet, Arnaud (2020). _Controlled sequential Monte Carlo_.

Liang, Faming and Liu, Chuanhai and Carroll, Raymond (2011). _Advanced Markov chain Monte Carlo methods: learning from past samples_, John Wiley \\&amp; Sons.

Mathieu Fourment and Brian C. Claywell and Vu Dinh and Connor McCoy and Frederick A. Matsen IV and Aaron E. Darling (2018). _Effective online bayesian phylogenetics via sequential monte carlo with guided proposals_.

Brooks, Steve and Gelman, Andrew and Jones, Galin and Meng, Xiao-Li (2011). _Handbook of Markov Chain Monte Carlo_, CRC press.

Arnaud Doucet and Nando de Freitas and Neil Gordon (2001). _Sequential Monte Carlo Methods in Practice_, Springer.

Vu Dinh and Aaron E Darling and Frederick A Matsen IV (2018). _Online Bayesian phylogenetic inference: theoretical foundations via sequential Monte Carlo_.

Walter R. Gilks and Carlo Berzuini (2001). _Following a Moving Target-Monte Carlo Inference for Dynamic Bayesian Models_.

+++
title = "Encyclopedia of Markov chain Monte Carlo methods"
author = ["Dominik Schrempf"]
description = "In the MCMC community, many people call the same concepts by different names"
date = 2020-11-12T00:00:00+01:00
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
    Monte Carlo (MCMC) methods by <sup id="676b94678a2d6c9d04a9b66e91b82cd3"><a href="#Geyer2011" title="@InBook{          Geyer2011,
      Author        = {Geyer, Charles J},
      Title         = {{Introduction to Markov Chain Monte Carlo}},
      Pages         = 45,
      Publisher     = {CRC press},
      Year          = 2011,
      BookTitle     = {{Handbook of Markov Chain Monte Carlo}}
    }">Geyer2011</a></sup>, Chapter 1 in
    <sup id="e1e37a8427e438f2177e7c707a2f8694"><a href="#Brooks2011" title="Brooks, Gelman, Jones, \&amp; Meng, Handbook of Markov chain Monte Carlo, CRC press (2011).">Brooks2011</a></sup>.
-   More advanced topics such as population based MCMC methods are covered in
    <sup id="b5a706697adb263d73098e60072ae11d"><a href="#Liang2011" title="Liang, Liu \&amp; Carroll, Advanced Markov chain Monte Carlo methods: learning from  past samples, John Wiley \&amp; Sons (2011).">Liang2011</a></sup>.


### Articles {#articles}

-   <sup id="f0227103734119b77f5580811b6f3205"><a href="#Gilks2001" title="Walter Gilks \&amp; Carlo Berzuini, Following a Moving Target-Monte Carlo Inference for  Dynamic Bayesian Models, {Journal of the Royal Statistical Society. Series B
                      (Statistical Methodology)}, v(1), 127--146 (2001).">Gilks2001</a></sup>
-   <sup id="0ab33258c70dc93da405dceb25d5c9c9"><a href="#DelMoral2006" title="Del Moral, Doucet \&amp; Jasra, Sequential Monte Carlo samplers, {Journal of the Royal Statistical Society: Series B
                      (Statistical Methodology)}, v(3), 411--436 (2006).">DelMoral2006</a></sup>
-   <sup id="7a29f5f0390cfe4b9879af8fe6394cfd"><a href="#Andrieu2010" title="Andrieu, Doucet, Holenstein \&amp; Roman, Particle Markov chain Monte Carlo methods, {Journal of the Royal Statistical Society: Series B
                      (Statistical Methodology)}, v(3), 269--342 (2010).">Andrieu2010</a></sup>
-   <sup id="54b61d4f223d48473b86320c0a4d367e"><a href="#Doucet2011" title="@InCollection{    Doucet2011,
      Author        = {A. {Doucet} and A. M. {Johansen}},
      Title         = {{A tutorial on particle filtering and smoothing: fifteen
                      years later}},
      BookTitle     = {{The Oxford handbook of nonlinear filtering}},
      Publisher     = {Oxford: Oxford University Press},
      Year          = 2011,
      Pages         = {656--704},
      msc2010       = {62M10}
    }">Doucet2011</a></sup>
-   <sup id="0529e4756add5da79b1f4eef5589b43f"><a href="#Chopin2012" title="Chopin, Jacob \&amp; Papaspiliopoulos, SMC2: an efficient algorithm for sequential analysis of  state space models, {Journal of the Royal Statistical Society: Series B
                      (Statistical Methodology)}, v(3), 397--426 (2012).">Chopin2012</a></sup>


### Articles tailored to a phylogenetic audience {#articles-tailored-to-a-phylogenetic-audience}

-   <sup id="a6376643b744242fb6bba104f05712f2"><a href="#BouchardCote2012" title="Bouchard-C&#244;t&#233;, Sankararaman, \&amp; Jordan, Phylogenetic inference via sequential monte carlo, {Systematic Biology}, v(4), 579--593 (2012).">BouchardCote2012</a></sup>
-   <sup id="e8d23a1c69bc73198a7ec34c97f9d193"><a href="#Dinh2018" title="Vu Dinh, Aaron E Darling \&amp; Frederick A Matsen IV, Online Bayesian phylogenetic inference: theoretical  foundations via sequential Monte Carlo, {Systematic Biology}, v(3), 503--517 (2018).">Dinh2018</a></sup>
-   <sup id="5fd71a0f12feaf6490542a96b3c163cb"><a href="#Fourment2018" title="Mathieu Fourment, Brian Claywell, Vu Dinh, , Connor McCoy, Frederick Matsen IV, Aaron \&amp; Darling, Effective online bayesian phylogenetics via sequential  monte carlo with guided proposals, {Systematic Biology}, v(3), 490--502 (2018).">Fourment2018</a></sup>


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

# Bibliography
<a id="Geyer2011"></a>[Geyer2011] @InBook          Geyer2011,
  Author        = Geyer, Charles J,
  Title         = Introduction to Markov Chain Monte Carlo,
  Pages         = 45,
  Publisher     = CRC press,
  Year          = 2011,
  BookTitle     = Handbook of Markov Chain Monte Carlo
 [↩](#676b94678a2d6c9d04a9b66e91b82cd3)

<a id="Brooks2011"></a>[Brooks2011] Brooks, Gelman, Jones, & Meng, Handbook of Markov chain Monte Carlo, CRC press (2011). [↩](#e1e37a8427e438f2177e7c707a2f8694)

<a id="Liang2011"></a>[Liang2011] Liang, Liu & Carroll, Advanced Markov chain Monte Carlo methods: learning from  past samples, John Wiley & Sons (2011). [↩](#b5a706697adb263d73098e60072ae11d)

<a id="Gilks2001"></a>[Gilks2001] Walter Gilks & Carlo Berzuini, Following a Moving Target-Monte Carlo Inference for  Dynamic Bayesian Models, <i>Journal of the Royal Statistical Society. Series B
                  (Statistical Methodology)</i>, <b>63(1)</b>, 127-146 (2001). [↩](#f0227103734119b77f5580811b6f3205)

<a id="DelMoral2006"></a>[DelMoral2006] Del Moral, Doucet & Jasra, Sequential Monte Carlo samplers, <i>Journal of the Royal Statistical Society: Series B
                  (Statistical Methodology)</i>, <b>68(3)</b>, 411-436 (2006). <a href="http://dx.doi.org/10.1111/j.1467-9868.2006.00553.x">doi</a>. [↩](#0ab33258c70dc93da405dceb25d5c9c9)

<a id="Andrieu2010"></a>[Andrieu2010] Andrieu, Doucet, Holenstein & Roman, Particle Markov chain Monte Carlo methods, <i>Journal of the Royal Statistical Society: Series B
                  (Statistical Methodology)</i>, <b>72(3)</b>, 269-342 (2010). <a href="http://dx.doi.org/10.1111/j.1467-9868.2009.00736.x">doi</a>. [↩](#7a29f5f0390cfe4b9879af8fe6394cfd)

<a id="Doucet2011"></a>[Doucet2011] @InCollection    Doucet2011,
  Author        = A. Doucet and A. M. Johansen,
  Title         = A tutorial on particle filtering and smoothing: fifteen
                  years later,
  BookTitle     = The Oxford handbook of nonlinear filtering,
  Publisher     = Oxford: Oxford University Press,
  Year          = 2011,
  Pages         = 656-704,
  msc2010       = 62M10
 [↩](#54b61d4f223d48473b86320c0a4d367e)

<a id="Chopin2012"></a>[Chopin2012] Chopin, Jacob & Papaspiliopoulos, SMC2: an efficient algorithm for sequential analysis of  state space models, <i>Journal of the Royal Statistical Society: Series B
                  (Statistical Methodology)</i>, <b>75(3)</b>, 397-426 (2012). <a href="http://dx.doi.org/10.1111/j.1467-9868.2012.01046.x">doi</a>. [↩](#0529e4756add5da79b1f4eef5589b43f)

<a id="BouchardCote2012"></a>[BouchardCote2012] Bouchard-Côté, Sankararaman, & Jordan, Phylogenetic inference via sequential monte carlo, <i>Systematic Biology</i>, <b>61(4)</b>, 579-593 (2012). <a href="http://dx.doi.org/10.1093/sysbio/syr131">doi</a>. [↩](#a6376643b744242fb6bba104f05712f2)

<a id="Dinh2018"></a>[Dinh2018] Vu Dinh, Aaron E Darling & Frederick A Matsen IV, Online Bayesian phylogenetic inference: theoretical  foundations via sequential Monte Carlo, <i>Systematic Biology</i>, <b>67(3)</b>, 503-517 (2018). <a href="http://dx.doi.org/10.1093/sysbio/syx087">doi</a>. [↩](#e8d23a1c69bc73198a7ec34c97f9d193)

<a id="Fourment2018"></a>[Fourment2018] Mathieu Fourment, Brian Claywell, Vu Dinh, , Connor McCoy, Frederick Matsen IV, Aaron & Darling, Effective online bayesian phylogenetics via sequential  monte carlo with guided proposals, <i>Systematic Biology</i>, <b>67(3)</b>, 490-502 (2018). <a href="http://dx.doi.org/10.1093/sysbio/syx090">doi</a>. [↩](#5fd71a0f12feaf6490542a96b3c163cb)

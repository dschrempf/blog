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
    Monte Carlo (MCMC) methods by Geyer (<a href="#citeproc_bib_item_10">2011</a>), Chapter 1 in
    Brooks et al. (<a href="#citeproc_bib_item_3">2011</a>).
-   More advanced topics such as population based MCMC methods are covered in
    Liang, Liu, and Carroll (<a href="#citeproc_bib_item_13">2011</a>).
-   See Doucet, de Freitas, and Gordon (<a href="#citeproc_bib_item_8">2001</a>) for sequential Monte Carlo algorithms.


### Articles {#articles}

-   Gilks and Berzuini (<a href="#citeproc_bib_item_11">2001</a>)
-   Del Moral, Doucet, and Jasra (<a href="#citeproc_bib_item_5">2006</a>)
-   Andrieu, Doucet, and Holenstein (<a href="#citeproc_bib_item_1">2010</a>)
-   Doucet and Johansen (<a href="#citeproc_bib_item_7">2011</a>)
-   Chopin, Jacob, and Papaspiliopoulos (<a href="#citeproc_bib_item_4">2012</a>)
-   Heng et al. (<a href="#citeproc_bib_item_12">2020</a>)


### Articles tailored to a phylogenetic audience {#articles-tailored-to-a-phylogenetic-audience}

-   Bouchard-Côté, Sankararaman, and Jordan (<a href="#citeproc_bib_item_2">2012</a>)
-   Dinh, Darling, and IV (<a href="#citeproc_bib_item_6">2018</a>)
-   Fourment et al. (<a href="#citeproc_bib_item_9">2018</a>)


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


## References {#references}

<style>.csl-entry{text-indent: -1.5em; margin-left: 1.5em;}</style><div class="csl-bib-body">
  <div class="csl-entry"><a id="citeproc_bib_item_1"></a>Andrieu, Christophe, Arnaud Doucet, and Roman Holenstein. 2010. “Particle Markov Chain Monte Carlo Methods.” <i>Journal of the Royal Statistical Society: Series B (Statistical Methodology)</i> 72 (3): 269–342. <a href="https://doi.org/10.1111/j.1467-9868.2009.00736.x">https://doi.org/10.1111/j.1467-9868.2009.00736.x</a>.</div>
  <div class="csl-entry"><a id="citeproc_bib_item_2"></a>Bouchard-Côté, Alexandre, Sriram Sankararaman, and Michael I. Jordan. 2012. “Phylogenetic Inference via Sequential Monte Carlo.” <i>Systematic Biology</i> 61 (4): 579–93. <a href="https://doi.org/10.1093/sysbio/syr131">https://doi.org/10.1093/sysbio/syr131</a>.</div>
  <div class="csl-entry"><a id="citeproc_bib_item_3"></a>Brooks, Steve, Andrew Gelman, Galin Jones, and Xiao-Li Meng, eds. 2011. <i>Handbook of Markov Chain Monte Carlo</i>. CRC press.</div>
  <div class="csl-entry"><a id="citeproc_bib_item_4"></a>Chopin, N., P. E. Jacob, and O. Papaspiliopoulos. 2012. “Smc2: An Efficient Algorithm for Sequential Analysis of State Space Models.” <i>Journal of the Royal Statistical Society: Series B (Statistical Methodology)</i> 75 (3): 397–426. <a href="https://doi.org/10.1111/j.1467-9868.2012.01046.x">https://doi.org/10.1111/j.1467-9868.2012.01046.x</a>.</div>
  <div class="csl-entry"><a id="citeproc_bib_item_5"></a>Del Moral, Pierre, Arnaud Doucet, and Ajay Jasra. 2006. “Sequential Monte Carlo Samplers.” <i>Journal of the Royal Statistical Society: Series B (Statistical Methodology)</i> 68 (3): 411–36. <a href="https://doi.org/10.1111/j.1467-9868.2006.00553.x">https://doi.org/10.1111/j.1467-9868.2006.00553.x</a>.</div>
  <div class="csl-entry"><a id="citeproc_bib_item_6"></a>Dinh, Vu, Aaron E Darling, and Frederick A Matsen IV. 2018. “Online Bayesian Phylogenetic Inference: Theoretical Foundations via Sequential Monte Carlo.” Edited by Edward Susko. <i>Systematic Biology</i> 67 (3): 503–17. <a href="https://doi.org/10.1093/sysbio/syx087">https://doi.org/10.1093/sysbio/syx087</a>.</div>
  <div class="csl-entry"><a id="citeproc_bib_item_7"></a>Doucet, A., and A. M. Johansen. 2011. “A tutorial on particle filtering and smoothing: fifteen years later.” In <i>The Oxford handbook of nonlinear filtering</i>, edited by Dan Crisan and Boris Rozovskii, 656–704. Oxford: Oxford University Press.</div>
  <div class="csl-entry"><a id="citeproc_bib_item_8"></a>Doucet, Arnaud, Nando de Freitas, and Neil Gordon, eds. 2001. <i>Sequential Monte Carlo Methods in Practice</i>. Springer New York. <a href="https://doi.org/10.1007/978-1-4757-3437-9">https://doi.org/10.1007/978-1-4757-3437-9</a>.</div>
  <div class="csl-entry"><a id="citeproc_bib_item_9"></a>Fourment, Mathieu, Brian C. Claywell, Vu Dinh, Connor McCoy, Frederick A. Matsen IV, and Aaron E. Darling. 2018. “Effective Online Bayesian Phylogenetics via Sequential Monte Carlo with Guided Proposals.” Edited by Edward Suskso. <i>Systematic Biology</i> 67 (3): 490–502. <a href="https://doi.org/10.1093/sysbio/syx090">https://doi.org/10.1093/sysbio/syx090</a>.</div>
  <div class="csl-entry"><a id="citeproc_bib_item_10"></a>Geyer, Charles J. 2011. “Introduction to Markov Chain Monte Carlo.” In <i>Handbook of Markov Chain Monte Carlo</i>, edited by Steve Brooks, Andrew Gelman, Galin Jones, and Xiao-Li Meng, 45. CRC press.</div>
  <div class="csl-entry"><a id="citeproc_bib_item_11"></a>Gilks, Walter R., and Carlo Berzuini. 2001. “Following a Moving Target-Monte Carlo Inference for Dynamic Bayesian Models.” <i>Journal of the Royal Statistical Society. Series B (Statistical Methodology)</i> 63 (1): 127–46.</div>
  <div class="csl-entry"><a id="citeproc_bib_item_12"></a>Heng, Jeremy, Adrian N. Bishop, George Deligiannidis, and Arnaud Doucet. 2020. “Controlled Sequential Monte Carlo.” <i>Annals of Statistics</i> 48 (5): 2904–29. <a href="https://doi.org/10.1214/19-aos1914">https://doi.org/10.1214/19-aos1914</a>.</div>
  <div class="csl-entry"><a id="citeproc_bib_item_13"></a>Liang, Faming, Chuanhai Liu, and Raymond Carroll. 2011. <i>Advanced Markov Chain Monte Carlo Methods: Learning from Past Samples</i>. Vol. 714. John Wiley &#38; Sons.</div>
</div>

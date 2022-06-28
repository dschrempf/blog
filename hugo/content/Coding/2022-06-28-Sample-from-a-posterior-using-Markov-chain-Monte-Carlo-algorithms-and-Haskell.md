+++
title = "Parameter inference using Markov chain Monte Carlo algorithms and Haskell"
author = ["Dominik Schrempf"]
description = "How to use a Markov chain Monte Carlo sampler"
date = 2022-06-28T00:00:00+02:00
keywords = ["Markov chain Monte Carlo", "Haskell", "Metropolis-Hastings-Green", "Hamiltonian dynamics"]
categories = ["Coding"]
type = "post"
draft = false
+++

[Markov chains](https://en.wikipedia.org/wiki/Markov_chain) (or processes) are sequences of events with a peculiar property:
the probability of each possible next event only depends on the state of the
previous event. Markov chains are widely used in statistics, for example, to
predict the weather. An interesting application of Markov chains is [Markov chain
Monte Carlo](https://en.wikipedia.org/wiki/Markov_chain_Monte_Carlo), a class of algorithms used to effectively sample from probability
distributions.

<div class="blockemph">

This sounds theoretical and over-complicated. Why do I need a dedicated
algorithm to sample from a probability distribution? Isn't it easy to just pick
more probable values more often than less probably values, and do so with the
correct ratio?

</div>

The answer is: Yes, and this is exactly what Markov chain Monte Carlo is about.

Many times, however, it is much faster to use dedicated methods to sample from
probability distributions, for example, from the [normal distribution](https://en.wikipedia.org/wiki/Normal_distribution#Generating_values_from_normal_distribution). Actually,
the most famous Metropolis-Hastings-Green algorithm (<a href="#citeproc_bib_item_1">Geyer 2011</a>) samples
new values often from a normal distribution, only to accept or discard the new
value according to the actual probability distribution of interest.


## References {#references}

## References

<style>.csl-entry{text-indent: -1.5em; margin-left: 1.5em;}</style><div class="csl-bib-body">
  <div class="csl-entry"><a id="citeproc_bib_item_1"></a>Geyer, Charles J. 2011. “Introduction to Markov Chain Monte Carlo.” In <i>Handbook of Markov Chain Monte Carlo</i>, edited by Steve Brooks, Andrew Gelman, Galin Jones, and Xiao-Li Meng, 45. CRC press.</div>
</div>

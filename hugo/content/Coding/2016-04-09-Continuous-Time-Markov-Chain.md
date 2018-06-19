+++
title = "A simulator for continuous-time Markov chains"
author = ["Dominik Schrempf"]
description = "Simulate a continuous time Markov chain with any transition rate matrix."
date = 2016-04-09T00:00:00+02:00
keywords = ["CTMC", "", "Chain", "", "Markov", "Chain"]
type = "post"
draft = false
+++

<span class="timestamp-wrapper"><span class="timestamp">[2016-04-09 Sat] </span></span> I extended [my set of C++ programs]({{< relref "2015-03-26-PopGen-CPP-Programs" >}}) to include a
simulator for generic continuous-time Markov chains.  I.e., any
transition rate matrix can be used.

If you are interested, just get the [GitHub repository](https://github.com/dschrempf/popgen-cpp-programs) and compile the
whole set of programs with `make all`.  Documentation can be found in
the `doc/` folder (check the `CTMC` class).

There is a sample program `src/moran_model_boundary_mutation`, that
runs the Moran model with boundary mutation (De Maio, N., Schrempf,
D., & Kosiol, C. (2015). PoMo: An Allele Frequency-Based Approach for
Species Tree Estimation. Systematic Biology, 64(6),
1018–1031. <10.1093/sysbio/syv048>).

Using the chain is as easy as:

```C++
// Define a GNU Scientific Library Matrix object.
gsl_matrix * my_transition_rate_matrix = alloc_and_set_matrix();
CTMC my_chain(my_transition_rate_matrix, number_of_states);
my_chain.run(a_specific_time);

// Now we print some output.
my_chain.print_hitting_times(std::cout);
my_chain.print_invariant_distribution(std::cout);
```

If you want to log the path of the chain, you have to activate the log
path upon initialization:

```C++
CTMC my_chain(my_transition_rate_matrix, number_of_states, true);

// Print the path.
my_chain.print_path(std::cout);
```

Logging the path is disabled by default because it uses a lot of
memory.

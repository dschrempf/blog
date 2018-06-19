+++
title = "A simple MCMC simulation"
author = ["Dominik Schrempf"]
description = "MCMC simulation to approximate observations of coin tosses."
date = 2015-01-15T00:00:00+01:00
keywords = ["MCMC", "", "", "Statistics", "", "Toss"]
lastmod = 2018-06-19T11:45:00+02:00
type = "post"
draft = false
+++

Suppose we observe 58 heads out of 100 coin tosses. Now, we want to know the
probability of tossing a head \\(\theta\\). A maximum likelihood guess would be
\\(\theta = 0.58\\) because then, the probability of observing 58 heads

\begin{align}
  P(58 \mathrm{ heads}) = {100 \choose 58} (0.58)^{58} (0.42)^{42}
\end{align}

is greatest (an example of the binomial distribution).

However, we could also use a Bayesian approach to calculate the posterior
distribution of the probability \\(\theta\\) (i.e., the probability that \\(\theta\\) is
a certain value conditioned on our observation).

The following C++ code does exactly this (the last column is the posterior).

```C++
#include <iostream>
#include <iomanip>

#include <math.h>
#include <gsl/gsl_rng.h>

// Run a coin toss MCMC simulation.

// User interface.
// Observation.
int n_tosses = 100;
int n_heads  = 58;
int n_tails  = n_tosses - n_heads;

// MCMC settings.
int n_iter      = 10000;
int print_every = 500;
double delta    = 0.1;

void fix_width_cout_str (std::string s)
{
    std::cout << std::setw(10) << std::fixed << std::setprecision(2)<< s << "  ";
}

void fix_width_cout_dbl (double d)
{
    std::cout << std::setw(10) << std::fixed << std::setprecision(2)<< d << "  ";
}

int main (int argc, char *argv[])
{
    const gsl_rng_type * t;
    gsl_rng * r;
    double theta;               // The probability of tossing a head.
    double posterior[100];           // The posterior.

    gsl_rng_env_setup();

    t = gsl_rng_default;
    r = gsl_rng_alloc (t);
    gsl_rng_set (r, 1);

    // Pick a first guess from the prior distribution (uniform prior).
    // Here, the prior does not really effect the posterior.  However,
    // it kicks in, when the likelihood ratio for acceptance is
    // calculated (see below).
    theta = gsl_rng_uniform (r);

    std::cout << "Start MCMC." << std::endl;

    fix_width_cout_str("iteration");
    fix_width_cout_str("theta_old");
    fix_width_cout_str("theta_pri");
    fix_width_cout_str("ln_tot");
    fix_width_cout_str("pr_of_acc");
    fix_width_cout_str("theta_new");
    std::cout << std::endl;

    // Initialize posterior.
    for (int i = 0; i < 100; i++) {
        posterior[i] = 0.0;
    }

    for (int i = 0; i < n_iter; i++)
        {
            // Acceptance ratio.
            double acc;
            double ln_likelihood_ratio;
            double ln_prior_ratio;
            double ln_proposal_ratio;
            double ln_tot;

            //////////////////////////////
            // Propose a new theta.
            // Uniform, symmetric jump algorithm (Metropolis algorithm).

            // The jump algorithm influences the runtime (How many
            // proposals are accepted?) but it should not change the
            // posterior; this can be proven for the Metropolos and
            // the Metropolis-Hastings (non-symmetric jumps) algorithm.
            double old_theta   = theta;
            double rn          = gsl_rng_uniform (r);
            double theta_prime = theta + (rn - 0.5) * delta;

            if (theta_prime < 0.0)
                theta_prime = - theta_prime;
            if (theta_prime > 1.0)
                theta_prime = 2.0 - theta_prime;

            //////////////////////////////
            // Accept theta_prime?
            // Calculate the natural logarithm of the likelihood
            // ratios of the new proposal to the old one.  It consists
            // of:
            // 1. The likelihood ratio due to the model.
            // 2. The ratio of the prior (this is, where the prior
            // comes in).  If the likelihood ratio of the model is
            // flat (i.e., ln_likelihood_ratio ~= 0.0), the prior is
            // very informative; something that we do not want in
            // general.
            // 3. The ratio of the proposal (the jumping algorithm).
            // This is, how we incorporate non-symmetric jumping
            // algorithms, so that they do not change the posterior.
            ln_likelihood_ratio =
                (n_heads*log(theta_prime) + n_tails*log(1.0-theta_prime)) -
                (n_heads*log(theta) + n_tails*log(1.0-theta));
            ln_prior_ratio = 0.0;
            ln_proposal_ratio = 0.0;
            ln_tot = ln_likelihood_ratio + ln_prior_ratio + ln_proposal_ratio;

            // Circumvent underflow error.
            if (ln_tot < -300.0)
                acc = 0.0;
            else if (ln_tot > 0.0)
                acc = 1.0;
            else
                acc = exp (ln_tot);

            // Accept with probability acc.
            double u = gsl_rng_uniform (r);
            if (u < acc)
                {
                    theta = theta_prime;
                    posterior[(int)(theta*100)] += 1.0;
                }

            //////////////////////////////
            //Log results.
            if (i % print_every == 0)
                {
                    fix_width_cout_dbl (i);
                    fix_width_cout_dbl (old_theta);
                    fix_width_cout_dbl (theta_prime);
                    fix_width_cout_dbl (ln_tot);
                    fix_width_cout_dbl (acc);
                    fix_width_cout_dbl (theta);
                    std::cout << std::endl;
                }

        }

    std::cout << "MCMC finished." << std::endl;
    std::cout << std::endl;

    // Normalize posterior.
    double sum = 0.0;
    for (int i = 0; i < 100; i++) {
        sum += posterior[i];
    }
    for (int i = 0; i < 100; i++) {
        posterior[i] = posterior[i]/sum;
    }


    for (int i =0 ; i < 100; i++) {
        std::cout << "Theta between ";
        std::cout << std::setw(3) << i;
        std::cout << " and ";
        std::cout << std::setw(3) << i+1;
        std::cout << ":\t";
        std::cout << std::setw(4) << std::setprecision(2) << (posterior[i]);
        std::cout << std::endl;
    }


    gsl_rng_free (r);

    return 0;
}
```

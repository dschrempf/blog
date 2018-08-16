+++
title = "Markov chains in Haskell"
author = ["Dominik Schrempf"]
description = "A clean Markov chain in Haskell"
date = 2018-02-10T00:00:00+01:00
keywords = ["Markov", "chain", "", "", "matrix", "", "process"]
categories = ["Coding"]
type = "post"
draft = false
+++

I have been working on Markov chains for quite a while now and wanted to assess how
Haskell can deal with simulating a simple, discrete chain.

Many sources can be found online. The code presented here is partly taken from a
[question on stackoverflow](https://stackoverflow.com/questions/25286816/generating-sequence-from-markov-chain-in-haskell). However, I was unsatisfied with the nomenclature and
parts of the code. So I refactored most of it. Also, there is a Haskell library
[markov-chain](https://hackage.haskell.org/package/markov-chain), which I am unsatisfied with because of code readability (it's
pretty abstruse). Furthermore, I looked through a lengthy post about using
Markov chains to simulate [interaction of magnetic spins](https://idontgetoutmuch.wordpress.com/2013/12/07/haskell-ising-markov-metropolis/) using the Ising model.
The concept of a Markov chain is explained well in this article but I believe
that the example is too complicated to understand in a reasonable amount of
time. Also, the [Repa package](https://hackage.haskell.org/package/repa) is used to represent the transition matrices. This
seemed a little bit of an overkill to me, so I decided to go with [maps](http://hackage.haskell.org/package/containers-0.5.11.0/docs/Data-Map-Strict.html).

You can also [download the source code](/ox-hugo/MarkovChainWithMap.hs) of the following post.

In this example, we will handle sentences with words. So our states are words
which are strings. It is also convenient to introduce some type synonyms.

```haskell
module Main where

import qualified Control.Monad.Random as R
import qualified Data.Map as M

-- | For better readability of the code, it is convenient to distinguish between
-- the source and the target.
type Source = String
type Target = String

-- | Transition from 'Source' to 'Target' observed in a sample.
type Transitions = [(Source, Target)]

-- | A 'Target' with associated frequency.
type TargetF = (Target, Rational)
```

As mentioned before, the transition matrix is represented using a map. This
might not be very efficient but it is easy to understand. The keys are just all
the words that we can start from. The values are, for each source, the targets
that we can _jump_ to and their respective frequencies in the data.

```haskell
type TransitionMatrix = M.Map Source [TargetF]
```

This function is the heart of the simulation. For a given transition probability
matrix and an initial string add a new word until a stop condition is reached.
Here, the stop condition is the end of a sentence (a period ".").

```haskell
generateSequence :: (R.MonadRandom m) => TransitionMatrix -> String -> m String
generateSequence tm s
  -- We have to test first, if the string is not null, otherwise 'last' throws
  -- an exception.
  | not (null s) && last s == '.' = return s
  | otherwise = do
      s' <- R.fromList $ tm M.! s
      ss <- generateSequence tm s'
      -- Only add a space after another word.
      return $ if null s then ss else s ++ " " ++ ss
```

The next functions are used to fill the transition matrix given a list of
observed transitions.

```haskell
-- | Add a target with its frequency to a list of targets with their
-- frequencies.
addTargetF :: TargetF -> [TargetF] -> [TargetF]
addTargetF (t, f) ts = case lookup t ts of
                   Nothing -> (t, f) : ts
                   Just n  -> (t, n+f) : filter notT ts where
                     notT (r, _) = r /= t

-- | Add more targets and their frequencies to a list of targets with their
-- frequencies. This function is needed because 'M.insertWith' requires an
-- inserting function of type (a -> a -> a).
addTargetFs :: [TargetF] -> [TargetF] -> [TargetF]
addTargetFs tsA tsB = foldr addTargetF tsB tsA

-- | Convert the observed transitions to the transition rate matrix.
transitionsToMatrix :: Transitions -> TransitionMatrix
transitionsToMatrix = foldr insert M.empty
  where
    insert t = M.insertWith addTargetFs (fst t) [(snd t, 1.0)]
```

Now, we need a collection of samples and a way to retrieve all the observed
transitions. The start of sentences is a little bit tricky. We kind of introduce
a new state here, the empty string "", which is followed by the first words of
the provided sentences.

```haskell
-- | Collect all transitions from one word to the next.
getTransitions :: [String] -> Transitions
getTransitions (s:ss) = zip ("":ws) ws ++ getTransitions ss
  where ws = words s
getTransitions _      = []

-- | A collection of samples.
samples :: [String]
samples = [ "I am a monster."
         , "I am a rock star."
         , "I want to go to Hawaii."
         , "I want to eat a hamburger."
         , "I have a really big headache."
         , "Haskell  is a fun language."
         , "Go eat a big hamburger."
         , "Markov chains are fun to use."
         ]
```

And that's already it. We can combine and execute our functions in the following
way.

```haskell
main :: IO ()
main = do
  s <- generateSequence (transitionsToMatrix $ getTransitions samples) ""
  print s
```

E.g.,

```text
> main
"I am a big hamburger."
```

Of course, the next step is to remove the `String` type dependency so that we
can use our chain for arbitrary types. Then, we might try to convert our code
into simulating a [continuous-time Markov process]({{< relref "2016-04-09-Continuous-Time-Markov-Chain" >}}), but this is another topic.

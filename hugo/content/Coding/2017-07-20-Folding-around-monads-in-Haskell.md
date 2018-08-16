+++
title = "Happy folding around monads in Haskell"
author = ["Dominik Schrempf"]
description = "An example of a monadic fold"
date = 2017-07-20T00:00:00+02:00
keywords = ["Haskell", "", ""]
tags = ["Coding"]
type = "post"
draft = false
+++

Folds are complicated themselves, but monadic folds always have blown my mind.
In what follows, I try to dissect `foldlM` for a specific example.

Monadic folds can be used to **perform a series of actions that depend on the
previous output**. The following function produces an _action b_ from a _value a_
also taking into account the output of the previous _action b_.

```haskell
f :: (b -> a -> m b)
```

And here the definition of `foldlM` (which is the same as `foldM`).

```haskell
foldlM :: (Foldable t, Monad m) => (b -> a -> m b) -> b -> t a -> m b
foldlM f z0 xs = foldr f' return xs z0
  where f' x k z = f z x >>= k
```

Let's have a look at an example. The following function performs `n` jumps of a
Markov chain starting from a given `State` `s` (an integer) according to a
transition probability matrix `ProbMatrix` `p` (don't worry about the state
space, or the state space size, it does not matter). At the moment, I am not
sure how to access or store the actual chain. This could be done by an
equivalent of `scanl` for general monads, which I was unable to find.

```haskell
jumpN :: (Monad m) => State -> ProbMatrix -> Int -> m State
jumpN s p n = foldM jump s (replicate n p)

jump :: (Monad m) => State -> ProbMatrix -> m State
```

And specifically, with `p` being any transition probability matrix

```haskell
jumpN 0 p 2 = foldM jump 0 [p, p]
```

Now we use the definition of `foldM`

```haskell
jumpN 0 p 2 = foldr f' return [p, p] 0
  where f' x k z = jump z x >>= k
```

which leads to

```haskell
jumpN 0 p 2 = f' p (foldr f' return [p]) 0
            = f' p (f' p (foldr f' return []) 0
            = f' p (f' p (return)) 0
            = f' p (f' p return) 0
            = jump 0 p >>= (f' p return)
```

And finally, we got what we wanted. This is the first time, that we see that
first, we perform a jump from zero and use the output to feed it to the next
jump.

```haskell
jumpN 0 p 2 = jump 0 p >>= (f' p return)
            = do
            s' <- jump 0 p
            f' p return s'
            = do
            s' <- jump 0 p
            (jump s' p >>= return)
            = do
            s'  <- jump 0  p
            s'' <- jump s' p
            return s''
```

Holy crap, I am not sure if understanding this was worth the pain :-).

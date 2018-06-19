-- The skeleton of this file is from
-- https://stackoverflow.com/questions/25286816/generating-sequence-from-markov-chain-in-haskell

-- However, it has been refactored quite a bit and comments have been added.

module Main where

import qualified Control.Monad.Random as R
import qualified Data.Map as M

-- | In this example, we handle sentences with words. So our states are strings.
-- For better readability of the code, it is convenient to distinguish between
-- the source and the target.
type Source = String
type Target = String

-- | Transition from 'Source' to 'Target' observed in a sample.
type Transitions = [(Source, Target)]

-- | A 'Target' with associated frequency.
type TargetF = (Target, Rational)

-- | The transitions from 'Source' to 'Target' with their frequency. This
-- (together with an initial value) completely defines the chain.
type TransitionMatrix = M.Map Source [TargetF]

-- | This function is the heart of the simulation. For a given transition
-- probability matrix and an initial string add a new word until a stop
-- condition is reached. Here, the stop condition is the end of a sentence (a
-- period).
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

-- | Collect all transitions from one word to the next.
getTransitions :: [String] -> Transitions
getTransitions (s:ss) = zip ("":ws) ws ++ getTransitions ss
  where ws = words s
getTransitions _      = []

-- | A collections of samples.
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

main :: IO ()
main = do
  s <- generateSequence (transitionsToMatrix $ getTransitions samples) ""
  print s

+++
title = "Algebraic graphs"
author = ["Dominik Schrempf"]
description = "A great way to think and reason about graphs"
date = 2019-11-21T00:00:00+01:00
keywords = ["Graph", "Algebra", "Alga", "Tree", "Sum", "Product", "Group", "Semigroup", "Monoid", "Haskell"]
categories = ["Coding"]
type = "post"
draft = false
+++

The [Algebraic Graphs Haskell library](https://hackage.haskell.org/package/algebraic-graphs) (Alga) is a fast, minimalist, and elegant
approach to working with graphs that allows for equational reasoning about the
correctness of algorithms. For reference, please also see the [accompanying
paper](https://github.com/snowleopard/alga-paper).

The advantages are:

-   algebraic graphs have a small core with just four graph construction primitives;
-   the core has a mathematical structure characterized by a set of laws or
    properties.

A **directed graph** in the mathematical sense is a set \\(V\\) of vertices \\(v\_i\\)
together with a set \\(E\\) of directed edges \\((v\_i, v\_j)\\), and is denoted
\\((V,E)\\). The beauty about algebraic graphs is that they are not defined
explicitly by lists of vertices and edges but in a recursive manner, similar to
the definition of algebraic trees.

```haskell
data Graph a = Empty
  | Vertex a
  | Overlay (Graph a) (Graph a)
  | Connect (Graph a) (Graph a)
```

A graph is either empty `ε`, consists of a single vertex `v`, or it is somehow
constructed by a combination of two sub-graphs using the binary construction
operators `Overlay` \\((+)\\) or `Connect` \\((\*)\\).

-   The **overlay** of two graphs is the union of vertices and edges

    \begin{align}
      (V\_1, E\_1) + (V\_2, E\_2) = (V\_1 \cup V\_2, E\_1 \cup E\_2).
    \end{align}
-   The **connection** of two graphs additionally creates edges between the vertices
    of the two graphs

    \begin{align}
      (V\_1, E\_1) \* (V\_2, E\_2) = (V\_1 \cup V\_2, E\_1 \cup E\_2 \cup V\_1 \times V\_2).
    \end{align}

    \\((V\_1 \times V\_2)\\) is the set of all edges from vertices of \\(V\_1\\) to
    vertices of \\(V\_2\\). For example, if \\(V\_1 = \\{1,2\\}\\), and \\(V\_2 = \\{3,4\\}\\),
    then

    \begin{align}
      (V\_1 \times V\_2) = \\{ (1,3), (1,4), (2,3), (2,4) \\}.
    \end{align}

    Only the connect operation allows the creation of new edges.

The algebraic properties of the the `Graph` data type are collected in a type
class which is also called `Graph`.

```haskell
class Graph g where
  type Vertex g
  empty :: g
  vertex :: Vertex g -> g
  overlay :: g -> g -> g
  connect :: g -> g -> g
```

The definition involves a [type synonym family](https://wiki.haskell.org/GHC/Type%5Ffamilies), which is a function on the type
level. The type synonym family specifies how the type of a vertex can be
extracted from the data type instance.

A valid `Graph` instance should fulfill the following **laws**:

-   \\((G, +, \epsilon)\\) is an idempotent commutative [monoid](https://en.wikipedia.org/wiki/Monoid). A monoid is an
    algebraic structure with an associative binary operation and an identity
    element. Idempotent means that \\(\forall x \in G: x + x = x\\).
-   \\((G, \ast, \epsilon)\\) is a monoid.
-   \\(\ast\\) distributes over \\(+\\). That is, \\(1 \ast (2 + 3) = (1 + 2) \ast (1 +
      3)\\).

This structure is very close to an idempotent [semiring](https://en.wikipedia.org/wiki/Semiring). The differences are:

-   The identity elements \\(\epsilon\_+\\) and \\(\epsilon\_{\ast}\\) are the same.
-   Consequently, \\(\epsilon\_+\\) is not an annihilating element and it is wrong
    that \\( \forall x \in G: \epsilon\_+ \ast x = 0 \\).

Further, we have the **decomposition law**:

\begin{align}
  x \ast y \ast z = x \ast y + x \ast z + y \ast z.
\end{align}

The strong decomposition law is a sufficient condition to induce the following
statements.

-   The identities of \\(+\\) and \\(\ast\\) are equal.
-   \\(+\\) is idempotent.

The binary operators \\(+\\) and \\(\ast\\) are closed, and together with
\\(\epsilon\\) and \\(v\\), algebraic graphs are complete. In particular, we cannot
create algebraic graphs that are not graphs in the mathematical sense, and all
graphs can be represented using algebraic graphs.

_The construction of a specific graph is **not identifiable**._ Similar to \\(8=5+3\\)
and \\(8=4+4\\), we can generate a graph by choosing two difference bipartitions
and overlay them. More basic, \\( \forall x \in G\\) we have

\begin{align}
  x = x \ast \epsilon.
\end{align}

_The [canonical form](https://en.wikipedia.org/wiki/Canonical%5Fform) of a given graph \\(g = (V\_g, E\_g)\\) is_

\begin{align}
  g = \sum\_{v \in V\_g} v + \sum\_{(u,v) \in E\_g} u \ast v.
\end{align}

We can define a **partial order** on graphs by

\begin{align}
  x \le y \iff x + y = y.
\end{align}

This is exactly the usual definition of a sub graph.

\begin{align}
  x \subseteq y \equiv x + y = y.
\end{align}

A graph instance, additionally having multiplicative commutativity

\begin{align}
  x \ast y = y \ast x
\end{align}

represents an **undirected graph**. In this case, the strong decomposition law
also induces associativity of \\(\ast\\).

The algebraic way of thinking about graphs and how to manipulate them was new to
me. Nonsense graph objects cannot be created at all, and so, an important source
of bugs is eliminated. This principle is an excellent example of the dogma
[parse, don't validate](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/), for which Haskell forms an excellent framework.

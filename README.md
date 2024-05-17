# decl-cm-playground

AKA: Declarative configuration management playground.

## Idea

[Declarative programming](https://en.wikipedia.org/wiki/Declarative_programming) has several
definitions which are not entirely compatible with each other. This leads to
people describing a variety of systems as declarative in one sense, but not in
other senses.

This repository will explore this in the context of configuration management
(CM) as the approach used by these software systems can vary greatly. In
particular, some CM systems allow for conditionals, loops, and ordering of
tasks. While these constructs are useful, depending on their implementation,
they can make the CM system less declarative.

One approach that I'm thinking through is that CM systems could use a knowledge
management system. This is already implemented in CFEngine 3 using Topic Maps.
What I am after here is not gathering facts about a running system, but
capturing facts about what makes up a final system and all its components. This
would give a hierarchical model along with dependencies and interfaces between
the components. These dependencies and interfaces are important because it is
the relationships between components that can reveal the order that changes
should be made.

There is also a slightly related area called "knowledge-based configuration".
This is more about using knowledge representation to model software product
lines.
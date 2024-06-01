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
management system. This is already implemented in CFEngine 3 using Topic Maps
[^cfengine-impl-km](https://docs.cfengine.com/docs/archive/manuals/st-knowledge.html)
[^burgess-2009-km-and-promises](https://dl.ifip.org/db/conf/aims/aims2009/Burgess09.pdf)
[^burgess-2010-notes-usenix-lisa-km-workshop](https://markburgess.org/blog_km.html)
[^burgess-2009-nightmare-of-knowledge](https://markburgess.org/blog_dream.html)
[^burgess-2012-scaffolding-of-knowledge](https://markburgess.org/blog_scaffold.html)
[^burgess-2013-evo-of-cm-thinking](https://markburgess.org/blog_whyiscmknowledge.html)
[^burgess-semantic-spacetimes](https://markburgess.org/spacetime.html)
.
What I am after here is not gathering facts about a running system, but
capturing facts about what makes up a final system and all its components. To
say it another way,  the knowledge here should be *a priori*.

This would give a hierarchical model along with dependencies and interfaces between
the components. These dependencies and interfaces are important because it is
the relationships between components that can reveal the order that changes
should be made.

There is also a slightly related area called
["knowledge-based configuration"](https://en.wikipedia.org/wiki/Knowledge-based_configuration).
This is more about using knowledge representation to model
[software product lines (SPL)](https://en.wikipedia.org/wiki/Software_product_line).
Work in that area could be useful in the sense that the SPLs
represent a system.

# TODO

- Show differing levels of "declarativity" in various CM systems.
- Show examples of *a priori*  and *a posteriori* knowledge
  with these systems.
- Can the idea of entities with types (things not strings) be used for modeling
  systems? Do existing CM systems provide this? Technically, everything in a computer is
  strings, but what I mean is that can one uniquely and semantically identify a
  particular component?

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
[^cfengine-impl-km]
[^burgess-2009-km-and-promises]
[^burgess-2009-nightmare-of-knowledge]
[^burgess-2010-notes-usenix-lisa-km-workshop]
[^burgess-2012-scaffolding-of-knowledge]
[^burgess-2013-evo-of-cm-thinking]
[^burgess-semantic-spacetimes]
.
What I am after here is not gathering facts about a running system, but
capturing facts about what makes up a final system and all its components. To
say it another way,  the knowledge here should be *a priori*.

[^cfengine-impl-km]: [CFEngine docs: Implementing Knowledge Management](https://docs.cfengine.com/docs/archive/manuals/st-knowledge.html)

[^burgess-2009-km-and-promises]: [Knowledge Management and Promises. by Mark Burgess (Ramin Sadre, Aiko Pras: Scalability of Networks and Services, Third International Conference on Autonomous Infrastructure, Management and Security, AIMS 2009, Enschede, The Netherlands, June 30-July 2, 2009. Proceedings. Springer, Lecture Notes in Computer Science 5637, ISBN: 978-3-642-02626-3)](https://dl.ifip.org/db/conf/aims/aims2009/Burgess09.pdf)

[^burgess-2009-nightmare-of-knowledge]: [Mark Burgess Website - The Nightmare of Knowledge](https://markburgess.org/blog_dream.html)
<!--<h2>The Nightmare of Knowledge</h2> <h3>September 27 2009</h3> <a href="blog_dream.html">Read more</a>-->

[^burgess-2010-notes-usenix-lisa-km-workshop]: [Mark Burgess Website - Notes from the USENIX/LISA Knowledge Management Workshop](https://markburgess.org/blog_km.html)
<!--<h2>LISA Knowledge Management Workshop</h2> <h3>13th December 2010</h3> href="blog_km.html">Read more</a>-->

[^burgess-2012-scaffolding-of-knowledge]: [Mark Burgess Website - The Scaffolding of Knowledge (Beyond desired state configuration management, for the Third Wave)](https://markburgess.org/blog_scaffold.html)
<!--<h2>The Scaffolding of Knowledge (Beyond desired state configuration management, for the Third Wave)</h2> <h3>5th April 2012</h3> <a href="blog_scaffold.html">Read more</a> -->

[^burgess-2013-evo-of-cm-thinking]: [Mark Burgess Website - The evolution of configuration management thinking as a business problem (in 2 universes)](https://markburgess.org/blog_whyiscmknowledge.html)
<!--<h2>The evolution of configuration management thinking as a business problem (in 2 universes)</h2> <h3>13 August 2013</h3> <a href="blog_whyiscmknowledge.html">Read more</a> -->

[^burgess-semantic-spacetimes]: [Mark Burgess Website - Semantic Spacetime Project](https://markburgess.org/spacetime.html),
[Semantic Spacetime and Promise Theory of Autonomous Networks - YouTube](https://www.youtube.com/watch?v=n81UP8BuOb8),
[GitHub - markburgess/SemanticSpaceTime](https://github.com/markburgess/SemanticSpaceTime),
[List: Semantic Spacetime and Data Analytics | Curated by Mark Burgess | Medium](https://mark-burgess-oslo-mb.medium.com/list/semantic-spacetime-and-data-analytics-28e9649c0ade)
\
[(1907.01796) Koalja: from Data Plumbing to Smart Workspaces in the Extended Cloud](https://arxiv.org/abs/1907.01796),
[GitHub - AljabrIO/koalja-operator: Development for Koalja - Smart data pipelines](https://github.com/AljabrIO/koalja-operator)
[List: Data pipelines | Curated by Mark Burgess | Medium](https://mark-burgess-oslo-mb.medium.com/list/data-pipelines-fed29bd4d9d4)


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

# Scenarios

## build-automation

- [bass](scenario/build-automation/bass/index.md)
- [bazel](scenario/build-automation/bazel/index.md)
- [earthly](scenario/build-automation/earthly/index.md)
- [gradle](scenario/build-automation/gradle/index.md)
- [maven](scenario/build-automation/maven/index.md)

## configuration-management

- [ansible](scenario/configuration-management/ansible/index.md)
- [cfengine](scenario/configuration-management/cfengine/index.md)
- [chef](scenario/configuration-management/chef/index.md)
- [puppet](scenario/configuration-management/puppet/index.md)
- [saltstack](scenario/configuration-management/saltstack/index.md)

## infrastructure-as-code

- [terraform](scenario/infrastructure-as-code/terraform/index.md)

## package-manager

- [nix](scenario/package-manager/nix/index.md)

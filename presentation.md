# Intro

Good morning! As a quick introduction, my name is Kyle and I am part of a two person DevOps team in on the larger Developer Experience Team. My colleague Gary and I are responsible for building and delivering https://developers.arcgis.com to production twice daily. The Developer website is comprised of 20 plus repositories of MDX files that is transpiled to HTML via a Node.js static site generator. This is static site generator is invoked by Github Action runners containerized on a Hashicorp Nomad cluster running on ECS VMs in the ESRI datacenter.  
As part of our build infrastructure and orchestration, Gary and I rely heavily on several tools, 4 of those tools in particular are BASH, GNU Make, NuShell and Just. To explain the use of the latter two tools, Just and NuShell, we should start by explaining our use of the former two two tools, Bash and Make.  
Many people on this call are likely familiar with both BASH and Make and i would hazard they are likely more conversant in said tools than I am.  That stated, to those on this call who are not familiar, a quick synopsis and overview is merited.  

## BASH

BASH is the shorthand name of for "Bourne-Again Shell", a direct descendent of the "sh" UNIX shell which was written by Stephen Bourne, hence the pun/joke of calling the newer shell "Bourne-again". It is highly likely, that if you have interfaced with a linux machine in the past 20 years via the commandline, you have interacted with BASH rather than "sh" or some other shell. The GNU Bash manual has an excellent summary of what a shell is and what it does so I will direct you to read that information there. As an aside, in my opinion, the GNU Documentation for most all GNU Software  (including GNU Make) is the gold standard for clarity and organization.  

## GNU Make

There are several flavors of Make but I will exclusively focus on GNU Make for this discussion. Make is a tool that in general, that facilitates the transformation of source code into executable code. It does this by reading the build instructions from a file called a makefile and executing those instructions, similar to how the Docker daemon constructs a Docker image from instructions contained in a Dockerfile. The key thing to remember is that Make is the "baker" who "bakes" the products by followin the "recipes" encoded in the makefile. ..


## Nushell

Nushell is a new shell and programming language written in Rust. The shell has many built-in commands and allows invoking many existing commandline utilities. The shell programming language is oriented around a couple of key features:
1. Strongly typed vs everything is a string in BASH, this means things coming through the pipeline is data, making this more similar to Powershell than to BASH.
2. The Nushell language is strongly based on functional programming languages, this means that variables are immutable by default and nearly every operation returns a value.

## Just


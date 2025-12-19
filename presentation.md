# Intro

Today I would like to talk about two software tools that I am very excited about: Just and NuShell. However, to fully represent my enthusiasm for these tools, it would be useful to discuss two similar and useful pieces of software: Bash and Make.

## BASH

BASH is the shorthand name of for "Bourne-Again Shell", a direct descendent of the "sh" UNIX shell which was written by Stephen Bourne, hence the pun/joke of calling the newer shell "Bourne-Again". It is highly likely, that if you have interfaced with a linux machine in the past 20 years via the commandline, you have interacted with BASH rather than the Bourne Shell ("sh") or one of the other myriad shells. The GNU Bash manual has an excellent summary of what a shell is and what it does so I will direct you to read that information there. As an aside, in my opinion, the GNU Documentation for most all GNU Software  (including GNU Make) is the gold standard for clarity and organization. 

## GNU Make

There are several flavors of Make but I will exclusively focus on GNU Make for this discussion. Make is a tool that in general, facilitates the transformation of source code into executable code. It does this by reading the build instructions from a file called a makefile and executing those instructions, similar to how the Docker daemon constructs a Docker image from instructions contained in a Dockerfile. The key thing to remember is that Make is the "baker" who "bakes" the products by followin the "recipes" encoded in the makefile. ..


## Nushell

Nushell is a new shell and programming language written in Rust. The shell has many built-in commands and allows invoking many existing commandline utilities. The shell programming language is oriented around a couple of key features:
1. Strongly typed vs everything is a string in BASH, this means things coming through the pipeline is data, making this more similar to Powershell than to BASH.
2. The Nushell language is strongly based on functional programming languages, this means that variables are immutable by default and nearly every operation returns a value.

## Just


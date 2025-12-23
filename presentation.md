# Intro


Initially when I pitched this presentation, I wanted to make it about deprecating 2 software tools in favor of 2 other tools, hence the title. As I created the examples for each of these tools around a simple problem, the more I became convinced that none of these 4 tools were all "good" or all "bad" and so I decided to orient the discussion toward the actual problem I was solving in my examples and showcase a few different solutions alongside the pros and cons of each those solutions. As a DevOps practitioner, most of my job is actually spent gluing different stuff together to give the appearance of a seamless system rather than an assemblage of bits and bobs cobbled together. Like all users of adhesive, be it model builders, plumbers or woodworkers, a DevOps practitioner grows to enjoy the understanding of "glue", it's speed of use, it's strengths, it's weaknesses, it's failure modes and indeed maybe even it's offputting smell.  Oftentimes, what we most understand about a given "glue" is the practicality of it, it's ease of application, it's longevity or lack thereof and most of all that it will probably just be "good enough" for the purpose we are tasking it with.  To return to the role we inhabit as DevOps practitioners, we often find the best tool is the one we have and the second best tool is the one we can get and maintain the easiest. Too that end, I want to discuss two tools that are nearly universal on Unix-like systems, Bash and Make, as well as two tools that require us to install them, but require virtually no maintenance and whose utility outweigh the pain of acquisition, those tools being Just and NuShell. But, first we should showcase  the simple problem we are setting out to solve.


## Example Task

In our daily roles as DevOps practitioners, we tend to have an unfortunate reliance on the internet and specifically, services available on the internet. Many of these services provide a status page that we can view to see if there are any past or current service incidents that will degrade our ability to complete our work. Let's create a simple script we can use to query the status of these services. Let's presume we need to retrieve the current state of the following services:
 * The Node Pacakage Manager Repository.
 * The Python Package Manager Repository.
 * The public Github Code repository.

Conveniently, each of these services use the same software for their service status pages which will make the abstraction of their retrieval convenient for our example code.




























If we were to do this in bash, we could use cURL to retrieve the JSON response but now we a new problem: Bash is somewhat oriented around processing line based text and we have a nested key value structure. We can introduce a command line JSON filter/processor JQ to our environment and retrieve the value for the nested key of 'status.description'.


## BASH

Bash is the shorthand name of for "Bourne-Again Shell", a direct descendent of the "Bourne Shell" which was written by Stephen Bourne and released in 1979, which explains the pun/joke of calling the newer shell "Bourne-Again". It is highly likely, that if you have interfaced with a linux machine in the past 20 years via the command line, you have interacted with Bash rather than the Bourne Shell or another of the other myriad shells available. The [GNU Bash manual](https://www.gnu.org/software/bash/manual/bash.html) has an excellent summary of [what a shell is](https://www.gnu.org/software/bash/manual/bash.html#What-is-a-shell_003f) and the [differences between Bash and the Bourne Shell](https://www.gnu.org/software/bash/manual/bash.html#Major-Differences-From-The-Bourne-Shell).  One of the key things to understand about Bash is it's type system, Bash only understands the data types of strings, integers, lists and in later versions associative arrays.

## GNU Make

There are several flavors of Make but I will exclusively focus on GNU Make for this discussion. Make is a tool that in general, facilitates the transformation of source code into executable code. It does this by reading the build instructions from a file called a makefile and executing those instructions, similar to how the Docker daemon constructs a Docker image from instructions contained in a Dockerfile. The key thing to remember is that Make is the "baker" who "bakes" the products by followin the "recipes" encoded in the makefile. ..

## Nushell

Nushell is a new shell and programming language written in Rust. The shell has many built-in commands and allows invoking many existing commandline utilities. The shell programming language is oriented around a couple of key features:
1. Strongly typed vs everything is a string in BASH, this means things coming through the pipeline is data, making this more similar to Powershell than to BASH.
2. The Nushell language is strongly based on functional programming languages, this means that variables are immutable by default and nearly every operation returns a value.

## Just


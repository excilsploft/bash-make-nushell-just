# Intro


Initially when I pitched this presentation, I wanted to make it about deprecating 2 software tools in favor of 2 other tools, hence the title of the talk. As I created the examples for each of these tools around a simple problem, the more I became convinced that none of these 4 tools were all "good" or all "bad" and so I decided to orient the discussion toward the actual problem I was solving in my examples and showcase a few different solutions alongside the pros and cons of each those solutions. As a DevOps practitioner, most of my job is actually spent gluing various software together to give the appearance of a seamless system rather than the assemblage of bits and bobs cobbled together that it is. Like all users of adhesive, be it model builders, plumbers or woodworkers, a DevOps practitioner grows to enjoy the understanding of "glue", it's speed of use, it's strengths, it's weaknesses, it's failure modes and indeed maybe even it's offputting smell.  Oftentimes, what we most understand about a given "glue" is the practicality of it, it's ease of application, it's longevity or lack thereof and most of all that it will probably just be "good enough" for the purpose we are tasking it with.  To return to the role we inhabit as DevOps practitioners, we often find the best tool is the one we have and the second best tool is the one we can get and maintain the easiest. Too that end, I want to discuss two tools that are nearly universal on Unix-like systems, Bash and Make, as well as two tools that require us to install them, but require virtually no maintenance and whose utility outweigh the pain of acquisition, those tools being Just and NuShell. But, first we should showcase  the simple problem we are setting out to solve.



## Requirements

The [examples](./examples) require the following software versions to fully function:
| Software | Version |
|----------|---------|
| Bash     | >=4     |
| GNU Make | >=3.81  |
| cURL     | >=8.5   |
| jq       | >=1.7   |
| Just     | 1.43.1  |
| NuShell  | 0.105.1 |
| Docker   | >= 28.0 |


**NOTE** Bash on most Mac machines is quite old, the Bash version in the examples uses Bash greater than 4+ (for associative arrays).  You can install a newer version using HomeBrew, just be sure to add it to your `PATH` environment variable first i.e. `export PATH=opt/homebrew/bin/bash:$PATH`


## Example Task

In our daily roles as DevOps practitioners, we tend to have an unfortunate reliance on the internet and specifically, services available on the internet. Despite being relatively reliable, many of these services provide a status page that we can view to see if there are any past or current service incidents that will degrade our ability to complete our work. Let's create a simple script we can use to query the status of these services. Let's presume we need to retrieve the current state of the following services:
 * The Node Pacakage Manager Repository.
 * The Python Package Manager Repository.
 * The public Github Code repository.

Conveniently, each of these services use the same software for their service status pages which will make the abstraction of their retrieval convenient for our example code.

Here is an excerpt of the JSON response we get when querying [Github's status page api](https://www.githubstatus.com/api/v2/summary.json):

```
{
  "page": {
    "id": "kctbh9vrtdwd",
    "name": "GitHub",
    "url": "https://www.githubstatus.com",
    "time_zone": "Etc/UTC",
    "updated_at": "2025-12-23T17:11:03.425Z"
  },
  "components": [
    {
      "id": "pjmpxvq2cmr2",
      "name": "Copilot",
      "status": "operational",
      "created_at": "2022-06-21T16:04:33.017Z",
      "updated_at": "2025-12-18T19:09:47.992Z",
      "position": 11,
      "description": null,
      "showcase": false,
      "start_date": "2022-06-21",
      "group_id": null,
      "page_id": "kctbh9vrtdwd",
      "group": false,
      "only_show_if_degraded": false
    }
  ],
  "incidents": [],
  "scheduled_maintenances": [],
  "status": {
    "indicator": "none",
    "description": "All Systems Operational"
  }
}
```

What we are going to focus on for the purposes of the demo, is the `status` block and specifically it's nested member `description`.


Being a pragmatist, let's start with the simplest tool at hand Bash and cUrl, but first a digression into Bash.

## BASH

Bash is the shorthand name of for "Bourne-Again Shell", a direct descendent of the "Bourne Shell" which was written by Stephen Bourne and released in 1979, which explains the pun/joke of calling the newer shell "Bourne-Again". It is highly likely, that if you have interfaced with a linux machine in the past 20 years via the command line, you have interacted with Bash rather than the Bourne Shell or another of the other myriad shells available. The [GNU Bash manual](https://www.gnu.org/software/bash/manual/bash.html) has an excellent summary of [what a shell is](https://www.gnu.org/software/bash/manual/bash.html#What-is-a-shell_003f) and the [differences between Bash and the Bourne Shell](https://www.gnu.org/software/bash/manual/bash.html#Major-Differences-From-The-Bourne-Shell).  One of the key things to understand about Bash is it's type system, Bash only understands the data types of strings, integers, lists and in later versions associative arrays. This presents a problem for us in our example task, we need a way to query the internet and when we do, the response is structured data and worse, nested structured data. In Bash, there is a Bash native method, outside of NetCat, cURL, wget etc to retrieve data from the network, however it is somewhat arcane and will not negotiate HTTPS, so for our case, it is not useful. Given this we will use cURL to interact with the service status pages but that does mean we need to have cURL installed. Then we run into our second problem, that of the structured data.  We can use [Bash parameter expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html) to treat the JSON response as string and parse it out.  This approach can be seen in our [first example](./examples/bash-get-status) with a commented,  backup call to the `sed` binary for the same thing as a comparison. This works, but only so long as the nested key `status.description` remains at the end of the JSON response, not ideal.

To remedy this we can install a command line JSON parser/filter called [jq](https://jqlang.org) that will allow us to better parse the JSON response, you can see that in our [second example](./eamples/bash-get-status-jq).

So unfortunately, the lack of Bash built-ins for handling HTTPs and decoding structured data show some deficits to a native Bash solution, though with the installation of cURL and JQ, those are quickly overcome.

Let's take our example of retrieving a set of status JSON reponses, parsing them and displaying into the familiar realm of being a DevOps/build engineer.  Let's say that a team member has written a simple utility to do this in Node.js and put it in a repo to clone and run at will.  This approach can be seen here in [example 3](03-node-get-status).  We can see the developer in this case, opted to use the Axios HTTP library instead of the native fetch and also included a library to colorize the console outpput. These packages require installation and may require future upgrades for security reasons. This is the perfect environment to introduce Make.

## GNU Make

There are several flavors of Make but I will exclusively focus on GNU Make for this discussion. Make is a tool that in general, facilitates the transformation of source code into executable code. It does this by reading the build instructions from a file called a makefile and executing those instructions, similar to how the Docker daemon constructs a Docker image from instructions contained in a Dockerfile. The key thing to remember is that Make is the "baker" who "bakes" the products by following the "recipes" encoded in the makefile. Make is, in short, a "build system". There is a very fun ACM whitepaper called [Build Systems à la Carte](https://www.microsoft.com/en-us/research/wp-content/uploads/2018/03/build-systems.pdf) that define and discuss various build systems with some surprising inclusions (Microsoft Excel), the key feature being the distillation of a dependency graph of steps and running only the necessary steps to for the desired output, i.e. if a step or dependency is already satisfied, then that step will be skipped on subsequent runs.

Let's look closer at the `Makefile` in [example 3](./exampoles/03-node-get-status)

Make allows us in this example to do the following things:
 1. Declare the node_modules directory dependent on both `package.json` and `package-lock.json` files   
 2. Run or re-run the command `npm install` when those files change to potentially update the scripts dependencies when they change.  
 3. This also gives us a central interface for wrapping up the install and run commands.  
 4. The `Makefile` could theoretically be extended even further to handle the installation of proper version of node or other dependencies.  


Make knows which steps to run or skip by watching the modified time of the inputs (i.e. the "dependencies") and the outputs (i.e. the "targets") and running only the steps needed to produce targets with updated modified timestamps.  This has the effect of Make being file oriented, it "watches" source files to produce output files". Make does have a feature to run "recipes" wherein the output is not a file, maybe something like a call to a REST service or storing a value in a database. This type of "target" is called a "`.PHONY` target", it is "PHONY" because it produces no files.  This feature introduces a compelling use case for DevOps practitioners: The ability to string a chain of commands that are dependent on one after another yet don't necessarily rely on filesystem changes   A couple of examples of this could be:

1. Watching terraform files to automatically create an updated terraform plan and apply.  
2. Building a Docker image, tagging it and pushing to an image repository when the Dockerfile has changed.  
3. Running a linter when a source code file has changed.  

Take our example of querying the overall health status of NPM, PyPi and Github, we could construct a make file that requires each of these services be available to perform the following steps:
1. Pull a repo from Github containing Node and Python code.  
2. Install the node and python dependencies..
3. Build and deploy the subsequent application. ..

That stated, watching the 'Summary' JSON statuses of each of these services, as we have in prior examples, is probably not the best way to assess the functionality of the services we would require in the prior scenario.

In [example 4](./examples/04-make-a-docker-image/) we have slightly different solution to that of the example node script, we have a simple python script that does more-or-less the same thing, howver this our target is not a local install of the `node_modules` but of a Docker image. We have set the Makefile up so that the Docker image is rebuilt any time either the script, or the requirements.txt is changed. We can easily extend this Makefile to add the logic for more complext tagging or pushing to a remote image repository.  

Because Make offers the `.PHONY` target, and because it has the ability to run recipes (both `.PHONY` and file targets) in a dependency chain, Make becomes a very enticing command runner.  We can encode a series of one-liners or even full scripts into recipes and use Makes target dependencies execute them in order.  Looking at [example 5](./examples/05-make-get-status), we have a simple bash for loop iterating over a Make variable and executing the familiar curl/JQ calls. One can see the downside almost immediately in using Make as task runner (rather than a Build System) by the fact we have to encode each line of our bBBash snippet into a single line (broken up with line continuation backslashes) and with Make's mandatory leading tab. This works but it is certainly not ideal.

This is just one of many "hard edges" in Make that make it harder to use and less desirable from a perspective of "I want to just encode a set of command in a file and run it".  This latter desire is best filled by a purpose built tool, that being [Just](https://just.systems/)

## Just

Just is a "task runner" rather than a "build system", it's sole purpose is to encode tasks (scripts, one-liners) related to a project into a file with a standard interface and allow them to be run either independently or in a dependency graph. Just borrows many of the concepts of Make but adds several features that make it superior for "just doing things", and simultaneously, simplifies it by removing some of the features that Make has that also can also contribute to it's complexity.  Just is written in Rust and on my Linux machine is a statically linked, single binary 4.6 MB in size. To see some of the capabilities of Just, the [Just Github Repository](https://github.com:casey/just) has an examples directory where there is a "kitchen-sink" Justfile that gives a fairly comprehensive overview of the features and capabilities.  For our example problem we can view [06-just-get-a-bash-status](./examples/06-just-get-a-bash-status) as a comparison to the previous Make example [05-make-get-status](./examples/05-make-get-status). The main differences are:

1. Make has the ability to have a variable that is a list, Just variables are only strings.
2. Make has a built in function to tokenize a string into words, in Just we needed to "shell out" to awk to tokenize the string variable"
3. Make only allows single line recipes that have to be concatenated, with new line escapes, Just allows multi-line "Shebang Recipes"
4. Make allows Make variables to be interpolated in recipes but the escaping "$" is needed if that symbol has special significance to the executing shell.  Just has a simpler "double brace" expansion that does not collide with shell vars.

These examples don't show the full scope of the differences between the two tools nor does it highlight the file dependency interrogation that Make provides and Just does not. However, as a "Task Runner" vs a "Build System", Just has the edge by allowing the multi-line shebang recipes. In [example 07-just-get-status](./examples/07-just-get-status), there is an iteration on the previous two examples (in Make and Just respectively) but introducing a new Just feature as well as a recipe in NuShell, for that reason it would be a good idea to give a quick overview on NuShell 

## Nushell

Nushell is a shell and programming language written in Rust, it is statically linked and on my Linux machine is 43MB in size. The shell has many built-in commands and allows invoking many existing commandline utilities. The shell programming language is oriented around a couple of key features:

1. Strongly typed and it's internal pipelines send stuctured data vs text, making this more similar to Powershell than to BASH.  
2. The Nushell language is strongly based on functional programming languages, this means that variables are immutable by default and nearly every operation returns a value.  
3. NuShell has a very comprehensive set of builtin commands and filters that understand many serialization formats from typical formats such as JSON, YAML, and CSV to things such as ICS (iCalendar) and MessagePack.  
4. Nu can invoke existing command line utilities and has features that allow transforming the line based output to the rich, structured data types Nu built-ins produce.

Returning to [example 07-just-get-status](./examples/07-just-get-status), we can see some now familiar features but with some new introductions:
1. We have a implemented a Shebang Recipe in NuShell.  
2. We have made that recipe Parameterized so that the logic NuShell runs get's its input from the Justfile recipe parameters.  
3. We invoke this Private recipe with named recipes that have the Private recipe as a dependency.  
4. We have a recipe `get-all` that invokes each named recipe as dependencies and does this in parallel rather than serially.  

While perhaps not the greatest show case of NuShell, it is is easy to see how NuShell was able to request JSON data from the various service endpoints, deserialize that JSON and present it without using cURL or JQ, i.e. using built-in commands to NuShell.

To showcase more of Justs features, in [example 08-just-get-a-polyglot](examples/08-just-get-a-polyglot/), we have a recipes that are implemented in 4 different languages (all using stanard library features). You can see how Just allows us to embed each language as a Shebang recipe and to verify we have the proper binaries in place.

Both Just and Make execute each recipe in it's own shell process, this effectively means that we cannot share state that is modified between recipe runs. 






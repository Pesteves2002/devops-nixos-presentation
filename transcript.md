# Slide 1

Hi Everyone, I'm <person 1> and this is <person 2>.

Today, we will explore a key feature that significantly enhance the reproducibility of your NixOS configurations

# Slide 2

We will start by introducing NixOS.

Next, we'll dive into Nix Flakes, covering their practical usage, and the associated pros and cons.

Finally, we will wrap up with our conclusion and take-home message.

# Slide 4

Let’s begin with an overview of Nix

- As a functional language, it allows for the declarative configuration.
- As a package manager, it's similar to yum, or apt in Debian, but it's declarative and allows to keep multi ver. of packages.

[We can describe the desired state of our systems without detailing how to achieve that state, and the package manager will handle the implementation details to reach that state.]

NixOS, on the other hand, is a Linux distribution built entirely on top of Nix.
It inherits the benefits if nix and follows a declarative approach to system configuration.

# Slide 5

So, why choose Nix or NixOS?

[Mainly because of these 3 features:]

First, it's reproducible. Nix ensures that whatever works on your machine can be replicated on any other machine.

Second, it's declarative. You simply declare your system configs, instead of manually configuring everything.

[like, you just need to write Nix code saying I want vim & git to be installed on my system.]

Nix will handle the rest, (the dependenices,) making it much easier to manage and maintain over time.

Finally, it's reliable. With Nix, you can easily roll back to a previous state if something goes wrong.

But is it really reproducible with nix itself?

# Slide 6

[Explain that the same config may create two completely different systems, which may break.]

If you’re not pinning specific versions of dependencies, your Nix configuration might pull in different versions of the packages on different machines or at different times.

Even with Nix's declarative configuration, the final outcome of the system might depend on hardware, environmental variables. This could mean that your configuration works perfectly on one machine but behaves differently on another.

E.g., a certain configuration might work with a specific set of dependencies today, but another configuration made in the future may have different dependencies that may break the system or not.

Luckily, Nix solves it with Nix Flakes.

# Slide 8

Nix Flakes is an experimental feature that was introduced in Nix 2.4, which brings a more standardized and declarative approach to managing dependencies & dev environments.

Flake is .nix file that contains the top level attributes.

It acts like "processors" of Nix code, which take Nix expressions as input and output things that Nix can use like package definitions, NixOS configurations.

When NixOS evaluates flake.nix, it will create a flake.lock file, pinning the version of all dependencies that a project uses.

Why is it important?

Because a config made today may not work in the future.
Because dependencies may change and it'll be hard to reproduce the same environment.

[Flake is .nix file that contains some top level attributes.
- Description of the flake.
- Inputs: A list of dependencies.
- Outputs: Receives the inputs and returns an attributes set.
- NixConfig: A set of options that are passed to the Nix evaluator. (Normally not used)]

# Slide 9

After evaluating the flake, a flake.lock is generated.

The flake.lock works in the same way as a package-lock.json or a cargo.lock file.

It contains all the information necessary to always get output the same result.

Look and explain the rev and narHash.

[This is how it pin the dependencies.]

# Slide 10

So How do I Use a Flake?

There are multiple ways to use it.

- nix build .#<name> builds a derivation (build a package)
- nix run .#<name> runs a derivation

In this case we create the `hello` derivation that is a c program that is compiled with gcc.
It creates a `directory` where the binary is stored and can be executed.

# Slide 11

So the most exciting feature is declaring your whole OS configuration as a flake.

This makes our configuration reproducible today but also in 100 years.

Here I can define multiple machines, such as my desktop and my laptop.

# Slide 12

Flakes also allows to manage dependency conflicts.

It may have already happened to you that some projects need a specific version of python and another project needs another version.

Flakes solves this problem through the creation of dev shells.

# Slide 13

This flake will create a temporary shell where all the packages provided will be available to use. (in this case python310).
After exiting the shell, these packages will be "removed", they will not be available to use anymore.
It also allows to set environment variables.

This allows for an easier way to manage dependencies.

# Slide 14

Pros of Flakes:

Truly reproducible configurations, even dependencies (in 100 years)
Rollback to a previous version of the configuration
Escape Dependency Hell


Cons of Flakes:

Updating the inputs is done imperatively
It is still experimental (may be broken in the future and has limited documentation)

No Lazy Evaluation (everything is downloaded even if not used)

# Slide 16

So with flakes you can declare you configuration in a reproducible way.

# Slide 17

This leads to our take away message:

With Flakes Tour COnfiguration will be reproducible Forever.

# Slide 18

Thank your for listening & special thanks to the feedback from Diogo & Rafael.

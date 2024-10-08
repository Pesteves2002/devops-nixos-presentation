# Slide 1

Hello Everyone, I'm <person 1> and this is <person 2>.
Today we are going to deep dive into some features that improve the reproducibility of your NixOS config.

We will talk about Nix Flakes and how to manage secrets securely.

# Slide 2

First we are gonna make an introduction to NixOS,
then we will talk about the nix flakes, how to use them and pros and cons
And then we will conclude.

# Slide 4

What is Nix/NixOS?

Nix can mean two things:

- The functional language that NixOS is built on.
- The package manager that NixOS uses.

After that we have NixOS, it's a Linux distribution that in contrast to other distributions,
it follows a declarative approach to system configuration.

Finally Nixpkgs, it's the Nix package repository. It's the largest repository,
being bigger than the Arch User Repository (AUR).

# Slide 5

So Why use Nix/NixOS?

Because of these 3 features:

- Reproducibility: You can easily reproduce your system configuration on another machine.
- Declarative: You can describe your system configuration in a declarative way.
- Reliable: You can rollback to a previous system configuration if something goes wrong.

But why is reproducibility with an asterisk?

# Slide 6

Explain that the same config may create two completely different systems, which may break or not.

# Slide 8

So first we will talk about Nix Flakes.

Nix Flakes is an experimental feature that was introduced in Nix 2.4.

It allows you to pin the version of dependencies.

Because a config made today may not work in the future because dependencies may change
and it'll be hard to reproduce the same environment.

Flake is .nix file that contains some top level attributes.

- Description of the flake.
- Inputs: A list of dependencies.
- Outputs: Receives the inputs and returns an attributes set.
- NixConfig: A set of options that are passed to the Nix evaluator. (Normally not used)

# Slide 9

After evaluating the flake, a flake.lock is generated.

The flake.lock works in the same way as a package-lock.json or a cargo.lock file.

It contains all the information necessary to always get output the same result.

Look and explain the rev and narHash.

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

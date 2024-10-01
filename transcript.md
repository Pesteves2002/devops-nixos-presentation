# Slide 0

Hello Everyone, I'm <person 1> and this is <person 2>.
Today we are going to deep dive into some features that improve the reproducibility of your NixOS config.

We will talk about Nix Flakes and how to manage secrets securely.

# Slide 2

But first let's make a small introduction.

What is Nix/NixOS?

Nix can mean two things:

- The functional language that NixOS is built on.
- The package manager that NixOS uses.

After that we have NixOS, it's a Linux distribution that in contrast to other distributions,
it follows a declarative approach to system configuration.

Finally Nixpkgs, it's the Nix package repository. It's the largest repository,
being bigger than the Arch User Repository (AUR).

# Slide 3

So Why use Nix/NixOS?

Because of these 3 features:

- Reproducibility: You can easily reproduce your system configuration on another machine.
- Declarative: You can describe your system configuration in a declarative way.
- Reliable: You can rollback to a previous system configuration if something goes wrong.

But why is reproducibility with an asterisk?

Well, because NixOS by itself does not provide 2 important features:

- Pin dependencies: To ensure that the version of the packages you are using is the same.
- A way to manage secrets securely.

# Slide 5 - 7

So first we will talk about Nix Flakes.

Nix Flakes is an experimental feature that was introduced in Nix 2.4.

It allows you to pin the version of dependencies.

This is one step closer to reproducibility.

Why do we need Nix Flakes?

Because a config made today may not work in the future because dependencies may change
and it'll be hard to reproduce the same environment.

# Slide 8

So what is a Flake?

Flake is .nix file that contains some top level attributes.

- Description of the flake.
- Inputs: A list of dependencies.
- Outputs: Receives the inputs and returns an attributes set.
- NixConfig: A set of options that are passed to the Nix evaluator. (Normally not used)

After evaluating the flake, a flake.lock is generated.

The flake.lock works in the same way as a package-lock.json or a cargo.lock file.

It contains all the information necessary to always get output the same result.

Look and explain the rev and narHash.

# Slide 9

So How do I Use a Flake?

There are multiple ways to use it.

- nix build .#<name> builds a derivation (build a package)
- nix run .#<name> runs a derivation

In this case we create the `hello` derivation that is a c program that is compiled with gcc.
It creates a `directory` where the binary is stored and can be executed.

# Slide 10

Flakes allows us to create developer shells.

Instead of installing packages that might be used only once, we can create a shell that has all the packages we need.

This packages are only usable inside this new shell, and not globally.

This is useful when multiple project have conflicting dependencies.
Such as project that needs Python 3.6 and another that needs Python 3.8.

In order to get this shell, I just need to run `nix develop`.

# Slide 11

So the most exciting feature is declaring your whole OS configuration as a flake.

This makes our configuration reproducible today but also in 100 years.

Here I can define multiple machines, such as my desktop and my laptop.

# Slide 13

So this is flakes, but what about secrets?

But why do we need `agenix`?

All files in the Nix store are readable by any system user, so it is a security risk to have clear text secrets.

It's very common to have secrets in our configuration and leaking them is a big security issue.

Agenix solves this problem by encrypting the secrets.

# Slide 14

In order to manage secrets securely, we can use `agenix`.

It encrypts secrets with a public key and decrypts them with a private key.

# Slide 15

How does it work?

`agenix` uses Public Key Cryptography.

In public key cryptography, there are two keys: a public key and a private key.

The public key can be shared with anyone, but the private key must be kept secret.

In this case, the secrets are encrypted with the public key and only the private key can decrypt them.

So only the people that have the private key can decrypt the secrets.

`age` is used to encrypt/decrypt the secrets.

# Slide 16

So how do I use `agenix`?

You first start by telling which systems public keys will be used.

Then you define the file name and which public keys are used.

Then you run `agenix -e <secret>.age`, here you will write the secret (password, API key).

It will then be encrypted.

# Slide 17

In order to use the secret, you first need to tell where is it.

And then reference it in your configuration.

If properly configured, the secret will be decrypted and used securely only by the `nextcloud` service.

# Slide 19

With Flakes and Agenix, Your Configuration will be Reproducible and Secure *Forever*











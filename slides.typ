#import "@preview/polylux:0.3.1": *
#import themes.clean: *

#set document(
  title: [DevOps Presentation: NixOS: Reproducibility with Flakes and Secrets], author: ("Tomás Esteves", "Wenqi Cao"), keywords: ("nixos", "presentation", "devops"), date: datetime(year: 2024, month: 10, day: 2, hour: 13, minute: 00, second: 00),
)

// compile .pdfpc wth `polylux2pdfpc {fname}.typ`
// then present with, e.g., `pdfpc --windowed both {fname}.pdf`

// uncomment to get a "submittable" PDF
// #enable-handout-mode(true)

#let kthblue = rgb("#000060")
#show: clean-theme.with(
  short-title: [*NixOS: Reproducibility with Flakes and Secrets*], color: kthblue, logo: image("common/KTH_logo_RGB_bla.svg"),
)

#pdfpc.config(duration-minutes: 7)

// consistent formatting + make typstfmt play nice
#let notes(speaker: "???", ..bullets) = pdfpc.speaker-note("## " + speaker + "\n\n" + bullets.pos().map(x => "- " + x).join("\n"))

#show link: it => underline(stroke: 1pt + kthblue, text(fill: kthblue, it))

#let cmd = it => block(
  fill: rgb("#1d2433"), inset: 7pt, radius: 5pt, text(fill: rgb("#a2aabc"), size: 12pt, it),
)

#let big-picture-slide(content) = {
  polylux-slide({
    place(top + left, image("assets/nix-wallpaper-nineish-dark-gray.svg"))
    set text(white, 2em)
    set align(left + horizon)
    box(width: 40%, align(center + horizon, content))
  })
}

#let cover = title-slide(
  title: text(25pt)[NixOS: Reproducibility with Flakes and Secrets], subtitle: [
    DD2482 Automated Software Testing and DevOps

    *Presentation*

    #smallcaps[KTH Royal Institute of Technology]

    Wednesday, 2#super[nd] of October, 2024

    #notes(speaker: "Tomás", "introduce topic", "introduce presenters")
  ], authors: (
    [Tomás Esteves\ #link("mailto:tmbpe@kth.se")], [Wenqi Cao\ #link("mailto:wenqic@kth.se")],
  ),
)

#cover

#slide(title: "Overview")[
  - Introduction to Nix/NixOS
    - What is Nix/NixOS?
    - Why Nix/NixOS?
  - A Path to Reproducibility
    - Nix Flakes (Dependency Management)
    - Agenix (Secret Management)
  - Conclusion
]

#new-section-slide("Introduction")

#slide(
  title: "What is Nix/NixOS?",
)[
  #side-by-side[
    - *Nix*, the (functional) language
    - *Nix*, the package manager
    - *NixOS*, the operating system
    - *Nixpkgs*, the package repository
  ][
    #align(center, image("assets/nix-snowflake-colours.svg", height: 70%))
  ]

  #notes(speaker: "Tomás", "nixlang/nix/nixos/nixpkgs")
]

#slide(
  title: "Why Nix/NixOS?",
)[
  #v(1em)
  #grid(
    columns: (1fr, 1fr, 1fr), gutter: 1em, align: center + bottom, image("assets/reproducible.svg", height: 50%), image("assets/declarative.svg", height: 50%), image("assets/reliable.svg", height: 50%), [*Reproducible\**], [*Declarative*], [*Reliable*],
  )

  #notes(
    speaker: "Tomás", "Reproducible: works on my machine, works on every machine", "Declarative: infrastructure as code, allows you to copy code from stackoverflow and it will work", "Reliable: if something goes bad, you can always rollback and avoid being fired, but why is there an asterisk? well because that is not always true",
  )
]

#new-section-slide("A Path to Reproducibility")

#big-picture-slide()[
  Nix Flakes
]

#slide(title: "What are Nix Flakes?")[
  #side-by-side[
    - Experimental feature of the *Nix* package manager
    - Provides a way to *pin* the version of dependencies
  ][
    #align(center, image("assets/dependency-hell.jpg", height: 70%))
  ]

  #notes(speaker: "Tomás", "pin versions of the dependecies")
]

#slide(
  title: "Structure of a Flake",
)[
#side-by-side[
#text(
  12pt,
)[
```nix
{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
```
]
- flake.nix
][
#text(
  12pt,
)[
```nix
{
  "nodes": {
    "nixpkgs": {
      "locked": {
        "lastModified": 1727348695,
        "narHash": "sha256-J+PeFKSDV+pHL7ukkfpVzCOO7mBSrrpJ3svwBFABbhI=",
        "owner": "nixos",
        "repo": "nixpkgs",
        "rev": "1925c603f17fc89f4c8f6bf6f631a802ad85d784",
        "type": "github"
      },
    },
    ...
  },
}


    ```
]
- flake.lock
]
#notes(
  speaker: "Tomás", "description, inputs (dependencies), and outputs (what is done), flake lock explain git version  and narHash (integrity)",
)
]

#slide(
  title: "Build and Run Programs",
)[
#side-by-side(columns: (1fr, 1.5fr))[
- Run #cmd(`nix build .#<name>`)
- Run #cmd(`nix run .#<name>`)
][
#text(12pt)[
```nix
{
  description = "A flake for building Hello World";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-20.03;

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "hello";
        src = self;
        buildPhase = "gcc -o hello ./hello.c";
        installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
      };
  };
}
```
]
]
#notes(
  speaker: "Tomás", "build (derivation) and run programs with flake, in this case hello, is compiled and ran in result/bin/hello",
)
]

#slide(
  title: "Create Dev Shells",
)[
#side-by-side(columns: (1fr, 1.5fr))[
- Run #cmd(`nix develop`)
][
#set text(12pt)
```nix
{
  description = "Flake for the dev ops presentation";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs: inputs.utils.lib.eachDefaultSystem (system:
    let
      pkgs = import inputs.nixpkgs { inherit system; };
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [ typst typstfmt pdfpc polylux2pdfpc ];
      };
    }
  );
}
```
]
#notes(
  speaker: "Tomás", "create a development shell with the tools needed for the presentation, talk about python versions",
)
]

#slide(
  title: "Declare NixOS config",
)[
#side-by-side(columns: (1fr, 1.5fr))[
- Run #cmd(`nixos-rebuild switch --flake .#hostname`)
][
#set text(12pt)
```nix
  {
    description = "Flake for deploying spoon machine";

    inputs.nixpkgs.url = "nixpkgs/nixos-24.05";

    outputs = { self, nixpkgs }: {
      nixosConfigurations.spoon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
    };
  }
  ```
]

#notes(
  speaker: "Tomás", "deploy the configuration with nixos-rebuild switch --flake .#hostname",
)
]

#big-picture-slide()[
  Agenix
]

#slide(title: "Why use Agenix?")[
  #side-by-side[
    - The Nix store is readable by all processes and users
    - Leak secrets in public repositories
  ][
    #align(center, image("assets/lock_broken.png", height: 70%))
  ]
]

#slide(title: "What is Agenix?")[
  #side-by-side(columns: (1fr, 1.5fr))[
    - Tool that manages secrets in a Nix configuration
    - Encrypts using ssh keys
  ][
    #align(center, image("assets/lock.svg", height: 70%))
  ]
]

#slide(
  title: "How does it work?",
)[
  #side-by-side[
    - Public Key Cryptography
    - Only the owner of the private key can decrypt the secret
  ][
    #align(center, image("assets/Asymmetric_encryption_colored.png", height: 70%))
  ]
]

#slide(
  title: "Add a Secret",
)[
#side-by-side(
  columns: (1fr, 1.5fr),
)[
- Add which systems can access the secret
- Run #cmd(`agenix -e <secret>.age`)
][
#set text(14pt)
```nix
let
  system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0idNvgGiucWgup/mP78zyC23uFjYq0evcWdjGQUaBH";
  system2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJDyIr/FSz1cJdcoW69R+NrWzwGK/+3gJpqD1t8L2zE";

  systems = [ system1 system2 ];
in
{
  "secret1.age".publicKeys = [ system1 ];
  "secret2.age".publicKeys = systems;
}

```
]
]

#slide(title: "Use a Secret")[
#side-by-side(columns: (1fr, 1.5fr))[
  - Set the secret in the Nix configuration
  - Reference the secret in the service
][
#set text(15pt)
```nix
age.secrets.nextcloud = {
  file = ./secrets/secret1.age;
  owner = "nextcloud";
  group = "nextcloud";
};
services.nextcloud = {
  enable = true;
  package = pkgs.nextcloud29;
  hostName = "localhost";
  config.adminpassFile = config.age.secrets.nextcloud.path;
};
```
]
]

#new-section-slide("Conclusion")

#big-picture-slide(
  )[
  With Flakes and Agenix, Your Configuration will be Reproducible and Secure
  *Forever*
  #notes(speaker: "Diogo", "Declare once, deploy forever, wherever")
]

#cover

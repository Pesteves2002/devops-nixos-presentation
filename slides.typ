#import "@preview/polylux:0.3.1": *
#import themes.clean: *

#set document(
  title: [DevOps Presentation: NixOS: Reproducibility with Flakes], author: ("Tomás Esteves", "Wenqi Cao"), keywords: ("nixos", "presentation", "devops"), date: datetime(year: 2024, month: 10, day: 10, hour: 13, minute: 00, second: 00),
)

// compile .pdfpc wth `polylux2pdfpc {fname}.typ`
// then present with, e.g., `pdfpc --windowed both {fname}.pdf`

// uncomment to get a "submittable" PDF
// #enable-handout-mode(true)

#let kthblue = rgb("#000060")
#show: clean-theme.with(
  short-title: [*NixOS: Reproducibility with Flakes*], color: kthblue, logo: image("common/KTH_logo_RGB_bla.svg"),
)

#pdfpc.config(duration-minutes: 7)

// consistent formatting + make typstfmt play nice
#let notes(speaker: "???", ..bullets) = pdfpc.speaker-note("## " + speaker + "\n\n" + bullets.pos().map(x => "- " + x).join("\n"))

#show link: it => underline(stroke: 1pt + kthblue, text(fill: kthblue, it))

#let cmd = it => block(
  fill: rgb("#1d2433"), inset: 7pt, radius: 5pt, text(fill: rgb("#a2aabc"), size: 15pt, it),
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
  title: text(25pt)[NixOS: Reproducibility with Flakes ], subtitle: [
    DD2482 Automated Software Testing and DevOps

    *Presentation*

    #smallcaps[KTH Royal Institute of Technology]

    Thursday, 10#super[th] of October, 2024

    #notes(speaker: "Tomás", "introduce topic", "introduce presenters")
  ], authors: (
    [Tomás Esteves\ #link("mailto:tmbpe@kth.se")], [Wenqi Cao\ #link("mailto:wenqic@kth.se")],
  ),
)

#cover

#slide(
  title: "Overview",
)[
  - Introduction
    - What is Nix/NixOS?
    - Limitations of NixOS
  - Nix Flakes
    - Definition
    - Usage
    - Pros and Cons
  - Conclusion

  #notes(
    speaker: "Tomás", "Introduction to Nix/Nixos", "How can We improve reproducibility?", "Conclusion",
  )
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
    speaker: "Tomás", "Reproducible: works on my machine, works on every machine", "Declarative: infrastructure as code, allows you to copy code from stackoverflow and it will work", "Reliable: if something goes bad, you can always rollback and avoid being fired", "but why is there an asterisk? well because that is not always true", "But NixOS does not provide dependecy pinning and secure management of secrets",
  )
]

#slide(
  title: "Is NixOS really reproducible?",
)[
  #side-by-side[
    #align(center, image("assets/computer.svg", height: 40%))

    - Created in 2023
      - *NixOS* 23.05
      - *Python* 3.8
  ][
    #grid(
      columns: (1fr, 4fr, 1fr), gutter: 1em, align: center + horizon, $<--$, image("assets/config.svg", height: 40%), $-->$,
    )
    #set align(center)
    config.nix
  ][
    #align(center, image("assets/disaster.svg", height: 40%))

    - Created in 2024
      - *NixOS* 24.05
      - *Python* 3.9
  ]
]

#new-section-slide("Nix Flakes")

#slide(
  title: "What are Nix Flakes?",
)[
#side-by-side(
  columns: (1fr, 1.25fr),
)[
  - Experimental feature of the *Nix* package manager
  - Provides a way to *pin* the version of dependencies
][
#text(
  11pt,
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

    overlays.default = final: prev: { ... };

    formatter.x86_64-linux = ...;

  };
}
```
]
- flake.nix
]

#notes(
  speaker: "Tomás", "pin versions of the dependecies", "escape dependency hell",
)
]

#slide(
  title: "Flake.lock",
)[
#side-by-side(
  columns: (1fr, 1.5fr),
)[
- Works in the same way as a `package-lock.json` or `cargo.lock` file.
- Automatically generated when `flake.nix` is evaluated.
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
  speaker: "Tomás", "description, inputs (dependencies)", "and outputs (what is done)", "evaluates flake lock explain git version  and narHash (integrity)",
)
]

#slide(
  title: "Create Your Own Packages",
)[
#side-by-side(columns: (1fr, 1.5fr))[
- Use your own custom packages everywhere

- Build and Run the _derivation_:
  - #cmd(`nix build .#<name>`)
  - #cmd(`nix run .#<name>`)
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
  title: "Declare Your System",
)[
#side-by-side(columns: (1fr, 1.25fr))[
- Use your NixOS config everywhere

- Update your config:
  - #cmd(`nixos-rebuild switch --flake .#hostname`)
][
#set text(12pt)
```nix
    {
      description = "Flake for deploying the spoon machine";

      inputs.nixpkgs.url = "nixpkgs/nixos-24.05";

      outputs = { self, nixpkgs }: {
        nixosConfigurations.spoon = nixpkgs.lib.nixosSystem {
          modules = [
            ./spoon.nix
          ];
        };

        nixosConfigurations.lamp = nixpkgs.lib.nixosSystem {
          modules = [
            ./lamp.nix
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

#slide(title: "Dependency Conflicts")[
  #side-by-side[
    - Multiple projects require different versions of the same package
      - *Project A*: *Python* 3.8
      - *Project B*: *Python* 3.12

    - Flakes solves this problem
  ][
    #align(center, image("assets/dependency-hell.jpg", height: 70%))
  ]
]

#slide(
  title: "Create Dev Shells",
)[
#side-by-side(
  columns: (1fr, 1.5fr),
)[
- Creates an ephemeral development shell
  - Packages needed
  - Environment Variables

- Create shell
  - #cmd(`nix develop`)
][
#set text(11pt)
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
        buildInputs = with pkgs; [ typst typstfmt pdfpc polylux2pdfpc python310 ];

        KEY = "ABCD";
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

#slide(title: "Pros and Cons of Flakes")[
  #side-by-side[
    Pros

    - Truly Reproducible
    - Rollback Feature
    - Escape Dependency Conflicts
  ][
    Cons

    - Need to Update Imperatively
    - Experimental
      - Prone to Breaking Changes
      - Limited Documentation
    - No Lazy Evaluation
  ]
]

#new-section-slide("Conclusion")

#slide(
  title: "True Reproducibility with Flakes",
)[
  #side-by-side[
    #align(center, image("assets/lion.svg", height: 40%))

    - Created in 2023
      - *NixOS* 23.05
      - *Python* 3.8
  ][
    #grid(
      columns: (1fr, 4fr, 1fr), gutter: 1em, align: center + horizon, $<--$, image("assets/config.svg", height: 20%), $-->$,
    )
    #set align(center)
    flake.nix

    #align(center, image("assets/lock.svg", height: 20%))

    #set align(center)
    flake.lock
  ][
    #align(center, image("assets/monkey.svg", height: 40%))

    - Created in 2024
      - *NixOS* 23.05
      - *Python* 3.8
  ]
]

#big-picture-slide()[
  With Flakes Your Configuration will be Reproducible *Forever*
]

#cover

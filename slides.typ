#import "@preview/polylux:0.3.1": *
#import themes.clean: *

#set document(
  title: [DevOps Presentation: NixOS: Reproducibility with Flakes and Secrets],
  author: ("Tomás Esteves", "Wenqi Cao"),
  keywords: ("nixos", "presentation", "devops"),
  date: datetime(year: 2024, month: 10, day: 2, hour: 13, minute: 00, second: 00)
)

// compile .pdfpc wth `polylux2pdfpc {fname}.typ`
// then present with, e.g., `pdfpc --windowed both {fname}.pdf`

// uncomment to get a "submittable" PDF
// #enable-handout-mode(true)

#let kthblue = rgb("#000060")
#show: clean-theme.with(
  short-title: [*Presentation: NixOS: Reproducibility with Flakes and Secrets*],
  color: kthblue,
  logo: image("common/KTH_logo_RGB_bla.svg"),
)

#pdfpc.config(duration-minutes: 7)

// consistent formatting + make typstfmt play nice
#let notes(speaker: "???", ..bullets) = pdfpc.speaker-note("## " + speaker + "\n\n" + bullets.pos().map(x => "- " + x).join("\n"))

#show link: it => underline(stroke: 1pt + kthblue, text(fill: kthblue, it))

#let focus = it => text(kthblue, strong(it))

#let big-picture-slide(content) = {
  polylux-slide({
    place(top + left, image("assets/nix-wallpaper-nineish-dark-gray.svg"))
    set text(white, 2em)
    set align(left + horizon)
    box(width: 40%, align(center + horizon, content))
  })
}

#let cover = title-slide(
  title: text(25pt)[NixOS: Reproducibility with Flakes and Secrets],
  subtitle: [
    DD2482 Automated Software Testing and DevOps

    *Presentation*

    #smallcaps[KTH Royal Institute of Technology]

    Wednesday, 2#super[nd] of October, 2024

    #notes(
      speaker: "Diogo",
      "introduce topic",
      "introduce presenters",
    )
  ],
  authors: (
    [Tomás Esteves\ #link("mailto:tmbpe@kth.se")],
    [Wenqi Cao\ #link("mailto:wenqic@kth.se")],
  ),
)

#cover

#new-section-slide("Introduction")

#slide(title: "What is Nix/NixOS?")[
  #side-by-side[
    - *Nix*, the (functional) language
    - *Nix*, the package manager
    - *NixOS*, the operating system
    - *Nixpkgs*, the package repository
  ][
    #align(center, image("assets/nix-snowflake-colours.svg", height: 70%))
  ]

  #notes(
    speaker: "Diogo",
    "nixlang/nix/nixos/nixpkgs",
  )
]

#slide(title: "Why Nix/NixOS?")[
  #v(1em)
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 1em,
    align: center + bottom,
    image("assets/reproducible.svg", height: 50%),
    image("assets/declarative.svg", height: 50%),
    image("assets/reliable.svg", height: 50%),
    [*Reproducible*],
    [*Declarative*],
    [*Reliable*],
  )

  #notes(
    speaker: "Tomás",
    "Reproducible: works on my machine, works on every machine",
    "Declarative: infrastructure as code, allows you to copy code from stackoverflow and it will work",
    "Reliable: if something goes bad, you can always rollback and avoid being fired",
  )
]

#slide(title: "Is it truly Reproducible?")[
  - *nixos-rebuild*, update existing host

  #notes(
    speaker: "Tomás",
    "declare disk partitions with disko",
    "provision a new host with nixos-anywhere",
    "update the host with nixos-rebuild",
  )
]

#big-picture-slide()[
  Demo
]

#new-section-slide("Conclusion")

#big-picture-slide()[
  With NixOS, you can declare your infrastructure once
  and deploy it forever
  #notes(
    speaker: "Diogo",
    "Declare once, deploy forever, wherever"
  )
]

#cover

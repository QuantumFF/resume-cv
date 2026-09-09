// Two-column resume style.
// Roboto, narrow left rail for contact / education / skills / homelab,
// wide right column for experience and projects.
//
// This template does NOT use pandoc's body variable. build.sh splits resume.md into
// two markdown fragments, converts each to typst, and this file includes them:
//   sidebar.typ  <- Education, Skills, Homelab, Spoken Languages
//   main.typ     <- Experience, Personal Projects
// Both fragments must sit next to the generated .typ file.

#let author-name = [$name$]
#let accent = rgb("#1f3a5f")

#set document(title: "$title$", author: "$author$")

#set page(
  paper: "a4",
  margin: (x: 1.4cm, top: 1.3cm, bottom: 1.1cm),
  footer: context {
    let total = counter(page).final().first()
    if total > 1 {
      set text(size: 8pt, fill: luma(50%))
      align(center)[
        #author-name #h(0.4em) · #h(0.4em) #counter(page).display() / #total
      ]
    }
  },
)

#set text(font: "Roboto", size: 9.3pt, lang: "en")
#set par(leading: 0.55em, spacing: 0.6em, justify: false)

#set list(indent: 0.6em, spacing: 0.32em, marker: (
  text(fill: accent)[•],
  text(fill: accent.lighten(30%))[--],
  [·],
))
#show list: set block(spacing: 0.36em)

#show link: it => text(fill: accent, it)
#show strong: it => text(fill: accent, weight: "bold", it.body)

#show heading.where(level: 2): it => block(above: 0.95em, below: 0.45em)[
  #set text(size: 9pt, weight: "bold", tracking: 0.09em, fill: accent)
  #upper(it.body)
  #v(-0.6em)
  #line(length: 100%, stroke: 0.7pt + accent.lighten(45%))
]

#show heading.where(level: 3): it => block(above: 0.6em, below: 0.25em)[
  #set text(size: 9.6pt, weight: "bold")
  #it.body
]

// ---------- Header ----------

#block(below: 0.6em)[
  #text(size: 23pt, weight: "bold", fill: accent, tracking: -0.01em)[#author-name]
  #v(-0.35em)
  #line(length: 100%, stroke: 1.6pt + accent)
]

// ---------- Body: left rail + main column ----------

#grid(
  columns: (34%, 1fr),
  column-gutter: 1.3em,
  grid.vline(x: 1, stroke: 0.5pt + accent.lighten(60%)),
  // left rail
  [
    #block(above: 0.2em)[
      #set text(size: 8.7pt, fill: luma(20%))
      #heading(level: 2)[Contact]
      - $location$
      - $phone$
      - #link("mailto:$email$")[$email$]
      - #link("$github-url$")[$github$]
      - #link("$linkedin-url$")[$linkedin$]
    ]

    #include "sidebar.typ"
  ],
  // main column
  [
    $if(summary)$
    #block(above: 0.2em, below: 0.3em)[
      #set text(size: 9.2pt, fill: luma(15%))
      $summary$
    ]
    $endif$

    #include "main.typ"
  ],
)

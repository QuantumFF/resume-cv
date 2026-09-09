// Modern single-column resume style.
// Noto Sans, deep navy accent on headings and links, tighter leading.
// Pandoc template: rendered from resume.md via build.sh

#let author-name = [$name$]
#let accent = rgb("#1f3a5f")

#set document(title: "$title$", author: "$author$")

#set page(
  paper: "a4",
  margin: (x: 1.5cm, top: 1.2cm, bottom: 1.0cm),
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

#set text(font: "Noto Sans", size: 9.2pt, lang: "en")
#set par(leading: 0.5em, spacing: 0.52em, justify: false)

#set list(indent: 0.7em, spacing: 0.28em, marker: (
  text(fill: accent)[•],
  text(fill: accent.lighten(25%))[--],
  [·],
))
#show list: set block(spacing: 0.32em)

#show link: it => text(fill: accent, it)
#show strong: it => text(fill: accent, weight: "bold", it.body)

// Section headings: accent-coloured, uppercase, hairline rule.
#show heading.where(level: 2): it => block(above: 0.68em, below: 0.24em)[
  #set text(size: 9.6pt, weight: "bold", tracking: 0.09em, fill: accent)
  #upper(it.body)
  #v(-0.55em)
  #line(length: 100%, stroke: 0.8pt + accent.lighten(45%))
]

#show heading.where(level: 3): it => block(above: 0.7em, below: 0.3em)[
  #set text(size: 10pt, weight: "bold")
  #it.body
]

// ---------- Header ----------

#let dot = [#h(0.5em) #text(fill: accent.lighten(40%))[•] #h(0.5em)]

#block(below: 0.7em)[
  #text(size: 22pt, weight: "bold", fill: accent, tracking: -0.01em)[#author-name]

  #v(-0.55em)

  #stack(
    dir: ttb,
    spacing: 0.34em,
    text(size: 8.7pt, fill: luma(25%))[$location$ #dot $phone$ #dot #link("mailto:$email$")[$email$]],
    text(size: 8.7pt, fill: luma(25%))[#link("$github-url$")[$github$] #dot #link("$linkedin-url$")[$linkedin$]],
  )

  #v(0.34em)

  #line(length: 100%, stroke: 1.6pt + accent)
]

$if(summary)$
#block(below: 0.35em)[
  #set text(size: 9.3pt, fill: luma(15%))
  $summary$
]
$endif$

$body$

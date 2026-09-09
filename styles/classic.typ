// Classic single-column resume style.
// Libertinus Serif, black on white, ruled section headings.
// Pandoc template: rendered from resume.md via build.sh

#let author-name = [$name$]

#set document(title: "$title$", author: "$author$")

#set page(
  paper: "a4",
  margin: (x: 1.6cm, top: 1.3cm, bottom: 1.0cm),
  footer: context {
    let total = counter(page).final().first()
    if total > 1 {
      set text(size: 8pt, fill: luma(45%))
      align(center)[
        #author-name #h(0.4em) · #h(0.4em) #counter(page).display() / #total
      ]
    }
  },
)

#set text(font: "Libertinus Serif", size: 9.8pt, lang: "en")
#set par(leading: 0.45em, spacing: 0.5em, justify: false)

#set list(indent: 0.75em, spacing: 0.26em, marker: ([•], [--], [·]))
#show list: set block(spacing: 0.3em)

#show link: it => it

// Section headings: small caps-ish, ruled underneath.
#show heading.where(level: 2): it => block(above: 0.58em, below: 0.24em)[
  #set text(size: 10.6pt, weight: "bold", tracking: 0.09em)
  #upper(it.body)
  #v(-0.5em)
  #line(length: 100%, stroke: 0.6pt + black)
]

#show heading.where(level: 3): it => block(above: 0.7em, below: 0.35em)[
  #set text(size: 10.5pt, weight: "bold")
  #it.body
]

// ---------- Header ----------

#let dot = [#h(0.45em) | #h(0.45em)]

#align(center)[
  #text(size: 21pt, weight: "bold", tracking: 0.02em)[#author-name]

  #v(-0.5em)

  #stack(
    dir: ttb,
    spacing: 0.32em,
    text(size: 9.3pt)[$location$ #dot $phone$ #dot #link("mailto:$email$")[$email$]],
    text(size: 9.3pt)[#link("$github-url$")[$github$] #dot #link("$linkedin-url$")[$linkedin$]],
  )
]

$if(summary)$
#block(above: 1.1em, below: 0.1em)[$summary$]
$endif$

$body$

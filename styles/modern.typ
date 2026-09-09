// Modern single-column resume style.
// Noto Sans, deep navy accent on headings and links, tighter leading.
// Pandoc template: rendered from resume.md via build.sh

#let author-name = [$name$]
#let accent = rgb("#1f3a5f")

#set document(title: "$title$", author: "$author$")

#set page(
  paper: "a4",
  margin: (x: 1.7cm, top: 1.4cm, bottom: 1.3cm),
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

#set text(font: "Noto Sans", size: 9.7pt, lang: "en")
#set par(leading: 0.58em, spacing: 0.62em, justify: false)

#set list(indent: 0.8em, body-indent: 0.5em, spacing: 0.36em, marker: (
  text(fill: accent)[•],
  text(fill: accent.lighten(25%))[--],
  [·],
))
#show list: set block(above: 0.44em, below: 0.8em)

#show link: it => text(fill: accent, it)
#show strong: it => text(fill: accent, weight: "bold", it.body)

// Section headings: accent-coloured, uppercase, hairline rule.
#show heading.where(level: 2): it => block(above: 1.35em, below: 0.5em, sticky: true)[
  #set text(size: 9.6pt, weight: "bold", tracking: 0.09em, fill: accent)
  #upper(it.body)
  #v(-0.55em)
  #line(length: 100%, stroke: 0.8pt + accent.lighten(45%))
]

// ---------- Entry headings, with the trailing parenthetical set flush right ----------

// Typst splits markup text into text/space element sequences, so rebuild the
// plain string. Returns none if the heading holds anything else (e.g. a link).
#let flatten-text(c) = {
  if c.func() == text { return c.text }
  if c == [ ] { return " " }
  if c.has("children") {
    let out = ""
    for ch in c.children {
      let s = flatten-text(ch)
      if s == none { return none }
      out += s
    }
    return out
  }
  none
}

// "Some Title (June 2024 - Present)" -> ("Some Title", "June 2024 - Present")
// Anything without a trailing parenthetical comes back as (body, none).
#let split-trailing-paren(body) = {
  let s = flatten-text(body)
  if s == none or not s.ends-with(")") { return (body, none) }
  let parts = s.split("(")
  if parts.len() < 2 { return (body, none) }
  let tail = parts.last()
  if tail.slice(0, tail.len() - 1).contains(")") { return (body, none) }
  (s.slice(0, s.len() - tail.len() - 1).trim(), tail.slice(0, tail.len() - 1))
}

#show heading.where(level: 3): it => {
  let (title, aside) = split-trailing-paren(it.body)
  block(above: 0.8em, below: 0.34em, sticky: true)[
    #set text(size: 9.9pt, weight: "bold")
    #if aside == none {
      title
    } else {
      grid(
        columns: (1fr, auto),
        column-gutter: 1em,
        align: (left + top, right + top),
        title,
        text(weight: "regular", size: 9.2pt, fill: luma(40%))[#aside],
      )
    }
  ]
}

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

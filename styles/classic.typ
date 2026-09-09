// Classic single-column resume style.
// Libertinus Serif, black on white, ruled section headings.
// Pandoc template: rendered from resume.md via build.sh
//
// Level-3 headings are entry titles. A trailing parenthetical is pulled out
// and set flush right, so dates and durations line up down the page:
//   ### Monash University Malaysia (June 2024 - Present)

#let author-name = [$name$]

#set document(title: "$title$", author: "$author$")

#set page(
  paper: "a4",
  margin: (x: 1.9cm, top: 1.6cm, bottom: 1.4cm),
  footer: context {
    let total = counter(page).final().first()
    if total > 1 {
      set text(size: 8.5pt, fill: luma(45%))
      align(center)[
        #author-name #h(0.4em) · #h(0.4em) #counter(page).display() / #total
      ]
    }
  },
)

#set text(font: "Libertinus Serif", size: 10.5pt, lang: "en")
#set par(leading: 0.62em, spacing: 0.7em, justify: false)

#set list(indent: 0.9em, body-indent: 0.5em, spacing: 0.42em, marker: ([•], [--], [·]))
#show list: set block(above: 0.5em, below: 0.85em)

#show link: it => it

// ---------- Section headings ----------

#show heading.where(level: 2): it => block(above: 1.5em, below: 0.6em, sticky: true)[
  #set text(size: 13pt, weight: "bold")
  #smallcaps(it.body)
  #v(-0.42em)
  #line(length: 100%, stroke: 0.7pt + black)
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
  block(above: 1.0em, below: 0.45em, sticky: true)[
    #set text(size: 10.8pt, weight: "bold")
    #if aside == none {
      title
    } else {
      grid(
        columns: (1fr, auto),
        column-gutter: 1em,
        align: (left + top, right + top),
        title,
        text(weight: "regular", size: 10pt)[#aside],
      )
    }
  ]
}

// ---------- Header ----------

#let dot = [#h(0.5em) | #h(0.5em)]

#align(center)[
  #text(size: 22pt, weight: "bold", tracking: 0.02em)[#author-name]

  #v(-0.35em)

  #stack(
    dir: ttb,
    spacing: 0.4em,
    text(size: 9.8pt)[$location$ #dot $phone$ #dot #link("mailto:$email$")[$email$]],
    text(size: 9.8pt)[#link("$github-url$")[$github$] #dot #link("$linkedin-url$")[$linkedin$]],
  )

  #v(0.5em)

  #line(length: 100%, stroke: 0.7pt + black)
]

$if(summary)$
#block(above: 1.0em, below: 0.2em)[$summary$]
$endif$

$body$

# Resume

One markdown file, three PDF layouts. `resume.md` holds the content, `styles/*.typ`
are pandoc templates that render it through typst.

## Build

```sh
./build.sh              # all three styles into out/
./build.sh classic      # just one
./build.sh --final      # copy the chosen style to out/Jonathan-Chan-Resume.pdf
```

Needs `pandoc` (3.x or newer) and `typst`. On Arch: `pacman -S pandoc-cli typst`.

Each style wants a font installed:

| Style    | Font             | Arch package        |
| -------- | ---------------- | ------------------- |
| classic  | Libertinus Serif | ships with typst    |
| modern   | Noto Sans        | `noto-fonts`        |
| twocol   | Roboto           | `ttf-roboto`        |

Check with `typst fonts`, not `fc-list`. Typst bundles a few faces of its own,
Libertinus Serif among them, so `fc-match "Libertinus Serif"` reports a fallback
even though the classic style renders correctly. A font typst genuinely cannot
find falls back silently: the PDF builds and just looks wrong.

## Layout

```
resume.md            content, single source of truth
resume-draft.md      the original hand-written draft, kept for reference
styles/classic.typ   Libertinus Serif, small caps headings, black on white
styles/modern.typ    Noto Sans, navy accent
styles/twocol.typ    Roboto, left rail plus main column
build.sh
out/                 generated PDFs (committed)
build/               scratch files for the two-column build (gitignored)
```

## Writing content

Identity lives in the YAML frontmatter, not the body. The templates lay out the
header, so contact details are metadata rather than a bullet list:

```yaml
name: Jonathan Chan Zhi Thern
location: Subang Jaya, Selangor, Malaysia
phone: "+60 10-225 4283"
email: jonathanczt@gmail.com
github: GitHub
github-url: https://www.github.com/quantumff
summary: |
  Two or three sentences.
```

`github` and `linkedin` are the visible label, `*-url` is where the link points.
Set the label to the URL itself (`github.com/quantumff`) if you want the address
readable on a printed copy.

The body uses two heading levels and flat bullet lists:

```markdown
## Experience

### Worked in a university group (of 6 people) using agile and scrum (over 3 months)

- Built a Learning Management System website
- **Software Stack:** Vite+React with a PostgreSQL+Express backend
```

`##` is a section. `###` is an entry, and every entry gets its own bold title
with space above it.

### Dates go in trailing parentheses

A show rule splits a trailing `(...)` off an entry title and sets it flush right,
so dates line up down the right margin:

```markdown
### Monash University Malaysia (June 2024 - Present)
```

renders as **Monash University Malaysia** on the left and `June 2024 - Present`
against the right edge.

The rule only fires on plain-text titles. If the title contains a link it stays
inline, which is why `### [Aldex](url) ([live](url))` keeps `(live)` where you
wrote it. To date a project entry, put the whole link in the title and the date
in the trailing parens.

## How it renders

`classic` and `modern` are one pandoc call each, with typst as the PDF engine:

```sh
pandoc resume.md --wrap=none --template=styles/classic.typ --pdf-engine=typst -o out/resume-classic.pdf
```

`twocol` needs more work because typst cannot reflow a linear document into a
side rail. `build.sh` splits `resume.md` by section into two markdown fragments,
converts each to typst, and the template `#include`s both into a grid. Routing is
one variable at the top of `build.sh`:

```sh
SIDEBAR_SECTIONS="Education|Skills|Homelab|Spoken Languages"
```

A new `##` section lands in the main column unless you name it there.

## Gotchas

These all cost real debugging time. They will bite again.

**Always pass `--wrap=none`.** Pandoc wraps output at 72 columns by default,
which broke the PDF title by splitting a typst string literal across a newline.
The document still compiled, so the only symptom was a corrupt title in the
metadata.

**Write `$$` for a literal dollar sign in a template.** Pandoc expands `$body$`
anywhere in the file, including inside typst comments. A comment mentioning
`$body$` dumped the entire resume into the middle of the template.

**Letter-spacing breaks text extraction.** `tracking: 0.1em` on headings made
`EDUCATION` come out of the PDF as `EDUCATI ON`, and `PERSONAL PROJECTS` as
`PE R SO NAL P RO J E C T S`. Applicant tracking systems key off section
headings, so this quietly matters. Classic uses Libertinus true small caps
instead of letter-spaced uppercase, which fixed it. After touching any heading
style, check:

```sh
pdftotext out/resume-classic.pdf - | tr -d '\f' | grep -icE '^(education|experience|skills|personal projects|homelab|spoken languages)$'
```

That should print `6`. The `tr -d '\f'` strips the form feed that pdftotext
prepends to the first line of each page.

**Typst gives you heading text as elements, not a string.** `it.body.text` is
empty for anything with a space in it, because typst splits markup into `text`
and `space` elements. Each template carries a `flatten-text` helper that walks
the children and rebuilds the string, returning `none` if it finds anything that
isn't plain text.

**Templates cannot `#import` or `#include` a shared file** when typst runs as
pandoc's PDF engine, because pandoc writes the intermediate `.typ` to a temp
directory. That is why `flatten-text` is duplicated in all three templates, and
why the two-column build compiles with `typst compile` in `build/` instead.

## Checks worth running before sending it out

```sh
pdfinfo out/resume-classic.pdf                 # page count, title, author
pdftotext out/resume-classic.pdf -             # what a keyword filter reads
pdftoppm -r 110 -png out/resume-classic.pdf /tmp/preview   # eyeball every page
```

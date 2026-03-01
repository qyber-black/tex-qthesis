# Qyber thesis class and template

> SPDX-FileCopyrightText: 2026 Frank Langbein <frank@langbein.org>\
> SPDX-License-Identifier: LPPL-1.3c

The **qthesis** class is a LaTeX class for research degree theses, plus a ready-to-use template. It provides a clean layout (A4, 12pt, 1.5 spacing), optional sans/serif/mixed fonts, numeric or author--year citations, and a compact chapter style. The template suggests a common PhD structure (Introduction, Literature Review, Methods, Results, Discussion, optional Further Analysis, Conclusions and Future Work); chapters and sections can be adapted to the candidate's needs. The template in this directory demonstrates all features and can be filled with your own content.

## Build

The Makefile uses **latexmk** to run the LaTeX engine, bibliography, and cross-references as needed.

- **Build the thesis:** `make` or `make all` (produces `main.pdf`).
- **Remove build artifacts:** `make clean`. Use `make distclean` to also remove `main.pdf`.
- **Word count:** `make wordcount` for per-file and total word count (caption words shown separately).

**Choose the LaTeX engine** with the `ENGINE` variable (default: `lua` = lualatex):

- `make` or `make ENGINE=lua` — LuaLaTeX
- `make ENGINE=pdf` — pdfLaTeX
- `make ENGINE=xe` — XeLaTeX

## Requirements

You need **latexmk**, **lualatex** (or pdflatex/xelatex if you switch engine), **makeglossaries** (for acronyms), and **bibtex** (for the bibliography). Install them via your distribution (TeX Live, MiKTeX, etc.).

## Quality checks

Run `make check` to run REUSE lint (license and copyright compliance; see [REUSE](https://reuse.software)). This project is REUSE-compliant (SPDX headers in source files, `LICENSES/LPPL-1.3c.txt`, `REUSE.toml` for `bibliography.bib` which cannot hold SPDX headers). If the `reuse` tool is not installed, the target reports that. You can extend the Makefile `check` target with thesis-specific checks (e.g. validating numbers against data sources, or scripts that regenerate tables from data and ensure the document is in sync).

## Where to put the class

The template expects `qthesis.cls` in the same directory as `main.tex`. To use the class in other projects, either copy `qthesis.cls` into that project or install it in your TEXMF tree.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute (GitHub PRs, patches, or GitLab MRs if you have qyber.black access).

## License and copyright

Template and class: **LPPL-1.3c**, Copyright (C) 2026 Frank Langbein \<<frank@langbein.org>\>. The Current Maintainer of this work is Frank Langbein [frank@langbein.org](mailto:frank@langbein.org). See the [LaTeX Project Public License](https://www.latex-project.org/lppl/). The `LICENSE` file in this directory contains the short notice.

## Reviewer comments (`%ID`)

To leave comments for a co-author or reviewer, use a line starting with `%ID` (e.g. `%F` for Frank), with a space after the ID. Place the comment on the line immediately after the sentence or element it refers to. Find all such comments with:

```bash
grep -r '^%[A-Za-z] ' *.tex */*.tex
```

When a comment is addressed, delete it. See the comment block at the top of `main.tex` for the full convention.

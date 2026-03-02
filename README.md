# Qyber thesis class and template

> SPDX-FileCopyrightText: 2026 Frank Langbein <frank@langbein.org>\
> SPDX-License-Identifier: LPPL-1.3c

The **qthesis** class is a LaTeX class for research degree theses, plus ready-to-use templates. It provides a clean layout (A4, 12pt, 1.5 spacing), optional sans (default), serif, or hacker fonts, numeric or author--year citations, and a compact chapter style. The main thesis template suggests a common PhD structure (Introduction, Literature Review, Methods, Results, Discussion, optional Further Analysis, Conclusions and Future Work); chapters and sections can be adapted to the candidate's needs. The template in this directory demonstrates all features and can be filled with your own content.

For shorter documents related to the PhD (such as annual progress reports), the **qreport** class and the `progress-report.tex` example in this directory provide an article-style layout with a compact title block and suggested section structure. The report template is generic and can be adapted to match your institution's specific progress-review guidance.

## Getting started as a PhD student

This directory is intended to be your main PhD thesis and progress-report project, kept under version control in a git repository (for example a fork on GitHub, GitLab, or your institution's Git service).

- **Fork the template**: on your hosting platform (GitHub, GitLab, etc.), fork the upstream repository that contains this directory into your own namespace. Then clone *your fork* to your machine, so your local copy and remote stay linked.
- **Build once**: in this directory, run `make` (or `make ENGINE=pdf` / `make ENGINE=xe`) to build `main.pdf` and check that your toolchain is working.
- **Edit the thesis**:
  - Put global metadata in `main.tex` using `\title`, `\author`, `\degree`, `\university`, `\date`, and optionally `\keywords`.
  - Write your main chapters in `C1/chapter1.tex` through `C7/chapter7.tex` (add or remove chapter files as needed).
  - Use the appendix files in `AA/` and `AB/` (or create new ones) for supplementary material.

If you start from an upstream template repository, your fork will keep a relationship to that source. While you are still close to the original template, you can occasionally bring in upstream changes (for example by creating a merge request from the upstream project into your fork, or by adding an `upstream` remote and merging from it). Once you have made substantial local edits to the thesis template files, you should only merge upstream changes when strictly necessary and review all differences carefully; at that stage it is often simpler to treat your fork as independent and carry across only specific changes you really need.

## Progress reports with qreport

For progress reports and similar shorter documents:

- Use `progress-report.tex` as a starting point. It demonstrates the `qreport` class, report metadata (`\candidate`, `\programme`, `\supervisors`, `\reporttype`, `\reportperiod`, etc.), and a suggested section structure for typical PhD progress reviews.
- For each new report, create a copy of `progress-report.tex` with a descriptive name, for example:
  - `progress-report-year1.tex`
  - `progress-report-midterm.tex`
  - `progress-report-YYYY-MM.tex`
- To build a single report PDF, run:

  ```bash
  make progress-report.pdf         # or make <name>.pdf for another report file
  ```

- The `Makefile` also supports a `REPORTS` list. For example:

  ```bash
  REPORTS="progress-report-year1 progress-report-year2" make reports
  ```

  will build all configured report PDFs in one go.

Keep all your reports in this same repository so that they are versioned together with the thesis (and can be reviewed via normal git workflows instead of separate Overleaf projects.

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

## Fonts and obfuscation

- Class option **`obfuscate`** enables font obfuscation for any font (sans, serif, or hacker). Requires **LuaLaTeX**; with XeLaTeX or pdfLaTeX a warning is emitted and normal fonts are used.
- Generate obfuscated fonts with the build script. Default **`make hacker-font`** produces `fonts/hacker-obfuscated.otf` and `fonts/obfuscate-perm.lua` (use optional **`SEED=n`** for a reproducible permutation).
- To use obfuscation with **sans** or **serif**, run the script with the same **`--seed`** (e.g. same `SEED=` when using make), **`--font`** path to the base font (e.g. Source Sans Pro or Source Serif Pro), and **`--output-font sans-obfuscated.otf`** or **`serif-obfuscated.otf`**. Example: `python3 scripts/build-hacker-font.py --output-dir fonts --seed 42 --font /path/to/SourceSansPro-Regular.otf --output-font sans-obfuscated.otf`.
- For full obfuscation (including **\textbf**, **\textit**, and **\textsc** used in the class), generate all variants per family with the **same seed**: Regular, Bold, Italic, BoldItalic (e.g. `sans-obfuscated.otf`, `sans-obfuscated-Bold.otf`, `sans-obfuscated-Italic.otf`, `sans-obfuscated-BoldItalic.otf`). Optionally SmallCaps (used in newthought, headers, chapter titles) or Slanted if your font provides them. Expected files: `fonts/<base>.otf`, `fonts/<base>-Bold.otf`, `fonts/<base>-Italic.otf`, `fonts/<base>-BoldItalic.otf`, and `fonts/obfuscate-perm.lua` (shared).

## Quality checks

Run `make check` to run REUSE lint (license and copyright compliance; see [REUSE](https://reuse.software)). This project is REUSE-compliant (SPDX headers in source files, `LICENSES/LPPL-1.3c.txt`, `REUSE.toml` for `bibliography.bib` which cannot hold SPDX headers). If the `reuse` tool is not installed, the target reports that. You can extend the Makefile `check` target with thesis-specific checks (e.g. validating numbers against data sources, or scripts that regenerate tables from data and ensure the document is in sync).

## Working with git (recommended over Overleaf)

We recommend keeping this project in a git repository hosted on a service such as GitHub, GitLab, or your institution's Git platform, instead of editing the sources directly on Overleaf. A simple workflow looks like this:

- **Edit, build, commit**:
  - Make changes to your `.tex` files (thesis or progress reports).
  - Run `make` (or `make reports`) to check that everything still compiles.
  - Use `git status` to see what changed, then `git commit` with a short message.
- **Use branches for bigger changes**: create a branch (e.g. `year2-results` or `rewrite-intro`) for substantial edits, and merge it back once you are happy.
- **Sync with a remote**: push regularly to your remote repository so your work is backed up and can be reviewed, commented on, or cloned to another machine.

If you migrate existing Overleaf content, copy your `.tex` and `.bib` files into this structure and commit them here; subsequent work can then proceed entirely in this git-based project.

## Where to put the class

The template expects `qthesis.cls` in the same directory as `main.tex`. To use the class in other projects, either copy `qthesis.cls` into that project or install it in your TEXMF tree.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute (GitHub PRs, patches, or GitLab MRs if you have qyber.black access).

If you are using this repository as your own PhD thesis project and notice ways to improve the templates or documentation (for example clearer comments, additional example chapters or report sections, or better defaults), you are encouraged to feed those improvements back upstream:

- Open an issue on the upstream project describing the problem or suggestion.
- Or, from your fork, create a pull/merge request with a focused change (for example, a clearer explanation in `README.md`, an additional example in `progress-report.tex`, or a small class option that is generally useful).

Keep your own thesis- and report-specific customisations in your fork; only propose changes that are broadly useful to other students or supervisors.

## License and copyright

Template and class: **LPPL-1.3c**, Copyright (C) 2026 Frank Langbein \<<frank@langbein.org>\>. The Current Maintainer of this work is Frank Langbein [frank@langbein.org](mailto:frank@langbein.org). See the [LaTeX Project Public License](https://www.latex-project.org/lppl/). The `LICENSE` file in this directory contains the short notice.

## Reviewer comments (`%ID`)

To leave comments for a co-author or reviewer, use a line starting with `%ID` (e.g. `%F` for Frank), with a space after the ID. Place the comment on the line immediately after the sentence or element it refers to. Find all such comments with:

```bash
grep -r '^%[A-Za-z] ' *.tex */*.tex
```

When a comment is addressed, delete it. See the comment block at the top of `main.tex` for the full convention.

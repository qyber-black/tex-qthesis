# Contributing to qthesis

> SPDX-FileCopyrightText: 2026 Frank Langbein <frank@langbein.org>\
> SPDX-License-Identifier: LPPL-1.3c

Thank you for your interest in contributing. This document explains how to contribute to the **qthesis** LaTeX class and template.

## Where the project lives

- **Canonical repository:** The main repository is on **GitLab** at [qyber.black](https://qyber.black), in the **Tools** group. That is where the authoritative source is kept and where maintainers work.
- **GitHub mirror:** The project is mirrored on **GitHub** for discoverability and so that people can contribute without a qyber.black account. Most contributors will use GitHub.

You do **not** need an account on qyber.black to contribute. Use GitHub (or patches by email) as described below; maintainers will review and integrate accepted changes into the GitLab repo.

## How to contribute

### Option A: Contribute via GitHub (recommended)

1. **Fork and clone**
   Fork the project on **GitHub** (use the mirrored repo), then clone your fork:

   ```bash
   git clone https://github.com/YOUR-USERNAME/qthesis.git
   cd qthesis
   ```

   Add the upstream mirror as a remote so you can pull updates:

   ```bash
   git remote add upstream https://github.com/ORIGINAL-OWNER/qthesis.git
   ```

2. **Create a branch**, make your changes, **build and test** (see “Build and test” below).

3. **Open a pull request** on **GitHub** against the default branch. Describe what you changed and why. If there is an issue, link it.

Maintainers will review pull requests on GitHub and, when accepted, bring the changes into the GitLab repo. Your contribution will be included in the canonical project.

### Option B: Contribute via patch or email

If you prefer not to use GitHub:

- Create your change on a branch, run `make` and `make check`, then create a patch:
  `git format-patch -1 HEAD` (or the appropriate range).
- Send the patch (or a link to a branch you host elsewhere) to the maintainers—e.g. by opening an issue on GitHub describing your change and attaching the patch, or by email if you have a maintainer contact.

Maintainers will consider the patch and, if accepted, apply it to the GitLab repo.

### Option C: If you have a qyber.black (GitLab) account

If you do have access to the GitLab instance: clone the canonical repo, create a branch, push it, and open a **merge request** on GitLab. That is the direct route into the main repository.

---

### Build and test (all options)

- **Build the PDF:**
  `make` or `make all` (requires latexmk, pdflatex/xelatex/lualatex, makeglossaries, bibtex).

- **Quality checks:**
  `make check` runs REUSE lint. The project aims to be REUSE-compliant; fix any `reuse lint` issues before submitting.

- **Clean build (optional):**
  `make distclean && make` to ensure a full rebuild.

### Making your changes

- **Class (`qthesis.cls`):** Keep the same style (comments, spacing). Do not remove or alter SPDX copyright/license lines at the top.
- **Template (`.tex`, `.bib`, etc.):** Follow the conventions in the comment block at the top of `main.tex` (citations, spaces, reviewer comments). Add SPDX headers to new files; see [REUSE](https://reuse.software) and existing files.
- **Other files:** Use the same license and copyright as the rest of the project (LPPL-1.3c; see `LICENSE` and `REUSE.toml`).

- **Commits:** Use clear, short messages. Reference issues if applicable (e.g. `Fix list of figures check (fixes #12)`).

## What to contribute

- **Bug fixes:** Fixes for the class or template (layout, numbering, citations, front matter, etc.).
- **Documentation:** Improvements to README, this guide, or in-file comments.
- **Template improvements:** Better examples, new optional sections, or clearer comments in `main.tex` and chapter files.
- **Class improvements:** New options or behaviour that fit the existing design (A4, 12pt, clean layout, optional fonts/citations). Discuss larger changes in an issue first if unsure.

## License and copyright

By contributing, you agree that your contributions will be licensed under the same terms as the project: **LPPL-1.3c** (LaTeX Project Public License). Add your copyright to the SPDX header of files you create or substantially modify, e.g.:

```text
% SPDX-FileCopyrightText: 2026 Your Name <your.email@example.com>
% SPDX-License-Identifier: LPPL-1.3c
```

Keep existing copyright notices; new lines can be added for new contributors.

## Questions

If something is unclear, open an issue on **GitHub** (mirror repo) so that anyone can participate. If you have access to qyber.black, you can instead use the GitLab project in the Tools group. For the exact repository URLs, see the project’s GitHub or GitLab page.

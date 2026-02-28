# Makefile for qthesis template (uses latexmk)
# Main thesis file: main.tex. Run: make help for targets.
#
# LaTeX engine: set ENGINE to pdf (default), xelatex, or lualatex.
#   make              # pdflatex
#   make ENGINE=xelatex
#   make ENGINE=lualatex
#
# SPDX-FileCopyrightText: 2026 Frank Langbein <frank@langbein.org>
# SPDX-License-Identifier: LPPL-1.3c

MAIN = main
ENGINE ?= pdf

# ------------------------------------------------------------------------------
# Default: build (first target). Run "make help" for all targets.
# ------------------------------------------------------------------------------
.PHONY: all
all: $(MAIN).pdf

# ------------------------------------------------------------------------------
# Help
# ------------------------------------------------------------------------------
help:
	@echo "qthesis template Makefile targets:"
	@echo "  make [all]     Build $(MAIN).pdf (default)."
	@echo "  make help      Show this help."
	@echo "  make clean    Remove build artifacts (keep PDF)."
	@echo "  make distclean  clean + remove $(MAIN).pdf"
	@echo "  make wordcount  Per-file and total word count (captions shown separately)."
	@echo "  make check    Run quality checks (REUSE lint, optional thesis-specific)."
	@echo ""
	@echo "Engine: make ENGINE=pdf (default) | ENGINE=xelatex | ENGINE=lualatex"

# latexmk engine flag and compiler command for nonstopmode + file-line-error
ifeq ($(ENGINE),xelatex)
  LATEXMK_ENGINE = -xelatex
  LATEXMK_CMD = -xelatex="xelatex -interaction=nonstopmode -file-line-error %O %S"
else
  ifeq ($(ENGINE),lualatex)
    LATEXMK_ENGINE = -lualatex
    LATEXMK_CMD = -lualatex="lualatex -interaction=nonstopmode -file-line-error %O %S"
  else
    LATEXMK_ENGINE = -pdf
    LATEXMK_CMD = -pdflatex="pdflatex -interaction=nonstopmode -file-line-error %O %S"
  endif
endif

LATEXMK = latexmk

.PHONY: clean distclean wordcount check help

$(MAIN).pdf: $(MAIN).tex qthesis.cls bibliography.bib acronyms.tex \
	C1/chapter1.tex C2/chapter2.tex C3/chapter3.tex C4/chapter4.tex \
	C5/chapter5.tex C6/chapter6.tex C7/chapter7.tex Appendix/appendix.tex
	$(LATEXMK) $(LATEXMK_ENGINE) $(LATEXMK_CMD) $(MAIN)
	-makeglossaries $(MAIN)
	$(LATEXMK) $(LATEXMK_ENGINE) $(LATEXMK_CMD) $(MAIN)

clean:
	$(LATEXMK) -c $(MAIN)
	rm -f *.aux *.log *.out *.toc *.lof *.lot *.loa
	rm -f *.bbl *.blg *.run.xml *.bcf
	rm -f *.acn *.acr *.alg *.glg *.glo *.gls *.ist
	rm -f *.fls *.fdb_latexmk *.synctex.gz

distclean: clean
	$(LATEXMK) -C $(MAIN)
	rm -f $(MAIN).pdf

# Word count: includes \input files (-inc). Full count = text + headers + captions.
# Caption words are shown separately per file and in total.
wordcount:
	@echo "Word count per file (total = text + headers + captions):"; \
	texcount -quiet -inc -sum=1,1,1,0,0,0,0 $(MAIN).tex 2>/dev/null | awk '\
	  /^File: / { f=$$2 } \
	  /^Included file: \.\// { sub(/^Included file: \.\//,""); f=$$0 } \
	  /^Sum count: / { if (f != "") { s=$$3 } else if (tot) { total_sum=$$3 } } \
	  /^Words outside text \(captions/ { c=$$NF; if (f != "" && s != "") { print "  " f ": " s " words (" c " in captions)"; tw+=s; tc+=c; f=""; s="" } else if (total_sum != "") { print ""; print "  Total: " total_sum " words (" c " in captions)"; exit } } \
	  /^File\(s\) total:/ { tot=1 } \
	  END { if (total_sum == "" && tw != "") print "\n  Total: " tw " words (" tc " in captions)" }' \
	  || (echo "  (texcount failed; fallback: detex+wc)"; detex $(MAIN).tex 2>/dev/null | wc -w)

# ------------------------------------------------------------------------------
# Check: REUSE lint (license/copyright) and optional thesis-specific checks
# ------------------------------------------------------------------------------
# This template aims to be REUSE-compliant (https://reuse.software). Install the
# reuse tool and run "make check" to verify SPDX headers and license files.
# You can add thesis-specific checks below, e.g.:
#   - Validate numbers/values against data sources (scripts that compare .tex to data).
#   - Regenerate tables/figures from data and diff (ensure document is in sync).
#   - Spell-check or style checks. Hook them here so "make check" runs everything.
check:
	@echo "Running REUSE lint (license/copyright compliance)..."; \
	if command -v reuse >/dev/null 2>&1; then reuse lint; else echo "  (reuse not installed; install from https://reuse.software to enable)"; fi
	@echo "Check done. Add custom checks above (data validation, data-to-document sync, etc.)."

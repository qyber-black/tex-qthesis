
% qthesis.cls -- Qyber thesis class
% Engines: pdfLaTeX, XeLaTeX, LuaLaTeX.
% Layout: A4, 12pt, 3cm margins; 1.5 line spacing; ragged-right;
%   main text 12pt, footnotes and captions at least 11pt.
% Chapter style: number/letter and title on first line; header has a top bar
%   and "Chapter N" or "Appendix A" label.
%
% SPDX-FileCopyrightText: 2026 Frank Langbein <frank@langbein.org>
% SPDX-License-Identifier: LPPL-1.3c
% This file may be distributed and/or modified under the terms of the
% LaTeX Project Public License (LPPL), version 1.3c.
% The latest version of this license is at https://www.latex-project.org/lppl/
%
% User commands (set in preamble): \title, \author, \degree, \university, \date;
%   \license{SPDX-ID}, \copyrightholder{}, \licenseyear{} (optional).
% In document: \maketitle{abstract text}; \bib{basename} for bibliography.
% Override acronym file: \renewcommand{\qthesisacronymfile}{yourfile.tex}.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{qthesis}[2026/02/27 Qyber thesis class]

\makeatletter

% ------------------------------------------------------------------------------
% Class options
% ------------------------------------------------------------------------------
% Font: mixed (default) = sans-serif text + serif math; sans = all sans-serif;
%   serif = serif text and math.
% Layout: oneside (default) or twoside for double-sided printing.
% Citation: numeric (default) [1], [1,2] or harvard (Author, 2000).
% Any other option is passed through to the underlying book class.

\newif\ifqthesis@font@mixed
\newif\ifqthesis@font@sans
\newif\ifqthesis@font@serif
\newif\ifqthesis@twoside
\newif\ifqthesis@cite@harvard

\qthesis@font@mixedtrue
\qthesis@font@sansfalse
\qthesis@font@seriffalse
\qthesis@twosidefalse
\qthesis@cite@harvardfalse

\DeclareOption{mixed}{%
  \qthesis@font@mixedtrue
  \qthesis@font@sansfalse
  \qthesis@font@seriffalse
}
\DeclareOption{sans}{%
  \qthesis@font@mixedfalse
  \qthesis@font@sanstrue
  \qthesis@font@seriffalse
}
\DeclareOption{serif}{%
  \qthesis@font@mixedfalse
  \qthesis@font@sansfalse
  \qthesis@font@seriftrue
}

\DeclareOption{harvard}{\qthesis@cite@harvardtrue}
\DeclareOption{numeric}{\qthesis@cite@harvardfalse}

\DeclareOption{twoside}{%
  \PassOptionsToClass{twoside}{book}%
  \qthesis@twosidetrue
}
\DeclareOption{oneside}{%
  \PassOptionsToClass{oneside}{book}%
  \qthesis@twosidefalse
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}

\ProcessOptions\relax
\LoadClass[12pt,a4paper]{book}

% Use roman numerals (i, ii, ...) for front matter from the very first page,
% and treat the document as front matter until \mainmatter is called.
% In front matter: sections unnumbered (secnumdepth -1), only chapters in TOC (tocdepth 0).
% Close LOF/LOT/LOA write streams after .aux was read so \listoffigures etc.\ can read the files.
\AtBeginDocument{%
  \@ifundefined{qthesis@opened@lof}{}{\immediate\closeout\tf@lof}%
  \@ifundefined{qthesis@opened@lot}{}{\immediate\closeout\tf@lot}%
  \@ifundefined{qthesis@opened@loa}{}{\immediate\closeout\tf@loa}%
  \@mainmatterfalse
  \pagenumbering{roman}%
  \setcounter{secnumdepth}{-1}%
  \setcounter{tocdepth}{0}%
}
% Restore section numbering and TOC depth in main matter (no etoolbox here).
\let\qthesis@orig@mainmatter\mainmatter
\renewcommand{\mainmatter}{%
  \setcounter{secnumdepth}{3}%
  \setcounter{tocdepth}{3}%
  \addtocontents{toc}{\protect\setcounter{tocdepth}{3}}%
  \qthesis@orig@mainmatter
}
% Discourage \subsection and below in front matter (warn if used).
\let\qthesis@orig@subsection\subsection
\renewcommand{\subsection}{%
  \if@mainmatter\else
    \PackageWarning{qthesis}{Do not use \string\subsection\space in front matter; use \string\section\space only}%
  \fi
  \qthesis@orig@subsection
}
\let\qthesis@orig@subsubsection\subsubsection
\renewcommand{\subsubsection}{%
  \if@mainmatter\else
    \PackageWarning{qthesis}{Do not use \string\subsubsection\space in front matter; use \string\section\space only}%
  \fi
  \qthesis@orig@subsubsection
}

% ------------------------------------------------------------------------------
% Packages (required for class behaviour and layout)
% ------------------------------------------------------------------------------
\RequirePackage{iftex}
\ifPDFTeX
  \RequirePackage[T1]{fontenc}%
  \RequirePackage[utf8]{inputenc}%
  \RequirePackage{lmodern}% Latin Modern as default font when using pdfTeX
\fi

\RequirePackage{fix-cm}% Allow CM to scale to arbitrary sizes if used

\RequirePackage[a4paper,margin=3.0cm]{geometry}% Default margins for the class

% ------------------------------------------------------------------------------
% Float placement: relaxed so floats sit closer to first reference and full
% float pages are easier. Defaults are conservative (few floats per page, large
% text fraction), which can push figures/tables far away. We allow more floats per
% page and more of a page to be float area so the algorithm places them sooner.
% ------------------------------------------------------------------------------
\renewcommand{\topfraction}{0.9}        % max fraction of page for top floats (default 0.7)
\renewcommand{\bottomfraction}{0.7}     % max fraction for bottom floats (default 0.3)
\renewcommand{\textfraction}{0.05}      % min fraction that must be text (default 0.2)
\renewcommand{\floatpagefraction}{0.8}  % min fraction for a float-only page (default 0.5)
\setcounter{topnumber}{4}               % max floats at top of page (default 2)
\setcounter{bottomnumber}{3}            % max floats at bottom (default 1)
\setcounter{totalnumber}{6}             % max total floats on a text page (default 3)

\RequirePackage{graphicx}% \includegraphics for figures
\RequirePackage{amsmath,amsfonts,amssymb}% Standard math
\RequirePackage{xcolor}% Used for link colour (qthesislinkblue)
\RequirePackage{microtype}% Protrusion (and expansion under pdfTeX) for better typography
\RequirePackage{setspace}% \onehalfspacing
\RequirePackage[document]{ragged2e}% \RaggedRight for left-aligned paragraphs
\RequirePackage{etoolbox}% \pretocmd, \patchcmd, \ifstrempty, etc.

% When the .aux file is read at \begin{document}, the kernel sets \@writefile to
% \@gobbletwo, so \@writefile{lof}{...} etc.\ are discarded and .lof/.lot/.loa
% are never created. Patch so we write those to the list files; then
% \listoffigures etc.\ can read them and the lists appear.
\newwrite\tf@lof
\newwrite\tf@lot
\newwrite\tf@loa
\long\def\qthesis@writelist#1#2{%
  \@ifundefined{qthesis@opened@#1}{%
    \immediate\openout\csname tf@#1\endcsname\jobname.#1
    \expandafter\gdef\csname qthesis@opened@#1\endcsname{}%
  }{}%
  \immediate\write\csname tf@#1\endcsname{\unexpanded{#2}}%
}
\def\qthesis@write@lof#1{\qthesis@writelist{lof}{#1}}
\def\qthesis@write@lot#1{\qthesis@writelist{lot}{#1}}
\def\qthesis@write@loa#1{\qthesis@writelist{loa}{#1}}
% Only lof/lot/loa get written to list files; toc and others are gobbled (kernel behaviour).
\long\def\qthesis@writefile#1#2{%
  \edef\qthesis@write@arg{#1}%
  \ifx\qthesis@write@arg\qthesis@lofstr
    \qthesis@write@lof{#2}%
  \else
    \ifx\qthesis@write@arg\qthesis@lotstr
      \qthesis@write@lot{#2}%
    \else
      \ifx\qthesis@write@arg\qthesis@loastr
        \qthesis@write@loa{#2}%
      \else
        \@gobbletwo{#1}{#2}%
      \fi
    \fi
  \fi
}
\def\qthesis@lofstr{lof}\def\qthesis@lotstr{lot}\def\qthesis@loastr{loa}
\patchcmd{\document}{\let\@writefile\@gobbletwo}{\let\@writefile\qthesis@writefile}{}{}

% Citations: natbib with options matching class (harvard or numeric)
\ifqthesis@cite@harvard
  \RequirePackage[authoryear,round,sort&compress,longnamesfirst]{natbib}%
  % Author-year style: (Author, 2000; Author & Coauthor, 2001)
  \bibpunct{(}{)}{;}{a}{,}{,}%
\else
  % Numeric, compressed: [1], [1,2], [1–3]
  \RequirePackage[numbers,sort&compress,square]{natbib}%
  \bibpunct{[}{]}{,}{n}{,}{,}%
\fi
\RequirePackage{xurl}% Allow line breaks in URLs
\RequirePackage{hyperref}% PDF links, bookmarks, and metadata
\ifPDFTeX
  \RequirePackage[hyphenbreaks]{breakurl}% Better URL breaking with pdfTeX
\fi

% Glossaries: if you define acronyms with \newacronym, a List of Acronyms is
% included in the front matter. Default style: long-short (first use: ``long (short)'',
% later: short). Build: pdflatex, then makeglossaries (or makeindex), then pdflatex again.
\RequirePackage[acronym,nomain,toc]{glossaries}% nomain: we only use acronyms, not the main glossary
\setacronymstyle{long-short}% First use: full form (abbreviation); later: abbreviation only
\makeglossaries
\newif\ifqthesis@hasacronyms
\qthesis@hasacronymsfalse
\pretocmd{\newacronym}{\global\qthesis@hasacronymstrue}{}{}
% Acronym file: loaded automatically if it exists. Override with
% \renewcommand{\qthesisacronymfile}{yourfile.tex} in the preamble.
\newcommand{\qthesisacronymfile}{acronyms.tex}
\IfFileExists{\qthesisacronymfile}{\input{\qthesisacronymfile}}{}
\AtBeginDocument{\glsaddall}% Include all defined acronyms in the list

% Redirect bare \cite to \citep and emit a warning, so authors use \citep
% (parenthetical) or \citet (narrative) explicitly.
\renewcommand{\cite}{%
  \PackageWarning{qthesis}{Use \string\citep\space or \string\citet\space instead of \string\cite}%
  \citep
}

\RequirePackage[font=small]{caption}% Caption font at least 11pt
\RequirePackage{textcomp}% \textcopyright for copyright page, \textdegree, etc.

% Link colour: used by hyperref and by our \href/\url overrides (no PDF border)
\definecolor{qthesislinkblue}{RGB}{0,0,120}

% ------------------------------------------------------------------------------
% Font configuration (depends on class options: mixed, sans, serif)
% ------------------------------------------------------------------------------
\ifPDFTeX
  \ifqthesis@font@mixed
    \RequirePackage[default]{sourcesanspro}%
    \RequirePackage{newtxmath}%
    \renewcommand{\familydefault}{\sfdefault}%
  \fi
  \ifqthesis@font@sans
    \RequirePackage[default]{sourcesanspro}%
    \renewcommand{\familydefault}{\sfdefault}%
  \fi
  \ifqthesis@font@serif
    \RequirePackage{newtxtext}%
    \RequirePackage{newtxmath}%
  \fi
\else
  % XeLaTeX/LuaLaTeX: use fontspec; avoid scaling so 12pt is true document size
  \RequirePackage{fontspec}%
  \defaultfontfeatures{Ligatures=TeX}%
  \ifqthesis@font@mixed
    \setmainfont{TeX Gyre Heros}%
    \setsansfont{TeX Gyre Heros}%
    \setmonofont{TeX Gyre Cursor}%
  \fi
  \ifqthesis@font@sans
    \setmainfont{TeX Gyre Heros}%
    \setsansfont{TeX Gyre Heros}%
    \setmonofont{TeX Gyre Cursor}%
  \fi
  \ifqthesis@font@serif
    \setmainfont{TeX Gyre Termes}%
    \setsansfont{TeX Gyre Heros}%
    \setmonofont{TeX Gyre Cursor}%
  \fi
\fi

% ------------------------------------------------------------------------------
% Layout defaults for the Qyber thesis class
% ------------------------------------------------------------------------------
\onehalfspacing
\RaggedRight
\emergencystretch=3em
\RequirePackage{parskip}

% At document start: ensure footnotes/captions stay at least 11pt (\small);
% if \license was set, load qthesis-licenses.tex for full license text in the
% License chapter (optional; copy from package into your project).
\AtBeginDocument{%
  \renewcommand{\footnotesize}{\small}%
  \ifqthesis@license
    \InputIfFileExists{qthesis-licenses.tex}{}{}%
  \fi
}

\microtypesetup{final,protrusion=true,nopatch=footnote}%
\ifXeTeX\else \microtypesetup{expansion=true}\fi% Expansion only with pdfTeX

\hypersetup{
  unicode=true,
  breaklinks=true,
  colorlinks=true,
  linkcolor=qthesislinkblue,
  citecolor=qthesislinkblue,
  urlcolor=qthesislinkblue,
  filecolor=qthesislinkblue,
  menucolor=qthesislinkblue
}
% Override \href and \UrlFont so all links use qthesislinkblue (no box, just colour)
\let\qthesis@orig@href\href
\renewcommand{\href}[2]{%
  \qthesis@orig@href{#1}{%
    {\color{qthesislinkblue}#2}%
  }%
}

\def\UrlFont{\ttfamily\color{qthesislinkblue}}%

% ------------------------------------------------------------------------------
% Page style (headers and footers)
% ------------------------------------------------------------------------------

\RequirePackage{fancyhdr}

% Thin rule on plain pages; thick rule on chapter opening pages (behind chapter label)
\newlength{\qthesis@headruleheight}
\newlength{\qthesis@headruleheight@thick}
\setlength{\qthesis@headruleheight}{0.4pt}
\setlength{\qthesis@headruleheight@thick}{3.2pt}

% Increase headheight for the chapter bar; reduce top margin so layout stays correct
\setlength{\headheight}{32pt}
\addtolength{\topmargin}{-16pt}

% No header/footer or rules (e.g. title page, abstract)
\fancypagestyle{empty}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}

% Running heads: page number; section/chapter title in main matter only; thin rule
\fancypagestyle{plain}{%
  \fancyhf{}%
  \ifqthesis@twoside
    \fancyhead[LE,RO]{\thepage}%
    \if@mainmatter
      \fancyhead[LO,RE]{\slshape\leftmark}%
    \else
      \fancyhead[LO,RE]{}%
    \fi
  \else
    \fancyhead[R]{\thepage}%
    \if@mainmatter
      \fancyhead[L]{\slshape\leftmark}%
    \else
      \fancyhead[L]{}%
    \fi
  \fi
  \renewcommand{\headrulewidth}{\qthesis@headruleheight}%
}

% Chapter opening page: page number and "Chapter N" / "Appendix A" in header with thick rule
\fancypagestyle{chapter}{%
  \fancyhf{}%
  \ifqthesis@twoside
    \fancyhead[RO,LE]{\thepage}%
  \else
    \fancyhead[R]{\thepage}%
  \fi
  \renewcommand{\headrule}{%
    \begingroup
      \normalfont
      \setlength{\dimen0}{0pt}%
      \settowidth{\dimen0}{\Large\bfseries\ \MakeUppercase{\@chapapp}~\qthesis@chapterlabel}%
      \vskip2pt
      \hrule\@height\qthesis@headruleheight\@width\headwidth
      \vskip-\qthesis@headruleheight
      \hbox to\headwidth{\hfill\vrule\@height\qthesis@headruleheight@thick\@width\dimen0}%
      \hbox to\headwidth{\hfill\Large\bfseries \MakeUppercase{\@chapapp}~\qthesis@chapterlabel}%
      \vskip-0.3\baselineskip
    \endgroup
  }%
  \renewcommand{\headrulewidth}{0pt}%
}

\pagestyle{plain}

% ------------------------------------------------------------------------------
% Chapter and appendix headings
% ------------------------------------------------------------------------------
% Main matter: "1. Title", "2. Title". Appendix: "A. Title", "B. Title".
% Front matter chapters (unnumbered) get no number. \qthesis@chapterlabel is
% what appears in the header (number or appendix letter).
\def\@makechapterhead#1{%
  \vspace*{3\baselineskip}%
  {\noindent\Huge\bfseries
    \if@mainmatter
      \thechapter.\ %
    \else
      \ifqthesis@inappendix
        \qthesis@chapterletter.\ %
      \fi
    \fi
    #1\par}%
  \vspace{2\baselineskip}%
}
\def\@makeschapterhead#1{%
  \vspace*{3\baselineskip}%
  {\noindent\Huge\bfseries #1\par}%
  \vspace{2\baselineskip}%
}

% First page of unstarred chapters uses "chapter" style; starred chapters use "plain"
\newif\ifqthesis@inappendix
\qthesis@inappendixfalse
\newcommand{\qthesis@chapterletter}{}
\def\qthesis@chapterlabel{\ifqthesis@inappendix \qthesis@chapterletter \else \thechapter \fi}

% After \backmatter, chapters are appendices: numbering A, B, C and section numbers A.1, A.2, ...
\newcounter{qthesis@appendixtoc@flag}
\let\qthesis@orig@backmatter\backmatter
\renewcommand{\backmatter}{%
  \qthesis@orig@backmatter
  \global\qthesis@inappendixtrue
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\appendixname}%
  \gdef\thechapter{\@Alph\c@chapter}%
  \gdef\thesection{\thechapter.\@arabic\c@section}%
  \gdef\thesubsection{\thesection.\@arabic\c@subsection}%
  \gdef\thesubsubsection{\thesubsection.\@arabic\c@subsubsection}%
  \gdef\theparagraph{\thesubsubsection.\@arabic\c@paragraph}%
  \gdef\thesubparagraph{\theparagraph.\@arabic\c@subparagraph}%
  \setcounter{secnumdepth}{3}%
  \setcounter{qthesis@appendixtoc@flag}{0}%
}

\let\qthesis@orig@appendix\appendix
\renewcommand{\appendix}{%
  \qthesis@orig@appendix
  \global\qthesis@inappendixtrue
}

% On each (unstarred) chapter: use "chapter" style on first page in main matter or
% appendix; otherwise "plain". Then switch to plain for following pages.
\pretocmd{\@chapter}{%
  \if@mainmatter
    \thispagestyle{chapter}%
  \else
    \ifqthesis@inappendix
      \refstepcounter{chapter}%
      \xdef\qthesis@chapterletter{\@Alph\c@chapter}%
      \global\advance\c@qthesis@appendixtoc@flag\@ne
      \thispagestyle{chapter}%
    \else
      \thispagestyle{plain}%
    \fi
  \fi
  \pagestyle{plain}%
}{}{}

\pretocmd{\@schapter}{%
  \thispagestyle{plain}%
  \pagestyle{plain}%
}{}{}

% Standard book class omits \numberline for backmatter chapters, so appendix
% entries in the TOC would show no "A", "B". We wrap \addcontentsline and
% inject \numberline for appendix chapters so the TOC shows "A Title", "B Title".
\def\qthesis@toc@name{toc}%
\def\qthesis@level@chapter{chapter}%
\def\qthesis@wrap@addcontentsline{%
  \let\qthesis@orig@addcontentsline\addcontentsline
  \def\addcontentsline##1##2##3{%
    \edef\qthesis@toc@arg{##1}%
    \edef\qthesis@level@arg{##2}%
    \ifx\qthesis@toc@arg\qthesis@toc@name
      \ifx\qthesis@level@arg\qthesis@level@chapter
        \ifnum\c@qthesis@appendixtoc@flag>\z@
          \global\advance\c@qthesis@appendixtoc@flag\m@ne
          \qthesis@orig@addcontentsline{##1}{##2}{\protect\numberline{\thechapter}##3}%
        \else
          \qthesis@orig@addcontentsline{##1}{##2}{##3}%
        \fi
      \else
        \qthesis@orig@addcontentsline{##1}{##2}{##3}%
      \fi
    \else
      \qthesis@orig@addcontentsline{##1}{##2}{##3}%
    \fi
  }%
}
\AtBeginDocument{\qthesis@wrap@addcontentsline}

% Put the bibliography into the TOC as a chapter
\patchcmd{\thebibliography}{\bibsection}{\bibsection\addcontentsline{toc}{chapter}{\bibname}}{}{}

% Supply \leftmark for running heads (chapter title or section number + title)
\renewcommand{\chaptermark}[1]{\markboth{#1}{}}
\renewcommand{\sectionmark}[1]{\markboth{\thesection\ #1}{}}
\renewcommand{\subsectionmark}[1]{}

% ------------------------------------------------------------------------------
% Metadata and title page
% ------------------------------------------------------------------------------
% User commands store values in internal macros used by \maketitlepage and \bib

\newcommand{\qthesis@title}{}
\newcommand{\qthesis@author}{}
\newcommand{\qthesis@degree}{}
\newcommand{\qthesis@university}{Your University}
\newcommand{\qthesis@date}{\today}

\renewcommand{\title}[1]{\gdef\qthesis@title{#1}}
\renewcommand{\author}[1]{\gdef\qthesis@author{#1}}
\newcommand{\degree}[1]{\gdef\qthesis@degree{#1}}
\newcommand{\university}[1]{\gdef\qthesis@university{#1}}
\renewcommand{\date}[1]{\gdef\qthesis@date{#1}}

% ------------------------------------------------------------------------------
% License and copyright (SPDX)
% ------------------------------------------------------------------------------
% \license{SPDX-ID} enables a copyright page after the abstract and a License
% chapter before the bibliography. Optional: \copyrightholder, \licenseyear.

\newif\ifqthesis@license
\qthesis@licensefalse
\gdef\qthesis@licenseid{}%
\gdef\qthesis@copyrightholder{}%
\gdef\qthesis@licenseyear{}%

\newcommand{\license}[1]{%
  \qthesis@licensetrue
  \gdef\qthesis@licenseid{#1}%
}
\newcommand{\copyrightholder}[1]{\gdef\qthesis@copyrightholder{#1}}
\newcommand{\licenseyear}[1]{\gdef\qthesis@licenseyear{#1}}

% Map SPDX identifier to {display name, URL}. Unknown IDs get generic spdx.org link.
\def\qthesis@setlicfrompair#1{\expandafter\qthesis@setlicfrompair@aux#1}
\def\qthesis@setlicfrompair@aux#1#2{\gdef\qthesis@lic@name{#1}\gdef\qthesis@lic@url{#2}}
\expandafter\def\csname qthesis@lic@MIT\endcsname{{MIT License}{https://spdx.org/licenses/MIT.html}}
\expandafter\def\csname qthesis@lic@Apache-2.0\endcsname{{Apache License 2.0}{https://www.apache.org/licenses/LICENSE-2.0}}
\expandafter\def\csname qthesis@lic@GPL-3.0-only\endcsname{{GNU GPL License v3.0 only}{https://spdx.org/licenses/GPL-3.0-only.html}}
\expandafter\def\csname qthesis@lic@GPL-3.0-or-later\endcsname{{GNU GPL License v3.0 or later}{https://spdx.org/licenses/GPL-3.0-or-later.html}}
\expandafter\def\csname qthesis@lic@AGPL-3.0-only\endcsname{{GNU AGPL License v3.0 only}{https://spdx.org/licenses/AGPL-3.0-only.html}}
\expandafter\def\csname qthesis@lic@AGPL-3.0-or-later\endcsname{{GNU AGPL License v3.0 or later}{https://spdx.org/licenses/AGPL-3.0-or-later.html}}
\expandafter\def\csname qthesis@lic@GFDL-1.3\endcsname{{GNU Free Documentation License 1.3}{https://www.gnu.org/licenses/fdl-1.3.html}}
\expandafter\def\csname qthesis@lic@CC-BY-4.0\endcsname{{Creative Commons Attribution License 4.0}{https://creativecommons.org/licenses/by/4.0/legalcode}}
\expandafter\def\csname qthesis@lic@CC-BY-SA-4.0\endcsname{{Creative Commons Attribution-ShareAlike License 4.0}{https://creativecommons.org/licenses/by-sa/4.0/legalcode}}
\expandafter\def\csname qthesis@lic@CC-BY-NC-4.0\endcsname{{Creative Commons Attribution-NonCommercial License 4.0}{https://creativecommons.org/licenses/by-nc/4.0/legalcode}}
\expandafter\def\csname qthesis@lic@CC-BY-NC-SA-4.0\endcsname{{Creative Commons Attribution-NonCommercial-ShareAlike License 4.0}{https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode}}
\expandafter\def\csname qthesis@lic@CC-BY-NC-ND-4.0\endcsname{{Creative Commons Attribution-NonCommercial-NoDerivatives License 4.0}{https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode}}
\expandafter\def\csname qthesis@lic@CC-BY-ND-4.0\endcsname{{Creative Commons Attribution-NoDerivatives License 4.0}{https://creativecommons.org/licenses/by-nd/4.0/legalcode}}
\expandafter\def\csname qthesis@lic@CC0-1.0\endcsname{{CC0 1.0 Universal}{https://creativecommons.org/publicdomain/zero/1.0/legalcode}}
\expandafter\def\csname qthesis@lic@BSD-2-Clause\endcsname{{BSD 2-Clause ``Simplified'' License}{https://spdx.org/licenses/BSD-2-Clause.html}}
\expandafter\def\csname qthesis@lic@BSD-3-Clause\endcsname{{BSD 3-Clause ``New'' or ``Revised'' License}{https://spdx.org/licenses/BSD-3-Clause.html}}
\expandafter\def\csname qthesis@lic@LPPL-1.3c\endcsname{{LaTeX Project Public License 1.3c}{https://www.latex-project.org/lppl/lppl-1-3c.html}}

% Resolve current \qthesis@licenseid to display name and URL (from table above or generic)
\newcommand{\qthesis@resolvelicense}{%
  \edef\qthesis@lic@curid{\qthesis@licenseid}%
  \edef\qthesis@lic@cstest{qthesis@lic@\qthesis@lic@curid}%
  \expandafter\@ifundefined\expandafter{\qthesis@lic@cstest}{%
    \gdef\qthesis@lic@name{SPDX: \qthesis@licenseid}%
    \gdef\qthesis@lic@url{https://spdx.org/licenses/\qthesis@licenseid.html}%
  }{%
    \expandafter\qthesis@setlicfrompair\csname qthesis@lic@\qthesis@lic@curid\endcsname
  }%
}

% Copyright page: shown after the abstract when \license{...} was set
\newcommand{\qthesis@copyrightpage}{%
  \clearpage
  \thispagestyle{empty}%
  \qthesis@resolvelicense
  \vfill
  \begin{center}
    \ \vfill
    Copyright\ \textcopyright\ \ifstrempty{\qthesis@licenseyear}{\number\year}{\qthesis@licenseyear}\ %
    \ifstrempty{\qthesis@copyrightholder}{\qthesis@author}{\qthesis@copyrightholder}\par
    \vspace{1ex}
    This work is licensed under the \qthesis@lic@name.\\{\ttfamily SPDX-License-Identifier: \qthesis@licenseid}\\
    Full text: \url{\qthesis@lic@url}
  \end{center}
  \cleardoublepage
}

\newcommand{\maketitlepage}{%
  \begin{titlepage}
    \thispagestyle{empty}% No page number on title page
    \begin{center}
      \vspace*{3ex}
      {\Huge\bfseries \qthesis@title\par}
      \vfill
      {\LARGE \qthesis@author\par}
      \vfill\vfill\vfill
      % Only show the degree sentence if a non-empty degree has been set
      \ifstrempty{\qthesis@degree}{}{%
        {\Large A thesis submitted for the degree of\par}
        {\Large\bfseries \qthesis@degree\par}%
        \vspace{4ex}%
      }%
      \vspace{8ex}
      {\Large \qthesis@university\par}
      \vspace{2ex}
      {\Large \qthesis@date\par}
    \end{center}
  \end{titlepage}
}

% Full front-matter sequence: title page, optional copyright page, abstract,
% then \frontlists (TOC, List of Figures, List of Tables, List of Algorithms, List of Acronyms)
\renewcommand{\maketitle}[1]{%
  \maketitlepage
  \ifqthesis@license
    \qthesis@copyrightpage
  \else
    \cleardoublepage
  \fi
  \begingroup
    \chapter*{Abstract}%
    \addcontentsline{toc}{chapter}{Abstract}%
    #1%
  \endgroup
  \cleardoublepage
  \frontlists
}

% ------------------------------------------------------------------------------
% Front matter: TOC and optional lists of figures, tables, algorithms
% ------------------------------------------------------------------------------
% We scan .lof/.lot/.loa (populated when .aux was read via our \@writefile patch)
% and only output each list if it has at least one entry.

\newif\ifqthesis@haslof
\newif\ifqthesis@haslot
\newif\ifqthesis@hasloa

% Standard \contentsline is 3-arg; hyperref uses 4. Consume 3 and optionally gobble 4th.
\newcommand{\qthesis@checklof}{%
  \qthesis@hasloffalse
  \begingroup
    \makeatletter
    \let\addvspace\@gobble
    \def\contentsline##1##2##3{%
      \global\qthesis@hasloftrue
      \@ifnextchar\bgroup{\@gobble}{}%
    }%
    \IfFileExists{\jobname.lof}{\input{\jobname.lof}}{}%
  \endgroup
}
\newcommand{\qthesis@checklot}{%
  \qthesis@haslotfalse
  \begingroup
    \makeatletter
    \let\addvspace\@gobble
    \def\contentsline##1##2##3{%
      \global\qthesis@haslottrue
      \@ifnextchar\bgroup{\@gobble}{}%
    }%
    \IfFileExists{\jobname.lot}{\input{\jobname.lot}}{}%
  \endgroup
}
\newcommand{\qthesis@checkloa}{%
  \qthesis@hasloafalse
  \begingroup
    \makeatletter
    \let\addvspace\@gobble
    \def\contentsline##1##2##3{%
      \global\qthesis@hasloatrue
      \@ifnextchar\bgroup{\@gobble}{}%
    }%
    \IfFileExists{\jobname.loa}{\input{\jobname.loa}}{}%
  \endgroup
}

\newcommand{\frontlists}{%
  \tableofcontents
  \cleardoublepage
  \qthesis@checklof
  \ifqthesis@haslof
    \listoffigures
    \addcontentsline{toc}{chapter}{List of Figures}%
    \cleardoublepage
  \fi
  \qthesis@checklot
  \ifqthesis@haslot
    \listoftables
    \addcontentsline{toc}{chapter}{List of Tables}%
    \cleardoublepage
  \fi
  \qthesis@checkloa
  \ifqthesis@hasloa
    \listofalgorithms
    \addcontentsline{toc}{chapter}{List of Algorithms}%
    \cleardoublepage
  \fi
  \ifqthesis@hasacronyms
    \printglossary[type=\acronymtype]
    \cleardoublepage
  \fi
}

% ------------------------------------------------------------------------------
% Bibliography
% ------------------------------------------------------------------------------
% \bib{basename} sets bibliography style (harvard -> agsm, numeric -> plainnat),
% optionally prints the License chapter (with full text if qthesis-licenses.tex
% defined it for this SPDX ID), then \bibliography{basename}.
\newcommand{\bib}[1]{%
  \ifqthesis@cite@harvard
    \bibliographystyle{agsm}%
  \else
    \bibliographystyle{plainnat}%
  \fi
  \ifqthesis@license
    \qthesis@resolvelicense
    \chapter*{License}\label{sec:license}%
    \addcontentsline{toc}{chapter}{License}%
    This work is licensed under the \qthesis@lic@name.\\{\ttfamily SPDX-License-Identifier: \qthesis@licenseid}\par
    \vspace{1ex}
    \edef\qthesis@lic@textcs{qthesis@licensetext@\qthesis@licenseid}%
    \expandafter\@ifundefined\expandafter{\qthesis@lic@textcs}{%
      The full license text is available at: \url{\qthesis@lic@url}\par
    }{%
      \small
      \@nameuse{\qthesis@lic@textcs}%
    }%
    \vspace{2\baselineskip}%
  \fi
  \bibliography{#1}%
}

\makeatother

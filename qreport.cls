% qreport.cls -- Qyber report class for PhD progress and related reports
% Standalone article-style class (no dependency on qarticle/qtex).
% Layout: A4, 12pt, single spacing by default; ragged-right; section-level
% structure only (no chapters). Title block at top of first page.
%
% SPDX-FileCopyrightText: 2026 Frank Langbein <frank@langbein.org>
% SPDX-License-Identifier: LPPL-1.3c
% This file may be distributed and/or modified under the terms of the
% LaTeX Project Public License (LPPL), version 1.3c.
% The latest version of this license is at https://www.latex-project.org/lppl/
% This work has the LPPL maintenance status `maintained'.
% The Current Maintainer of this work is Frank Langbein <frank@langbein.org>.
% This work consists of this file and the template files in the same distribution.
%
% User commands (set in preamble):
%   \title, \date;
%   \candidate, \studentid, \programme, \institution, \school,
%   \supervisors, \reporttype, \reportperiod;
%   optional \keywords{...}.
% In document: \maketitle for compact title block; \bib{basename} for bibliography.
%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{qreport}[2026/03/02 Qyber report class]

\makeatletter

% ------------------------------------------------------------------------------
% Class options (mirroring qarticle/qthesis where sensible)
% ------------------------------------------------------------------------------

\newif\ifqreport@justify
\qreport@justifyfalse
\DeclareOption{raggedright}{\qreport@justifyfalse}
\DeclareOption{justified}{\qreport@justifytrue}

\newif\ifqreport@font@sans
\newif\ifqreport@font@serif
\newif\ifqreport@font@hacker
\newif\ifqreport@twoside
\newif\ifqreport@cite@harvard

\qreport@font@sanstrue
\qreport@font@seriffalse
\qreport@font@hackerfalse
\qreport@twosidefalse
\qreport@cite@harvardfalse

\DeclareOption{sans}{%
  \qreport@font@sanstrue
  \qreport@font@seriffalse
  \qreport@font@hackerfalse
}
\DeclareOption{serif}{%
  \qreport@font@sansfalse
  \qreport@font@seriftrue
  \qreport@font@hackerfalse
}
\DeclareOption{hacker}{%
  \qreport@font@sansfalse
  \qreport@font@seriffalse
  \qreport@font@hackertrue
}

\DeclareOption{harvard}{\qreport@cite@harvardtrue}
\DeclareOption{numeric}{\qreport@cite@harvardfalse}

\DeclareOption{twoside}{%
  \PassOptionsToClass{twoside}{article}%
  \qreport@twosidetrue
}
\DeclareOption{oneside}{%
  \PassOptionsToClass{oneside}{article}%
  \qreport@twosidefalse
}

% Line spacing: single (default); onehalfspacing; linespread115/linespread12
\newif\ifqreport@onehalfspacing
\newif\ifqreport@linespread
\qreport@onehalfspacingfalse
\qreport@linespreadfalse
\DeclareOption{single}{\qreport@onehalfspacingfalse\qreport@linespreadfalse}
\DeclareOption{onehalfspacing}{\qreport@onehalfspacingtrue\qreport@linespreadfalse}
\DeclareOption{linespread115}{\qreport@linespreadtrue\def\qreport@linespreadval{1.15}}
\DeclareOption{linespread12}{\qreport@linespreadtrue\def\qreport@linespreadval{1.2}}

% Paragraph style: parskip (default) or parindent
\newif\ifqreport@parindent
\qreport@parindentfalse
\DeclareOption{parskip}{\qreport@parindentfalse}
\DeclareOption{parindent}{\qreport@parindenttrue}

% fullwidth = enable fullwidth environment and fullwidthfigure/fullwidthtable
\newif\ifqreport@fullwidth
\qreport@fullwidthfalse
\DeclareOption{fullwidth}{\qreport@fullwidthtrue}

% italic = section/subsection headings and captions in italic (default: bold/roman)
\newif\ifqreport@italic
\qreport@italicfalse
\DeclareOption{italic}{\qreport@italictrue}

% Unknown options -> pass through to article
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

\ProcessOptions\relax

% ------------------------------------------------------------------------------
% Base class
% ------------------------------------------------------------------------------

\LoadClass[12pt,a4paper]{article}

% ------------------------------------------------------------------------------
% Packages (layout and behaviour)
% ------------------------------------------------------------------------------

\RequirePackage{iftex}
\ifPDFTeX
  \RequirePackage[T1]{fontenc}%
  \RequirePackage[utf8]{inputenc}%
  \RequirePackage{lmodern}%
\fi

\RequirePackage{fix-cm}
\RequirePackage[a4paper,margin=3.0cm]{geometry}

% Float placement: relaxed to keep figures/tables near first reference
\renewcommand{\topfraction}{0.9}
\renewcommand{\bottomfraction}{0.7}
\renewcommand{\textfraction}{0.05}
\renewcommand{\floatpagefraction}{0.8}
\setcounter{topnumber}{4}
\setcounter{bottomnumber}{3}
\setcounter{totalnumber}{6}

\RequirePackage{graphicx}
\RequirePackage{amsmath,amsfonts,amssymb}
\RequirePackage[dvipsnames,svgnames]{xcolor}
\RequirePackage[tracking]{microtype}
\RequirePackage{setspace}
\ifqreport@justify
  \RequirePackage{ragged2e}% allow \RaggedRight locally
\else
  \RequirePackage[document]{ragged2e}% document-wide ragged-right
\fi
\RequirePackage{etoolbox}
\ifqreport@fullwidth
  \IfFileExists{changepage.sty}{%
    \RequirePackage[strict]{changepage}%
  }{%
    \IfFileExists{chngpage.sty}{%
      \RequirePackage[strict]{chngpage}%
    }{%
      \PackageWarning{qreport}{fullwidth option requires changepage or chngpage; fullwidth disabled}%
      \qreport@fullwidthfalse
    }%
  }%
\fi

% Citations: natbib with options matching class (harvard or numeric)
\ifqreport@cite@harvard
  \RequirePackage[authoryear,round,sort&compress,longnamesfirst]{natbib}%
  \bibpunct{(}{)}{;}{a}{,}{,}%
\else
  \RequirePackage[numbers,sort&compress,square]{natbib}%
  \bibpunct{[}{]}{,}{n}{,}{,}%
\fi

\RequirePackage{xurl}
\RequirePackage{hyperref}
\ifPDFTeX
  \RequirePackage[hyphenbreaks]{breakurl}%
\fi

\RequirePackage[font=small]{caption}
\setlength{\abovecaptionskip}{6pt}%
\setlength{\belowcaptionskip}{6pt}%
\ifqreport@italic
  \captionsetup{labelfont=it,textfont=it}%
\fi
\RequirePackage{textcomp}

% Font configuration (sans default, serif, hacker)
\ifPDFTeX
  \ifqreport@font@sans
    \RequirePackage[default]{sourcesanspro}%
    \RequirePackage{newtxmath}%
    \renewcommand{\familydefault}{\sfdefault}%
  \fi
  \ifqreport@font@serif
    \RequirePackage[default]{sourceserifpro}%
    \RequirePackage{newtxmath}%
  \fi
  \ifqreport@font@hacker
    \RequirePackage{inconsolata}%
    \RequirePackage{newtxmath}%
    \renewcommand{\familydefault}{\ttdefault}%
  \fi
\else
  \RequirePackage{fontspec}%
  \defaultfontfeatures{Ligatures=TeX}%
  \ifqreport@font@sans
    \IfFontExistsTF{Source Sans Pro}{%
      \setmainfont{Source Sans Pro}%
      \setsansfont{Source Sans Pro}%
      \IfFontExistsTF{Source Code Pro}{%
        \setmonofont{Source Code Pro}[Scale=MatchLowercase]%
      }{%
        \setmonofont{TeX Gyre Cursor}[Scale=MatchLowercase]%
      }%
    }{%
      \setmainfont{TeX Gyre Heros}%
      \setsansfont{TeX Gyre Heros}%
      \setmonofont{TeX Gyre Cursor}[Scale=MatchLowercase]%
    }%
  \fi
  \ifqreport@font@serif
    \IfFontExistsTF{Source Serif Pro}{%
      \setmainfont{Source Serif Pro}%
      \setsansfont{Source Sans Pro}[Scale=MatchLowercase]%
      \IfFontExistsTF{Source Code Pro}{%
        \setmonofont{Source Code Pro}[Scale=MatchLowercase]%
      }{%
        \setmonofont{TeX Gyre Cursor}[Scale=MatchLowercase]%
      }%
    }{%
      \setmainfont{TeX Gyre Termes}%
      \setsansfont{TeX Gyre Heros}[Scale=MatchLowercase]%
      \setmonofont{TeX Gyre Cursor}[Scale=MatchLowercase]%
    }%
  \fi
  \ifqreport@font@hacker
    \IfFontExistsTF{Inconsolata}{%
      \setmainfont{Inconsolata}%
      \setsansfont{Inconsolata}%
      \setmonofont{Inconsolata}%
    }{%
      \setmainfont{Fira Mono}%
      \setsansfont{Fira Mono}%
      \setmonofont{Fira Mono}%
    }%
  \fi
  \RequirePackage{unicode-math}%
  \setmathfont{Latin Modern Math}[Scale=MatchLowercase]%
\fi

% ------------------------------------------------------------------------------
% Layout defaults
% ------------------------------------------------------------------------------

\ifqreport@onehalfspacing
  \onehalfspacing
\else
  \ifqreport@linespread
    \linespread{\qreport@linespreadval}%
  \else
    \singlespacing
  \fi
\fi
\ifqreport@justify\else \RaggedRight\fi
\emergencystretch=3em

% Tight list style
\setlength{\leftmargini}{1pc}
\setlength{\leftmarginii}{1pc}
\setlength{\leftmarginiii}{1pc}
\setlength{\leftmarginiv}{1pc}
\setlength{\leftmarginv}{1pc}
\setlength{\leftmarginvi}{1pc}
\setlength{\labelsep}{0.5pc}
\setlength{\labelwidth}{\leftmargini}
\addtolength{\labelwidth}{-\labelsep}

% Quote environments: smaller type and indents
\renewenvironment{verse}
 {\let\\\@centercr
  \list{}{\itemsep \z@
  \itemindent -1pc%
  \listparindent\itemindent
  \rightmargin \leftmargin
  \advance\leftmargin 1pc}%
  \small%
  \item\relax}
 {\endlist}
\renewenvironment{quotation}
 {\list{}{\listparindent 1pc%
  \itemindent \listparindent
  \rightmargin \leftmargin
  \parsep \z@ \@plus\p@}%
  \small%
  \item\relax\noindent\ignorespaces}
 {\endlist}
\renewenvironment{quote}
 {\list{}{\rightmargin\leftmargin}%
  \small%
  \item\relax}
 {\endlist}

% Paragraph style: parskip (default) or parindent
\ifqreport@parindent
  \setlength{\parindent}{1em}%
  \setlength{\parskip}{0pt}%
  \setlength{\RaggedRightParindent}{1em}%
\else
  \RequirePackage{parskip}%
\fi

% Full-width content environments (extend into margin)
\newlength{\qreport@fullwidth@overhang}
\setlength{\qreport@fullwidth@overhang}{2cm}
\ifqreport@fullwidth
  \newenvironment{fullwidth}{%
    \begin{adjustwidth}{-\qreport@fullwidth@overhang}{-\qreport@fullwidth@overhang}%
  }{%
    \end{adjustwidth}%
  }
  \newenvironment{fullwidthfigure}[1][htbp]{%
    \begin{figure}[#1]%
    \begin{adjustwidth}{-\qreport@fullwidth@overhang}{-\qreport@fullwidth@overhang}%
    \centering
  }{%
    \end{adjustwidth}%
    \end{figure}%
  }
  \newenvironment{fullwidthtable}[1][htbp]{%
    \begin{table}[#1]%
    \begin{adjustwidth}{-\qreport@fullwidth@overhang}{-\qreport@fullwidth@overhang}%
    \centering
  }{%
    \end{adjustwidth}%
    \end{table}%
  }
\else
  \newenvironment{fullwidth}{\begingroup}{\endgroup}
\fi

% Newthought: letterspaced small caps at paragraph start
\newskip\qreport@newthoughtskip
\setlength{\qreport@newthoughtskip}{1.0\baselineskip plus 0.5ex minus 0.2ex}
\@ifundefined{textls}{%
  \newcommand{\newthought}[1]{\par\vspace{\qreport@newthoughtskip}\noindent\textsc{#1}}%
}{%
  \newcommand{\newthought}[1]{\par\vspace{\qreport@newthoughtskip}\noindent\textls[50]{\scshape #1}}%
}

% Math display spacing
\setlength{\abovedisplayskip}{6pt plus 2pt minus 4pt}%
\setlength{\belowdisplayskip}{6pt plus 2pt minus 4pt}%

% Footnote rule
\renewcommand{\footnoterule}{%
  \vspace*{4pt}%
  \hrule width 0.4\columnwidth height 0.4pt
  \vspace{4pt}%
}

% Microtype and hyperref setup
\AtBeginDocument{%
  \renewcommand{\footnotesize}{\small}%
}
\microtypesetup{final,protrusion=true,nopatch=footnote}%
\ifXeTeX\else \microtypesetup{expansion=true}\fi

\hypersetup{
  unicode=true,
  breaklinks=true,
  colorlinks=true,
  linkcolor=DarkBlue,
  citecolor=DarkGreen,
  urlcolor=DarkGreen,
  filecolor=DarkBlue,
  menucolor=DarkBlue
}
\let\qreport@orig@href\href
\renewcommand{\href}[2]{%
  \qreport@orig@href{#1}{{\color{DarkBlue}#2}}%
}
\def\UrlFont{\ttfamily\color{DarkGreen}}%

% Redirect bare \cite to \citep and emit a warning
\renewcommand{\cite}{%
  \PackageWarning{qreport}{Use \string\citep\space or \string\citet\space instead of \string\cite}%
  \citep
}

% ------------------------------------------------------------------------------
% Section/subsection headings (titlesec)
% ------------------------------------------------------------------------------

\RequirePackage{titlesec}%
\ifqreport@italic
  \titleformat{\section}[hang]{\normalfont\Large\itshape}{\thesection}{1em}{}%
  \titleformat{\subsection}[hang]{\normalfont\large\itshape}{\thesubsection}{1em}{}%
\else
  \titleformat{\section}[hang]{\normalfont\Large\bfseries}{\thesection}{1em}{}%
  \titleformat{\subsection}[hang]{\normalfont\large\bfseries}{\thesubsection}{1em}{}%
\fi
\titlespacing*{\section}{0pt}{3.5ex plus 1ex minus .2ex}{2.3ex plus .2ex}%
\titlespacing*{\subsection}{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}%

% First paragraph after section: no indent when parindent option is set
\ifqreport@parindent
  \let\qreport@orig@afterheading\@afterheading
  \renewcommand{\@afterheading}{%
    \qreport@orig@afterheading
    \noindent
  }
\fi

% ------------------------------------------------------------------------------
% Page style (section-based running heads)
% ------------------------------------------------------------------------------

\RequirePackage{fancyhdr}
\newlength{\qreport@headruleheight}
\setlength{\qreport@headruleheight}{0.4pt}
\setlength{\headheight}{14.5pt}

\fancypagestyle{plain}{%
  \fancyhf{}%
  \ifqreport@twoside
    \fancyhead[LE,RO]{\thepage}%
    \fancyhead[LO,RE]{\textls[50]{\scshape\leftmark}}%
  \else
    \fancyhead[L]{\textls[50]{\scshape\leftmark}}%
    \fancyhead[R]{\thepage}%
  \fi
  \renewcommand{\headrulewidth}{\qreport@headruleheight}%
}
\fancypagestyle{empty}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}

\pagestyle{plain}
\renewcommand{\sectionmark}[1]{\markboth{\ifnum\c@secnumdepth>\z@\thesection\ \fi#1}{}}
\renewcommand{\subsectionmark}[1]{\markright{\ifnum\c@secnumdepth>\m@ne\thesubsection\ \fi#1}}

% ------------------------------------------------------------------------------
% Abstract environment (optional)
% ------------------------------------------------------------------------------

\newif\ifqreport@haskeywords
\qreport@haskeywordsfalse
\newcommand{\qreport@keywords}{}%
\newcommand{\keywords}[1]{%
  \gdef\qreport@keywords{#1}%
  \ifstrempty{#1}{}{\qreport@haskeywordstrue}%
}

\renewenvironment{abstract}{%
  \par\vspace*{-\parskip}\vspace*{-\baselineskip}\noindent%
  \small
  \quotation
  \noindent\rule{\linewidth}{0.4pt}\par\vspace{0.1ex}\noindent%
}{%
  \ifqreport@haskeywords
    \par\vspace{0.25ex}\noindent\textbf{Keywords:}\ \qreport@keywords%
  \fi
  \par\vspace*{-\baselineskip}\vspace{1ex}%
  \noindent\rule{\linewidth}{0.4pt}%
  \endquotation
}

% ------------------------------------------------------------------------------
% Metadata and title block
% ------------------------------------------------------------------------------

\newcommand{\qreport@title}{}
\newcommand{\qreport@date}{\today}
\newcommand{\qreport@candidate}{}
\newcommand{\qreport@studentid}{}
\newcommand{\qreport@programme}{}
\newcommand{\qreport@institution}{Your University}
\newcommand{\qreport@school}{}
\newcommand{\qreport@supervisors}{}
\newcommand{\qreport@reporttype}{}
\newcommand{\qreport@reportperiod}{}

\renewcommand{\title}[1]{\gdef\qreport@title{#1}}
\renewcommand{\date}[1]{\gdef\qreport@date{#1}}

\newcommand{\candidate}[1]{\gdef\qreport@candidate{#1}}
\newcommand{\studentid}[1]{\gdef\qreport@studentid{#1}}
\newcommand{\programme}[1]{\gdef\qreport@programme{#1}}
\newcommand{\institution}[1]{\gdef\qreport@institution{#1}}
\newcommand{\school}[1]{\gdef\qreport@school{#1}}
\newcommand{\supervisors}[1]{\gdef\qreport@supervisors{#1}}
\newcommand{\reporttype}[1]{\gdef\qreport@reporttype{#1}}
\newcommand{\reportperiod}[1]{\gdef\qreport@reportperiod{#1}}

% Fallback: if \author is used instead of \candidate, treat it as the candidate name.
\renewcommand{\author}[1]{\gdef\qreport@candidate{#1}}

% Compact, article-style title block at top of first page.
\renewcommand{\maketitle}{%
  \par
  \begingroup
    \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
    \else
      \global\@topnum\z@
      \@maketitle
    \fi
    \thispagestyle{empty}%
  \endgroup
  \setcounter{footnote}{0}%
  \let\thanks\relax
  \let\maketitle\relax
  \let\@maketitle\relax
}

\def\@maketitle{%
  \begin{center}%
    {\LARGE\bfseries \qreport@title\par}%
    \vspace{0.5ex}%
    {\large
      \lineskip .5em
      \ifx\qreport@candidate\@empty
      \else
        \qreport@candidate\par
      \fi
    }%
    \vspace{0.5ex}%
    {\normalsize
      \ifx\qreport@programme\@empty\else \qreport@programme\par\fi
      \ifx\qreport@school\@empty
        \qreport@institution\par
      \else
        \qreport@school, \qreport@institution\par
      \fi
      \ifx\qreport@studentid\@empty\else Student ID: \qreport@studentid\par\fi
      \ifx\qreport@supervisors\@empty\else Supervisors: \qreport@supervisors\par\fi
      \ifx\qreport@reporttype\@empty\else \qreport@reporttype\par\fi
      \ifx\qreport@reportperiod\@empty\else Reporting period: \qreport@reportperiod\par\fi
      \qreport@date\par
    }%
    \vspace{0.5ex}%
  \end{center}%
}

% Convenience: \maketitlewithabstract{...} = title + abstract block
\newcommand{\maketitlewithabstract}[1]{%
  \maketitle
  \begin{abstract}
    #1%
  \end{abstract}
}

% ------------------------------------------------------------------------------
% Bibliography helper
% ------------------------------------------------------------------------------

\renewcommand{\bibname}{References}

\newcommand{\bib}[1]{%
  \ifqreport@cite@harvard
    \bibliographystyle{agsm}%
  \else
    \bibliographystyle{plainnat}%
  \fi
  \bibliography{#1}%
}

\makeatother


%版本设定
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{cvertbook}[2021/03/08 v0.0 Standard Chinese vertical document class]
\LoadClassWithOptions{book}


\RequirePackage{xeCJK}
\RequirePackage{ruby}
\RequirePackage[landscape, includeheadfoot]{geometry} 
\RequirePackage{zhnumber}
\RequirePackage{atbegshi}

% 边框使用的属性
\newlength{\myleft}
\newlength{\myright}
\newlength{\mytop}
\newlength{\mybottom}
\setlength{\myleft}{2cm}
\setlength{\myright}{2cm}
\setlength{\mytop}{3cm}
\addtolength{\mytop}{-0.25em}
\setlength{\mybottom}{3cm}
\addtolength{\mybottom}{0.25em}

\setlength{\topmargin}{0pt}
\setlength{\headheight}{1.7\baselineskip}
\setlength{\headsep}{0.3\baselineskip}
\setlength{\footskip}{2\baselineskip}

\newlength{\vertbookoffset}
\setlength{\vertbookoffset}{1cm}

% 设置竖排的装订线距离
\let\@@outputpage\@outputpage
\def\@outputpage{\expandafter\@oddgeometryeven\@@outputpage}
\def\@oddgeometryeven{%
  \ifodd\thepage
    \setlength{\voffset}{\vertbookoffset}
  \else
    \setlength{\voffset}{-\vertbookoffset}
\fi}

\geometry{
  left=\myleft,
  right=\myright,
  top=\mytop,
  bottom=\mybottom
}
\setlength{\parskip}{0pt}
%\parskip=0pt

% -- 基础的直排效果
\defaultCJKfontfeatures{RawFeature={vertical:+vert:+vhal}}
\setCJKmainfont{SimSun}

% 调整英文基线
\newcommand*\CJKmovesymbol[1]{\raise.25em\hbox{#1}}
\newcommand*\CJKmove{
  \punctstyle{plain}% do not modify the spacing between punctuations
  \let\CJKsymbol\CJKmovesymbol
  \let\CJKpunctsymbol\CJKsymbol}
\AtBeginDocument{\CJKmove \sloppy}
 
% 将纸张旋转90度
\AtBeginShipout{%
  \global\setbox\AtBeginShipoutBox\vbox{%
    \special{pdf: put @thispage <</Rotate 90>>}%
    \box\AtBeginShipoutBox
  }%
}%
% ------------------------------------------------


% -- 中文化编号

\RequirePackage{titlesec}
\RequirePackage{titletoc}%,everypage}
\renewcommand{\thepart}{\zhnum{part}}
\renewcommand{\thechapter}{\zhnum{chapter}}
\renewcommand{\thesection}{\zhnum{section}}
\renewcommand{\thesubsection}{\zhnum{subsection}}
\newcommand\zhpage{\zhnum{page}}

% 重写部标题部分
\renewcommand\part{%
  \if@openright \cleardoublepage
  \else \clearpage
  \fi
  \thispagestyle{empty}%
  \if@twocolumn
    \onecolumn
    \@tempswatrue
  \else
    \@tempswafalse
  \fi
  \null\vfil
  \secdef\@part\@spart
 }

\def\@part[#1]#2{%
  \ifnum \c@secnumdepth >-2\relax
    \refstepcounter{part}%
    \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
  \else
    \addcontentsline{toc}{part}{#1}%
  \fi
  \markboth{}{}%
  {
    \vfill
    \interlinepenalty \@M
    \normalfont
    \ifnum \c@secnumdepth >-2\relax
      \Huge%\bfseries \partname\nobreakspace
      {第\,}\thepart{\,部}
      \par
      \vskip 20\p@
    \fi
    \Huge #2
    \vskip 20\p@}%
    \@endpart}

\def\@spart#1{%
{
  \centering
  \interlinepenalty \@M
  \normalfont
  \Huge #1\par}%
  \@endpart
}

\def\@endpart{
  %\vfil
  \newpage
  \if@twoside
    \if@openright
      %\null
      \relax %\thispagestyle{empty}%\newpage
    \fi
  \fi
  \if@tempswa \twocolumn
  \fi
}




% --  usage
% \titleformat{ command }[ shape ]{ format }{ label }{ sep }{ before }[ after ]
% \titlespacing{ command }{ left }{ beforesep }{ aftersep }[ right ]
%----------------------------
\titleformat{\chapter}[hang]{\Huge\bfseries} 
{第\,\thechapter\,章} {2pc} {\thispagestyle{empty}}
\titlespacing{\chapter}{0pc}{*2}{*2}[5pc]                
%----------------------------
\titleformat{\section}[hang]{\Large\bfseries}
{第\,\thesection\,节}{2pc}{}
\titlespacing{\section}{5pc}{*2}{*2}[5pc]
%----------------------------
\titleformat{\subsection}[hang]{}
{\thesubsection\,}{1em}{}
\titlespacing{\subsection}{0pc}{*1}{*0}
%--------------------------------
% 中文目录

\titlecontents{chapter}[0em]{}    
{第\zhnum{\thecontentslabel}章~~}
{}{\hspace{1em}\titlerule{.}\thecontentspage}
\titlecontents{section}[4em]{}
{第\zhnum{\thecontentslabel}节~~}
{}{\titlerule*{.}\thecontentspage}
\titlecontents{subsection}[8em]{}
{第\zhnum{\thecontentslabel}小节~~}
{}{\titlerule*{.}\thecontentspage}

% -- 页眉页脚设置
\RequirePackage{fancyhdr}

\pagestyle{fancy}
\fancyhf{}%清空页眉页脚
\fancyhead[RE]{第\zhpage 页}%页码位置：偶数页居左，奇数页居右
\fancyhead[LE]{\thepart}%在偶数页显示\leftmark，通常为章标题
\fancyfoot[RO]{第\zhpage 页}%页码位置：偶数页居左，奇数页居右
\fancyfoot[LO]{\thepart}%在偶数页显示\leftmark，通常为章标题
\fancypagestyle{plain}{%重新定义plain样式，在章的首页使用plain样式
\fancyhf{}
\renewcommand\headrulewidth{0pt}
\renewcommand\footrulewidth{0pt}
}

\def\headrule{{
  \if@fancyplain
    \let\headrulewidth\plainheadrulewidth
  \fi%
  \ifodd\thepage\relax
  \else%
    \vskip 0.3em
    \hrule\@height 0.5pt \@width\headwidth
  \fi
}}

\def\footrule{{
  \if@fancyplain
    \let\footrulewidth\plainfootrulewidth
  \fi%
  \ifodd\thepage
    \hrule\@height 0.5pt \@width\headwidth
    \vskip -0.2em
  \fi
}}

\renewcommand{\contentsname}{\centering 目录}
\renewcommand\tableofcontents{%
 %\if@twocolumn
% \@restonecoltrue\onecolumn
 %\else
% \@restonecolfalse
% \fi
 \chapter*{\contentsname
 \@mkboth{%
 \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
 \@starttoc{toc}%
 %\if@restonecol\twocolumn\fi
\newpage
 }
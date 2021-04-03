% 版本设定
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{cvertbook}[2021/03/08 v0.0 Standard Chinese vertical document class]
\LoadClassWithOptions{book}

% 引用宏包
\RequirePackage[AutoFallBack]{xeCJK}
\RequirePackage{ruby}
\RequirePackage[landscape, includeheadfoot]{geometry} 
\RequirePackage{zhnumber}
\RequirePackage{atbegshi}
\RequirePackage{fancyhdr}
\RequirePackage{longtable}


% 边框使用的属性
\newlength{\myleft}
\newlength{\myright}
\newlength{\mytop}
\newlength{\mybottom}
\setlength{\myleft}{1.6cm}
\setlength{\myright}{1.6cm}
\setlength{\mytop}{1.56cm}
\addtolength{\mytop}{-0.3em}
\setlength{\mybottom}{1.56cm}
\addtolength{\mybottom}{0.27em}

\setlength{\topmargin}{0pt}
\setlength{\headheight}{1.7\baselineskip}
\setlength{\headsep}{0.3\baselineskip}
\setlength{\footskip}{2\baselineskip}

\geometry{
  left=\myleft,
  right=\myright,
  top=\mytop,
  bottom=\mybottom
}
\setlength{\parskip}{0pt}
\setlength{\parindent}{2em}


% 单双页偏移
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


% -- 基础的直排效果
\defaultCJKfontfeatures{RawFeature={vertical:+vert:+vhal}}
% 将纸张旋转90度
\AtBeginShipout{%
  \global\setbox\AtBeginShipoutBox\vbox{%
    \special{pdf: put @thispage <</Rotate 90>>}%
    \box\AtBeginShipoutBox
  }%
}%


% 调整英文基线与句读
\xeCJKDeclarePunctStyle{judou}
{
enabled-hanging = true
}

\punctstyle{plain}

\newif\if@judou
\@judoufalse
\newcommand\judou{\@judoutrue}
\newif\if@nopunct
\@nopunctfalse
\newcommand\nopunct{\@nopuncttrue}

\newcommand*\CJKmovesymbol[1]{\raise.25em\hbox{#1}}
\newcommand*\CJKmovepunctsymbol[1]{\raise.6em\hb@xt@\z@{\hss#1}}
\newcommand*\CJKnopunctsymbol[1]{\setbox0=\hb@xt@\z@{\hss#1}\null}  %也不知道為什麼總之這樣可以把標點都消滅
\newcommand*\CJKmove{
  \let\CJKsymbol\CJKmovesymbol
  \if@nopunct
    \let\CJKpunctsymbol\CJKnopunctsymbol
  \else
    \if@judou
      \xeCJKsetwidth{。，、}{\z@}
      \xeCJKsetwidth*{。，、}{\z@}
      \punctstyle{quanjiao}
      \let\CJKpunctsymbol\CJKmovepunctsymbol
    \else
      \let\CJKpunctsymbol\CJKsymbol
    \fi
  \fi
}

\AtBeginDocument{\CJKmove \sloppy}



% -- 中文化编号
\newif\if@inmain
\@inmainfalse
\newcommand\inmain{\@inmaintrue}
\setcounter{tocdepth}{0}
\setcounter{secnumdepth}{0}   %设置深度到0即可
\renewcommand{\thepart}{\zhnum{part}}
\renewcommand{\thechapter}{\zhnum{chapter}}
\renewcommand{\thesection}{\zhnum{section}}
\renewcommand{\thesubsection}{\zhnum{subsection}}
\newcommand\zhpage{\zhnum{page}}
%\newcommand\zhpage{\zhdigits*{\thepage}}
\let\sectionmark\@gobble      %取消section的mark

% -- 页眉页脚设置
\pagestyle{fancy}
\fancyhf{}%清空页眉页脚
\fancyhead[RE]{\zhpage}%
\fancyhead[LE]{\leftmark}%
\fancyfoot[RO]{\zhpage}%
\fancyfoot[LO]{\rightmark}%
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

% 重写所有片段标题
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
    \addcontentsline{toc}{part}{#1}%
  \else
    \addcontentsline{toc}{part}{#1}%
  \fi
  \markboth{\MakeUppercase #1}{\MakeUppercase #1}%
  {
  \vfill
  \interlinepenalty \@M
  \normalfont
  \Huge \hspace{2em} #2 \vskip 4em
  \@endpart
  }
}

\def\@spart#1{%
  {
  \vfill
  \interlinepenalty \@M
  \normalfont
  \Huge #1\par
  \@endpart
  }
}

\def\@endpart{
  \newpage
  \if@tempswa \twocolumn \fi
}

% 新命令，用于标记子部，例如史记中的本纪，在正文中没有什么效果，只是会标记页眉页脚并且在目录中添加一行
\newcommand\zibu[2][]{%
  \clearpage
  \markboth{\MakeUppercase #1#2}{\MakeUppercase #1#2}%
  \addcontentsline{toc}{part}{\hspace{1em}#2}%
}

% 重写章标题部分
\renewcommand\chapter{
  \if@inmain \newpage%\clearpage
  \else \clearpage
  \fi
  \global\@topnum\z@
  \@afterindentfalse
  \secdef\@chapter\@schapter
}

\def\@chapter[#1]#2{
  \ifnum \c@secnumdepth >\m@ne
    \if@mainmatter
      \refstepcounter{chapter}%
      \typeout{\@chapapp\space\thechapter.}%
      \addcontentsline{toc}{chapter}{\hspace{2em}#1}%
    \else
      \addcontentsline{toc}{chapter}{\hspace{2em}#1}%
    \fi
  \else
    \addcontentsline{toc}{chapter}{\hspace{2em}#1}%
  \fi
  \markright{\MakeUppercase #1}%\chaptermark{#1}%
  \addtocontents{lof}{\protect\addvspace{10\p@}}%
  \addtocontents{lot}{\protect\addvspace{10\p@}}%
  \@makechapterhead{#2}%  \@afterheading %无星号版本允许首段缩进
}

\def\@makechapterhead#1{%
  {
  \vspace*{\baselineskip}%
  \parindent \z@ \raggedright \normalfont
  \interlinepenalty\@M
  \normalsize #1\par\nobreak
  \vskip \baselineskip
  }
}

\def\@schapter#1{
  \@makeschapterhead{#1}% 
  \@afterheading
}

\def\@makeschapterhead#1{%
  {
  \vspace*{\baselineskip}%
  \parindent \z@ \raggedright \normalfont
  \interlinepenalty\@M
  \normalsize #1\par\nobreak
  \vskip \baselineskip
  }
}

% 定义节、小节、段、小段
\renewcommand\section{
  \@startsection{section}{1}{\z@}%
  {-\baselineskip}%
  {\baselineskip}%
  {\normalfont\normalsize}}

\renewcommand\subsection{
  \@startsection{subsection}{2}{\z@}%
  {\baselineskip}%
  {\z@}%
  {\normalfont\normalsize}}

\renewcommand\subsubsection{
  \@startsection{subsubsection}{3}{\z@}%
  {0pt}%
  {-1em}%
  {\normalfont\normalsize}}

\renewcommand\paragraph{
  \@startsection{paragraph}{4}{\z@}%
  {0pt}%
  {-1em}%
  {\normalfont\normalsize}}

\renewcommand\subparagraph{
  \@startsection{subparagraph}{5}{\parindent}%
  {0pt}%
  {-1em}%
  {\normalfont\normalsize}}



% -- 重新定义目录
\renewcommand{\contentsname}{目录}
\renewcommand\tableofcontents{%
  \setlength{\@tempdima}{\parindent}
  \setlength{\parindent}{\z@}
  \chapter*{\contentsname
  \@mkboth{%
  \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
  \@starttoc{toc}%
  \newpage
  \setlength{\parindent}{\@tempdima}
}

\def\@startsubtoc#1{
  \begingroup \makeatletter 
  \@input{\jobname.#1}
  \if@filesw 
    \expandafter\newwrite
    \csname tf@#1\endcsname 
    \immediate\openout
    \csname tf@#1\endcsname 
    \jobname.#1\relax 
  \fi 
  \@nobreakfalse 
  \endgroup
}

\newcommand{\tableofpartsname}{总目录}
\newcommand\tableofparts{%
  \chapter*{\tableofpartsname
  \@mkboth{%
  \MakeUppercase\tableofpartsname}{\MakeUppercase\tableofpartsname}}%
  \@startsubtoc{subtoc}%
  \newpage
}

% 目录的目录中的partname
\newcommand*\l@partname[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty{-\@highpenalty}%
    \begingroup
    \parindent \z@ \rightskip \@pnumwidth
    \parfillskip -\@pnumwidth
    {\leavevmode
    #1\hfil \hb@xt@\@pnumwidth{\hss \zhnumber{#2}}}\par
    \nobreak
    \global\@nobreaktrue
    \everypar{\global\@nobreakfalse\everypar{}}%
    \endgroup
  \fi
}

% 目录样式
\renewcommand*\l@part[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty{-\@highpenalty}%
    \begingroup
    \parindent \z@ \rightskip \@pnumwidth
    \parfillskip -\@pnumwidth
    {\leavevmode
    #1\hfil \hb@xt@\@pnumwidth{\hss \zhnumber{#2}}}\par
    \nobreak
    \global\@nobreaktrue
    \everypar{\global\@nobreakfalse\everypar{}}%
    \endgroup
  \fi
  \addcontentsline{subtoc}{partname}{#1}%
}

\renewcommand*\l@chapter[2]{%
  \ifnum \c@tocdepth >\m@ne
    %\addpenalty{-\@highpenalty}%
    \begingroup
    \parindent \z@ \rightskip \@pnumwidth
    %\parfillskip -\@pnumwidth
    {\leavevmode
    #1\nobreak\hfill \nobreak\hb@xt@\@pnumwidth{\hss \zhnumber{#2}}\par
    %\penalty\@highpenalty
    }
    \endgroup
  \fi
}

% 自定义一个字号
\newcommand\littlesize{\@setfontsize\littlesize\@viiipt\@xpt}

% 封装表格命令
\newcommand\biao[3][]{%
  \par
  {\littlesize%使用小字体
  \begin{center}
  \begin{longtable}{#2}%
    \endfirsthead
    #1
    \endhead
    #3
  \end{longtable}
  \end{center}}
  \par%还原字体
}

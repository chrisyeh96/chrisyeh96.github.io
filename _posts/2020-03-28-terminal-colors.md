---
title: Terminal Colors
layout: post
use_code: true
use_math: false
use_toc: true
excerpt: In this post, I explore how terminals display color, a two-stage process involving ANSI escape codes and user-defined color schemes.
tags: [unix]
---


## Overview

Terminals traditionally take an input of bytes and display them as white text on a black background. If the input contains specific "control characters," then the terminal may alter certain display properties of the text, such as the color or font. Old terminals could only display a maximum of 8 colors. However, modern computer screens are capable of displaying 24-bit RGB color, so modern terminals have to implement a mapping of the 8 original colors to RGB values. This mapping can usually be changed according to user-defined **color schemes**.


## ASCII Escape Character

The [ANSI ASCII standard](https://en.wikipedia.org/wiki/ASCII) represents the escape `ESC` character by the decimal number 27 (33 in octal, 1B in hexadecimal). This is one of the control characters (0-31 and 127), not one of the printable characters (32-126).

ASCII code 27 is indeed the character corresponding to the [Escape key](https://en.wikipedia.org/wiki/Esc_key) on a keyboard. However, most shells recognize the Escape key as a control character (usually for a keyboard shortcut) and therefore do not translate the Escape key into any text representation. Thus, each programming language has its own method of representing the escape character within a string:

| | [Bash](https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html) | [C](https://en.wikipedia.org/wiki/Escape_sequences_in_C) | [Python 3](https://docs.python.org/3/reference/lexical_analysis.html)
------------|----------------|---------------------|-------------------------------------------------------------------
literal     | `\e`, `\E`     | `\e` (non-standard) | Python 3.3+ only: `\N{ESCAPE}`, `\N{escape}`, `\N{ESC}`, `\N{esc}`
octal       | `\033`         | `\33`, `\033`       | `\33`, `\033`
hexadecimal | `\x1b`         | `\x1b`              | `\x1b`
Unicode     | `\u1b`, `\U1b` | --                  | `\u001b`, `\U0000001b`

Additional notes
- For all 3 languages, any place where `1b` appears, the capitalized hexadecimal `1B` also works.
- Bash supports Unicode characters of the form `\uXXXX` (`\u` + 4 hexadecimal digits) and `\UXXXXXXXX` (`\U` + 8 hexadecimal digits), but unlike Python, it allows for leading zeros to be omitted.
- Most major C compilers, including [gcc](https://gcc.gnu.org/onlinedocs/gcc/Character-Escapes.html) and [clang](https://clang.llvm.org/doxygen/LiteralSupport_8cpp_source.html#l00116), support the non-standard `\e` syntax for the escape character.
- While C generally supports unicode characters of the form `\uXXXX` and `\UXXXXXXXX`, it oddly does not support Unicode *control characters*. From the [C18 specification](https://web.archive.org/web/20181230041359if_/http://www.open-std.org/jtc1/sc22/wg14/www/abq/c17_updated_proposed_fdis.pdf) on universal character names:
    > A universal character name shall not specify a character whose short identifier is less than 00A0 other than 0024 ($), 0040 (@), or 0060 (‘)


## ANSI Escape Codes for Terminal Graphics

The [ANSI escape code standard](https://en.wikipedia.org/wiki/ANSI_escape_code), formally adopted as [ISO/IEC 6429](https://www.ecma-international.org/publications/standards/Ecma-048.htm), defines a series of **control sequences**. Each control sequence begins with a **Control Sequence Inducer** (CSI), defined as an escape character followed immediately by a bracket: `ESC[`. In particular, a CSI followed by a certain number of "parameter bytes" (ASCII `0–9:;<=>?`) then the letter `m` forms a control sequence known as a **Select Graphic Rendition** (SGR). If no parameter bytes are explicitly given, then it is assumed to be `0`. SGR parameters can be chained together with a semicolon `;` as the delimiter.

Some common SGR parameters are shown below:

Parameter    | Effect
-------------|--------------------------------------------
`0`          | reset all SGR effects to their default
`1`          | bold or increased intensity
`2`          | faint or decreased intensity
`4`          | singly underlined
`5`          | slow blink
`30-37`      | foreground color (8 colors)
`38;5;x`     | foreground color (256 colors, non-standard)
`38;2;r;g;b` | foreground color (RGB, non-standard)
`40-47`      | background color (8 colors)
`48;5;x`     | background color (256 colors, non-standard)
`48;2;r;g;b` | background color (RGB, non-standard)
`90-97`      | bright foreground color (non-standard)
`100-107`    | bright background color (non-standard)

The 8 actual colors within the ranges (30-37, 40-47, 90-97, 100-107) are defined by the ANSI standard as follows:

Last Digit | Color
-----------|--------
0          | black
1          | red
2          | green
3          | yellow
4          | blue
5          | magenta
6          | cyan
7          | white

We put these pieces together to create a SGR command. Thus, `ESC[1m` specifies bold (or bright) text, and `ESC[31m` specifies red foreground text. We can chain together parameters; for example, `ESC[32;47m` specifies green foreground text on a white background.

The following diagram shows a complete example for rendering the word "text" in red with a single underline.

<svg xmlns="http://www.w3.org/2000/svg" class="center-block" width="400px" height="160px">
  <rect fill="white" stroke-width="2" />
  <text font-family="Courier New" font-size="14" y="20">
    <tspan fill="#32afff" dx="55">CSI</tspan>
    <tspan fill="#ef2929" dx="125">Final Byte</tspan>
  </text>
  <polyline stroke="#32afff" fill="none" stroke-width="3" points="2,40 2,30 135,30 135,40" />
  <polyline stroke="#ef2929" fill="none" stroke-width="3" points="245,40 245,30 270,30 270,40" />
  <text font-family="Courier New" font-size="45" y="80">
    <tspan fill="#ad7fa8">\x1b</tspan><!--
 --><tspan fill="#32afff">[</tspan><!--
 --><tspan fill="#4e9a06">31;4</tspan><!--
 --><tspan fill="#ef2929">m</tspan><!--
 --><tspan>text</tspan>
  </text>
  <polyline stroke="#ad7fa8" fill="none" stroke-width="3" points="2,90 2,100 110,100 110,90" />
  <polyline stroke="#4e9a06" fill="none" stroke-width="3" points="140,90 140,100 240,100 240,90" />
  <text font-family="Courier New" font-size="14" y="120">
    <tspan fill="#ad7fa8">ESC character</tspan>
    <tspan fill="#ad7fa8" x="3" dy="20">in Hex ASCII</tspan>
    <tspan fill="#4e9a06" dx="35" dy="-20">Parameters</tspan>
  </text>
</svg>

Notes
- For terminals that support bright foreground colors, `ESC[1;3Xm` is usually equivalent to `ESC[9Xm` (where `X` is a digit in 0-7). However, the reverse does not seem to hold, at least anecdotally: `ESC[2;9Xm` usually does not render the same as `ESC[3Xm`.
- Not all terminals support every effect.
- Documentation is available for Microsoft [Windows Console](https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences) and [Linux](http://man7.org/linux/man-pages/man4/console_codes.4.html).
- Microsoft and the Linux manual pages both refer to SGR as "Set Graphics Rendition," instead of "Select Graphic Rendition."

**Examples**
- Bash: `printf "\u1b[31mtest\033[ming\n"`
- C: `printf("%s\n", "\x1b[31mtest\033[0ming");`
- Python: `print('\N{ESC}[31mtest\u001b[0ming')`
- Output: <code><span style="color: red">test</span>ing</code>

Additional Sources
- [Colors In Terminal](http://jafrog.com/2013/11/23/colors-in-terminal.html): describes control sequences at a high level and covers 256-color support
- [ANSI Escape sequences](http://ascii-table.com/ansi-escape-sequences.php): easy-to-read chart of control sequences


## Color Schemes

The role of terminal color schemes is to map the 8 colors to RGB values. Most terminals support an additional 8 colors corresponding to the bold or bright variants of the original colors. The GitHub repo [ mbadolato/iTerm2-Color-Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes) provides a sampling of common color schemes.


## Windows Colors

While the 8 standard color names are widely used within ANSI and ISO standards documents as well as the Linux community, Microsoft uses slightly different names and ordering of colors.

**Windows Console (Command Prompt)**

The command `color` sets the default console foreground and background colors, and it can also be used to list out the supported colors with `color /?`. The colors are named as follows:
```
0 = Black       8 = Gray
1 = Blue        9 = Light Blue
2 = Green       A = Light Green
3 = Aqua        B = Light Aqua
4 = Red         C = Light Red
5 = Purple      D = Light Purple
6 = Yellow      E = Light Yellow
7 = White       F = Bright White
```
Notably, Microsoft renames "cyan" to "aqua" and "magenta" to "purple," and it names the bold/bright variant of black as "gray." This ordering is also the ordering of colors that appear in the Windows Console settings.

![Windows Console color settings]({{ site.baseurl }}/images/2020_03_28_windows_console_colors.png)


**Windows Terminal (beta)**

[Windows Terminal](https://github.com/microsoft/terminal) now uses the ANSI color names except that it still uses "purple" instead of "magenta." However, there is an [open issue](https://github.com/microsoft/terminal/issues/2641) (as of March 28, 2020) where Microsoft seems to be considering "magenta."


## My Preferred Color Scheme

Personally, here is the color scheme that I've found to work well for me. It is largely based on [Ubuntu's default terminal color scheme](https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/windowsterminal/Ubuntu.json) (changes are marked by an asterisk *).

Color                                                      | RGB             | Hexadecimal
-----------------------------------------------------------|-----------------|------------
<span style='color:#000000;'>&#9632;</span> black*         |   `0,   0,   0` | `000000`
<span style='color:#cc0000;'>&#9632;</span> red            | `204,   0,   0` | `cc0000`
<span style='color:#4e9a06;'>&#9632;</span> green          |  `78, 154,   6` | `4e9a06`
<span style='color:#c4a000;'>&#9632;</span> yellow         | `196, 160,   0` | `c4a000`
<span style='color:#729fcf;'>&#9632;</span> blue*          | `114, 159, 207` | `729fcf`
<span style='color:#75507b;'>&#9632;</span> magenta        | `117,  80, 123` | `75507b`
<span style='color:#06989a;'>&#9632;</span> cyan           |   `6, 152, 154` | `06989a`
<span style='color:#d3d7cf;'>&#9632;</span> white          | `211, 215, 207` | `d3d7cf`
<span style='color:#555753;'>&#9632;</span> bright black   |  `85,  87,  83` | `555753`
<span style='color:#ef2929;'>&#9632;</span> bright red     | `239,  41,  41` | `ef2929`
<span style='color:#8ae234;'>&#9632;</span> bright green   | `138, 226,  52` | `8ae234`
<span style='color:#fce94f;'>&#9632;</span> bright yellow  | `252, 233,  79` | `fce94f`
<span style='color:#32afff;'>&#9632;</span> bright blue*   |  `50, 175, 255` | `32afff`
<span style='color:#ad7fa8;'>&#9632;</span> bright magenta | `173, 127, 168` | `ad7fa8`
<span style='color:#34e2e2;'>&#9632;</span> bright cyan    |  `52, 226, 226` | `34e2e2`
<span style='color:#ffffff;'>&#9632;</span> bright white*  | `255, 255, 255` | `ffffff`

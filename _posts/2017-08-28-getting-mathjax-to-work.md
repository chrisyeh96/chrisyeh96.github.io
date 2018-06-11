---
title: Getting MathJax to Work
layout: post
use_code: true
use_toc: true
excerpt: Re-formatting a LaTeX document for use as a blog post took more work than expected. MathJax only supports the LaTeX math-mode commands, and there are additional formatting considerations as well. Here are some tools that I found to make the transition easier.
---

## Converting LaTeX to Markdown/MathJax:

1. Replace all `\textbf{abc}` with `**abc**`, and similarly for italics
- Find What: `\\textbf{([^}]+)}`
- Replace With: `**$1**`

2. Replace `\begin{enumerate} ... \end{enumerate}` with actual numbering

3. Replace `\href{link}{text}` with `[text](link)`
- Find What: `\\href{(.+)}{(.+)}`
- Replace With: `\[$2\]\($1\)`

4. Make sure all `$$ ... $$` equations have a newline above and below. This prevents these equations from being treated as inline equations.

5. Replace all `$ ... $` with `$$ ... $$`. (This assumes that single dollar signs have not been configured as delimiters for inline math.)
- Find What: `([^$])\$([^$]+)\$([^$])`
- Replace With: `$1\$\$$2\$\$$3`

6. Surround all LaTeX math-mode blocks (such as `\begin{align} ... \end{align}`) with `$$ ... $$`. This apparently tells the kramdown processor to avoid treating underscores `_` within math equations as italics.

## MathJax Configuration Options

MathJax can be configured to enable optional behavior, including automatic line breaks and support for additional inline math delimiters. These are options that I have played with, but I am wary of their drawbacks and therefore have decided to hold off on enabling them. The automatic line breaks do not account for equation formatting, so they tend to be ugly. Also, using single dollar signs for inline math would require escaping normal dollar signs when writing about currency. However, I am including the following code block for future reference, should I decide to enable these options. The code block would need to come *before* the `<script>` tag that links to the actual MathJax `.js` file.

```html
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    // enable automatic line breaks (might look ugly)
    CommonHTML: { linebreaks: { automatic: true } },
    "HTML-CSS": { linebreaks: { automatic: true } },
    SVG: { linebreaks: { automatic: true } },

    // enable $ for inline math -> use \$ for ordinary dollar-sign
    tex2jax: {
      inlineMath: [['$','$'], ['\\(','\\)']],
      processEscapes: true
    },
  });
</script>
```

Additionally, MathJax's accessibility extension [MathJax-a11y](https://mathjax.github.io/MathJax-a11y/) is supposed to support "smart" auto-collapsing equations. I tried to follow the [documentation](https://mathjax.github.io/MathJax-a11y/docs/) but was unsuccessful.

## Other Resources

[Supported LaTeX Commands in MathJax](http://docs.mathjax.org/en/latest/tex.html)

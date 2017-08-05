---
title: How I Setup Jekyll on GitHub Pages
layout: default
---

# How GitHub Pages Works

The User Pages default domain and host location (repository name) on GitHub is `username.github.io`. User Pages are automatically served over HTTPS from the `master` branch.

As far as I can tell, Jekyll is already enabled by default. In other words, there is no setting that you have to "turn on" in order to get Jekyll to start working on GitHub Pages. Simply by following the directory structure that Jekyll requires will result in the site getting built by Jekyll.

# My Setup

I initially selected the `Cayman` theme as I found it the most pleasing among the different themes that are "officially supported" by GitHub Pages. However, it doesn't come with any sort of navigation bar, so I found the `Cayman Blog` theme which does.

The problem is that `Cayman` and `Cayman Blog` do not use Bootstrap: in fact, they define CSS rules that occasionally conflict with Bootstrap. Consequently, I quit using any pre-defined theme and just used Bootstrap 4 (alpha v6) myself.

# Syntax Highlighting

Getting syntax highlighting to work required 3 steps.
1. Add `highlighter: rouge` to `_config.yml`
2. Add `rouge-github.css` to the `/css/` folder. I copied it over from the `Cayman` theme [repo](https://github.com/pages-themes/cayman/blob/master/_sass/rouge-github.scss), which is allowed per its CC0 license.
3. Include the `rouge-github.css` stylesheet in the `default.html` layout.

To avoid unnecessarily downloading this extra syntax-highlighting CSS on pages without code, I require that any page with code on it to set `use_code: true` in its front matter.

# MathJaX

Displaying LaTeX equations using MathJaX is surprisingly easy. The only necessary step is to link to the MathJaX JavaScript file.

To avoid unnecessarily downloading this extra JS file on pages without math formulas, I require that any page with math formulas on it to set `use_math: true` in its front matter.
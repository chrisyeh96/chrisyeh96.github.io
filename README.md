# Install Jekyll

I find it easiest to use the conda package manager to install the `github-pages` ruby gem, which contains the set of gems (including Jekyll) used by GitHub Pages itself to compile each site. There are two options:

**1. Directly use conda install the compiled `github-pages` gem.**

Assuming conda is installed, use the following commands to install Jekyll and the `github-pages` gem:

```bash
conda env update -f env.yml --prune
conda activate gh-pages
```

Note that conda-forge may not have the most up-to-date version of the `github-pages` gem ([link](https://anaconda.org/conda-forge/rb-github-pages)), but it should work fine.

**2. Use conda to install ruby, then use ruby to install the `github-pages` gem.**

If it is absolutely necessary to use the latest version of the `github-pages` gem, run the following commands:

```bash
conda env update -f env_ruby.yml --prune
conda activate ruby

gem install github-pages
```

This should just work. In case it doesn't, try the following commands and then try installing the `github-pages` gem again:

```bash
sudo apt update  # update package index
sudo apt upgrade build-essential  # compilation tools
```


# Build

**Build locally**: `jekyll build [options]`

**Serve locally**: `jekyll serve [options]`

Options
- `--baseurl /~chrisyeh`: add this if hosting this site at some non-root domain (e.g., `*.com/~chrisyeh`)
- `--drafts`: to show drafts among the latest posts

# Page Frontmatter Options

Variable            | Description
--------------------|------------
`excerpt`           | text to show on blog list and at top of post
`last_updated`      | date in `YYYY-MM-DD` format
`layout`            | name of layout from `_layout/` folder
`title`             | title of post
`use_code`          | boolean, set to `true` to include code-highlighting CSS
`use_fontawesome`   | boolean, set to `true` to include FontAwesome CSS
`use_math`          | boolean, set to `true` to include MathJax JS
`use_toc`           | boolean, set to `true` to include a table of contents

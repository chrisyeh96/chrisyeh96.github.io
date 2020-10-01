# Install Jekyll

Assuming conda is installed, use the following commands to install Jekyll and the `github-pages` gem:

```bash
conda env create -f env.yml
conda activate gh-pages
```

Note that conda-forge may not have the most up-to-date version of the `github-pages` gem, but it should work fine.


# Build

**Build locally**: `jekyll build [options]`

**Serve locally**: `jekyll serve [options]`

Options
- `--baseurl /~chrisyeh`: add this if hosting this site at some non-root domain (e.g., `*.com/~chrisyeh`)
- `--drafts`: to show drafts among the latest posts

# Page Frontmatter Options

Variable            | Description
--------------------|------------
`excerpt`           | Text to show on blog list and at top of post
`last_updated`      | Date in `YYYY-MM-DD` format
`layout`            | Name of layout from `_layout/` folder
`title`             | Title of post
`use_code`          | Boolean, set to `true` to include code-highlighting CSS
`use_fontawesome`   | Boolean, set to `true` to include FontAwesome CSS
`use_math`          | Boolean, set to `true` to include MathJax JS
`use_toc`           | Boolean, set to `true` to include a table of contents

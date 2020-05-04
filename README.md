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

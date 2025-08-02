# Install Jekyll

I find it best to use the conda package manager to install ruby, then use ruby to install the `github-pages` gem, which contains the set of gems (including Jekyll) used by GitHub Pages itself to compile each site. If conda is not already installed, [install conda first](https://docs.conda.io/en/latest/miniconda.html).

To install/update to the latest version of the `github-pages` gem, run the following commands:

```bash
conda env update -f env_ruby.yml --prune
conda activate ruby

# Install/update to the latest version of github-pages gem
# (but don't install unnecessary documentation).
# Then cleanup old versions of installed gems.
gem install github-pages --no-document
gem cleanup
```

If the `gem install github-pages` command causes an error, try the following commands and then try installing the `github-pages` gem again:

- On Ubuntu or Debian-based systems:

   ```bash
   # for Ubuntu
   sudo apt update  # update package index
   sudo apt upgrade build-essential  # compilation tools
   ```

- On macOS: you may need to install Xcode from the App Store.


# Build

**Build locally**: `jekyll build [options]`

**Serve locally**: `jekyll serve [options]`

Options
- `--baseurl /~chrisyeh`: add this if hosting this site at some non-root domain (e.g., `*.com/~chrisyeh`)
- `--drafts`: to show drafts among the latest posts
- `--force_polling`: use this when running Jekyll on WSL to enable auto-regeneration.


# Page Frontmatter Options

Variable            | Description
--------------------|------------
`excerpt`           | text to show on blog list and at top of post
`last_updated`      | date in `YYYY-MM-DD` format
`layout`            | name of layout from `_layout/` folder
`tags`              | list of tags, e.g., `[ML, math]`
`title`             | title of post
`use_code`          | boolean, set to `true` to include code-highlighting CSS
`use_fontawesome`   | boolean, set to `true` to include FontAwesome CSS
`use_math`          | boolean, set to `true` to include MathJax JS
`use_toc`           | boolean, set to `true` to include a table of contents

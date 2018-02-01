# chrisyeh
Personal website

Live websites at [https://chrisyeh96.github.io/](https://chrisyeh96.github.io/) and [https://stanford.edu/~chrisyeh](https://stanford.edu/~chrisyeh).

**Build Locally**

- GitHub Pages: `jekyll build`
- Stanford: `jekyll build --baseurl /~chrisyeh`

**Run Locally**

`jekyll serve --baseurl /~chrisyeh`

Add `--drafts` to show drafts as the latest posts.

We need the `baseurl` parameter for Stanford because the live website is not at the root domain. However, we don't include `baseurl` in the `_config.yml` file so that [https://chrisyeh96.github.io/](https://chrisyeh96.github.io/) also works.

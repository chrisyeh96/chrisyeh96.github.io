---
title: Blog
layout: post
use_code: true
use_math: true
permalink: /blog/
---

Posts below are sorted by date published. Alternatively, explore posts by [tags](../tags/).

<ul class="post-list">
{%- for post in site.posts -%}
  {% include post_list_item.html %}
{%- endfor -%}
</ul>
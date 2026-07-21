---
title: News
permalink: /news
layout: post
use_fontawesome: true
---

<ul class="post-list">
{%- for news_item in site.data.news -%}
{% include news_item.html %}
{%- endfor -%}
</ul>
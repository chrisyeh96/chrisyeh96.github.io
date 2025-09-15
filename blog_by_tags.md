---
title: Blog
permalink: /tags/
layout: post
nav_hidden: true
use_code: true
use_fontawesome: true
use_math: true
---

{%- assign sorted_tags = site.tags | sort -%}

## Tags

<p>
{%- for tag in sorted_tags -%}
  <a href="#{{ tag[0] }}" class="post-tag"><i class="fas fa-tag"></i> {{ tag[0] }}</a>
{%- endfor -%}
</p>

<hr>

{%- for tag in sorted_tags -%}
  <a name="{{ tag[0] }}" class="post-tag"><i class="fas fa-tag"></i> {{ tag[0] }}</a>
  <ul class="post-list">
    {%- for post in tag[1] -%}
    {% include post_list_item.html %}
    {%- endfor -%}
  </ul>
{%- endfor -%}
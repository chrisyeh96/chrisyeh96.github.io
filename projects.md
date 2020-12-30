---
title: Projects
layout: post
use_fontawesome: true
categories:
  - research
  - project
---

This page highlights several of my research and personal projects. For a complete list of my publications, see my [publications page](./publications.html).

{% for category in page.categories %}
  <div class="border-bottom">
  <h1 class="section-title">{{ category | capitalize }}</h1>
  {%- for project in site.data.projects -%}
    {%- if project.category != category -%}{% continue %}{%- endif -%}
    {%- if project.hidden -%}{%- continue -%}{%- endif -%}
    {% include project.html %}
  {%- endfor -%}
  </div>
{%- endfor -%}
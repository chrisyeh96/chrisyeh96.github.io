---
title: Projects
layout: post
use_fontawesome: true
categories:
  - research
  - project
---

This page highlights several of my research and personal projects. For a complete list of my publications, see my [publications page](./publications.html).

{%- assign project_counter = 0 -%}
{%- comment -%}
  I'm not sure why, but we need to use % instead of %- for this for loop. Otherwise, the <div> tag is escaped for no apparent reason.
{%- endcomment -%}
{% for category in page.categories %}
<div class="border-bottom">
<h1 class="section-title">{{ category | capitalize }}</h1>
  {%- for project in site.data.projects -%}
    {%- if project.category != category -%}{% continue %}{%- endif -%}
    {%- if project.hidden -%}{%- continue -%}{%- endif -%}
    {% include project.html project_counter=project_counter %}
    {%- assign project_counter = project_counter | plus: 1 -%}
  {%- endfor -%}
</div>
{% endfor %}

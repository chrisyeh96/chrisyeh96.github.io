---
title: Projects
layout: post
use_fontawesome: true
categories:
  - research
  - project
---

This page highlights several of my research and personal projects. For a complete list of my publications, see my [publications page](./publications.html).

{%- comment -%}
  I'm not sure why, but we need to use % instead of %- for the first liquid command. Otherwise, the <div> tag is escaped for no apparent reason.
{%- endcomment -%}
{% assign project_counter = 0 %}
<div class="border-bottom mb-3">
  {%- for project in site.data.projects -%}
    {%- if project.category == "archive" -%}{% continue %}{%- endif -%}
    {%- if project.hidden -%}{%- continue -%}{%- endif -%}
    {% include project.html project_counter=project_counter %}
    {%- assign project_counter = project_counter | plus: 1 -%}
  {%- endfor -%}
</div>

# Archive

{% for project in site.data.projects %}
  {%- if project.category == "archive" -%}
  {%- if project.hidden -%}{%- continue -%}{%- endif -%}
  {% include project.html project_counter=project_counter %}
  {%- assign project_counter = project_counter | plus: 1 -%}
  {%- endif -%}
{%- endfor -%}

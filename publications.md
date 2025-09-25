---
title: Publications
layout: post
use_fontawesome: true
---

{% capture newLine %}
{% endcapture %}

{%- comment -%}
<!-- embed Altmetric badge -->
<script type="text/javascript" src="https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js"></script>
{%- endcomment -%}

_* denotes equal contribution_. Papers are organized by category and sorted by reverse chronological order. For a reverse chronological list of publications without categorization, [click here](./publications_chronological/).

# Working manuscripts and preprints

<ol reversed>
{%- assign counter = 0 -%}
{%- for pub in site.data.publications -%}
  {%- if pub.hidden -%}{%- continue -%}{%- endif -%}
  {%- if pub.venue_type == "preprint" -%}
  {% include publication_item.html pub=pub counter=counter %}
  {%- assign counter = counter | plus: 1 -%}
  {%- endif -%}
{%- endfor -%}
</ol>

# Journal publications

<ol reversed>
{%- assign counter = 0 -%}
{%- for pub in site.data.publications -%}
  {%- if pub.hidden -%}{%- continue -%}{%- endif -%}
  {%- if pub.venue_type == "journal" -%}
  {% include publication_item.html pub=pub counter=counter %}
  {%- assign counter = counter | plus: 1 -%}
  {%- endif -%}
{%- endfor -%}
</ol>

# Conference publications

<ol reversed>
{%- assign counter = 0 -%}
{%- for pub in site.data.publications -%}
  {%- if pub.hidden -%}{%- continue -%}{%- endif -%}
  {%- if pub.venue_type == "conference" -%}
  {% include publication_item.html pub=pub counter=counter %}
  {%- assign counter = counter | plus: 1 -%}
  {%- endif -%}
{%- endfor -%}
</ol>

# Workshop publications

<ol reversed>
{%- assign counter = 0 -%}
{%- for pub in site.data.publications -%}
  {%- if pub.hidden -%}{%- continue -%}{%- endif -%}
  {%- if pub.venue_type == "workshop" -%}
  {% include publication_item.html pub=pub counter=counter %}
  {%- assign counter = counter | plus: 1 -%}
  {%- endif -%}
{%- endfor -%}
</ol>

# Other non-refereed publications

<ol reversed>
{%- assign counter = 0 -%}
{%- for pub in site.data.publications -%}
  {%- if pub.hidden -%}{%- continue -%}{%- endif -%}
  {%- if pub.venue_type == "other" -%}
  {% include publication_item.html pub=pub counter=counter %}
  {%- assign counter = counter | plus: 1 -%}
  {%- endif -%}
{%- endfor -%}
</ol>
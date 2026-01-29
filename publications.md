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

{%- assign counter = 0 -%}

{%- assign preprints = site.data.publications
  | where_exp: "pub", "pub.hidden != true"
  | where: "venue_type", "preprint"
-%}
{%- assign num_preprints = preprints | size -%}
{% if num_preprints > 0 %}
# Working manuscripts and preprints

<ol reversed>
{%- for pub in preprints -%}
  {% include publication_item.html pub=pub counter=counter %}
  {%- assign counter = counter | plus: 1 -%}
{%- endfor -%}
</ol>
{% endif %}

# Journal publications

<ol reversed>
{%- for pub in site.data.publications -%}
  {%- if pub.venue_type == "journal" and pub.hidden != true -%}
  {% include publication_item.html pub=pub counter=counter %}
  {%- assign counter = counter | plus: 1 -%}
  {%- endif -%}
{%- endfor -%}
</ol>

# Conference publications

<ol reversed>
{%- for pub in site.data.publications -%}
  {%- if pub.venue_type == "conference" and pub.hidden != true -%}
  {% include publication_item.html pub=pub counter=counter %}
  {%- assign counter = counter | plus: 1 -%}
  {%- endif -%}
{%- endfor -%}
</ol>

# Workshop publications

<ol reversed>
{%- for pub in site.data.publications -%}
  {%- if pub.venue_type == "workshop" and pub.hidden != true -%}
  {% include publication_item.html pub=pub counter=counter %}
  {%- assign counter = counter | plus: 1 -%}
  {%- endif -%}
{%- endfor -%}
</ol>

# Other non-refereed publications

<ol reversed>
{%- for pub in site.data.publications -%}
  {%- if pub.venue_type == "other" and pub.hidden != true -%}
  {% include publication_item.html pub=pub counter=counter %}
  {%- assign counter = counter | plus: 1 -%}
  {%- endif -%}
{%- endfor -%}
</ol>
---
title: Publications
layout: post
nav_hidden: true
use_fontawesome: true
---

{% capture newLine %}
{% endcapture %}

{%- comment -%}
<!-- embed Altmetric badge -->
<script type="text/javascript" src="https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js"></script>
{%- endcomment -%}

_* denotes equal contribution_

<ol reversed>
{%- assign counter = 0 -%}
{%- for pub in site.data.publications -%}
  {%- if pub.hidden -%}{%- continue -%}{%- endif -%}
  {% include publication_item.html pub=pub counter=counter %}
  {%- assign counter = counter | plus: 1 -%}
{%- endfor -%}
</ol>
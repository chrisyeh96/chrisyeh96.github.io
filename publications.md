---
title: Publications
layout: post
use_fontawesome: true
---

{% capture newLine %}
{% endcapture %}

<!-- embed Altmetric badge -->
<script type="text/javascript" src="https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js"></script>

_* denotes equal contribution_

<ol reversed>
{%- assign counter = 0 -%}
{%- for pub in site.data.publications -%}
  {%- if pub.hidden -%}{%- continue -%}{%- endif -%}
  <li>
  <div>
    {%- comment -%}
    {%- if pub.altmetric_id -%}
      <div class="altmetric-embed float-end" data-badge-type="donut" data-altmetric-id="{{ pub.altmetric_id }}"></div>
    {%- endif -%}
    {%- endcomment -%}
    {{ pub.formatted | markdownify }}
  </div>
  <p>
  {%- for media in pub.media -%}
    <a href="{{ media.url }}" class="post-meta post-tag me-2">
      {%- if media.type == "pdf" -%}<i class="fas fa-file">
      {%- elsif media.type == "github" -%}<i class="fab fa-github">
      {%- elsif media.type == "code" -%}<i class="fas fa-code">
      {%- elsif media.type == "youtube" -%}<i class="fab fa-youtube">
      {%- elsif media.type == "video" -%}<i class="fas fa-play-circle">
      {%- else -%}<i class="fas fa-external-link-alt">
      {%- endif -%}
      </i> {{ media.name }}
    </a>
  {%- endfor -%}
  <a href="#citation{{ counter }}" class="post-meta post-tag" data-bs-toggle="collapse">Cite</a>
  </p>
  <div id="citation{{ counter }}" class="collapse">
    {{ pub.citation | prepend: "> " | markdownify }}
    {%- assign bibtex_code = pub.bibtex | append: "```" | prepend: newLine | prepend: "```bibtex" -%}
    {{ bibtex_code | markdownify }}
  </div>
  </li>
  {%- assign counter = counter | plus: 1 -%}
{%- endfor -%}
</ol>
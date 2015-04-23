---
layout: category
title:  "Events"
---

<ol>
{% for post in site.categories['event'] %}
	<li><a href="{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}
</ol>

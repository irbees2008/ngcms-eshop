<?xml version="1.0" encoding="utf-8"?>
<yml_catalog date="{{ 'now'|date("Y-m-d H:i") }}">
	<shop>
		<name>{{ system_flags.info.title.header }}</name>
		<url>{{ home }}</url>
		<currencies>
			<currency id="{{ system_flags.eshop.currency[0].code }}" rate="{{ system_flags.eshop.currency[0].rate_from }}"/>
		</currencies>
		<categories>
			{% for cat in cat_info %}
				<category id="{{ cat.id }}" {% if not (cat.parent_id == 0) %} parentId="{{ cat.parent_id }}" {% endif %}>{{ cat.name }}</category>
			{% endfor %}
		</categories>
		<offers>
			{% for entry in entries %}
				{% if entry.cid is defined and entry.cid %}
					<offer id="{{ entry.id }}" available="{% if (entry.variants.stock == 0) or (entry.variants.stock == 1) %}false{% elseif (entry.variants.stock == 5) %}true{% endif %}">
						<url>{{ home }}{{ entry.fulllink }}</url>
						<price>{{ entry.variants.price }}</price>
						{% if entry.variants.compare_price and entry.variants.compare_price > entry.variants.price %}
							<oldprice>{{ entry.variants.compare_price }}</oldprice>
						{% endif %}
						<currencyId>{{ system_flags.eshop.currency[0].code }}</currencyId>
						<categoryId>{{ entry.cid }}</categoryId>
						{% if (entry.images) %}
							{% for img in entry.images %}
								{% if (loop.index < 10) %}
									<picture>{{ home }}/uploads/eshop/products/{{ entry.id }}/thumb/{{ img.filepath }}</picture>
								{% endif %}
							{% endfor %}
						{% endif %}
						<name>{{ entry.name }}</name>
						<description>
							{% if not entry.annotation %}
								{% if entry.body|striptags|trim|replace({'&nbsp;': ' '})|length > 600 %}
									{{ entry.body|striptags|trim|replace({'&nbsp;': ' '})|slice(0, 600) ~ '...' }}
								{% else %}
									{{ entry.body|striptags|trim|replace({'&nbsp;': ' '}) }}
								{% endif %}
							{% endif %}

						</description>

						{% if (entry.features) %}
							{% for feature in entry.features %}
								{% if not (feature.name == 'source_url') %}
									<param name="{{ feature.name }}">{{ feature.value|replace({"&": "&amp;"}) }}</param>
								{% endif %}
							{% endfor %}
						{% endif %}
					</offer>
				{% endif %}
			{% endfor %}

		</offers>
	</shop>
</yml_catalog>


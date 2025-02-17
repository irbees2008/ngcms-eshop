<div class="container">
	<div class="collapse navbar-collapse" id="mainNavbar">
		<ul
			class="navbar-nav me-auto mb-2 mb-lg-0">
			<!-- Простой пункт меню -->
			<li class="nav-item">
				<a class="nav-link active" aria-current="page" href="{{ home }}">Главная</a>
			</li>

			<!-- Рекурсивное меню категорий -->
			{% macro recursiveCategory(category, level) %}
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" href="{{ category.cat_link }}" id="navbarDropdown{{ category.id }}" role="button" data-bs-toggle="dropdown" aria-expanded="false">
						{{ category.name }}
						{% if cnt.count[category.id] %}({{ cnt.count[category.id] }})
						{% endif %}
					</a>
					{% if category.children|length %}
						<ul class="dropdown-menu" aria-labelledby="navbarDropdown{{ category.id }}">
							{% for child in category.children %}
								<li>
									<a class="dropdown-item" href="{{ child.cat_link }}">
										{{ child.name }}
										{% if cnt.count[child.id] %}({{ cnt.count[child.id] }})
										{% endif %}
									</a>
									{% if child.children|length %}
										{{ _self.recursiveCategory(child, level + 1) }}
									{% endif %}
								</li>
							{% endfor %}
						</ul>
					{% endif %}
				</li>
			{% endmacro %}

			<!-- Генерация категорий -->
			{% if tree %}
				{% for category in tree %}
					{{ _self.recursiveCategory(category, 0) }}
				{% endfor %}
			{% endif %}
		</ul>
	</div>
</div>


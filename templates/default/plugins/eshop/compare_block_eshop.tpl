<!-- Кнопка "Сравнение" -->
<li class="dropdown">
	<a class="text-white text-decoration-none dropdown-toggle d-flex align-items-center {% if (count == 0) %}disabled{% endif %}" href="#" id="compareDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" {% if (count > 0) %} onclick="location.href='{{home}}/eshop/compare/'" {% endif %}>
		<i class="fas fa-balance-scale me-2"></i>
		<span class="text-el">Сравнение</span>
		<span class="compareListCount {% if (count == 0) %}d-none{% endif %}">
			{{ count }}
		</span>
	</a>
	<!-- Выпадающее меню -->
	<ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end" aria-labelledby="compareDropdown">
		{% if (count == 0) %}
			<li>
				<span class="dropdown-item-text text-muted">
					Ваш список “Список сравнения” пуст
				</span>
			</li>
		{% else %}
			<li>
				<a class="dropdown-item" href="{{home}}/eshop/compare/">Перейти к сравнению</a>
			</li>
		{% endif %}
	</ul>
</li>

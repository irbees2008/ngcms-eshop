{% if (entries) %}
	<div
		class="container py-5">
		<!-- Заголовок -->
		<div class="row mb-4">
			<div class="col">
				<h1 class="title text-center">
					<span class="s-t">Результаты поиска</span>
					<span class="what-search">«{{ search_request }}»</span>
				</h1>
			</div>
		</div>

		<!-- Список товаров -->
		<div class="row" id="items-catalog-main">
			{% for entry in entries %}
				<div class="col-md-4 mb-4">
					<div
						class="card h-100 {% if (entry.variants[0].stock == 0) or (entry.variants[0].stock == 1) %}not-avail{% elseif (entry.variants[0].stock == 5) %}to-cart{% endif %}">
						<!-- Изображение и название товара -->
						<a href="{{ entry.fulllink }}" class="text-decoration-none text-dark">
							<img src="{% if (entry.images[0].filepath) %}{{ home }}/uploads/eshop/products/{{ entry.id }}/thumb/{{ entry.images[0].filepath }}{% else %}{{ home }}/engine/plugins/eshop/tpl/img/img_none.jpg{% endif %}" class="card-img-top" alt="{{ entry.name }}">
							<h5 class="card-title text-center mt-2">{{ entry.name }}</h5>
						</a>

						<!-- Артикул -->
						<div class="card-body">
							<p class="card-text text-muted small">Артикул:
								{{ entry.code }}</p>

							<!-- Цены -->
							<div class="d-flex justify-content-between align-items-center">
								<span class="text-danger fw-bold">
									{% if (entry.variants[0].price) %}
										{{ (entry.variants[0].price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
										{{ system_flags.eshop.current_currency.sign }}
									{% else %}
										Цена не указана
									{% endif %}
								</span>
								{% if (not (entry.variants[0].compare_price == '0.00')) and (not (entry.variants[0].compare_price == '')) %}
									<span class="text-muted">
										<s>
											{{ (entry.variants[0].compare_price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
											{{ system_flags.eshop.current_currency.sign }}
										</s>
									</span>
								{% endif %}
							</div>

							<!-- Кнопки -->
							<div class="d-grid gap-2 mt-3">
								{% if (entry.variants[0].stock == 0) or (entry.variants[0].stock == 1) %}
									<button class="btn btn-secondary disabled" disabled>Нет в наличии</button>
								{% elseif (entry.variants[0].stock == 5) %}
									<button class="btn btn-success">В корзине</button>
								{% else %}
									<button class="btn btn-primary">Купить</button>
								{% endif %}
								<button class="btn btn-outline-secondary">Сравнить</button>
								<button class="btn btn-outline-secondary">В избранное</button>
							</div>

							<!-- Описание -->
							<div class="mt-3">
								<p class="card-text text-muted small">{{ entry.annotation|truncateHTML(30, '...') }}</p>
							</div>
						</div>
					</div>
				</div>
			{% endfor %}
		</div>

		<!-- Пагинация -->
		{% if (pages.true) %}
			<nav aria-label="Page navigation" class="mt-4">
				<ul class="pagination justify-content-center">
					{% if (prevlink.true) %}
						<li class="page-item">
							<a class="page-link" href="{{ prevlink.link }}" aria-label="Previous">
								<span aria-hidden="true">&laquo;</span>
							</a>
						</li>
					{% endif %}
					{{ pages.print }}
					{% if (nextlink.true) %}
						<li class="page-item">
							<a class="page-link" href="{{ nextlink.link }}" aria-label="Next">
								<span aria-hidden="true">&raquo;</span>
							</a>
						</li>
					{% endif %}
				</ul>
			</nav>
		{% endif %}
	</div>
{% else %}
	<div class="container py-5">
		<div class="alert alert-info text-center" role="alert">
			<i class="fas fa-info-circle me-2"></i>Не найдено товаров
		</div>
	</div>
{% endif %}


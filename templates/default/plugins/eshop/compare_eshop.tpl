{% if entries %}
	<div
		class="container py-5">
		<!-- Заголовок -->
		<h1 class="text-center mb-4">Сравнение товаров</h1>

		<!-- Таблица сравнения -->
		<div class="table-responsive">
			<table class="table table-bordered align-middle">
				<thead class="table-light">
					<tr>
						<th scope="col">Категория</th>
						{% for fl in features_list %}
							<th scope="col">{{ fl.name }}</th>
						{% endfor %}
						<th scope="col">Цена</th>
						<th scope="col">Старая цена</th>
						<th scope="col">Наличие</th>
						<th scope="col">Действия</th>
					</tr>
				</thead>
				<tbody>
					{% for entry in entries %}
						<tr>
							<!-- Название товара -->
							<td>
								<div class="d-flex align-items-center">
									<img src="{% if (entry.images[0].filepath) %}{{ home }}/uploads/eshop/products/{{ entry.id }}/thumb/{{ entry.images[0].filepath }}{% else %}{{ home }}/engine/plugins/eshop/tpl/img/img_none.jpg{% endif %}" alt="{{ entry.name }}" class="me-2" style="width: 50px; height: 50px; object-fit: cover;">
									<span>{{ entry.name }}</span>
								</div>
							</td>
							<!-- Характеристики -->
							{% for ftre in entry.features %}
								<td>{{ ftre.value }}</td>
							{% endfor %}
							<!-- Цена -->
							<td>
								{% if (entry.variants[0].price) %}
									<span class="fw-bold text-danger">
										{{ (entry.variants[0].price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
										{{ system_flags.eshop.current_currency.sign }}
									</span>
								{% else %}
									Цена не указана
								{% endif %}
							</td>
							<!-- Старая цена -->
							<td>
								{% if (not (entry.variants[0].compare_price == '0.00')) and (not (entry.variants[0].compare_price == '')) %}
									<span class="text-muted">
										<s>
											{{ (entry.variants[0].compare_price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
											{{ system_flags.eshop.current_currency.sign }}
										</s>
									</span>
								{% endif %}
							</td>
							<!-- Наличие -->
							<td>
								{% if (entry.variants[0].stock == 0) or (entry.variants[0].stock == 1) %}
									<span class="badge bg-secondary">Нет в наличии</span>
								{% elseif (entry.variants[0].stock == 5) %}
									<span class="badge bg-success">В корзине</span>
								{% else %}
									<span class="badge bg-primary">В наличии</span>
								{% endif %}
							</td>
							<!-- Действия -->
							<td>
								<div class="btn-group" role="group">
									<button type="button" class="btn btn-sm btn-outline-secondary btnBuy orderBut" data-id="{{ entry.id }}">

										Купить
									</button>
									<button type="button" class="btn btn-sm btn-outline-secondary" data-id="{{ entry.id }}">
										Сравнить
									</button>
									<button type="button" class="btn btn-sm btn-outline-danger deleteFromCompare" data-id="{{ entry.id }}">

										Удалить
									</button>

								</div>
							</td>
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</div>

		<!-- Пустой список -->
	{% else %}
		<div class="alert alert-warning text-center" role="alert">
			Список сравнения пуст
		</div>
	{% endif %}
</div>

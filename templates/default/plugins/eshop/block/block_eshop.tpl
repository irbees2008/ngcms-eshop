{% set chunked_entries = entries|batch(4) %}
{% for chunk in chunked_entries %}
	<div class="carousel-item {% if loop.first %}active{% endif %}">
		<div class="row">
			{% for entry in chunk %}
				<div class="col-md-3 mb-3">
					<div
						class="card">
						<!-- Изображение товара -->
						<a href="{{ entry.view_link }}" class="text-decoration-none">
							<img src="{% if (entry.images[0].filepath) %}{{ home }}/uploads/eshop/products/{{ entry.id }}/thumb/{{ entry.images[0].filepath }}{% else %}{{ home }}/engine/plugins/eshop/tpl/img/img_none.jpg{% endif %}" class="card-img-top" alt="{{ entry.name }}">
						</a>

						<!-- Статус товара (хит, новинка, акция) -->
						<div class="position-absolute top-0 end-0 me-2 mt-2">
							{% if (mode == 'stocked') %}
								<span class="badge bg-danger">Хит</span>
							{% elseif (mode == 'last') %}
								<span class="badge bg-primary">Новинка</span>
							{% elseif (mode == 'featured') %}
								<span class="badge bg-success">Акция</span>
							{% endif %}
						</div>

						<!-- Тело карточки -->
						<div
							class="card-body">
							<!-- Название товара -->
							<h5 class="card-title">
								<a href="{{ entry.view_link }}" class="text-decoration-none text-dark">{{ entry.name }}</a>
							</h5>

							<!-- Цена товара -->
							<div class="d-flex justify-content-between align-items-center">
								<span class="text-danger fw-bold">
									{% if (entry.variants[0].price) %}
										{{ (entry.variants[0].price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
										{{ system_flags.eshop.current_currency.sign }}
									{% else %}
										Цена не указана
									{% endif %}
								</span>

								<!-- Кнопка "Купить" -->
								<a href="{{ entry.view_link }}" class="btn btn-outline-primary">

									<i class="fas fa-shopping-cart me-2"></i>Купить
								</a>
							</div>

							<!-- Старая цена (если есть) -->
							{% if (not (entry.variants[0].compare_price == '0.00')) and (not (entry.variants[0].compare_price == '')) %}
								<div class="mt-2">
									<span class="text-muted">
										<s>
											{{ (entry.variants[0].compare_price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
											{{ system_flags.eshop.current_currency.sign }}
										</s>
									</span>
								</div>
							{% endif %}
						</div>
					</div>
				</div>
			{% endfor %}
		</div>
	</div>
{% endfor %}

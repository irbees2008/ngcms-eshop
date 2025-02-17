{% if not (formEntry.error) %}
	<div
		class="container py-5">
		<!-- Заголовок заказа -->
		<div class="row mb-4">
			<div class="col">
				<h1 class="text-center text-md-start">
					Заказ №<span class="fw-bold">{{ formEntry.id }}</span>
				</h1>
			</div>
		</div>

		<!-- Информация о заказе -->
		<div class="row">
			<div class="col-md-6">
				<div class="card mb-4">
					<div class="card-header bg-light">
						<h5 class="mb-0">Информация о заказе</h5>
					</div>
					<div class="card-body">
						<table class="table table-borderless">
							<tbody>
								<tr>
									<th scope="row">Имя:</th>
									<td>{{ formEntry.name }}</td>
								</tr>
								<tr>
									<th scope="row">E-mail:</th>
									<td>{{ formEntry.email }}</td>
								</tr>
								<tr>
									<th scope="row">Телефон:</th>
									<td>{{ formEntry.phone }}</td>
								</tr>
								<tr>
									<th scope="row">Способ оплаты:</th>
									<td>{{ formEntry.payment_type.name }}</td>
								</tr>
								<tr>
									<th scope="row">Способ доставки:</th>
									<td>{{ formEntry.delivery_type.name }}</td>
								</tr>
								<tr>
									<th scope="row">Адрес доставки:</th>
									<td>{{ formEntry.address }}</td>
								</tr>
								<tr>
									<th scope="row">Комментарий:</th>
									<td>{{ formEntry.comment }}</td>
								</tr>
								<tr>
									<th scope="row">Дата заказа:</th>
									<td>{{ formEntry.dt|date('d.m.Y H:i') }}</td>
								</tr>
								<tr>
									<th scope="row">Статус оплаты:</th>
									<td>
										<span class="badge {% if formEntry.paid == 0 %}bg-danger{% else %}bg-success{% endif %}">
											{% if formEntry.paid == 0 %}Не оплачен{% else %}Оплачен
											{% endif %}
										</span>
										{% if formEntry.paid == 0 %}
											<form method="get" action="{{ payment.link }}" target="_blank" class="d-inline-block ms-2">
												<input type="hidden" value="{{ formEntry.id }}" name="order_id">
												<input type="hidden" value="{{ formEntry.uniqid }}" name="order_uniqid">
												<input type="hidden" value="{{ payment.systems[2].name }}" name="payment_id">
												<button type="submit" class="btn btn-primary btn-sm">
													Оплатить
												</button>
											</form>
										{% endif %}
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>

			<!-- Список товаров -->
			<div class="col-md-6">
				<div class="card mb-4">
					<div class="card-header bg-light">
						<h5 class="mb-0">Мой заказ</h5>
					</div>
					<div class="card-body">
						{% if recs > 0 %}
							<table class="table table-hover">
								<tbody>
									{% for entry in entries %}
										<tr>
											<td>
												<div class="d-flex align-items-center">
													<img src="{% if (entry.xfields.item.image_filepath) %}{{ home }}/uploads/eshop/products/{{ entry.xfields.item.id }}/thumb/{{ entry.xfields.item.image_filepath }}{% else %}{{ home }}/engine/plugins/eshop/tpl/img/img_none.jpg{% endif %}" alt="{{ entry.title }}" class="me-3" style="width: 50px; height: 50px; object-fit: cover;">
													<div>
														<a href="{{ entry.xfields.item.view_link }}" class="text-decoration-none text-dark fw-bold">
															{{ entry.title }}
														</a>
														<div class="small text-muted">{{ entry.xfields.item.v_name }}</div>
													</div>
												</div>
											</td>
											<td class="text-center">{{ entry.count }}
												шт.</td>
											<td class="text-end">
												<span class="fw-bold">
													{{ (entry.price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
													{{ system_flags.eshop.current_currency.sign }}
												</span>
											</td>
										</tr>
									{% endfor %}
								</tbody>
								<tfoot>
									<tr>
										<td colspan="2" class="text-end">Стоимость товаров:</td>
										<td class="text-end">
											<span class="fw-bold">
												{{ (total * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
												{{ system_flags.eshop.current_currency.sign }}
											</span>
										</td>
									</tr>
									<tr>
										<td colspan="2" class="text-end">Доставка:</td>
										<td class="text-end">Бесплатно</td>
									</tr>
									<tr>
										<td colspan="2" class="text-end">К оплате:</td>
										<td class="text-end">
											<span class="fw-bold">
												{{ (total * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
												{{ system_flags.eshop.current_currency.sign }}
											</span>
										</td>
									</tr>
								</tfoot>
							</table>
						{% else %}
							<div class="alert alert-warning text-center" role="alert">
								Ваша корзина пуста!
							</div>
						{% endif %}
					</div>
				</div>
			</div>
		</div>
	</div>
{% else %}
	<div class="container py-5">
		<div class="alert alert-danger" role="alert">
			<h4 class="alert-heading">Ошибка!</h4>
			<ul class="mb-0">
				{% for err in formEntry.error %}
					<li>{{ err }}</li>
				{% endfor %}
			</ul>
		</div>
	</div>
{% endif %}

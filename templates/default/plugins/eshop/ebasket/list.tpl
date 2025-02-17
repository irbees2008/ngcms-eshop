<script src="{{ tpl_url }}/js/cusel-min-2.5.js"></script>
<script src="{{ tpl_url }}/js/_product.js"></script>

{% if formEntry.error %}
	<div class="container py-5">
		<div class="alert alert-danger" role="alert">
			<h4 class="alert-heading">Ошибка!</h4>
			<ul class="mb-0">
				{% for error in formEntry.error %}
					<li>{{ error }}</li>
				{% endfor %}
			</ul>
		</div>
	</div>
{% else %}
	<div
		class="container py-5">
		<!-- Заголовок -->
		<h1 class="text-center mb-4">Оформление заказа</h1>

		<!-- Форма заказа -->
		<div class="row">
			<div class="col-md-6">
				<div class="card mb-4">
					<div class="card-header bg-light">
						<h5 class="mb-0">Контактные данные</h5>
					</div>
					<div class="card-body">
						<form id="checkoutForm">
							<div class="mb-3">
								<label for="name" class="form-label">Имя *</label>
								<input type="text" class="form-control" id="name" name="name" required>
							</div>
							<div class="mb-3">
								<label for="email" class="form-label">Email *</label>
								<input type="email" class="form-control" id="email" name="email" required>
							</div>
							<div class="mb-3">
								<label for="phone" class="form-label">Телефон *</label>
								<input type="tel" class="form-control" id="phone" name="phone" required>
							</div>
							<div class="mb-3">
								<label for="paymentType" class="form-label">Способ оплаты</label>
								<select class="form-select" id="paymentType" name="paymentType" required>
									{% for variant in entriesPaymentTypes %}
										<option value="{{ variant.id }}">{{ variant.name }}</option>
									{% endfor %}
								</select>
							</div>
							<div class="mb-3">
								<label for="deliveryType" class="form-label">Способ доставки</label>
								<select class="form-select" id="deliveryType" name="deliveryType" required>
									{% for variant in entriesDeliveryTypes %}
										<option value="{{ variant.id }}">{{ variant.name }}</option>
									{% endfor %}
								</select>
							</div>
							<div class="mb-3">
								<label for="address" class="form-label">Адрес доставки</label>
								<input type="text" class="form-control" id="address" name="address">
							</div>
							<div class="mb-3">
								<label for="comment" class="form-label">Комментарий к заказу</label>
								<textarea class="form-control" id="comment" name="comment" rows="3"></textarea>
							</div>
							<button type="submit" class="btn btn-primary w-100">Оформить заказ</button>
						</form>
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
											<td class="text-center">
<div
	class="btn-group" role="group">
	<!-- Кнопка "Уменьшить" -->
	<button type="button" class="btn btn-sm btn-outline-secondary cart_quantity_down" title="Уменьшить" data-id="{{ entry.id }}" data-linked_ds="{{ entry.linked_ds }}" data-linked_id="{{ entry.linked_id }}" data-price="{{ entry.price }}">
		-
	</button>

	<!-- Отображение текущего количества -->
	<span class="btn btn-sm btn-outline-secondary cart_quantity_input" data-id="{{ entry.id }}" data-linked_ds="{{ entry.linked_ds }}" data-linked_id="{{ entry.linked_id }}" data-price="{{ entry.price }}">
		{{ entry.count }}
	</span>

	<!-- Кнопка "Добавить" -->
	<button type="button" class="btn btn-sm btn-outline-secondary cart_quantity_up" title="Добавить" data-id="{{ entry.id }}" data-linked_ds="{{ entry.linked_ds }}" data-linked_id="{{ entry.linked_id }}" data-price="{{ entry.price }}">
		+
	</button>
<!-- Кнопка "Удалить" -->
<button type="button" class="btn btn-sm btn-outline-danger cart_quantity_delete" title="Удалить" data-id="{{ entry.id }}" data-linked_ds="{{ entry.linked_ds }}" data-linked_id="{{ entry.linked_id }}">
	<i class="fas fa-trash-alt"></i>
	<!-- Иконка корзины -->
</button>

</div>

											</td>
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
{% endif %}

<script>
	$(document).ready(function () { // Функция для обновления количества и общей суммы
function update_updown_total(click_this, count) { // Проверяем, что click_this существует и имеет атрибут data-price
if (! click_this || ! click_this.attr("data-price")) {
console.error("Ошибка: элемент или атрибут data-price не найдены");
return;
}

// Получаем цену и преобразуем её в число
var price = parseFloat(click_this.attr("data-price").trim());
if (isNaN(price)) {
console.error("Ошибка: некорректное значение цены");
return;
}

// Проверяем корректность значения count
if (isNaN(parseInt(count)) || parseInt(count) <= 0) {
count = 1; // Устанавливаем минимальное значение
}

// Получаем данные товара
var id = click_this.attr("data-id");
var linked_ds = click_this.attr("data-linked_ds");
var linked_id = click_this.attr("data-linked_id");

// Отправляем запрос на сервер
rpcEshopRequest("eshop_ebasket_manage", {
action: "update_count",
id: id,
linked_ds: linked_ds,
linked_id: linked_id,
count: count
}, function (resTX) { // Обновляем значение в поле ввода
click_this.text(count);
// Для span
// click_this.val(count); // Для input

// Вычисляем новую общую стоимость товара
var total = parseFloat(count * price).toFixed(2);
click_this.closest("tr") // Находим родительскую строку таблицы.find("td span.price").text(total);

// Пересчитываем итоговую сумму
var sum = 0;
$("td span.price").each(function () {
sum += parseFloat($(this).text()) || 0; // Защита от NaN
});
$("#finalAmount").text(sum.toFixed(2));
});
}

// Обработчик для кнопки "Увеличить"
$(".cart_quantity_up").on("click", function (e) {
var click_this = $(this).closest(".btn-group").find(".cart_quantity_input"); // Находим поле ввода
var count = parseInt(click_this.text()) + 1;
// Для span
// var count = parseInt(click_this.val()) + 1; // Для input
update_updown_total(click_this, count);
});

// Обработчик для кнопки "Уменьшить"
$(".cart_quantity_down").on("click", function (e) {
var click_this = $(this).closest(".btn-group").find(".cart_quantity_input"); // Находим поле ввода
var count = parseInt(click_this.text()) - 1;
// Для span
// var count = parseInt(click_this.val()) - 1; // Для input
update_updown_total(click_this, count);
});

// Обработчик для изменения значения вручную
$(document).on("change", ".cart_quantity_input", function (e) {
var count = parseInt($(this).val()); // Для input
update_updown_total($(this), count);
});

// Обработчик для удаления товара
$(".cart_quantity_delete").on("click", function (e) {
var id = $(this).attr("data-id");
var linked_ds = $(this).attr("data-linked_ds");
var linked_id = $(this).attr("data-linked_id");

// Отправляем запрос на удаление товара
rpcEshopRequest("eshop_ebasket_manage", {
action: "delete",
id: id,
linked_ds: linked_ds,
linked_id: linked_id
}, function (resTX) {
location.reload(); // Перезагружаем страницу после удаления
});
});
});
</script>

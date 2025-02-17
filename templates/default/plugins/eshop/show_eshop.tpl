<section class="container my-4">

	<div class="container my-4">
		<div
			class="row">
			<!-- Левая колонка: Изображения -->
			<div class="col-md-6">
				<div
					class="mb-3">
					<!-- Главное изображение -->
					<div id="mainImage" class="text-center">
						{% if entriesImg %}
							{% for entry in entriesImg %}
								{% if loop.first %}
									<a href="{{ home }}/uploads/eshop/products/{{ id }}/{{ entry.filepath }}" data-bs-toggle="modal" data-bs-target="#imageModal">
										<img src="{{ home }}/uploads/eshop/products/{{ id }}/thumb/{{ entry.filepath }}" class="img-fluid rounded" alt="{{ name }}">
									</a>
								{% endif %}
							{% endfor %}
						{% else %}
							<a href="{{ home }}/engine/plugins/eshop/tpl/img/img_none.jpg" data-bs-toggle="modal" data-bs-target="#imageModal">
								<img src="{{ home }}/engine/plugins/eshop/tpl/img/img_none.jpg" class="img-fluid rounded" alt="{{ name }}">
							</a>
						{% endif %}
					</div>

					<!-- Модальное окно для увеличения изображения -->
					<div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
						<div class="modal-dialog modal-lg">
							<div class="modal-content">
								<div class="modal-body text-center">
									<img src="" class="img-fluid" id="modalImage" alt="Увеличенное изображение">
								</div>
							</div>
						</div>
					</div>

					<!-- Дополнительные изображения (карусель) -->
					<div class="mt-3">
						<div id="additionalImagesCarousel" class="carousel slide" data-bs-ride="carousel">
							<div class="carousel-inner">
								{% for entry in entriesImg %}
									<div class="carousel-item {% if loop.first %}active{% endif %}">
										<img src="{{ home }}/uploads/eshop/products/{{ id }}/thumb/{{ entry.filepath }}" class="d-block w-100" alt="{{ name }}">
									</div>
								{% endfor %}
							</div>
							<button class="carousel-control-prev" type="button" data-bs-target="#additionalImagesCarousel" data-bs-slide="prev">
								<span class="carousel-control-prev-icon" aria-hidden="true"></span>
								<span class="visually-hidden">Previous</span>
							</button>
							<button class="carousel-control-next" type="button" data-bs-target="#additionalImagesCarousel" data-bs-slide="next">
								<span class="carousel-control-next-icon" aria-hidden="true"></span>
								<span class="visually-hidden">Next</span>
							</button>
						</div>
					</div>
				</div>
			</div>

			<!-- Правая колонка: Информация о товаре -->
			<div class="col-md-6">
				<div class="card h-100">
					<div
						class="card-body">

						<!-- Название товара -->
						<h1 class="card-title">{{ name }}<a href="{{ edit_link }}" target="_blank">[E]</a>
						</h1>

						<!-- Код товара -->
						<p class="card-text">
							<strong>Код:</strong>
							{{ code }}</p>

						<!-- Варианты товара -->
						{% if entriesVariants|length > 1 %}
							<div class="mb-3">
								<select class="form-select" id="variantSwitcher" onchange="change_variant(this)">
									{% for variant in entriesVariants %}
										<option value="{{ variant.id }}|{{ variant.price }}|{{ variant.compare_price }}|{{ variant.stock }}" data-variant="{{ variant.id }}" data-price="{{ variant.price }}" data-stock="{{ variant.stock }}">
											{{ variant.name }}
										</option>
									{% endfor %}
								</select>
							</div>
						{% endif %}

						<!-- Цены -->
						<div class="mb-3">
							{% for variant in entriesVariants %}
								{% if loop.index == 1 %}
									{% if variant.price %}
										<p class="card-text">
											<strong>Цена:</strong>
											<span class="priceVariant fw-bold">
												{{ (variant.price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
												{{ system_flags.eshop.current_currency.sign }}
											</span>
										</p>
									{% endif %}
									{% if not (variant.compare_price == '0.00') and not (variant.compare_price == '') %}
										<p class="card-text text-muted">
											<s>
												{{ (variant.compare_price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
												{{ system_flags.eshop.current_currency.sign }}
											</s>
										</p>
									{% endif %}
								{% endif %}
							{% endfor %}

						</div>

						<!-- Наличие товара -->

						<div class="d-grid gap-2">
							{% if entriesVariants[0].stock == 5 %}
								<button type="button" class="btn btn-success" data-id="{{ id }}" data-variant="{{ entriesVariants[0]['id'] }}">
									В корзине
								</button>
								<button type="button" class="btn btn-primary orderBut" data-id="{{ id }}" data-variant="{{ entriesVariants[0]['id'] }}">
									Купить
								</button>
								<button type="button" class="btn btn-outline-primary fastOrderBut" data-id="{{ id }}" data-variant="{{ entriesVariants[0]['id'] }}">
									Купить в один клик
								</button>
								<small class="text-success">Есть в наличии</small>
							{% elseif entriesVariants[0].stock == 1 %}
								<button type="button" class="btn btn-warning fastPriceBut" data-id="{{ id }}" data-variant="{{ entriesVariants[0]['id'] }}">
									Сообщить о появлении
								</button>
								<small class="text-warning">На заказ</small>
							{% else %}
								<button type="button" class="btn btn-danger infoBut fastPriceBut" data-id="{{ id }}" data-variant="{{ entriesVariants[0]['id'] }}">
									Сообщить о появлении
								</button>
								{% if entriesVariants[0].stock == 0 %}
									<small class="text-danger">Нет в наличии</small>
								{% endif %}
							{% endif %}
						</div>

						<!-- Дополнительные действия -->
						<div
							class="d-flex gap-2">
							<!-- Сравнение -->
							<div class="btn-group">
								<button type="button" class="btn btn-outline-secondary btnCompare toCompare {% if compare %}active{% endif %}" data-id="{{ id }}">
									<i class="fas fa-exchange-alt"></i>
									Cравнить
								</button>
							</div>

							<!-- Избранное -->
							<div class="btn-group">
								<button type="button" class="btn btn-outline-secondary toWishlist isDrop" data-id="5853">
									<i class="fas fa-heart"></i>
									В избранные
								</button>
								<button type="button" class="btn btn-secondary inWishlist" style="display: none;">
									<i class="fas fa-heart"></i>
									В избранных
								</button>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Описание и характеристики -->
	<div
		class="container my-4">
		<!-- Вкладки -->
		<ul class="nav nav-tabs" id="productTabs" role="tablist">
			<li class="nav-item" role="presentation">
				<button class="nav-link active" id="characteristics-tab" data-bs-toggle="tab" data-bs-target="#characteristics" type="button" role="tab" aria-controls="characteristics" aria-selected="true">Характеристики</button>
			</li>
			<li class="nav-item" role="presentation">
				<button class="nav-link" id="description-tab" data-bs-toggle="tab" data-bs-target="#description" type="button" role="tab" aria-controls="description" aria-selected="false">Описание</button>
			</li>
			<li class="nav-item" role="presentation">
				<button class="nav-link" id="reviews-tab" data-bs-toggle="tab" data-bs-target="#reviews" type="button" role="tab" aria-controls="reviews" aria-selected="false">
					<i class="fas fa-comment"></i>
					Отзывы
				</button>
			</li>
			<li class="nav-item" role="presentation">
				<button class="nav-link" id="delivery-tab" data-bs-toggle="tab" data-bs-target="#delivery" type="button" role="tab" aria-controls="delivery" aria-selected="false">Доставка и оплата</button>
			</li>
		</ul>

		<!-- Содержимое вкладок -->
		<div
			class="tab-content mt-3" id="productTabsContent">

			<!-- Характеристики -->
			<div class="tab-pane fade show active" id="characteristics" role="tabpanel" aria-labelledby="characteristics-tab">
				<table class="table table-bordered">
					<tbody>
						{% for feature in entriesFeatures %}
							<tr>
								<th scope="row">{{ feature.name }}</th>
								<td>{{ feature.value }}</td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			</div>

			<!-- Описание -->
			<div class="tab-pane fade" id="description" role="tabpanel" aria-labelledby="description-tab">
				<p>{{ body }}</p>
			</div>

			<!-- Отзывы -->
			<div class="tab-pane fade" id="reviews" role="tabpanel" aria-labelledby="reviews-tab">
				<div class="comments">
					<ul class="list-group">
						<li class="list-group-item">Отзыв 1</li>
						<li class="list-group-item">Отзыв 2</li>
					</ul>
					{{ comments_form }}
				</div>
			</div>

			<!-- Доставка и оплата -->
			<div class="tab-pane fade" id="delivery" role="tabpanel" aria-labelledby="delivery-tab">
				<div id="deliveryTabs">
					<h5>Доставка</h5>
					<p>{{ system_flags.eshop.description_delivery }}</p>
					<h5>Оплата</h5>
					<p>{{ system_flags.eshop.description_order }}</p>
				</div>
			</div>
		</div>
	</div>

</section>
{% if entriesRelated %}
	<!-- Start. Similar Products -->
	<section class="container my-4">
		<h3 class="text-center mb-4">Похожие товары</h3>
		<div
			id="similarProductsCarousel" class="carousel slide" data-bs-ride="carousel">
			<!-- Indicators -->
			<div class="carousel-indicators">
				{% for entry in entriesRelated %}
					<button type="button" data-bs-target="#similarProductsCarousel" data-bs-slide-to="{{ loop.index0 }}" class="{% if loop.first %}active{% endif %}" aria-current="{% if loop.first %}true{% else %}false{% endif %}" aria-label="Slide {{ loop.index }}"></button>
				{% endfor %}
			</div>

			<!-- Slides -->
			<div class="carousel-inner">
				{% for entry in entriesRelated %}
					<div class="carousel-item {% if loop.first %}active{% endif %}">
						<div class="row">
							<div class="col-md-4 mx-auto">
								<div
									class="card h-100 {% if entry.variants[0].stock == 0 or entry.variants[0].stock == 1 %}not-avail{% elseif entry.variants[0].stock == 5 %}to-cart{% endif %}">
									<!-- Product Image -->
									<a href="{{ entry.fulllink }}" class="text-decoration-none text-dark">
										<img src="{% if entry.images[0].filepath %}{{ home }}/uploads/eshop/products/{{ entry.id }}/thumb/{{ entry.images[0].filepath }}{% else %}{{ home }}/engine/plugins/eshop/tpl/img/img_none.jpg{% endif %}" class="card-img-top" alt="{{ entry.name }}">
									</a>
									<!-- Product Details -->
									<div class="card-body">
										<h6 class="card-title">{{ entry.name }}</h6>
										<div
											class="card-text">
											<!-- Price -->
											<div class="d-flex align-items-center">
												{% if entry.variants[0].price %}
													<span class="price priceVariant fw-bold">
														{{ (entry.variants[0].price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
														{{ system_flags.eshop.current_currency.sign }}
													</span>
												{% endif %}
												{% if not (entry.variants[0].compare_price == '0.00') and not (entry.variants[0].compare_price == '') %}
													<span class="price-add ms-2 text-muted">
														<s>
															{{ (entry.variants[0].compare_price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
															{{ system_flags.eshop.current_currency.sign }}
														</s>
													</span>
												{% endif %}
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				{% endfor %}
			</div>

			<!-- Controls -->
			<button class="carousel-control-prev" type="button" data-bs-target="#similarProductsCarousel" data-bs-slide="prev">
				<span class="carousel-control-prev-icon" aria-hidden="true"></span>
				<span class="visually-hidden">Previous</span>
			</button>
			<button class="carousel-control-next" type="button" data-bs-target="#similarProductsCarousel" data-bs-slide="next">
				<span class="carousel-control-next-icon" aria-hidden="true"></span>
				<span class="visually-hidden">Next</span>
			</button>
		</div>
	</section>
	<!-- End. Similar Products -->
{% endif %}

<script>
	// Обработчик для кнопок сравнения
document.querySelectorAll('.btnCompare').forEach(button => {
button.addEventListener('click', function () {
const id = this.dataset.id;
rpcEshopRequest('eshop_compare', {
'action': 'add',
'id': id
}, function (resTX) {
alert('Товар добавлен в сравнение!');
});
});
});

// Обработчик для кнопок избранного
document.querySelectorAll('.toWishlist').forEach(button => {
button.addEventListener('click', function () {
const id = this.dataset.id;
rpcEshopRequest('eshop_wishlist', {
'action': 'add',
'id': id
}, function (resTX) {
alert('Товар добавлен в избранное!');
});
});
});
variant = "";
variant_id = {{ entriesVariants[0].id }};
variant_price = {{ entriesVariants[0].price }};
variant_compare_price = {{ entriesVariants[0].compare_price }};
variant_stock = {{ entriesVariants[0].stock }};
// Обработчик для модального окна
document.querySelectorAll('#mainImage a').forEach(link => {
link.addEventListener('click', function (e) {
e.preventDefault();
const imgSrc = this.querySelector('img').src;
document.getElementById('modalImage').src = imgSrc;
});
});

// Обработчик для изменения варианта товара
function change_variant(el) {
const variant = $(el).val().split('|');
const [variant_id, variant_price, variant_compare_price, variant_stock] = variant;

// Обновление цен и другого контента
$('.priceVariant').text(variant_price);
$('.addCurrPrice').text(variant_compare_price);

// Дополнительная логика при необходимости
}
document.addEventListener('DOMContentLoaded', function () {
var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
tooltipTriggerList.forEach(function (tooltipTriggerEl) {
new bootstrap.Tooltip(tooltipTriggerEl);
});
});
document.addEventListener('DOMContentLoaded', function () {
var tabTriggerList = [].slice.call(document.querySelectorAll('#productTabs a'));
tabTriggerList.forEach(function (tabTriggerEl) {
new bootstrap.Tab(tabTriggerEl);
});
});
$(document).ready(function () {
$('.btn-add-to-cart').on('click', function (e) {
e.preventDefault();
var productId = $(this).data('id');
rpcEshopRequest('eshop_ebasket_manage', {
'action': 'add',
'id': productId
}, function (resTX) {
$('#cart-count').text(resTX['count']);
alert('Товар добавлен в корзину!');
});
});
});
$(document).ready(function () {
$('.btn-notify').on('click', function (e) {
e.preventDefault();
var productId = $(this).data('id');
rpcEshopRequest('eshop_notify', {
'action': 'subscribe',
'id': productId
}, function (resTX) {
alert('Вы подписались на уведомления о поступлении товара.');
});
});
});
document.addEventListener('DOMContentLoaded', function () {
var tabTriggerList = [].slice.call(document.querySelectorAll('#productTabs a'));
tabTriggerList.forEach(function (tabTriggerEl) {
new bootstrap.Tab(tabTriggerEl);
});
});
</script>

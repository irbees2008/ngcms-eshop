{% if info %}
	<div class="alert alert-info" role="alert">
		{{ info }}
	</div>
{% endif %}

<div
	class="container py-5">
	<!-- Заголовок категории -->
	<h1 class="text-center mb-4">{{ cat_info.name }}</h1>
	<p class="text-center text-muted">{{ cat_info.cnt }}
		товаров</p>

	<!-- Фильтр -->
	<div class="row mb-4">
		<div class="col-md-3">
			<button class="btn btn-outline-secondary w-100 d-flex justify-content-between align-items-center" type="button" data-bs-toggle="collapse" data-bs-target="#filterCollapse" aria-expanded="false" aria-controls="filterCollapse">
				<span>Фильтр</span>
				<i class="fas fa-chevron-down"></i>
			</button>
			<div class="collapse mt-3" id="filterCollapse">
				{% set cnt_in_filter = 0 %}
				{% for ftr in system_flags.eshop.features %}
					{% if ftr.in_filter == 1 and IsCatFeatures(cat_info.id, ftr.id, system_flags.eshop.categories_features) %}
						{% set cnt_in_filter = cnt_in_filter + 1 %}
					{% endif %}
				{% endfor %}
				{% if system_flags.eshop.features and cnt_in_filter %}
					<form id="filterForm">
						{% for ftr in system_flags.eshop.features %}
							{% if ftr.in_filter == 1 and IsCatFeatures(cat_info.id, ftr.id, system_flags.eshop.categories_features) %}
								<div class="mb-3">
									<label class="form-label">{{ ftr.name }}</label>
									{% if ftr.ftype == 2 %}
										<select class="form-select niceCheck" name="{{ ftr.name }}">
											{% for fkopt, fvopt in ftr.foptions %}
												<option value="{{ fkopt }}">{{ fvopt }}</option>
											{% endfor %}
										</select>
									{% else %}
										<input type="text" class="form-control niceCheck" placeholder="{{ ftr.name }}" name="{{ ftr.name }}">
									{% endif %}
								</div>
							{% endif %}
						{% endfor %}
						<button type="submit" class="btn btn-primary w-100">Применить</button>
					</form>
				{% endif %}
			</div>
		</div>

		<!-- Список товаров -->
		<div
			class="col-md-9">
			<!-- Панель сортировки -->
			<div class="d-flex justify-content-between align-items-center mb-4">
<form method="post" id="catalogForm">
	<div class="mb-3">
		<label for="sort" class="form-label visually-hidden">Сортировать</label>
		<select class="form-select" id="sort" name="order" onchange="this.form.submit()">
			<option value="date_desc" {% if (filter.order == 'date_desc') %} selected {% endif %}>По дате</option>
			<option value="name_asc" {% if (filter.order == 'name_asc') %} selected {% endif %}>По названию (А-Я)</option>
			<option value="price_asc" {% if (filter.order == 'price_asc') %} selected {% endif %}>От дешевых к дорогим</option>
			<option value="price_desc" {% if (filter.order == 'price_desc') %} selected {% endif %}>От дорогих к дешевым</option>
			<option value="stock_desc" {% if (filter.order == 'stock_desc') %} selected {% endif %}>По наличию</option>
			<option value="likes_desc" {% if (filter.order == 'likes_desc') %} selected {% endif %}>По популярности</option>
		</select>
	</div>
</form>

				<div class="btn-group" role="group">
					<button type="button" class="btn btn-outline-secondary">
						<i class="fas fa-th-list"></i>
					</button>
					<button type="button" class="btn btn-outline-secondary">
						<i class="fas fa-table"></i>
					</button>
				</div>
			</div>

			<!-- Товары -->
			<div id="productsContainer" class="row">
				{% for entry in entries %}
					<div class="col-md-4 mb-4">
						<div
							class="card h-100">
							<!-- Изображение товара -->
							<a href="{{ entry.fulllink }}" class="text-decoration-none">
								<img src="{% if (entry.images[0].filepath) %}{{ home }}/uploads/eshop/products/{{ entry.id }}/thumb/{{ entry.images[0].filepath }}{% else %}{{ home }}/engine/plugins/eshop/tpl/img/img_none.jpg{% endif %}" class="card-img-top" alt="{{ entry.name }}">
							</a>
							<!-- Название товара -->
							<h5 class="card-title text-center mt-2 px-2">
								<a href="{{ entry.fulllink }}" class="text-decoration-none text-dark">{{ entry.name }}</a>
							</h5>
							<!-- Артикул -->
							<p class="card-text text-center text-muted small">Артикул:
								{{ entry.code }}</p>
							<!-- Цена -->
							<div class="card-body d-flex flex-column justify-content-between">
								<div class="d-flex justify-content-between align-items-center">
									<span class="text-danger fw-bold">
										{% if (entry.variants[0].price) %}
											{{ (entry.variants[0].price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
											{{ system_flags.eshop.current_currency.sign }}
										{% else %}
											Цена не указана
										{% endif %}
									</span>
								</div>
								<!-- Старая цена -->
								{% if (not (entry.variants[0].compare_price == '0.00')) and (not (entry.variants[0].compare_price == '')) %}
									<div class="mt-2 text-center">
										<span class="text-muted">
											<s>
												{{ (entry.variants[0].compare_price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
												{{ system_flags.eshop.current_currency.sign }}
											</s>
										</span>
									</div>
								{% endif %}
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
							</div>
						</div>
					</div>
				{% endfor %}
			</div>

			<!-- Пагинация -->
			{% if pages.true %}
				<nav aria-label="Page navigation" class="mt-4">
					<ul class="pagination justify-content-center">
						{% if prevlink.true %}
							<li class="page-item">
								<a class="page-link pagination-link" href="{{ prevlink.link }}" aria-label="Previous">
									<span aria-hidden="true">&laquo;</span>
								</a>
							</li>
						{% endif %}
						{{ pages.print }}
						{% if nextlink.true %}
							<li class="page-item">
								<a class="page-link pagination-link" href="{{ nextlink.link }}" aria-label="Next">
									<span aria-hidden="true">&raquo;</span>
								</a>
							</li>
						{% endif %}
					</ul>
				</nav>
			{% endif %}
		</div>
	</div>
</div>

<!-- Скрипты -->
<script>
	document.addEventListener('DOMContentLoaded', function () { // Обработчик для фильтрации
const filterForm = document.getElementById('filterForm');
if (filterForm) {
filterForm.addEventListener('submit', function (e) {
e.preventDefault();
const formData = new FormData(filterForm);

fetch('/filter', {
method: 'POST',
body: formData
}).then(response => response.json()).then(data => {
document.getElementById('productsContainer').innerHTML = data.html;
}).catch(error => {
console.error('Ошибка при фильтрации:', error);
});
});
}

// Обработчик для сортировки
const sortOptions = document.querySelectorAll('.sort-option');
sortOptions.forEach(option => {
option.addEventListener('click', function (e) {
e.preventDefault();
const sortType = this.getAttribute('data-sort');

fetch(`/sort?sort=${sortType}`).then(response => response.json()).then(data => {
document.getElementById('productsContainer').innerHTML = data.html;
}).catch(error => {
console.error('Ошибка при сортировке:', error);
});
});
});

// Обработчик для пагинации
const paginationLinks = document.querySelectorAll('.pagination-link');
paginationLinks.forEach(link => {
link.addEventListener('click', function (e) {
e.preventDefault();
const url = this.getAttribute('href');

fetch(url).then(response => response.json()).then(data => {
document.getElementById('productsContainer').innerHTML = data.html;
}).catch(error => {
console.error('Ошибка при загрузке страницы:', error);
});
});
});
});
</script>

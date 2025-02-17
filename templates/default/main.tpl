[TWIG]
<!DOCTYPE html>
<html lang="ru">
	<head>
		<meta http-equiv="content-type" content="text/html; charset={{ lang['encoding'] }}"/>
		<meta http-equiv="content-language" content="{{ lang['langcode'] }}"/>
		<meta name="generator" content="{{ what }} {{ version }}"/>
		<meta name="document-state" content="dynamic"/>
		{{ htmlvars }}
		<!-- Подключение Bootstrap CSS -->
		<link
		href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Подключение иконок Font Awesome -->
		<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
		<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

		<style>
			body {
				font-family: Arial, sans-serif;
			}
			.carousel-item img {
				transition: transform 0.3s ease-in-out;
			}
			.carousel-item img:hover {
				transform: scale(1.05);
			}
			/* Стили для кнопок управления каруселью */
			.carousel-control-prev,
			.carousel-control-next {
				width: auto;
				background-color: rgba(0, 0, 0, 0.5); /* Полупрозрачный фон */
				border-radius: 50%;
				height: 40px;
				width: 40px;
				top: 50%;
				transform: translateY(-50%);
			}
			.carousel-control-prev-icon,
			.carousel-control-next-icon {
				filter: invert(1); /* Белые стрелки */
			}
			/* Стили для индикаторов карусели */
			.carousel-indicators li {
				width: 10px;
				height: 10px;
				border-radius: 50%;
				background-color: #ccc;
			}
			.carousel-indicators .active {
				background-color: #007bff;
			}

			/* Стиль для модального окна */
			.modal-content {
				border-radius: 10px;
			}
			.modal-header {
				background-color: #007bff;
				color: white;
				border-top-left-radius: 10px;
				border-top-right-radius: 10px;
			}
			.modal-body ul {
				list-style: none;
				padding: 0;
			}
			.modal-body ul li a {
				text-decoration: none;
				color: #333;
				font-size: 16px;
			}
			.modal-body ul li a:hover {
				color: #007bff;
			}
			/* Стиль для иконки */
			.icon_compare_list {
				display: inline-block;
				width: 20px;
				height: 20px;
				background-color: #007bff;
				border-radius: 4px;
			}
			/* Стиль для счетчика товаров */
			.compareListCount {
				background-color: #dc3545;
				color: white;
				font-size: 12px;
				padding: 2px 6px;
				border-radius: 50%;
				margin-left: 5px;
			}
			/* Отключаем указатель, если список пуст */
			.isDrop {
				cursor: default;
			} /* Стиль для иконки */
			.icon_compare_list {
				display: inline-block;
				width: 20px;
				height: 20px;
				background-color: #ffffff;
				border-radius: 4px;
			}

			/* Стиль для счетчика товаров */
			.compareListCount {
				background-color: #dc3545;
				color: white;
				font-size: 12px;
				padding: 2px 6px;
				border-radius: 50%;
				margin-left: 5px;
			} /* Стиль для активной кнопки */
			.currency-list .btn.active {
				background-color: #007bff;
				color: white;
			}
			/* Общие стили для карусели */
			.horizontal-carousel {
				background-color: #f8f9fa;
				padding: 20px 0;
			}

			/* Стили для карточек */
			.card {
				display: flex;
				flex-direction: column;
				min-height: 400px; /* Минимальная высота карточки */
				border: 1px solid #ddd;
				border-radius: 8px;
				overflow: hidden;
				transition: transform 0.3s ease, box-shadow 0.3s ease;
			}

			.card:hover {
				transform: translateY(-5px);
				box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
			}

			.card-img-top {
				width: 100%;
				height: 200px; /* Фиксированная высота изображения */
				object-fit: cover; /* Обрезка изображения */
			}

			.card-title {
				font-size: 1rem;
				font-weight: bold;
				margin-bottom: 0.5rem;
				white-space: nowrap;
				overflow: hidden;
				text-overflow: ellipsis;
			}

			.card-body {
				flex-grow: 1;
				display: flex;
				flex-direction: column;
				justify-content: space-between;
			}

			.card-text {
				font-size: 0.9rem;
				line-height: 1.4;
				max-height: 3.6em;
				overflow: hidden;
				text-overflow: ellipsis;
				display: -webkit-box;
				-webkit-line-clamp: 2;
				-webkit-box-orient: vertical;
			}
		</style>

		{% if pluginIsActive('rss_export') %}
			<link href="{{ home }}/rss.xml" rel="alternate" type="application/rss+xml" title="RSS"/>
		{% endif %}
		<!-- Подключение jQuery -->
		<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

		<script type="text/javascript" src="{{ scriptLibrary }}/functions.js"></script>
		<script type="text/javascript" src="{{ scriptLibrary }}/ajax.js"></script>
		<title>{{ titles }}</title>
		<script type="text/javascript">
			var locale = "";
		</script>

		<script type="text/javascript">
			var curr = '$',
cartItemsProductsId = ["1035"],
nextCs = '€',
nextCsCond = nextCs == '' ? false : true,
pricePrecision = parseInt(''),
checkProdStock = "", // use in plugin plus minus
inServerCompare = parseInt("0"),
inServerWishList = parseInt("0"),
countViewProd = parseInt("6"),
theme = "http://fluid.imagecmsdemo.net/templates/fluid/",
siteUrl = "http://fluid.imagecmsdemo.net/",
colorScheme = "css/color_scheme_1",
isLogin = "0" === '1' ? true : false,
typePage = "main",
typeMenu = "row";
text = {
search: function (text) {
return 'Введите более' + ' ' + text + ' символов';
},
error: {
notLogin: 'В список желаний могут добавлять только авторизированные пользователи',
fewsize: function (text) {
return 'Выберите размер меньше или равно' + ' ' + text + ' пикселей';
},
enterName: 'Введите название'
}
}

text.inCart = 'В корзине';
text.pc = 'шт.';
text.quant = 'Кол-во:';
text.sum = 'Сумма:';
text.toCart = 'Купить';
text.pcs = 'Количество:';
text.kits = 'Комплектов:';
text.captchaText = 'Код протекции';
text.plurProd = ['товар', 'товара', 'товаров'];
text.plurKits = ['набор', 'набора', 'наборов'];
text.plurComments = ['отзыв', 'отзыва', 'отзывов'];
		</script>

	</head>
	<body>
		{% block body %}
			<div id="loading-layer" style="display: none;">
				Загрузка...
			</div>

			<header class="bg-dark text-white py-3">
				<div class="container-fluid">
					<div
						class="d-flex justify-content-between align-items-center">
						<!-- Левая часть меню -->
						<ul class="list-unstyled d-flex mb-0 align-items-center">
							<li>
								<a href="{{ home }}/static/sposoby-dostavki-tovarov-samovyvoz-adresnaya-dostavka-kurerom-i-dostavka-pochtoi.html" class="text-white text-decoration-none me-3">Доставка</a>

							</li>
							<li>
								<a href="{{ home }}/static/sposoby-oplaty-nalichnymi-pri-poluchenii-i-bankovskoi-kartoi.html" class="text-white text-decoration-none me-3">Оплата</a>

							</li>
							<li>
								<a href="{{ home }}/news" class="text-white text-decoration-none me-3">Новости</a>
							</li>
							<li>
								<a href="{{ home }}/brands" class="text-white text-decoration-none me-3">Бренды</a>
							</li>
							<li>
								<a data-bs-toggle="modal" data-bs-target="#currencyModal" class="text-white text-decoration-none me-3">Валюты</a>

							</li>
						</ul>

						<!-- Правая часть меню -->
						<ul
							class="list-unstyled d-flex mb-0 align-items-center">
							<!-- Избранное -->
							<li class="me-3">
								<a href="{{ home }}/wishlist" class="text-white text-decoration-none">
									<i class="fas fa-heart me-1"></i>
									Избранное
								</a>
							</li>

							{{ callPlugin('eshop.compare', {}) }}

							<!-- Кабинет -->
							<li>
								{% if not (global.flags.isLogged) %}
									<a onclick="location = '{{home}}/login/'">
										<i class="fas fa-user me-1"></i>
										Вход
									</a>
								{% else %}
									<a data-bs-toggle="modal" data-bs-target="#userModal" class="text-white text-decoration-none">
										<i class="fas fa-user me-1"></i>
										Кабинет
									</a>
								{% endif %}
							</li>
						</ul>
					</div>
				</div>
			</header>
			<section class="bg-light py-4">
				<div class="container">
					<div
						class="row align-items-center">
						<!-- Логотип -->
						<div class="col-md-3">
							<a href="{{ home }}" class="text-decoration-none">
								<img src="{{ tpl_url }}/img/logo.png" alt="Логотип магазина" class="img-fluid">

							</a>
						</div>

						<!-- Поле поиска -->
						<div class="col-md-3">
							<form name="search" method="post" action="{{home}}/eshop/search/" class="input-group">
								<input type="text" id="inputString" name="keywords" autocomplete="off" class="form-control" placeholder="Поиск товаров..." aria-label="Search">
								<button class="btn btn-primary" type="submit">
									<i class="fas fa-search"></i>
								</button>
							</form>
						</div>

						<!-- Информационный блок -->
						<div class="col-md-3 info-block text-center">
							{{ system_flags.eshop.description_phones }}

						</div>

						<!-- Корзина -->
						<div class="col-md-3 text-end">
							{{ callPlugin('eshop.total', {}) }}

						</div>
					</div>
				</div>
			</section>
			<!-- Горизонтальное меню -->
			<nav class="navbar navbar-expand-lg navbar-light bg-white border-top border-bottom">

				{{ callPlugin('eshop.show_catz_tree', {}) }}

			</nav>
			{% if isHandler('news:main') %}

				<!-- Баннер -->
				<section class="py-5">
					<div
						id="bannerCarousel" class="carousel slide" data-bs-ride="carousel">
						<!-- Индикаторы карусели -->
						<ol class="carousel-indicators">
							<li data-bs-target="#bannerCarousel" data-bs-slide-to="0" class="active"></li>
							<li data-bs-target="#bannerCarousel" data-bs-slide-to="1"></li>
							<li data-bs-target="#bannerCarousel" data-bs-slide-to="2"></li>
						</ol>

						<!-- Слайды карусели -->
						<div
							class="carousel-inner">
							<!-- Слайд 1 -->
							<div class="carousel-item active">
								<img src="{{ tpl_url }}/img/slider/1.png" class="d-block w-100" alt="Слайд 1">

								<div class="carousel-caption d-none d-md-block">
									<h2>Добро пожаловать в наш магазин!</h2>
									<p class="lead">Здесь вы найдете все необходимое для вашего дома и отдыха.</p>
									<a href="#" class="btn btn-primary btn-lg">Перейти к покупкам</a>
								</div>
							</div>
							<!-- Слайд 2 -->
							<div class="carousel-item">
								<img src="{{ tpl_url }}/img/slider/2.png" class="d-block w-100" alt="Слайд 2">

								<div class="carousel-caption d-none d-md-block">
									<h2>Новые коллекции уже в продаже!</h2>
									<p class="lead">Успейте приобрести товары из новой коллекции по выгодным ценам.</p>
									<a href="#" class="btn btn-primary btn-lg">Посмотреть новинки</a>
								</div>
							</div>
							<!-- Слайд 3 -->
							<div class="carousel-item">
								<img src="{{ tpl_url }}/img/slider/3.png" class="d-block w-100" alt="Слайд 3">

								<div class="carousel-caption d-none d-md-block">
									<h2>Специальные предложения!</h2>
									<p class="lead">Только сегодня скидки до 50% на весь ассортимент.</p>
									<a href="#" class="btn btn-primary btn-lg">Успей купить</a>
								</div>
							</div>
						</div>

						<!-- Кнопки управления каруселью -->
						<button class="carousel-control-prev" type="button" data-bs-target="#bannerCarousel" data-bs-slide="prev">
							<span class="carousel-control-prev-icon" aria-hidden="true"></span>
							<span class="visually-hidden">Previous</span>
						</button>
						<button class="carousel-control-next" type="button" data-bs-target="#bannerCarousel" data-bs-slide="next">
							<span class="carousel-control-next-icon" aria-hidden="true"></span>
							<span class="visually-hidden">Next</span>
						</button>
					</div>
				</section>

				<!-- Каталог товаров -->
				<section class="py-5">
					<div class="container">
						<div class="text-success d-flex align-items-center my-4">
							<hr class="flex-grow-1">
							<h2 class="text-muted mx-3">Популярные товары</h2>
							<hr class="text-success flex-grow-1">
						</div>
						<div id="popularCarousel" class="carousel slide" data-bs-ride="carousel">
							<div class="carousel-inner">
								{{ callPlugin('eshop.show', {'number' : 12, 'mode' : 'stocked', 'template': 'block_eshop'}) }}
							</div>
							<!-- Кнопки управления каруселью -->
							<button class="carousel-control-prev" type="button" data-bs-target="#popularCarousel" data-bs-slide="prev">
								<span class="carousel-control-prev-icon" aria-hidden="true"></span>
								<span class="visually-hidden">Previous</span>
							</button>
							<button class="carousel-control-next" type="button" data-bs-target="#popularCarousel" data-bs-slide="next">
								<span class="carousel-control-next-icon" aria-hidden="true"></span>
								<span class="visually-hidden">Next</span>
							</button>
						</div>
					</div>
				</section>

				<!--Новинки-->
				<section class="py-5bg-light">
					<div class="container">
						<div class="text-success d-flex align-items-center my-4">
							<hr class="flex-grow-1">
							<h2 class="text-muted mx-3">Новинки</h2>
							<hr class="text-success flex-grow-1"></div>

						<div id="newCarousel" class="carousel slide" data-bs-ride="carousel">
							<div class="carousel-inner">
								{{ callPlugin('eshop.show', {'number' : 12, 'mode' : 'last', 'template': 'block_eshop'}) }}
							</div>
							<!-- Кнопки управления каруселью -->
							<button class="carousel-control-prev" type="button" data-bs-target="#newCarousel" data-bs-slide="prev">
								<span class="carousel-control-prev-icon" aria-hidden="true"></span>
								<span class="visually-hidden">Previous</span>
							</button>
							<button class="carousel-control-next" type="button" data-bs-target="#newCarousel" data-bs-slide="next">
								<span class="carousel-control-next-icon" aria-hidden="true"></span>
								<span class="visually-hidden">Next</span>
							</button>
						</div>
					</div>
				</section>

				<!-- Спецпредложения -->
				<section class="py-5">
					<div class="container">
						<div class="text-success d-flex align-items-center my-4">
							<hr class="flex-grow-1">
							<h2 class="text-muted mx-3">Спецпредложения</h2>
							<hr class="text-success flex-grow-1">
						</div>

						<div id="specialCarousel" class="carousel slide" data-bs-ride="carousel">
							<div class="carousel-inner">
								{{ callPlugin('eshop.show', {'number' : 12, 'mode' : 'featured', 'template': 'block_eshop'}) }}
							</div>
							<!-- Кнопки управления каруселью -->
							<button class="carousel-control-prev" type="button" data-bs-target="#specialCarousel" data-bs-slide="prev">
								<span class="carousel-control-prev-icon" aria-hidden="true"></span>
								<span class="visually-hidden">Previous</span>
							</button>
							<button class="carousel-control-next" type="button" data-bs-target="#specialCarousel" data-bs-slide="next">
								<span class="carousel-control-next-icon" aria-hidden="true"></span>
								<span class="visually-hidden">Next</span>
							</button>
						</div>
					</div>
				</section>

				{{ callPlugin('xnews.show', { 'template' : 'xnews1', 'extractEmbeddedItems' : 1, 'count' : '3'}) }}

			{% else %}

				{{ breadcrumbs }}

				{{ mainblock }}
			{% endif %}
			{% if isHandler('news:main') %}
				<div class="container">
					<div id="ViewedProducts"></div>
				</div>
				<script>
					jQuery(document).ready(function () {
if (!document.getElementById('ViewedProducts')) {
console.error('Элемент #ViewedProducts не найден!');
return;
}

var page_stack = br.storage.get('page_stack');
if (page_stack != null) {
var page_stack_str = page_stack.join(",");
rpcEshopRequest('eshop_viewed', {
'action': 'show',
'page_stack': page_stack_str
}, function (resTX) {
if (! resTX || ! resTX['update']) {
console.error('AJAX-ответ пустой или некорректный:', resTX);
return;
}
jQuery('#ViewedProducts').html(resTX['update']);
const viewedCarousel = document.getElementById('viewedCarousel');
if (viewedCarousel) {
new bootstrap.Carousel(viewedCarousel, {interval: false});
} else {
console.error('Элемент #viewedCarousel не найден после обновления контента!');
}
});
}
});
				</script>
			{% endif %}

			<!-- Футер -->
			<footer class="bg-dark text-white py-4">
				<div class="container">
					<div class="row">
						<div class="col-md-4">
							<h5>О нас</h5>
							<p>Мы предлагаем широкий ассортимент товаров для вашего дома и отдыха. Наши цены доступны каждому!</p>
						</div>
						<div class="col-md-4">
							<h5>Контакты</h5>
							<ul class="list-unstyled">
								<li>
									<i class="fas fa-phone me-2"></i>+7 (999) 123-45-67</li>
								<li>
									<i class="fas fa-envelope me-2"></i>info@shop.ru</li>
							</ul>
						</div>
						<div class="col-md-4">
							<h5>Социальные сети</h5>
							<ul class="list-unstyled d-flex">
								<li>
									<a href="#" class="text-white me-3">
										<i class="fab fa-vk"></i>
									</a>
								</li>
								<li>
									<a href="#" class="text-white me-3">
										<i class="fab fa-instagram"></i>
									</a>
								</li>
								<li>
									<a href="#" class="text-white">
										<i class="fab fa-facebook"></i>
									</a>
								</li>
							</ul>
						</div>
					</div>
					<hr class="my-4">
					<p class="text-center mb-0">&copy;
						<a title="{{ home_title }}" href="{{ home }}">{{ home_title }}</a>
						Powered by
						<a title="Next Generation CMS" target="_blank" href="http://ngcms.ru/">NG CMS</a>
						2007
																																																																																																																																																																																															—
						{{ now|date("Y") }}.</p>

				</div>
			</footer>

			<!-- Модальное окно -->
			<div class="modal fade" id="userModal" tabindex="-1" aria-labelledby="userModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div
						class="modal-content">
						<!-- Заголовок модального окна -->
						<div class="modal-header">
							<h5 class="modal-title" id="userModalLabel">Меню пользователя</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<!-- Тело модального окна -->
						<div class="modal-body">
							{% if (global.flags.isLogged) %}
								<ul>
									{% if (global.user.status == 1) %}
										<li>
											<a href="{{admin_url}}">Админка</a>
										</li>
									{% endif %}
									<li>
										<a href="{{home}}/profile.html">Основные данные</a>
									</li>
									<li>
										<a href="{{home}}/logout/">Выход</a>
									</li>
								</ul>
							{% else %}
								<p>Вы не авторизованы.</p>
							{% endif %}
						</div>
						<!-- Подвал модального окна -->
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Закрыть</button>
						</div>
					</div>
				</div>
			</div>
			<!-- Модальное окно -->
			<div class="modal fade" id="currencyModal" tabindex="-1" aria-labelledby="currencyModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div
						class="modal-content">
						<!-- Заголовок модального окна -->
						<div class="modal-header">
							<h5 class="modal-title" id="currencyModalLabel">Выберите валюту</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<!-- Тело модального окна -->
						<div class="modal-body">
							<div class="currency-list">
								{% for cc in system_flags.eshop.currency %}
									<a href="{{ cc.currency_link }}" class="btn btn-light w-100 mb-2 {% if (system_flags.eshop.current_currency.id == cc.id) %}active{% endif %}">
										{{ cc.code }}
									</a>
								{% endfor %}
							</div>
						</div>
						<!-- Подвал модального окна -->
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Закрыть</button>
						</div>
					</div>
				</div>
			</div>
			{{ callPlugin('eshop.notify', {}) }}

			<!-- Подключение Bootstrap JS и Popper.js -->

			<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
			<script src="{{ tpl_url }}/js/compare.js"></script>
			<script src="{{ tpl_url }}/js/united_scripts.js"></script>

			<script type="text/javascript">
				init();
// initDownloadScripts(['united_scripts'], 'init', 'scriptDefer');
			</script>

			<script>

				var variant = "";
var variant_id = "";
var variant_price = "";
var variant_compare_price = "";
var variant_stock = "";

function change_variant(el) {
variant = $(el).attr("value").split('|');
parse_variant_str(variant);

$('.priceVariant').html(variant_price);
$('.addCurrPrice').html(variant_compare_price);
}

function parse_variant_str(variant) {
variant_id = variant[0];
variant_price = variant[1];
variant_compare_price = variant[2];
variant_stock = variant[3];
}

$(document).ready(function () {

$(".orderBut").click(function (e) {
var id = $(this).attr('data-id');
var count = $("input[name='quantity']").attr('value');
if (count == undefined) {
count = 1;
}

if (variant_id == "" || variant_id == undefined) {
variant_id = $(this).attr('data-variant');
}

if (variant_id == "" || variant_id == undefined) {
variant = $("#variantSwitcher").attr('value').split('|');
parse_variant_str(variant);
}

rpcEshopRequest('eshop_ebasket_manage', {
'action': 'add',
'ds': 1,
'id': id,
'count': count,
'variant_id': variant_id
}, function (resTX) {
document.getElementById('tinyBask').innerHTML = resTX['update'];
e.preventDefault();
});
});

$(".btnCompare").click(function (e) {
var id = $(this).attr('data-id');
var bl = $(this);

if (bl.hasClass("active")) {
rpcEshopRequest('eshop_compare', {
'action': 'remove',
'id': id
}, function (resTX) {
bl.removeClass("active");
bl.find(".niceCheck").removeClass("active");
bl.find("input:checkbox").prop('checked', false);
$('.compare-button').html(resTX['update']);
});

} else {
rpcEshopRequest('eshop_compare', {
'action': 'add',
'id': id
}, function (resTX) {
bl.addClass("active");
bl.find(".niceCheck").addClass("active");
bl.find("input:checkbox").prop('checked', true);
$('.compare-button').html(resTX['update']);
});
}
});

$(".deleteFromCompare").click(function (e) {
var id = $(this).attr('data-id');
rpcEshopRequest('eshop_compare', {
'action': 'remove',
'id': id
}, function (resTX) {
location.reload();
});
});

$(".ratebox2").click(function () {

var id = $(this).attr('data-id');
rpcEshopRequest('eshop_likes_result', {
'action': 'do_like',
'id': id
}, function (resTX) {
$(".ratebox2").html(resTX['update']);
});
});

});
			</script>

		{% endblock %}
	</body>
</html>
[debug]
{debug_queries}{debug_profiler}
[/debug]
[/TWIG]

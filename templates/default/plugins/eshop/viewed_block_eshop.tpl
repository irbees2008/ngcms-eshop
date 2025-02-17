{% if entries %}
	<div class="horizontal-carousel">
		<section class="special-proposition frame-view-products py-5">
			<div class="container">
				<div class="text-success d-flex align-items-center my-4">
					<hr class="flex-grow-1">
					<h2 class="text-muted mx-3">Вы уже смотрели</h2>
					<hr class="text-success flex-grow-1">
				</div>
				<div id="viewedCarousel" class="carousel slide">
					<div class="carousel-inner">
						{% set chunked_entries = entries|batch(4) %}
						{% for chunk in chunked_entries %}
							<div class="carousel-item {% if loop.first %}active{% endif %}">
								<div class="row">
									{% for entry in chunk %}
										<div class="col-md-3 mb-4">
											<div
												class="card">
												<!-- Изображение товара -->
												<a href="{{ entry.fulllink }}" class="text-decoration-none">
													<img src="{% if (entry.images[0].filepath) %}{{ home }}/uploads/eshop/products/{{ entry.id }}/thumb/{{ entry.images[0].filepath }}{% else %}{{ home }}/engine/plugins/eshop/tpl/img/img_none.jpg{% endif %}" class="card-img-top" alt="{{ entry.name }}">
												</a>
												<!-- Название товара -->
												<h5 class="card-title text-center mt-2">
													<a href="{{ entry.fulllink }}" class="text-decoration-none text-dark">{{ entry.name }}</a>
												</h5>
												<!-- Цена товара -->
												<div class="card-body">
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
													<!-- Старая цена (если есть) -->
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
												</div>
											</div>
										</div>
									{% endfor %}
								</div>
							</div>
						{% endfor %}
					</div>
					<!-- Кнопки управления каруселью -->
					<button class="carousel-control-prev" type="button" data-bs-target="#viewedCarousel" data-bs-slide="prev">

						<span class="carousel-control-prev-icon" aria-hidden="true"></span>
						<span class="visually-hidden">Previous</span>
					</button>
					<button class="carousel-control-next" type="button" data-bs-target="#viewedCarousel" data-bs-slide="next">

						<span class="carousel-control-next-icon" aria-hidden="true"></span>
						<span class="visually-hidden">Next</span>
					</button>

				</div>
			</div>
		</section>
	</div>
	<script>
		document.addEventListener('DOMContentLoaded', function () {
const viewedCarousel = document.getElementById('viewedCarousel');
if (viewedCarousel) {
new bootstrap.Carousel(viewedCarousel, {
interval: false // Отключаем автопрокрутку
});
}
});
	</script>
{% endif %}

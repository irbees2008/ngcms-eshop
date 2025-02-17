<a href="{{ home }}{{ basket_link }}" class="text-decoration-none">
	<div class="btn-bask pointer">
		<button
			class="btn btn-light d-flex flex-column align-items-center p-3" type="button" style="border-radius: 10px;">
			<!-- Иконка корзины -->
			<i class="fas fa-shopping-cart mb-2" style="font-size: 24px;"></i>
			<!-- Текст "Моя корзина" -->
			<span class="title text-el d-none d-lg-block">Моя корзина</span>
			{% if (count > 0) %}
				<!-- Если в корзине есть товары -->
				<div class="basket-info text-center">
					<span id="basket_count">{{ count }}</span>
					<span>товар</span>
					<span class="divider mx-1">–</span>
					<span id="basket_price">
						{{ (price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}
						{{ system_flags.eshop.current_currency.sign }}
					</span>
				</div>
			{% else %}
				<!-- Если корзина пуста -->
				<div class="basket-info text-center text-muted">пуста</div>
			{% endif %}
		</button>
	</div>
</a>

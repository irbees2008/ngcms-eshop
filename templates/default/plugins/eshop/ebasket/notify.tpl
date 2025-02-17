<!-- Попап "Товар добавлен в корзину" -->
<div class="modal fade" id="popupCart" tabindex="-1" aria-labelledby="popupCartLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div
			class="modal-content">
			<!-- Заголовок -->
			<div class="modal-header">
				<h5 class="modal-title" id="popupCartLabel">Товар добавлен к покупкам</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<!-- Контент -->
			<div class="modal-body">
				<div class="alert alert-success d-flex align-items-center" role="alert">
					<i class="fas fa-check-circle me-2"></i>
					<span>Вы добавили товар в корзину</span>
				</div>
			</div>
			<!-- Футер -->
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Вернуться к покупкам</button>
				<a href="{{ home }}{{ basket_link }}" class="btn btn-primary">
					<i class="fas fa-shopping-cart me-2"></i>Оформить заказ
				</a>
			</div>
		</div>
	</div>
</div>

<!-- Попап "Купить в один клик" -->
<div class="modal fade" id="fastOrderModal" tabindex="-1" aria-labelledby="fastOrderModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div
			class="modal-content">
			<!-- Заголовок -->
			<div class="modal-header">
				<h5 class="modal-title" id="fastOrderModalLabel">Купить в один клик</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<!-- Контент -->
			<div class="modal-body">
				<form id="fastorder-frame">
					<div class="mb-3">
						<label for="name" class="form-label">Имя</label>
						<input type="text" class="form-control" id="name" name="name" value="{{ global.user.xfields_name }}">
					</div>
					<div class="mb-3">
						<label for="phone" class="form-label">Телефон</label>
						<input type="text" class="form-control" id="phone" name="phone" value="{{ global.user.xfields_phone }}">
					</div>
					<div class="mb-3">
						<label for="address" class="form-label">Адрес доставки</label>
						<input type="text" class="form-control" id="address" name="address" value="{{ global.user.xfields_address }}">
					</div>
				</form>
			</div>
			<!-- Футер -->
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
				<button type="button" class="btn btn-primary" id="send_fastorder">
					<i class="fas fa-check me-2"></i>Заказать
				</button>
			</div>
		</div>
	</div>
</div>

<!-- Попап "Сообщить о появлении" -->
<div class="modal fade" id="fastPriceModal" tabindex="-1" aria-labelledby="fastPriceModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div
			class="modal-content">
			<!-- Заголовок -->
			<div class="modal-header">
				<h5 class="modal-title" id="fastPriceModalLabel">Сообщить о появлении</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<!-- Контент -->
			<div class="modal-body">
				<form id="fastprice-frame">
					<div class="mb-3">
						<label for="name" class="form-label">Имя</label>
						<input type="text" class="form-control" id="name" name="name" value="{{ global.user.xfields_name }}">
					</div>
					<div class="mb-3">
						<label for="phone" class="form-label">Телефон</label>
						<input type="text" class="form-control" id="phone" name="phone" value="{{ global.user.xfields_phone }}">
					</div>
					<div class="mb-3">
						<label for="address" class="form-label">Адрес доставки</label>
						<input type="text" class="form-control" id="address" name="address" value="{{ global.user.xfields_address }}">
					</div>
				</form>
			</div>
			<!-- Футер -->
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
				<button type="button" class="btn btn-primary" id="send_fastprice">
					<i class="fas fa-check me-2"></i>Заказать
				</button>
			</div>
		</div>
	</div>
</div>


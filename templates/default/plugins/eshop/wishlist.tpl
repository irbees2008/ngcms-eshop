<div class="container my-4">
	<h3>Список желаний</h3>
	<div class="row">
		{% if wishlist|length > 0 %}
			{% for item in wishlist %}
				<div class="col-md-4 mb-4">
					<div class="card">
						<img src="{{ item.image }}" class="card-img-top" alt="{{ item.name }}">
						<div class="card-body">
							<h5 class="card-title">{{ item.name }}</h5>
							<p class="card-text">{{ item.price }}
								{{ system_flags.eshop.current_currency.sign }}</p>
							<button class="btn btn-danger remove-from-wishlist" data-id="{{ item.id }}">
								<i class="fas fa-trash"></i>
								Удалить
							</button>
						</div>
					</div>
				</div>
			{% endfor %}
		{% else %}
			<p>Ваш список желаний пуст.</p>
		{% endif %}
	</div>
</div>

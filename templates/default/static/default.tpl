<div
	class="container py-5">
	<!-- Заголовок -->
	<h1 class="block-title text-center mb-4">{{ title }}</h1>

	<!-- Основной контент -->
	<div class="content mb-4">
		{{ content }}
	</div>

	<!-- Дополнительные ссылки -->
	<div class="d-flex justify-content-between align-items-center">
		{% if (flags.canEdit) %}
			<a href="{{ edit_static_url }}" class="btn btn-outline-primary">
				<i class="fas fa-edit me-2"></i>
				{{ lang['editstatic'] }}
			</a>
		{% endif %}

		<a href="{{ print_static_url }}" class="btn btn-outline-secondary">
			<i class="fas fa-print me-2"></i>
			{{ lang['printstatic'] }}
		</a>
	</div>
</div>


<article
	class="full-post container py-5">
	<!-- Заголовок статьи -->
	<h1 class="title text-center mb-4">{{ news.title }}</h1>

	<!-- Метаданные -->
	<div class="meta text-muted text-center mb-4">
		{{ news.date }}
		{% if pluginIsActive('uprofile') %}
			|
			<a href="{{ news.author.url }}" class="text-decoration-none">{{ news.author.name }}</a>
		{% else %}
			|
			{{ news.author.name }}
		{% endif %}
	</div>

	<!-- Основной контент -->
	<div class="content mb-4">
		<p>{{ news.short }}{{ news.full }}</p>
	</div>

	<!-- Пагинация -->
	{% if (news.flags.hasPagination) %}
		<nav aria-label="Page navigation" class="mb-4">
			<ul class="pagination justify-content-center">
				{{ news.pagination }}
			</ul>
		</nav>
	{% endif %}

	<!-- Футер статьи -->
	<div
		class="post-full-footer row justify-content-between">
		<!-- Теги -->
		<div class="col-md-6">
			{% if pluginIsActive('tags') and p.tags.flags.haveTags %}
				<div class="post-full-tags text-muted">
					<i class="fas fa-tags me-2"></i>
					{{ lang.tags }}:
					{{ tags }}
				</div>
			{% endif %}
		</div>

		<!-- Просмотры и комментарии -->
		<div class="col-md-6 text-end">
			<div class="post-full-meta text-muted">
				<i class="fas fa-eye me-2"></i>
				{{ lang.views }}:
				{{ news.views }}
				{% if pluginIsActive('comments') %}
					|
					<i class="fas fa-comments me-2"></i>
					{{ lang.com }}: {comments-num}
				{% endif %}
			</div>
		</div>
	</div>

	<!-- Рейтинг -->
	{% if pluginIsActive('rating') %}
		<div class="post-rating text-center mt-4">
			<span class="fw-bold">{{ lang.rating }}:</span>
			<span class="post-rating-inner ms-2">{{ plugin_rating }}</span>
		</div>
	{% endif %}
</article>

<!-- Похожие статьи -->
{% if pluginIsActive('similar') %}
	<div class="container py-4">
		<div class="row">
			<div class="col">
				<h3 class="text-center mb-4">{{ lang.similar }}</h3>
				{{ plugin_similar_tags }}
			</div>
		</div>
	</div>
{% endif %}

<!-- Комментарии -->
{% if pluginIsActive('comments') %}
	<div class="container py-4">
		<div class="row">
			<div class="col">
				<h3 class="text-center mb-4">{{ lang.comments }}
					({comments-num})</h3>
				{{ plugin_comments }}
			</div>
		</div>
	</div>
{% endif %}

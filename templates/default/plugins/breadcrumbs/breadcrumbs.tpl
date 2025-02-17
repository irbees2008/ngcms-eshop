<div class="container">
	<nav aria-label="breadcrumb">
		<ol class="breadcrumb">
			{% for loc in location %}
				<li class="breadcrumb-item">
					<a href="{{ loc.url }}" typeof="v:Breadcrumb">
						<span class="text-el">{{ loc.title }}</span>
					</a>
				</li>
			{% endfor %}
			{% if location_last %}
				<li class="breadcrumb-item active" aria-current="page">
					<span class="text-el">{{ location_last }}</span>
				</li>
			{% endif %}
		</ol>
	</nav>
</div>

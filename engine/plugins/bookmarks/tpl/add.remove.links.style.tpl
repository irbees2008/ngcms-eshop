<div id="bookmarks_{{ product }}" class="btn-bookmark">
	<button type="button" href="{{ link }}" title="{{ link_title }}" onclick="bookmarks('{{ url }}', '{{ product }}', '{{ action }}', {{ isFullProduct ? 'true' : 'false' }}); return false;" class="btnBookmark">
<span class="icon_wish"></span>
		<span class="text-el">
			{% if found %}
				В избранном
			{% else %}
				В избранное
			{% endif %}
		</span>
	</button>
	{% if isFullProduct and counter %}
		<span id="bookmarks_counter_{{ product }}" class="bookmark-counter">({{ counter }})</span>
	{% endif %}
</div>

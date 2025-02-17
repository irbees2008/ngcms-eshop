<div class="block-title">{{ lang['lostpassword'] }}</div>
<form name="lostpassword" action="{{ form_action }}" method="post">
	<input type="hidden" name="type" value="send" />
	{{ entries }} 
	{% if flags.hasCaptcha %}
	<div class="label label-table captcha pull-left">
		<label>{{ lang['captcha'] }}:</label>
		<input type="text" name="vcode" class="input" />
		<img
			src="{{ captcha_source_url }}"
			onclick="reload_captcha();"
			id="img_captcha"
			style="cursor: pointer"
			alt="{{ lang['captcha'] }}" />
		<div class="label-desc">
			{{ lang['captcha_desc'] }}
		</div>
	</div>
	<div class="clearfix"></div>
	<div class="label">
		<input type="submit" value="{{ lang['send_pass'] }}" class="button" />
	</div>
	{% endif %}
</form>
<script type="text/javascript">
	function reload_captcha() {
		var captcha = document.getElementById('img_captcha');

		captcha && (captcha.src = "{{ captcha_source_url }}?rand=" + Math.random());
	}
</script>


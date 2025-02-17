{% if (flags.error) %}
	<div class="alert alert-error">{{ lang['login.error'] }}</div>
{% endif %}

{% if (flags.banned) %}
	<div class="alert alert-info">{{ lang['login.banned'] }}</div>
{% endif %}

{% if (flags.need_activate) %}
	<div class="alert alert-info">{{ lang['login.need_activate'] }}</div>
{% endif %}

<div class="frame-inside page-register">
	<div class="container">
		<div class="f-s_0 title-register without-crumbs">
			<div class="frame-title">
				<h1 class="title">{{ lang['login.title'] }}</h1>
			</div>
		</div>

		<div class="frame-register">
			<form name="login" method="post" action="{{ form_action }}">
				<input type="hidden" name="redirect" value="{{ redirect }}" />
				<div class="horizontal-form">
					<label>
						<span class="title">{{ lang['login.username'] }}:</span>
						<div class="frame-form-field">
							<input type="text" type="text" name="username" class="input" />
						</div>
					</label>
					<label>
						<span class="title">{{ lang['login.password'] }}:</span>
						<div class="frame-form-field">
							<input
								type="password"
								type="password"
								name="password"
								class="input" />
						</div>
					</label>

					<div class="frame-label">
						<span class="title">&nbsp;</span>
						<div class="frame-form-field">
							<div class="btn-form m-b_15">
								<input type="submit" value="{{ lang['login.submit'] }}" />
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>

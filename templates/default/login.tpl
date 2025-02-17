{% if flags.error %}
	<div class="alert alert-danger" role="alert">
		{{ lang['login.error'] }}
	</div>
{% endif %}

{% if flags.banned %}
	<div class="alert alert-info" role="alert">
		{{ lang['login.banned'] }}
	</div>
{% endif %}

{% if flags.need_activate %}
	<div class="alert alert-info" role="alert">
		{{ lang['login.need_activate'] }}
	</div>
{% endif %}

<div class="container py-5">
	<div class="row justify-content-center">
		<div class="col-md-6">
			<div class="card">
				<div class="card-header bg-light text-center">
					<h4 class="mb-0">{{ lang['login.title'] }}</h4>
				</div>
				<div class="card-body">
					<form name="login" method="post" action="{{ form_action }}">
						<input
						type="hidden" name="redirect" value="{{ redirect }}"/>

						<!-- Поле для имени пользователя -->
						<div class="mb-3">
							<label for="username" class="form-label visually-hidden">{{ lang['login.username'] }}</label>
							<div class="input-group">
								<span class="input-group-text">
									<i class="fas fa-user"></i>
								</span>
								<input type="text" id="username" name="username" class="form-control" placeholder="{{ lang['login.username'] }}" required/>
							</div>
						</div>

						<!-- Поле для пароля -->
						<div class="mb-3">
							<label for="password" class="form-label visually-hidden">{{ lang['login.password'] }}</label>
							<div class="input-group">
								<span class="input-group-text">
									<i class="fas fa-lock"></i>
								</span>
								<input type="password" id="password" name="password" class="form-control" placeholder="{{ lang['login.password'] }}" required/>
							</div>
						</div>

						<!-- Кнопка отправки формы -->
						<div class="d-grid">
							<button type="submit" class="btn btn-primary">
								{{ lang['login.submit'] }}
							</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

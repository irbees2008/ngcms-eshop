<script type="text/javascript">

	$(document).ready(function () {
		var registrationValidator = (function () {

			var validateFields = function () {

				$("#reg_login").change(function () {

					if ($('#reg_login').val() == '') {
						$("#reg_login").css({
							"display": "table-cell",
							"background": "#f9f9f9",
							"border": "1px solid #e2e2e2",
							"box-shadow": "inset 2px 3px 3px -2px #e2e2e2"
						});
						$("div#reg_login").html("<span>{{ lang.auth_login_descr }}</span>");
						return;
					}

					$.post('/engine/rpc.php', {
						json: 1,
						methodName: 'core.registration.checkParams',
						rndval: new Date().getTime(),
						params: json_encode({'login': $('#reg_login').val()}),
						dataType: 'json'
					}, function (data) {
						if (typeof data == 'string') {
							resTX = $.parseJSON(data);
						} else {
							resTX = data;
						}
						if (!resTX['status']) {
							alert('Error [' + resTX['errorCode'] + ']: ' + resTX['errorText']);
						} else {
							if ((resTX['data']['login'] > 0) && (resTX['data']['login'] < 100)) {
								$("#reg_login").css("border-color", "#b54d4b");
								$("div#reg_login").html("<span style='color:#b54d4b;'>{{ lang.theme['registration.msg.login_warning'] }}</span>");
							} else {
								$("#reg_login").css("border-color", "#94c37a");
								$("div#reg_login").html("<span style='color:#94c37a;'>{{ lang.theme['registration.msg.login_success'] }}</span>");
							}
						}
					}, "text").error(function () {
						alert('HTTP error during request', 'ERROR');
					});

				});

				$("#reg_email").change(function () {

					if ($('#reg_email').val() == '') {
						$("#reg_email").css({
							"display": "table-cell",
							"background": "#f9f9f9",
							"border": "1px solid #e2e2e2",
							"box-shadow": "inset 2px 3px 3px -2px #e2e2e2"
						});
						$("div#reg_email").html("<span>{{ lang.auth_email_descr }}</span>");
						return;
					}

					$.post('/engine/rpc.php', {
						json: 1,
						methodName: 'core.registration.checkParams',
						rndval: new Date().getTime(),
						params: json_encode({'email': $('#reg_email').val()}),
						dataType: 'json'
					}, function (data) {
						if (typeof data == 'string') {
							resTX = $.parseJSON(data);
						} else {
							resTX = data;
						}
						if (!resTX['status']) {
							alert('Error [' + resTX['errorCode'] + ']: ' + resTX['errorText']);
						} else {
							if ((resTX['data']['email'] > 0) && (resTX['data']['email'] < 100)) {
								$("#reg_email").css("border-color", "#b54d4b");
								$("div#reg_email").html("<span style='color:#b54d4b;'>{{ lang.theme['registration.msg.email_warning'] }}</span>");
							} else {
								$("#reg_email").css("border-color", "#94c37a");
								$("div#reg_email").html("<span style='color:#94c37a;'>{{ lang.theme['registration.msg.email_success'] }}</span>");
							}
						}
					}).error(function () {
						alert('HTTP error during request', 'ERROR');
					});

				});

				$("#reg_password2").change(function () {

					if ($('#reg_password2').val() == '' && $('#reg_password').val() == '') {
						$("#reg_password").css({
							"display": "table-cell",
							"background": "#f9f9f9",
							"border": "1px solid #e2e2e2",
							"box-shadow": "inset 2px 3px 3px -2px #e2e2e2"
						});
						$("#reg_password2").css({
							"display": "table-cell",
							"background": "#f9f9f9",
							"border": "1px solid #e2e2e2",
							"box-shadow": "inset 2px 3px 3px -2px #e2e2e2"
						});
						$("div#reg_password2").html("<span>{{ lang.auth_pass2_descr }}</span>");
						return;
					}

					if ($('#reg_password2').val() != $('#reg_password').val()) {
						$("#reg_password").css("border-color", "#b54d4b");
						$("#reg_password2").css("border-color", "#b54d4b");
						$("div#reg_password2").html("<span style='color:#b54d4b;'>{{ lang.theme['registration.msg.password_warning'] }}</span>");
					} else {
						$("#reg_password").css("border-color", "#94c37a");
						$("#reg_password2").css("border-color", "#94c37a");
						$("div#reg_password2").html("<span style='color:#94c37a;'>{{ lang.theme['registration.msg.password_success'] }}</span>");
					}

				});

				$("#reg_password").change(function () {

					if ($('#reg_password2').val() == '' && $('#reg_password').val() == '') {
						$("#reg_password").css({
							"display": "table-cell",
							"background": "#f9f9f9",
							"border": "1px solid #e2e2e2",
							"box-shadow": "inset 2px 3px 3px -2px #e2e2e2"
						});
						$("#reg_password2").css({
							"display": "table-cell",
							"background": "#f9f9f9",
							"border": "1px solid #e2e2e2",
							"box-shadow": "inset 2px 3px 3px -2px #e2e2e2"
						});
						$("div#reg_password2").html("<span>{{ lang.auth_pass2_descr }}</span>");
						return;
					}
					if ($('#reg_password2').val() != $('#reg_password').val()) {
						$("#reg_password").css("border-color", "#b54d4b");
						$("#reg_password2").css("border-color", "#b54d4b");
						$("div#reg_password2").html("<span style='color:#b54d4b;'>{{ lang.theme['registration.msg.password_warning'] }}</span>");
					} else {
						$("#reg_password").css("border-color", "#94c37a");
						$("#reg_password2").css("border-color", "#94c37a");
						$("div#reg_password2").html("<span style='color:#94c37a;'>{{ lang.theme['registration.msg.password_success'] }}</span>");
					}

				});

			};

			return {
				validateFields: validateFields
			};

		})();

		registrationValidator.validateFields();
	});

</script>

<div
	class="container py-5">
	<!-- Заголовок -->
	<h1 class="block-title text-center mb-4">{{ lang.registration }}</h1>

	<!-- Форма регистрации -->
	<form name="register" action="{{ form_action }}" method="post" onsubmit="return validate();" class="row g-3">
		<input
		type="hidden" name="type" value="doregister"/>

		<!-- Поля формы -->
		{% for entry in entries %}
			<div class="col-md-6">
				<label for="{{ entry.id }}" class="form-label">{{ entry.title }}</label>
				<div class="input-group">
					<span class="input-group-text">
						<i class="fas fa-user"></i>
					</span>
					<span class="form-control">{{ entry.input }}</span>
				</div>
				<small id="{{ entry.id }}" class="form-text text-muted">{{ entry.descr }}</small>
			</div>
		{% endfor %}

		<!-- Капча -->
		{% if flags.hasCaptcha %}
			<div class="col-md-6">
				<label for="reg_capcha" class="form-label">{{ lang.captcha }}</label>
				<div class="input-group mb-3">
					<input id="reg_capcha" type="text" name="vcode" class="form-control" placeholder="{{ lang.captcha }}" required/>
					<span class="input-group-text">
						<img src="{{ admin_url }}/captcha.php" onclick="reload_captcha();" id="img_captcha" style="cursor: pointer;" alt="{{ lang.captcha }}"/>
					</span>
				</div>
				<small class="form-text text-muted">{{ lang.captcha_desc }}</small>
			</div>
		{% endif %}

		<!-- Правила и кнопка отправки -->
		<div class="col-12">
			<div class="form-check mb-3">
				<input type="checkbox" name="agree" id="agree" class="form-check-input" required/>
				<label for="agree" class="form-check-label">{{ lang.theme['registration.rules'] }}</label>
			</div>
			<button type="submit" class="btn btn-primary w-100">{{ lang.register }}</button>
		</div>
	</form>
</div>

<!-- Подключение Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<script type="text/javascript">
	function validate() {
		if (document.register.agree.checked == false) {
			window.alert('{{ lang.theme['registration.check_rules'] }}');
			return false;
		}
		return true;
	}
	function reload_captcha() {
		var captc = document.getElementById('img_captcha');
		if (captc != null) {
			captc.src = "{{ admin_url }}/captcha.php?rand=" + Math.random();
		}
	}
</script>
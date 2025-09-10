<li
	class="globalFrameProduct {% if (entry.variants[0].stock == 0) or (entry.variants[0].stock == 1) %}not-avail{% elseif (entry.variants[0].stock == 5) %}to-cart{% endif %}" data-pos="top" data-equalhorizcell="" style="height: 321px;">
	<!-- Start. Photo & Name product -->
	<a href="{{entry.fulllink}}" class="frame-photo-title">
		<span class="photo-block">
			<span class="helper"></span>
			{% if (entry.images[0].filepath) %}<img src='{{home}}/uploads/eshop/products/{{entry.id}}/thumb/{{entry.images[0].filepath}}' class="vImg">{% else %}<img src='{{home}}/engine/plugins/eshop/tpl/img/img_none.jpg' class="vImg">
			{% endif %}
		</span>
		<span class="title">{{ entry.name }}</span>
	</a>
	<!-- End. Photo & Name product -->
	<div class="description">
		<!-- Start. article & variant name & brand name -->
		<!-- End. article & variant name & brand name -->
		<!--
								                                            <div class="frame-star f-s_0">
								                                            <div class="star">
								                                                <div id="star_rating_1104" class="productRate star-small">
								                                                    <div style="width: 80%"></div>
								                                                </div>
								                                            </div>
								                                            <a href="http://fluid.imagecmsdemo.net/shop/product/mobilnyi-telefon-sony-xperia-v-lt25i-black#comment" class="count-response">
								                                                        14                отзывов            </a>
								                                            </div>
								                                            -->
		<!-- Start. Prices-->
			<div
			class="frame-prices f-s_0"> <!-- Start. Product price-->
			<span class="current-prices f-s_0">
				<span class="price-new">
					<span>
						{% if (entry.variants[0].price) %}
							<span class="price priceVariant">{{ (entry.variants[0].price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}</span>
							{{ system_flags.eshop.current_currency.sign }}
						{% endif %}
					</span>
				</span>
				{% if (not (entry.variants[0].compare_price == '0.00')) and (not (entry.variants[0].compare_price == '')) %}
					<span class="price-add">
						<span>
							<span class="price addCurrPrice">
								<s>{{ (entry.variants[0].compare_price * system_flags.eshop.currency[0].rate_from / system_flags.eshop.current_currency.rate_from)|number_format(2, '.', '') }}</s>
							</span>
							<s>{{ system_flags.eshop.current_currency.sign }}</s>
						</span>
					</span>
				{% endif %}
			</span>
			<!-- End. Product price-->
		</div>
		<!-- End. Prices-->
		<div class="funcs-buttons frame-without-top">
			<div class="no-vis-table">
				{% if (entry.variants[0].stock == 0) or (entry.variants[0].stock == 1) %}
					<div class="js-variant-5834 js-variant">
						<div class="alert-exists">Нет в наличии</div>
						<div class="btn-not-avail">
							<button class="infoBut isDrop" type="button" data-drop=".drop-report"></button>
						</div>
					</div>
				{% elseif (entry.variants[0].stock == 5) %}
					<!-- Start. Collect information about Variants, for future processing -->
					<div class="frame-count-buy js-variant-{{entry.id}} js-variant">
						<div class="btn-buy btn-cart d_n">
							<button type="button" data-id="{{entry.id}}" class="btnBuy">
								<span class="icon_cleaner icon_cleaner_buy"></span>
								<span class="text-el">В корзине</span>
							</button>
						</div>
						<div class="btn-buy">
							<button type="button" class="btnBuy orderBut" data-id="{{entry.id}}">
								<span class="icon_cleaner icon_cleaner_buy"></span>
								<span class="text-el">Купить</span>
							</button>
						</div>
					</div>
					<div class="frame-count-buy js-variant-{{entry.id}} js-variant" style="display:none">
						<div class="btn-buy btn-cart d_n">
							<button type="button" data-id="{{entry.id}}" class="btnBuy">
								<span class="icon_cleaner icon_cleaner_buy"></span>
								<span class="text-el">В корзине</span>
							</button>
						</div>
						<div class="btn-buy">
							<button type="button" class="btnBuy orderBut" data-id="{{entry.id}}">
								<span class="icon_cleaner icon_cleaner_buy"></span>
								<span class="text-el">Купить</span>
							</button>
						</div>
					</div>
				{% endif %}
			</div>
		</div>
		<!-- End. Collect information about Variants, for future processing -->
		<div class="frame-without-top"><!--
												                                            <div class="frame-wish-compare-list no-vis-table">
												                                                <div class="frame-btn-wish js-variant-{{entry.id}} js-variant d_i-b_">
												                                                <div class="btnWish btn-wish btn-wish-in" data-id="{{entry.id}}">
												                                            <button class="toWishlist isDrop" type="button" data-rel="tooltip" data-title="В избранные" data-drop="#wishListPopup" style="display: none;">
												                                                <span class="icon_wish"></span>
												                                                <span class="text-el d_l">В избранные</span>
												                                            </button>
												                                            <button class="inWishlist" type="button" data-rel="tooltip" data-title="В избранныx">
												                                                <span class="icon_wish"></span>
												                                                <span class="text-el d_l">В избранныx</span>
												                                            </button>
												                                        </div>
												                                        <script>
												                                        langs["Create list"] = 'Создать список';
												                                        langs["Wrong list name"] = 'Неверное имя списка';
												                                        langs["Already in Wish List"] = 'Уже в Списке Желаний';
												                                        langs["List does not chosen"] = 'Список не обран';
												                                        langs["Limit of Wish List finished "] = 'Лимит списков пожеланий исчерпан';
												                                        </script>    </div>
												                                                <div class="frame-btn-wish js-variant-{{entry.id}} js-variant d_i-b_" style="display:none">
												                                                <div class="btnWish btn-wish" data-id="{{entry.id}}">
												                                            <button class="toWishlist isDrop" type="button" data-rel="tooltip" data-title="В избранные" data-drop="#wishListPopup" >
												                                                <span class="icon_wish"></span>
												                                                <span class="text-el d_l">В избранные</span>
												                                            </button>
												                                            <button class="inWishlist" type="button" data-rel="tooltip" data-title="В избранныx" style="display: none;">
												                                                <span class="icon_wish"></span>
												                                                <span class="text-el d_l">В избранныx</span>
												                                            </button>
												                                        </div>
												                                        <script>
												                                        langs["Create list"] = 'Создать список';
												                                        langs["Wrong list name"] = 'Неверное имя списка';
												                                        langs["Already in Wish List"] = 'Уже в Списке Желаний';
												                                        langs["List does not chosen"] = 'Список не обран';
												                                        langs["Limit of Wish List finished "] = 'Лимит списков пожеланий исчерпан';
												                                        </script>    </div>
												                                            </div>
												                                        -->
			<!-- End. Wish List & Compare List buttons -->
		</div>
		<!-- End. Collect information about Variants, for future processing -->
	</div>
	<!-- Start. Remove buttons if compare-->
	<button type="button" class="icon_times deleteFromCompare" data-id="{{entry.id}}"></button>
	<!-- End. Remove buttons if compare-->
	<!-- Start. For wishlist page-->
	<!-- End. For wishlist page--><div class="decor-element"> </div>
</li>

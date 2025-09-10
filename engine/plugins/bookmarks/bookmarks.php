<?php
/*
 * bookmarks for NextGeneration CMS (http://ngcms.ru/)
 * Copyright (C) 2010 Alexey N. Zhukov (http://digitalplace.ru)
 * http://digitalplace.ru
 *
 * code based on kt2k's plugin
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 */
# protect against hack attempts
if (!defined('NGCMS')) die ('HAL');
add_act('index', 'bookmarks_view');
add_act('index', 'bookmarks_init_vars');
register_plugin_page('bookmarks', 'modify', 'bookmarks_t', 0);
register_plugin_page('bookmarks', '', 'bookmarksPage', 0);
global $lang;
LoadPluginLang('bookmarks', 'main', '', '', ':');
$bookmarks_script = '
<script type="text/javascript">
	function futu_alert(header, text, close, className) {
		if (!document.getElementById(\'futu_alerts_holder\')) {
			var futuAlertOuter = document.createElement(\'div\');
			futuAlertOuter.className = \'futu_alert_outer\';
			document.body.appendChild(futuAlertOuter);
			var futuAlertFrame = document.createElement(\'div\');
			futuAlertFrame.className = \'frame\';
			futuAlertOuter.appendChild(futuAlertFrame);
			var futuAlertsHolder = document.createElement(\'div\');
			futuAlertsHolder.id = \'futu_alerts_holder\';
			futuAlertsHolder.className = \'futu_alerts_holder\';
			futuAlertFrame.appendChild(futuAlertsHolder);
		}
		var futuAlert = document.createElement(\'div\');
		futuAlert.className = \'futu_alert \' + className;
		document.getElementById(\'futu_alerts_holder\').appendChild(futuAlert);
		futuAlert.id = \'futu_alert\';
		var futuAlertHeader = document.createElement(\'div\');
		futuAlertHeader.className = \'futu_alert_header\';
		futuAlert.appendChild(futuAlertHeader);
		futuAlertHeader.innerHTML = header;
		if (close) {
			var futuAlertCloseButton = document.createElement(\'a\');
			futuAlertCloseButton.href = \'#\';
			futuAlertCloseButton.className = \'futu_alert_close_button\';
			futuAlertCloseButton.onclick = function(ev) {
				if(!ev) {
					ev=window.event;
				}
				if (!document.all) ev.preventDefault(); else ev.returnValue = false;
				document.getElementById(\'futu_alerts_holder\').removeChild(futuAlert);
			}
			futuAlert.appendChild(futuAlertCloseButton);
			var futuAlertCloseButtonIcon = document.createElement(\'img\');
			futuAlertCloseButtonIcon.src = \'/engine/plugins/bookmarks/img/btn_close.gif\';
			futuAlertCloseButton.appendChild(futuAlertCloseButtonIcon);
		}
		var futuAlertText = document.createElement(\'div\');
		futuAlertText.className = \'futu_alert_text\';
		futuAlert.appendChild(futuAlertText);
		futuAlertText.innerHTML = text;
		futuAlert.style.position = \'relative\';
		futuAlert.style.top = \'0\';
		futuAlert.style.display = \'block\';
		if (!close) {
			/* addEvent("click",function(){
				document.getElementById(\'futu_alerts_holder\').removeChild(futuAlert);
			}, document.getElementById(\'futu_alert\'));*/
			setTimeout(function () { document.getElementById(\'futu_alerts_holder\').removeChild(futuAlert); }, 3000);
		}
	}
	function bookmarks(url, product, action, isFullProduct) {
    var ajaxBookmarks = new sack();
    ajaxBookmarks.onShow("");
    ajaxBookmarks.onComplete = function() {
        if(ajaxBookmarks.response == "limit") {
            futu_alert("' . $lang['bookmarks:msg_title'] . '", "' . $lang['bookmarks:err_add_limit'] . '", true, "message");
        }
										else if(ajaxBookmarks.response == "notlogged"){
											futu_alert("' . $lang['bookmarks:msg_title'] . '", "' . $lang['bookmarks:err_notlogged'] . '", true, "error");
										}
										else if(ajaxBookmarks.response == "err_add"){
											futu_alert("' . $lang['bookmarks:msg_title'] . '", "' . $lang['bookmarks:err_add'] . '", true, "error");
										} else {
											elementObj = document.getElementById("bookmarks_" + product);
											elementObj.innerHTML = ajaxBookmarks.response;
											elementObj = document.getElementById("bookmarks_counter_" + product);
											if(ajaxBookmarks.response.indexOf("<!-- add -->") != -1){
												futu_alert("' . $lang['bookmarks:msg_title'] . '", "' . $lang['bookmarks:msg_add'] . '", false, "save");
											}
											else{
												futu_alert("' . $lang['bookmarks:msg_title'] . '", "' . $lang['bookmarks:msg_delete'] . '", false, "save");
											}
										}
									};
    ajaxBookmarks.setVar("product", product);
    ajaxBookmarks.setVar("action", action);
    ajaxBookmarks.setVar("ajax", true);
    ajaxBookmarks.setVar("isFullProduct", isFullProduct ? "1" : "0");
    ajaxBookmarks.requestFile = url;
    ajaxBookmarks.method = "GET";
    ajaxBookmarks.runAJAX();
}
</script>';
register_htmlvar('plain', $bookmarks_script);
$tpath = locatePluginTemplates(array(':bookmarks.css'), 'bookmarks', intval(pluginGetVariable('bookmarks', 'localsource')));
register_stylesheet($tpath['url::bookmarks.css'] . '/bookmarks.css');
/* declare variables to be global
 * bookmarksLoaded - flag is bookmarks already loaded
 * bookmarksList   - result of $mysql -> select
 */
global $bookmarksLoaded, $bookmarksList;
$bookmarksLoaded = 0;
$bookmarksList = array();
# generate links for add/remove bookmark for eshop products
function bookmarks_eshop_show($product_id, $product_data) {
	global $lang, $bookmarksLoaded, $bookmarksList, $userROW, $tpl, $mysql, $twig, $template;
	
	# определяем пути к шаблонам
	$tpath = locatePluginTemplates(array('add.remove.links.style', 'not.logged.links'), 'bookmarks', pluginGetVariable('bookmarks', 'localsource'));
	
	# если пользователь не авторизован
	if (!is_array($userROW)) {
		if (pluginGetVariable('bookmarks', 'counter')) {
			$tVars['counter'] = $mysql->result('SELECT COUNT(*) FROM ' . prefix . '_bookmarks WHERE product_id=' . $product_id);
			$tVars['counter'] = $tVars['counter'] ? $tVars['counter'] : '';
			$tVars['isFullProduct'] = true;
			$tVars['isShortProduct'] = false;
			$xg = $twig->loadTemplate($tpath['not.logged.links'] . 'not.logged.links.tpl');
			$template['vars']['plugin_bookmarks_product'] = $xg->render($tVars);
		} else {
			$template['vars']['plugin_bookmarks_product'] = '';
		}
		return;
	}
	
	# загружаем закладки пользователя
	if (!$bookmarksLoaded)
		bookmarks_sql();
		
	# проверяем, есть ли товар в закладках
	$found = 0;
	foreach ($bookmarksList as $brow) {
		if ($brow['id'] == $product_id) {
			$found = 1;
			break;
		}
	}
	
	# генерируем ссылку
	$link = generatePluginLink('bookmarks', 'modify', array(), array('product' => $product_id, 'action' => ($found ? 'delete' : 'add')));
	$url = generatePluginLink('bookmarks', 'modify');
	
	$tVars = array(
		'product' => $product_id,
		'action' => ($found ? 'delete' : 'add'),
		'link' => $link,
		'found' => $found,
		'url' => $url,
		'link_title' => ($found ? $lang['bookmarks:title_delete'] : $lang['bookmarks:title_add']),
		'isFullProduct' => true,
		'isShortProduct' => false
	);
	
	# генерируем счетчик
	if (pluginGetVariable('bookmarks', 'counter')) {
		$tVars['counter'] = $mysql->result('SELECT COUNT(*) FROM ' . prefix . '_bookmarks WHERE product_id=' . $product_id);
		$tVars['counter'] = $tVars['counter'] ? $tVars['counter'] : '';
	} else {
		$tVars['counter'] = '';
	}
	
	$xg = $twig->loadTemplate($tpath['add.remove.links.style'] . 'add.remove.links.style.tpl');
	$template['vars']['plugin_bookmarks_product'] = $xg->render($tVars);
}

# регистрируем хук для показа товара
add_act('eshop:show', 'bookmarks_eshop_show');
# function for fetching SQL bookmarks data
function bookmarks_sql()
{
	global $mysql, $config, $userROW, $bookmarksLoaded, $bookmarksList;
	$bookmarksLoaded = 1;
	if ($userROW['id']) {
		$bookmarksList = $mysql->select("SELECT p.id, p.name as title, p.url as alt_name, p.annotation, p.body as content FROM " . prefix . "_bookmarks AS b LEFT JOIN " . prefix . "_eshop_products p ON p.id = b.product_id WHERE b.user_id = " . db_squote($userROW['id']));
	}
}
class BookmarksCoreFilter extends CoreFilter
{
	function showUserMenu(&$tVars)
	{
		global $mysql, $userROW, $template;
		if (!is_array($userROW)) {
			$template['vars']['plugin_bookmarks_all'] = array(
				'link' => '',
				'count' => 0
			);
			return;
		}
		$count = $mysql->result('SELECT COUNT(*) FROM ' . prefix . '_bookmarks WHERE user_id = ' . db_squote($userROW['id']));
		$bookmarks_link = generatePluginLink('bookmarks', null);
		$tVars['p']['bookmarks'] = [
			'count' => $count ?: 0,
			'link'  => $bookmarks_link
		];


	}
}
register_filter('core.userMenu', 'bookmarks', new BookmarksCoreFilter);
# initialize bookmarks variables
function bookmarks_init_vars()
{
	global $template, $mysql, $userROW;
	
	// Создаем переменную plugin_bookmarks_all для всех пользователей
	if (is_array($userROW)) {
		$bookmarks_count = $mysql->result('SELECT COUNT(*) FROM ' . prefix . '_bookmarks WHERE user_id = ' . db_squote($userROW['id']));
		$bookmarks_link = generatePluginLink('bookmarks', null);
	} else {
		$bookmarks_count = 0;
		$bookmarks_link = '';
	}
	$template['vars']['plugin_bookmarks_all'] = array(
		'link' => $bookmarks_link,
		'count' => $bookmarks_count
	);
}

# view bookmarks on sidebar
function bookmarks_view()
{
	global $template, $tpl, $lang, $mysql, $config, $parse, $userROW, $bookmarksLoaded, $bookmarksList, $twig;
	if (!pluginGetVariable('bookmarks', 'sidebar')) {
		$template['vars']['plugin_bookmarks'] = '';
		return;
	}
	$cacheFileName = md5('bookmarks' . $config['theme'] . $config['default_lang']) . $userROW['id'] . '.txt';
	if (pluginGetVariable('bookmarks', 'cache')) {
		$cacheData = cacheRetrieveFile($cacheFileName, pluginGetVariable('bookmarks', 'cacheExpire'), 'bookmarks');
		if ($cacheData != false) {
			$template['vars']['plugin_bookmarks'] = $cacheData;
			return;
		}
	}
	$tpath = locatePluginTemplates(array('entries', 'bookmarks'), 'bookmarks', pluginGetVariable('bookmarks', 'localsource'));
	$maxlength = intval(pluginGetVariable('bookmarks', 'maxlength')) ?: 100;
	if (!$bookmarksLoaded && pluginGetVariable('bookmarks', 'sidebar'))
		bookmarks_sql();
	$result = array();
	$count = 0;
	foreach ($bookmarksList as $row) {
		$count++;
		if ($count > intval(pluginGetVariable('bookmarks', 'max_sidebar'))) break;
		// Получаем изображение товара
		$imageRow = $mysql->record("SELECT filepath FROM " . prefix . "_eshop_images WHERE product_id = " . $row['id'] . " ORDER BY position LIMIT 1");
		$image = '';
		if ($imageRow) {
			$image = $config['home_url'] . '/uploads/eshop/products/' . $row['id'] . '/thumb/' . $imageRow['filepath'];
		}
		
		$title = (strlen($row['title']) > $maxlength) ?
			substr(secure_html($row['title']), 0, $maxlength) . "..." :
			secure_html($row['title']);
			
		// Генерируем ссылку на товар
		$link = checkLinkAvailable('eshop', 'show') ?
			generateLink('eshop', 'show', array('alt' => $row['alt_name'])) :
			generateLink('core', 'plugin', array('plugin' => 'eshop', 'handler' => 'show'), array('alt' => $row['alt_name']));
			
		$result[] = array(
			'link' => $link,
			'title' => $title,
			'image' => $image
		);
	}
	if ((!$count) && pluginGetVariable('bookmarks', 'hide_empty')) {
		if (pluginGetVariable('bookmarks', 'cache')) {
			cacheStoreFile($cacheFileName, ' ', 'bookmarks');
		}
		$template['vars']['plugin_bookmarks'] = '';

		return;
	}
	$tVars = array(
		'tpl_url' => tpl_url,
		'entries' => $result,
		'bookmarks_page' => generatePluginLink('bookmarks', null),
		'count' => $count
	);
	$xt = $twig->loadTemplate($tpath['bookmarks'] . 'bookmarks.tpl');
	$output = $xt->render($tVars);
	if (pluginGetVariable('bookmarks', 'cache')) {
		cacheStoreFile($cacheFileName, $output, 'bookmarks');
	}
	$template['vars']['plugin_bookmarks'] = $output;
	


}
# personal plugin pages for add/remove bookmarks
function bookmarks_t() {
	global $mysql, $config, $userROW, $HTTP_REFERER, $SUPRESS_TEMPLATE_SHOW, $tpl, $lang, $bookmarksList, $bookmarksLoaded, $template, $twig, $handler;
	# product ID
	$productID = intval($_GET['product']);
	$ajax = $_GET['ajax'];
	# при определении $isFullProduct используйте:
	$isFullProduct = isset($_GET['isFullProduct']) ? intval($_GET['isFullProduct']) : 0;
	# process bookmarks only for logged in users
	if (!is_array($userROW)) {
		if ($ajax) die('notlogged');
		# Redirect UNREG users far away :)
		header('Location: ' . $config['home_url'] . '');
		return;
	}
	if (!$bookmarksLoaded)
		$count_list = $mysql->result('SELECT COUNT(*) FROM ' . prefix . '_bookmarks WHERE user_id = ' . db_squote($userROW['id']));
	else
		$count_list = count($bookmarksList);
	# for return reverse action
	$action = '';
	# add action
	if ($_GET['action'] == 'add') {
		# check limits
		if (intval(pluginGetVariable('bookmarks', 'bookmarks_limit')) < $count_list + 1) {
			if ($ajax) die("limit");
			else {
				# determine paths for template files
				$tpath = locatePluginTemplates(array('bookmarks.page'), 'bookmarks', pluginGetVariable('bookmarks', 'localsource'));
				$tvars['vars']['all_bookmarks'] = '';
				$tvars['vars']['no_bookmarks'] = $lang['bookmarks:err_add_limit'];
				$tpl->template('bookmarks.page', $tpath['bookmarks.page']);
				$tpl->vars('bookmarks.page', $tvars);
				$template['vars']['mainblock'] = $tpl->show('bookmarks.page');
				return;
			}
		}
		# check that this product exists & we didn't bookmarked this product earlier
		if (count($mysql->select("SELECT id FROM " . prefix . "_eshop_products WHERE id = " . $productID)) &&
			(!count($mysql->select("SELECT * FROM " . prefix . '_bookmarks WHERE user_id = ' . db_squote($userROW['id']) . " AND product_id=" . $productID)))
		) {
			# ok, bookmark it
			$mysql->query("INSERT INTO `" . prefix . "_bookmarks` (`user_id`,`product_id`) VALUES (" . db_squote($userROW['id']) . "," . db_squote($productID) . ")");
			$action = 'delete';
		} else die('err_add');
		# delete action
	} elseif ($_GET['action'] == 'delete') {
		$mysql->query("DELETE FROM `" . prefix . "_bookmarks` WHERE `user_id`=" . db_squote($userROW['id']) . " AND `product_id`=" . db_squote($productID));
		$action = 'add';
	}
	# if cache is activated - truncate cache file [ to clear cache ]
	if (pluginGetVariable('bookmarks', 'cache')) {
		$cacheFileName = md5('bookmarks' . $config['theme'] . $config['default_lang']) . $userROW['id'] . '.txt';
		cacheStoreFile($cacheFileName, '', 'bookmarks');
	}
	# make redirection back if not-ajax mode
	if (!$ajax) {
		header("Location: " . ($HTTP_REFERER ? $HTTP_REFERER : $config['home_url']));
		return;
	}
	$SUPRESS_TEMPLATE_SHOW = 1;
	# generate link
	$link = generatePluginLink('bookmarks', 'modify', array(), array('product' => $productID, 'action' => $action));
	$url = generatePluginLink('bookmarks', 'modify');
	# determine paths for template files
	$tpath = locatePluginTemplates(array('ajax.add.remove.links.style'), 'bookmarks', pluginGetVariable('bookmarks', 'localsource'));
	$tVars = array(
		'product' => $productID,
		'action' => $action,
		'link' => $link,
		'url' => $url,
		'link_title' => ($action == 'delete' ? $lang['bookmarks:title_delete'] : $lang['bookmarks:title_add']),
		'isFullProduct' => $isFullProduct,
		'isShortProduct' => !$isFullProduct,
		'counter' => pluginGetVariable('bookmarks', 'counter') ? $mysql->result('SELECT COUNT(*) FROM ' . prefix . '_bookmarks WHERE product_id=' . $productID) : ''
	);
	$isFullProduct = isset($_GET['isFullProduct']) ? intval($_GET['isFullProduct']) : (isHandler('eshop:show') ? 1 : 0);
	$tVars['isFullProduct'] = $isFullProduct;
	# generate counter [if requested]
	if (pluginGetVariable('bookmarks', 'counter')) {
		$tVars['counter'] = $mysql->result('SELECT COUNT(*) FROM ' . prefix . '_bookmarks WHERE product_id=' . $productID);
		$tVars['counter'] = $tVars['counter'] ? $tVars['counter'] : '';
	} else $tVars['counter'] = '';
	$xt = $twig->loadTemplate($tpath['ajax.add.remove.links.style'] . 'ajax.add.remove.links.style.tpl');
	header("Content-Type: text/html; charset=utf-8");
	echo $xt->render($tVars) . ($action == 'delete' ? '<!-- add -->' : '<!-- delete -->');
}
# personal plugin pages for display all user's bookmarks
function bookmarksPage() {
    global $SYSTEM_FLAGS, $lang, $userROW, $bookmarksLoaded, $bookmarksList, $template, $config, $tpl, $twig, $mysql;
    if (!is_array($userROW)) {
        header('Location: ' . $config['home_url']);
        return;
    }
    if (!$bookmarksLoaded)
        bookmarks_sql();
    $tpath = locatePluginTemplates(array('bookmarks.page', 'news.short'), 'bookmarks', pluginGetVariable('bookmarks', 'localsource'));
    $SYSTEM_FLAGS['info']['title']['group'] = $lang['bookmarks:pp_title'];
    if (!count($bookmarksList)) {
        $template['vars']['mainblock'] = $lang['bookmarks:nobookmarks'];
        return;
    }
    
    // Получаем товары из закладок
    $products = array();
    foreach ($bookmarksList as $brow) {
        // Получаем изображение товара
        $imageRow = $mysql->record("SELECT filepath FROM " . prefix . "_eshop_images WHERE product_id = " . $brow['id'] . " ORDER BY position LIMIT 1");
        $image = '';
        if ($imageRow) {
            $image = $config['home_url'] . '/uploads/eshop/products/' . $brow['id'] . '/thumb/' . $imageRow['filepath'];
        }
        
        // Генерируем ссылку на товар
        $link = checkLinkAvailable('eshop', 'show') ?
            generateLink('eshop', 'show', array('alt' => $brow['alt_name'])) :
            generateLink('core', 'plugin', array('plugin' => 'eshop', 'handler' => 'show'), array('alt' => $brow['alt_name']));
            
        $products[] = array(
            'id' => $brow['id'],
            'title' => $brow['title'],
            'link' => $link,
            'image' => $image,
            'annotation' => $brow['annotation']
        );
    }
    
    $tVars = array(
        'products' => $products,
        'count' => count($bookmarksList),
        'tpl_url' => tpl_url,
        'all_bookmarks' => ''
    );
    
    // Генерируем HTML для списка товаров используя шаблон product.short
    if (count($products) > 0) {
        $productHtml = '';
        $productTemplate = $twig->loadTemplate($tpath['news.short'] . 'news.short.tpl');
        foreach ($products as $product) {
            // Генерируем кнопку закладки для товара
            bookmarks_eshop_show($product['id'], array());
            
            $productVars = array(
                'entry' => array(
                    'id' => $product['id'],
                    'name' => $product['title'],
                    'fulllink' => $product['link'],
                    'images' => array(array('filepath' => basename($product['image']))),
                    'variants' => array(array('stock' => 5, 'price' => 0, 'compare_price' => ''))
                ),
                'home' => $config['home_url'],
                'tpl_url' => tpl_url,
                'plugin_bookmarks_product' => $template['vars']['plugin_bookmarks_product']
            );
            $productHtml .= $productTemplate->render($productVars);
        }
        $tVars['all_bookmarks'] = $productHtml;
    }
    
    $xt = $twig->loadTemplate($tpath['bookmarks.page'] . 'bookmarks.page.tpl');
    $template['vars']['mainblock'] = $xt->render($tVars);
}

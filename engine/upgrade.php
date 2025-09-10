<?php
/**
 * Инструмент обновления базы данных NGCMS
 *
 * @copyright Copyright (C) 2008-2025 Next Generation CMS (http://ngcms.ru/)
 * @license MIT
 */
@include_once 'core.php';
// Матрица обновлений
$upgradeMatrix = [
    1 => [
        "INSERT IGNORE INTO " . prefix . "_config (name, value) VALUES ('database.engine.revision', '1')",
    ],
    2 => [
        "ALTER TABLE " . prefix . "_news ADD COLUMN content_delta TEXT AFTER content",
        "ALTER TABLE " . prefix . "_news ADD COLUMN content_source INT DEFAULT 0 AFTER content_delta",
        "UPDATE " . prefix . "_config SET value = 2 WHERE name = 'database.engine.revision'",
        "UPDATE " . prefix . "_config SET value = '" . engineVersion . "' WHERE name = 'database.engine.version'",
    ],
    3 => [
        "ALTER TABLE " . prefix . "_news DROP COLUMN content_delta",
        "ALTER TABLE " . prefix . "_news DROP COLUMN content_source",
        "UPDATE " . prefix . "_config SET value = 3 WHERE name = 'database.engine.revision'",
    ],
    4 => [
        "UPDATE " . prefix . "_config SET value = 4 WHERE name = 'database.engine.revision'",
    ],
    5 => [
        "UPDATE " . prefix . "_config SET value = 5 WHERE name = 'database.engine.revision'",
    ],
    6 => [
        // Меняем тип поля обратно на MEDIUMTEXT (оптимальный вариант)
        "ALTER TABLE " . prefix . "_news MODIFY xfields MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci",
        // Восстанавливаем поврежденные данные
        "UPDATE " . prefix . "_news SET xfields = REPLACE(xfields, 'SER[a:', 'SER|a:') WHERE xfields LIKE 'SER[a:%'",
        "UPDATE " . prefix . "_news SET xfields = '' WHERE xfields LIKE 'SER|a:%' AND xfields NOT LIKE '%}'",
        "UPDATE " . prefix . "_config SET value = 6 WHERE name = 'database.engine.revision'",
    ],
    7 => [
        "UPDATE " . prefix . "_config SET value = 7 WHERE name = 'database.engine.revision'",
    ],
];
// Получаем текущую версию БД
$currentVersion = getCurrentDBVersion();
// Проверяем необходимость обновления
if ($currentVersion < minDBVersion) {
    echo renderUpgradeHeader($currentVersion, minDBVersion);
    doUpgrade($currentVersion + 1, minDBVersion);
} else {
    // Проверяем и восстанавливаем plugdata.php если нужно (одноразовая операция)
    checkAndRepairPlugdataFile($currentVersion);
    echo renderNoUpgradeNeeded();
}
/**
 * Проверяет и восстанавливает файл plugdata.php если нужно
 */
function checkAndRepairPlugdataFile($currentVersion): void
{
    // Выполняем восстановление только если версия БД >= 7 (после основных обновлений)
    // и только один раз
    if ($currentVersion >= 7) {
        $repairDone = checkRepairStatus();
        if (!$repairDone) {
            echo "<div style='max-width:1000px; margin:20px auto; padding:20px; background:#f8f9fa; border-radius:5px;'>";
            echo "<h3>Проверка файла настроек плагинов</h3>";
            repairPlugdataFile();
            markRepairAsDone();
            echo "</div>";
        }
    }
}
/**
 * Проверяет, было ли уже выполнено восстановление
 */
function checkRepairStatus(): bool
{
    $db = NGEngine::getInstance()->getDB();
    try {
        $result = $db->record(
            "SELECT value FROM " . prefix . "_config WHERE name = 'plugdata.repair.done'"
        );
        return is_array($result) && $result['value'] == '1';
    } catch (Exception $e) {
        // Если таблицы нет или произошла ошибка, считаем что восстановление не делалось
        return false;
    }
}
/**
 * Помечает восстановление как выполненное
 */
function markRepairAsDone(): void
{
    $db = NGEngine::getInstance()->getDB();
    try {
        $db->exec(
            "INSERT INTO " . prefix . "_config (name, value) VALUES ('plugdata.repair.done', '1')
             ON DUPLICATE KEY UPDATE value = '1'"
        );
    } catch (Exception $e) {
        // Игнорируем ошибки при записи статуса
    }
}
/**
 * Получает текущую версию БД
 */
function getCurrentDBVersion(): int
{
    $db = NGEngine::getInstance()->getDB();
    try {
        $versionRecord = $db->record(
            "SELECT * FROM " . prefix . "_config WHERE name = 'database.engine.revision'"
        );
        return is_array($versionRecord) ? (int)$versionRecord['value'] : 0;
    } catch (Exception $e) {
        return 0;
    }
}
/**
 * Выполняет обновление БД
 */
function doUpgrade(int $fromVersion, int $toVersion): void
{
    global $upgradeMatrix;
    $db = NGEngine::getInstance()->getDB();
    // Временное разрешение проблемных дат
    $db->exec("SET SQL_MODE='ALLOW_INVALID_DATES'");
    for ($version = $fromVersion; $version <= $toVersion; $version++) {
        echo "<div class='upgrade-step'>";
        echo "<h3><i class='icon-version'></i> Обновление до версии {$version}</h3>";
        echo "<div class='step-actions'>";
        if ($version == 5) {
            // Выполняем конвертацию кодировки
            echo "<h4>Конвертация базы данных в UTF-8 (utf8mb4)</h4>";
            convertDatabaseEncodingToUtf8mb4($db);
        } else {
            // Специальная логика для определенных версий
            if ($version == 7) {
                // Обновление плагина комментариев - ДОБАВЛЯЕМ ПОЛЕ moderated
                echo "<h4>Обновление плагина комментариев</h4>";
                $commentsTable = prefix . '_comments';
                try {
                    $tableExistsResult = $db->query("SHOW TABLES LIKE '{$commentsTable}'");
                    $tableExists = false;
                    if (is_array($tableExistsResult)) {
                        $tableExists = count($tableExistsResult) > 0;
                    } elseif ($tableExistsResult) {
                        $tableExists = $tableExistsResult->rowCount() > 0;
                    }
                    if ($tableExists) {
                        echo "<div class='action'><div class='status'>Таблица комментариев `{$commentsTable}` найдена.</div></div>";
                        // Проверяем наличие поля 'moderated'
                        if (!columnExists($db, $commentsTable, 'moderated')) {
                            executeSqlWithReporting($db, "ALTER TABLE `{$commentsTable}` ADD `moderated` TINYINT(1) NOT NULL DEFAULT '1'");
                            echo "<div class='action'><div class='success'>Поле 'moderated' успешно добавлено</div></div>";
                        } else {
                            echo "<div class='action'><div class='skipped'>Поле 'moderated' уже существует.</div></div>";
                        }
                    } else {
                        echo "<div class='action'><div class='skipped'>Плагин комментариев не установлен (таблица `{$commentsTable}` не найдена). Обновление пропущено.</div></div>";
                    }
                } catch (Exception $e) {
                    echo "<div class='action'><div class='status error'>Ошибка при обновлении плагина комментариев: " . htmlspecialchars($e->getMessage()) . "</div></div>";
                }
            }
            // Стандартная обработка для других версий
            if (!empty($upgradeMatrix[$version])) {
                foreach ($upgradeMatrix[$version] as $sql) {
                    executeSqlWithReporting($db, $sql);
                }
            }
            // В функции doUpgrade, внутри блока версии 7, после repairPlugdataFile():
            if ($version == 7) {
                echo "<h4>Восстановление файла настроек плагинов</h4>";
                repairPlugdataFile();
                // ДОБАВЛЯЕМ НОВЫЙ КОД ЗДЕСЬ:
                echo "<h4>Обновление конфигурационного файла</h4>";
                updateConfigFile();
            }
        }
        echo "</div></div>";
    }
    // Восстановление стандартного режима SQL
    $db->exec("SET SQL_MODE=''");
    echo renderSuccessMessage();
    renderFooter();
}
/**
 * Обновляет конфигурационный файл, добавляя параметр admin_skin если его нет
 */
function updateConfigFile(): void
{
    $configFile = confroot . 'config.php';
    echo "<div class='action'>";
    echo "<div class='status'>Проверка конфигурационного файла: " . htmlspecialchars($configFile) . "</div>";
    if (!file_exists($configFile)) {
        echo "<div class='skipped'>Файл конфигурации не существует</div>";
        echo "</div>";
        return;
    }
    // Читаем содержимое файла
    $content = file_get_contents($configFile);
    // Проверяем, существует ли уже параметр admin_skin
    if (strpos($content, "'admin_skin'") !== false) {
        echo "<div class='skipped'>Параметр 'admin_skin' уже существует</div>";
        echo "</div>";
        return;
    }
    // Ищем позицию строки 'theme'
    $themePos = strpos($content, "'theme'");
    if ($themePos === false) {
        echo "<div class='error'>Параметр 'theme' не найден в конфигурационном файле</div>";
        echo "</div>";
        return;
    }
    // Находим конец строки с theme (ищем запятую)
    $endPos = strpos($content, "',", $themePos);
    if ($endPos === false) {
        // Если нет запятой, ищем закрывающую кавычку
        $endPos = strpos($content, "'", $themePos + 7);
    }
    if ($endPos === false) {
        echo "<div class='error'>Не удалось определить конец строки 'theme'</div>";
        echo "</div>";
        return;
    }
    // Вставляем новую строку после theme
    $newContent = substr_replace($content, ",\n  'admin_skin' => 'default'", $endPos + 1, 0);
    // Создаем резервную копию
    $backupFile = $configFile . '.backup_' . date('Ymd_His');
    file_put_contents($backupFile, $content);
    // Записываем обновленное содержимое
    if (file_put_contents($configFile, $newContent)) {
        echo "<div class='success'>Параметр 'admin_skin' => 'default' успешно добавлен после 'theme'</div>";
        echo "<div class='status'>Резервная копия: " . basename($backupFile) . "</div>";
    } else {
        echo "<div class='error'>Ошибка записи в файл конфигурации</div>";
    }
    echo "</div>";
}
/**
 * Восстанавливает файл plugdata.php
 */
function repairPlugdataFile(): void
{
    $plugdataFile = confroot . 'plugdata.php';
    echo "<div class='action'>";
    echo "<div class='status'>Проверка файла: " . htmlspecialchars($plugdataFile) . "</div>";
    // Если файла нет - просто выходим, не создаем новый
    if (!file_exists($plugdataFile)) {
        echo "<div class='skipped'>Файл не существует. Плагины будут использовать настройки по умолчанию.</div>";
        echo "</div>";
        return;
    }
    $content = file_get_contents($plugdataFile);
    $content = trim($content);
    // Проверка на BOM
    if (substr($content, 0, 3) === "\xEF\xBB\xBF") {
        $content = substr($content, 3);
        echo "<div class='status'>Обнаружен и удален BOM</div>";
    }
    // Пробуем десериализовать
    $data = @unserialize($content);
    if (is_array($data)) {
        echo "<div class='success'>Файл корректный, восстановление не требуется</div>";
    } else {
        echo "<div class='error'>Файл поврежден, пытаемся восстановить...</div>";
        // Пробуем восстановить
        $repaired = repairSerializedData($content);
        if ($repaired !== $content) {
            // Проверяем восстановленные данные
            $testData = @unserialize($repaired);
            if (is_array($testData)) {
                // Создаем резервную копию
                $backupFile = $plugdataFile . '.backup_' . date('Ymd_His');
                file_put_contents($backupFile, $content);
                // Сохраняем исправленную версию
                file_put_contents($plugdataFile, $repaired);
                echo "<div class='success'>Файл успешно восстановлен! Резервная копия: " . basename($backupFile) . "</div>";
            } else {
                echo "<div class='error'>Автоматическое восстановление не удалось. Файл остался без изменений.</div>";
            }
        } else {
            echo "<div class='error'>Не удалось восстановить автоматически. Файл остался без изменений.</div>";
        }
    }
    echo "</div>";
}
/**
 * Восстанавливает сериализованные данные
 */
function repairSerializedData($data)
{
    // 1. Убираем лишние символы в начале/конце
    $data = trim($data);
    // 2. Проверяем корректность структуры
    if (substr($data, 0, 2) !== 'a:') {
        // Пробуем найти начало массива
        if (preg_match('/a:\d+:\{/', $data, $matches, PREG_OFFSET_CAPTURE)) {
            $startPos = $matches[0][1];
            $data = substr($data, $startPos);
        } else {
            return $data;
        }
    }
    // 3. Исправляем некорректные длины строк
    $data = preg_replace_callback('/s:(\d+):"([^"]*)";/', function ($matches) {
        $correctLength = strlen($matches[2]);
        return 's:' . $correctLength . ':"' . $matches[2] . '";';
    }, $data);
    // 4. Исправляем проблемы с кодировкой
    if (function_exists('mb_convert_encoding')) {
        $data = mb_convert_encoding($data, 'UTF-8', 'UTF-8');
    }
    // 5. Исправляем распространенные проблемы с сериализацией NGCMS
    $data = str_replace('SER[a:', 'SER|a:', $data);
    return $data;
}
/**
 * Получает тип столбца
 */
function getColumnType($db, $table, $column): string
{
    $result = $db->record(
        "SELECT COLUMN_TYPE FROM information_schema.columns
        WHERE table_schema = DATABASE()
        AND table_name = '{$table}'
        AND column_name = '{$column}'"
    );
    return $result['COLUMN_TYPE'] ?? '';
}
/**
 * Конвертирует кодировку базы данных в utf8mb4
 */
function convertDatabaseEncodingToUtf8mb4($db): void
{
    echo "<div class='action'><div class='status'>Начало конвертации в utf8mb4...</div></div>";
    // 1. Отключаем строгий режим MySQL
    executeSqlWithReporting($db, "SET SESSION sql_mode = 'NO_ENGINE_SUBSTITUTION'");
    try {
        // 2. Получаем имя базы данных
        $dbName = '';
        $result = $db->query("SELECT DATABASE() AS dbname");
        if (is_array($result)) {
            $dbName = $result[0]['dbname'] ?? '';
        } else {
            $row = $result->fetch(PDO::FETCH_ASSOC);
            $dbName = $row['dbname'] ?? '';
        }
        if (empty($dbName)) {
            throw new Exception("Не удалось определить имя базы данных");
        }
        echo "<div class='action'><div class='status'>Обнаружена база: {$dbName}</div></div>";
        // 3. Изменяем кодировку всей базы
        executeSqlWithReporting($db, "ALTER DATABASE `{$dbName}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
        // 4. Получаем список всех таблиц
        $tables = [];
        $result = $db->query("SHOW TABLES");
        if (is_array($result)) {
            foreach ($result as $row) {
                $tables[] = reset($row);
            }
        } else {
            while ($row = $result->fetch(PDO::FETCH_NUM)) {
                $tables[] = $row[0];
            }
        }
        // 5. Обрабатываем таблицу ng_tags_tmp_export отдельно
        if (in_array('ng_tags_tmp_export', $tables)) {
            echo "<div class='action'>";
            echo "<h4>Обработка временной таблицы тегов: ng_tags_tmp_export</h4>";
            // Проверяем существование индекса 'tag'
            $indexExists = false;
            $indexResult = $db->query("SHOW INDEX FROM `ng_tags_tmp_export` WHERE Key_name = 'tag'");
            if (is_array($indexResult)) {
                $indexExists = !empty($indexResult);
            } else {
                $indexExists = $indexResult->rowCount() > 0;
            }
            // Удаляем уникальный индекс если существует
            if ($indexExists) {
                executeSqlWithReporting($db, "ALTER TABLE `ng_tags_tmp_export` DROP INDEX `tag`");
                echo "<div class='success'>Уникальный индекс 'tag' удален</div>";
            }
            // Удаляем дубликаты тегов (более надежный способ)
            try {
                // Создаем временную таблицу с уникальными тегами
                executeSqlWithReporting($db, "CREATE TEMPORARY TABLE temp_unique_tags AS
            SELECT MIN(id) as min_id, tag, COUNT(*) as cnt
            FROM ng_tags_tmp_export
            GROUP BY tag
            HAVING COUNT(*) > 1");
                // Показываем информацию о дубликатах
                $dupResult = $db->query("SELECT COUNT(*) as duplicate_count FROM temp_unique_tags");
                $dupCount = 0;
                if (is_array($dupResult)) {
                    $dupCount = $dupResult[0]['duplicate_count'] ?? 0;
                } else {
                    $dupRow = $dupResult->fetch(PDO::FETCH_ASSOC);
                    $dupCount = $dupRow['duplicate_count'] ?? 0;
                }
                echo "<div class='status'>Найдено дубликатов: {$dupCount}</div>";
                if ($dupCount > 0) {
                    // Удаляем дубликаты, оставляя только первую запись
                    executeSqlWithReporting($db, "DELETE t1 FROM ng_tags_tmp_export t1
                INNER JOIN temp_unique_tags t2 ON t1.tag = t2.tag
                WHERE t1.id != t2.min_id");
                    echo "<div class='success'>Дубликаты удалены</div>";
                }
                // Удаляем временную таблицу
                executeSqlWithReporting($db, "DROP TEMPORARY TABLE temp_unique_tags");
            } catch (Exception $e) {
                echo "<div class='skipped'>Ошибка при удалении дубликатов: " . htmlspecialchars($e->getMessage()) . "</div>";
                // Продолжаем выполнение даже если не удалось удалить дубликаты
            }
            // Конвертируем таблицу
            executeSqlWithReporting($db, "ALTER TABLE `ng_tags_tmp_export` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            // Восстанавливаем уникальный индекс (если он был)
            if ($indexExists) {
                try {
                    // Проверяем, что нет дубликатов перед созданием индекса
                    $dupCheck = $db->query("SELECT COUNT(*) as total, COUNT(DISTINCT tag) as unique_count FROM ng_tags_tmp_export");
                    $checkData = [];
                    if (is_array($dupCheck)) {
                        $checkData = $dupCheck[0] ?? [];
                    } else {
                        $checkData = $dupCheck->fetch(PDO::FETCH_ASSOC);
                    }
                    $total = $checkData['total'] ?? 0;
                    $unique = $checkData['unique_count'] ?? 0;
                    if ($total == $unique) {
                        executeSqlWithReporting($db, "ALTER TABLE `ng_tags_tmp_export` ADD UNIQUE INDEX `tag` (`tag`)");
                        echo "<div class='success'>Уникальный индекс 'tag' восстановлен</div>";
                    } else {
                        echo "<div class='skipped'>Не удалось восстановить уникальный индекс: остались дубликаты тегов</div>";
                        // Создаем обычный индекс вместо уникального
                        executeSqlWithReporting($db, "ALTER TABLE `ng_tags_tmp_export` ADD INDEX `tag` (`tag`)");
                        echo "<div class='success'>Создан обычный индекс 'tag'</div>";
                    }
                } catch (Exception $e) {
                    echo "<div class='skipped'>Не удалось восстановить индекс: " . htmlspecialchars($e->getMessage()) . "</div>";
                }
            }
            echo "<div class='success'>Таблица успешно конвертирована</div>";
            echo "</div>";
            // Удаляем обработанную таблицу из списка
            $tables = array_diff($tables, ['ng_tags_tmp_export']);
        }
        // 6. Обрабатываем остальные таблицы
        foreach ($tables as $tableName) {
            echo "<div class='action'>";
            echo "<h4>Обработка таблицы: {$tableName}</h4>";
            try {
                // Проверяем целостность таблицы
                $checkResult = $db->query("CHECK TABLE `{$tableName}");
                $needsRepair = false;
                if (is_array($checkResult)) {
                    foreach ($checkResult as $row) {
                        if (stripos($row['Msg_text'], 'corrupt') !== false || stripos($row['Msg_text'], 'error') !== false) {
                            $needsRepair = true;
                            break;
                        }
                    }
                } else {
                    while ($row = $checkResult->fetch(PDO::FETCH_ASSOC)) {
                        if (stripos($row['Msg_text'], 'corrupt') !== false || stripos($row['Msg_text'], 'error') !== false) {
                            $needsRepair = true;
                            break;
                        }
                    }
                }
                if ($needsRepair) {
                    echo "<div class='status'>Обнаружены проблемы, попытка восстановления...</div>";
                    $db->exec("REPAIR TABLE `{$tableName}");
                }
                // Проверяем наличие поля xfields
                $hasXfields = columnExists($db, $tableName, 'xfields');
                if ($hasXfields) {
                echo "<div class='status'>Обнаружено поле xfields - особая обработка</div>";
                // Шаг 1: Определяем текущий тип поля
                $currentType = getColumnType($db, $tableName, 'xfields');
                // Шаг 2: Сохраняем данные во временную таблицу
                $backupTable = "backup_{$tableName}_xfields";
                executeSqlWithReporting($db, "CREATE TEMPORARY TABLE `{$backupTable}` AS SELECT id, xfields FROM `{$tableName}` WHERE xfields != ''");
                // Шаг 3: Конвертируем таблицу
                executeSqlWithReporting($db, "ALTER TABLE `{$tableName}` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
                // Шаг 4: Восстанавливаем MEDIUMTEXT тип для xfields (не LONGTEXT!)
                if (stripos($currentType, 'longtext') === false) {
                    executeSqlWithReporting($db, "ALTER TABLE `{$tableName}` MODIFY `xfields` MEDIUMTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
                }
                // Шаг 5: Восстанавливаем данные (скрываем детали обработки)
                $result = $db->query("SELECT COUNT(*) as total FROM `{$backupTable}`");
                $totalCount = 0;
                if (is_array($result)) {
                    $totalCount = $result[0]['total'] ?? 0;
                } else {
                    $row = $result->fetch(PDO::FETCH_ASSOC);
                    $totalCount = $row['total'] ?? 0;
                }
                echo "<div class='status'>Обработка {$totalCount} записей с полем xfields...</div>";
                $processed = 0;
                $errors = 0;
                $result = $db->query("SELECT id, xfields FROM `{$backupTable}`");
                $data = is_array($result) ? $result : $result->fetchAll(PDO::FETCH_ASSOC);
                foreach ($data as $row) {
                    $processed++;
                    if (!empty($row['xfields'])) {
                        $xfields = $row['xfields'];
                        // Проверяем целостность сериализованных данных
                        if (strpos($xfields, 'SER|a:') === 0) {
                            if (substr($xfields, -1) !== '}' || !preg_match('/^SER\|a:\d+:\{/', $xfields)) {
                                $xfields = ''; // Очищаем поврежденные данные
                            }
                        }
                        try {
                            $escapedXfields = addslashes($xfields);
                            $id = (int)$row['id'];
                            $sql = "UPDATE `{$tableName}` SET xfields = '{$escapedXfields}' WHERE id = {$id}";
                            $db->exec($sql);
                        } catch (Exception $e) {
                            $errors++;
                            // Выводим ошибку только если она произошла
                            echo "<div class='error'>Ошибка при обработке записи ID {$id}: " . htmlspecialchars($e->getMessage()) . "</div>";
                        }
                    }
                }
                // Показываем итоги обработки
                if ($errors > 0) {
                    echo "<div class='error'>Обработано записей: {$processed}, ошибок: {$errors}</div>";
                } else {
                    echo "<div class='success'>Успешно обработано {$processed} записей</div>";
                }
                // Шаг 6: Удаляем временную таблицу
                executeSqlWithReporting($db, "DROP TEMPORARY TABLE `{$backupTable}`");
                echo "<div class='success'>Данные xfields восстановлены (MEDIUMTEXT)</div>";
            } else {
                // 7. Проверяем текущую кодировку таблицы
                $createResult = $db->query("SHOW CREATE TABLE `{$tableName}`");
                $createTable = '';
                if (is_array($createResult)) {
                    $createTable = $createResult[0]['Create Table'] ?? $createResult[0][1] ?? '';
                } else {
                    $createRow = $createResult->fetch(PDO::FETCH_NUM);
                    $createTable = $createRow[1] ?? '';
                }
                if (strpos($createTable, 'CHARSET=utf8mb4') !== false) {
                    echo "<div class='skipped'>Таблица уже в utf8mb4, пропускаем</div>";
                    echo "</div>";
                    continue;
                }
                // 8. Конвертируем таблицу
                try {
                    executeSqlWithReporting($db, "ALTER TABLE `{$tableName}` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
                } catch (Exception $e) {
                    if (strpos($e->getMessage(), "Can't find record") !== false) {
                        echo "<div class='status'>Попытка альтернативного способа конвертации...</div>";
                        include_once 'convertTableAlternative.php';
                        convertTableAlternative($db, $tableName);
                    } else {
                        throw $e;
                    }
                }
            }
            // 9. Обрабатываем проблемные столбцы (только для таблиц без xfields)
            if (!$hasXfields) {
                $columns = $db->query("SHOW FULL COLUMNS FROM `{$tableName}`");
                $columnsData = [];
                if (is_array($columns)) {
                    $columnsData = $columns;
                } else {
                    $columnsData = $columns->fetchAll(PDO::FETCH_ASSOC);
                }
                foreach ($columnsData as $col) {
                    $field = $col['Field'] ?? $col[0];
                    // Пропускаем проблемные поля
                    if (in_array($field, ['nsched_activate', 'nsched_deactivate'])) {
                        echo "<div class='skipped'>Пропускаем поле: {$field}</div>";
                        continue;
                    }
                    $type = $col['Type'] ?? $col[1];
                    // Уменьшаем длину индексированных VARCHAR столбцов
                    if (preg_match('/varchar\((\d+)\)/i', $type, $matches)) {
                        $length = (int)$matches[1];
                        if ($length > 191) {
                            $indexes = $db->query("SHOW INDEX FROM `{$tableName}` WHERE Column_name = '{$field}'");
                            $hasIndex = false;
                            if (is_array($indexes)) {
                                $hasIndex = !empty($indexes);
                            } else {
                                $hasIndex = $indexes->rowCount() > 0;
                            }
                            if ($hasIndex) {
                                $newType = str_replace("varchar({$length})", "varchar(191)", $type);
                                executeSqlWithReporting(
                                    $db,
                                    "ALTER TABLE `{$tableName}` MODIFY `{$field}` {$newType} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
                                );
                            }
                        }
                    }
                }
            }
                echo "<div class='success'>Таблица успешно конвертирована</div>";
            } catch (Exception $e) {
                echo "<div class='error'>Ошибка обработки таблицы {$tableName}: " . htmlspecialchars($e->getMessage()) . "</div>";
                // Пытаемся альтернативный способ для проблемных таблиц
                if (strpos($e->getMessage(), "Can't find record") !== false) {
                    echo "<div class='status'>Попытка альтернативного способа конвертации...</div>";
                    try {
                        include_once 'convertTableAlternative.php';
                        convertTableAlternative($db, $tableName);
                        echo "<div class='success'>Таблица {$tableName} конвертирована альтернативным способом</div>";
                    } catch (Exception $e2) {
                        echo "<div class='error'>Альтернативный способ не удался: " . htmlspecialchars($e2->getMessage()) . "</div>";
                    }
                }
            }
            echo "</div>";
        }
        // 10. Обновляем версию базы данных до 5
        executeSqlWithReporting($db, "UPDATE " . prefix . "_config SET value = '5' WHERE name = 'database.engine.revision'");
        executeSqlWithReporting($db, "UPDATE " . prefix . "_config SET value = '" . engineVersion . "' WHERE name = 'database.engine.version'");
        echo "<div class='action'><div class='status success'>Конвертация базы {$dbName} успешно завершена! Версия базы обновлена до 5.</div></div>";
    } catch (Exception $e) {
        echo "<div class='action'><div class='status error'>Ошибка: " . htmlspecialchars($e->getMessage()) . "</div></div>";
        throw $e;
    }
}
/**
 * Выполняет SQL запрос с подробным отчетом
 */
function executeSqlWithReporting($db, $sql): void
{
    echo "<div class='action'>";
    echo "<div class='sql-query'><code>" . htmlspecialchars($sql) . "</code></div>";
    echo "<div class='status'>";
    try {
        $result = $db->exec($sql);
        if ($result === null) {
            throw new Exception("Ошибка выполнения запроса");
        }
        echo "<span class='success'><i class='icon-success'></i> Успешно</span>";
    } catch (Exception $e) {
        echo "<span class='error'><i class='icon-error'></i> Ошибка: " . htmlspecialchars($e->getMessage()) . "</span>";
        echo "</div></div>";
        throw $e;
    }
    echo "</div></div>";
}
/**
 * Проверяет существование столбца
 */
function columnExists($db, $table, $column): bool
{
    $result = $db->record(
        "SELECT COUNT(*) AS cnt FROM information_schema.columns
        WHERE table_schema = DATABASE()
        AND table_name = '{$table}'
        AND column_name = '{$column}'"
    );
    return $result && $result['cnt'] > 0;
}
/**
 * Шапка страницы обновления
 */
function renderUpgradeHeader(int $current, int $target): string
{
    return <<<HTML
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Обновление базы данных NGCMS</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                line-height: 1.6;
                color: #333;
                background: #f5f7fa;
                padding: 20px;
                max-width: 1000px;
                margin: 0 auto;
            }
            .header {
                background: #2c3e50;
                color: white;
                padding: 20px;
                border-radius: 5px;
                margin-bottom: 30px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .upgrade-step {
                background: white;
                border-radius: 5px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .step-actions {
                margin-top: 15px;
            }
            .action {
                padding: 10px;
                margin-bottom: 10px;
                border-left: 4px solid #eee;
            }
            .sql-query {
                font-family: Consolas, Monaco, 'Andale Mono', monospace;
                font-size: 14px;
                color: #555;
                margin-bottom: 5px;
            }
            .status {
                font-weight: 500;
            }
            .success {
                color: #27ae60;
            }
            .skipped {
                color: #f39c12;
            }
            .error {
                color: #e74c3c;
            }
            .icon-success:before {
                content: "✓";
                margin-right: 5px;
            }
            .icon-skip:before {
                content: "↷";
                margin-right: 5px;
            }
            .icon-error:before {
                content: "✗";
                margin-right: 5px;
            }
            .icon-version:before {
                content: "➤";
                margin-right: 10px;
                color: #3498db;
            }
            .btn {
                display: inline-block;
                background: #3498db;
                color: white;
                padding: 10px 20px;
                text-decoration: none;
                border-radius: 5px;
                font-weight: 500;
                margin-top: 20px;
                transition: background 0.3s;
            }
            .btn:hover {
                background: #2980b9;
            }
            .success-message {
                background: #27ae60;
                color: white;
                padding: 20px;
                border-radius: 5px;
                text-align: center;
                margin-top: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>Обновление базы данных NGCMS</h1>
            <p>Текущая версия: {$current} → Новая версия: {$target}</p>
        </div>
    HTML;
}
/**
 * Сообщение об успешном завершении
 */
function renderSuccessMessage(): string
{
    return <<<HTML
    <div class="success-message">
        <h2><i class="icon-success"></i> Обновление успешно завершено!</h2>
        <p>База данных была успешно обновлена до последней версии.</p>
        <a href="/engine/" class="btn">Перейти на сайт</a>
    </div>
    HTML;
}
/**
 * Сообщение, что обновление не требуется
 */
function renderNoUpgradeNeeded(): string
{
    return <<<HTML
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <title>Обновление не требуется</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                line-height: 1.6;
                color: #333;
                background: #f5f7fa;
                padding: 20px;
                max-width: 1000px;
                margin: 0 auto;
                text-align: center;
            }
            .message {
                background: #27ae60;
                color: white;
                padding: 30px;
                border-radius: 5px;
                margin: 50px auto;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                max-width: 600px;
            }
            .btn {
                display: inline-block;
                background: #3498db;
                color: white;
                padding: 12px 25px;
                text-decoration: none;
                border-radius: 5px;
                font-weight: 500;
                margin-top: 20px;
                transition: background 0.3s;
            }
            .btn:hover {
                background: #2980b9;
            }
        </style>
    </head>
    <body>
        <div class="message">
            <h2>База данных актуальна</h2>
            <p>Ваша база данных уже имеет последнюю версию. Обновление не требуется.</p>
            <a href="admin.php" class="btn">Перейти в панель управления</a>
        </div>
    </body>
    </html>
    HTML;
}
/**
 * Подвал страницы с кнопкой
 */
function renderFooter(): void
{
    echo <<<HTML
        <div style="text-align: center; margin-top: 30px;">
            <a href="admin.php" class="btn">
                <i class="icon-admin"></i> Перейти в панель управления
            </a>
        </div>
    </body>
    </html>
    HTML;
}

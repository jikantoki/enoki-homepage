<?php

/**
 * リポジトリのルート
 */
if (!defined('DIR_ROOT')) {
    define('DIR_ROOT', ($_SERVER['DOCUMENT_ROOT'] ?? '') . (defined('DIRECTORY_NAME') ? DIRECTORY_NAME : ''));
}

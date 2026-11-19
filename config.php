<?php
define('DB_HOST', 'localhost');
define('DB_NAME', 'illuminos');
define('DB_USER', 'root');
define('DB_PASS', '');

$conn = mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);
if (!$conn) die("Ошибка подключения: " . mysqli_connect_error());
mysqli_set_charset($conn, "utf8mb4");

function db_query($sql) { global $conn; return mysqli_query($conn, $sql); }
function db_fetch_all($sql) { $res = db_query($sql); return $res ? mysqli_fetch_all($res, MYSQLI_ASSOC) : []; }
function db_fetch_one($sql) { $res = db_query($sql); return $res ? mysqli_fetch_assoc($res) : null; }
function db_escape($str) { global $conn; return mysqli_real_escape_string($conn, $str); }

if (session_status() === PHP_SESSION_NONE) { session_start(); }

function is_logged_in() { return isset($_SESSION['user_id']); }
function is_admin() { return isset($_SESSION['role']) && $_SESSION['role'] === 'admin'; }
function redirect($url) { header("Location: $url"); exit; }

function get_all_content() { return db_fetch_all("SELECT c.*, cat.name AS cat FROM content c LEFT JOIN categories cat ON c.category_id=cat.id ORDER BY c.id DESC"); }
function get_movies() { return db_fetch_all("SELECT c.*, cat.name AS cat FROM content c LEFT JOIN categories cat ON c.category_id=cat.id WHERE c.type='movie' ORDER BY c.rating DESC"); }
function get_series() { return db_fetch_all("SELECT c.*, cat.name AS cat FROM content c LEFT JOIN categories cat ON c.category_id=cat.id WHERE c.type='series' ORDER BY c.rating DESC"); }
function get_content_by_id($id) { $id = (int)$id; return db_fetch_one("SELECT c.*, cat.name AS cat FROM content c LEFT JOIN categories cat ON c.category_id=cat.id WHERE c.id=$id"); }
function get_categories() { return db_fetch_all("SELECT * FROM categories ORDER BY id"); }
function get_tariffs() { return db_fetch_all("SELECT * FROM tariffs ORDER BY price"); }

function search_content($q) {
    $q = db_escape($q);
    return db_fetch_all("SELECT c.*, cat.name AS cat FROM content c LEFT JOIN categories cat ON c.category_id=cat.id WHERE c.title LIKE '%$q%' ORDER BY c.rating DESC");
}

function get_seasons($content_id) { $content_id = (int)$content_id; return db_fetch_all("SELECT * FROM seasons WHERE content_id=$content_id ORDER BY season_number"); }
function get_episodes($season_id) { $season_id = (int)$season_id; return db_fetch_all("SELECT * FROM episodes WHERE season_id=$season_id ORDER BY episode_number"); }
function get_people($content_id) { $cget_youtube_embedontent_id = (int)$content_id; return db_fetch_all("SELECT p.* FROM people p JOIN content_people cp ON p.id=cp.person_id WHERE cp.content_id=$content_id"); }

// Функция для конвертации ссылки YouTube в плеер
function get_youtube_embed($url) {
    if (!$url) return '';
    
    // Если админ уже вставил готовый iframe, возвращаем как есть
    if (strpos($url, '<iframe') !== false) return $url;

    // === ОБРАБОТКА YOUTUBE ===
    if (strpos($url, 'youtube.com') !== false || strpos($url, 'youtu.be') !== false) {
        preg_match('%(?:youtube(?:-nocookie)?\.com/(?:[^/]+/.+/|(?:v|e(?:mbed)?)/|.*[?&]v=)|youtu\.be/)([^"&?/ ]{11})%i', $url, $match);
        $video_id = $match[1] ?? '';
        if ($video_id) {
            return '<iframe width="100%" height="100%" src="https://www.youtube.com/embed/'.$video_id.'" frameborder="0" allowfullscreen></iframe>';
        }
    }

    // === ОБРАБОТКА RUTUBE ===
    if (strpos($url, 'rutube.ru') !== false) {
        // Пытаемся вытащить ID видео из разных вариантов ссылок
        // Примеры: 
        // https://rutube.ru/video/5b9fff01830c429d50fcbb99c535d29a/
        // https://rutube.ru/play/embed/5b9fff01830c429d50fcbb99c535d29a
        preg_match('/rutube\.ru\/(?:video|play\/embed)\/([a-z0-9]+)/i', $url, $match);
        $video_id = $match[1] ?? '';
        
        if ($video_id) {
            // Формируем правильный iframe для Rutube с нужными атрибутами
            return '<iframe width="100%" height="100%" src="https://rutube.ru/play/embed/'.$video_id.'" frameBorder="0" allow="clipboard-write; autoplay" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>';
        }
    }

    // Если ссылка не распознана, возвращаем как есть (на случай прямого iframe)
    return $url;
}
?>
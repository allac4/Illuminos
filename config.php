// Функция для конвертации ссылок YouTube и Rutube в плеер
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

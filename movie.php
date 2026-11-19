<?php
require_once 'config.php';
$id = (int)($_GET['id'] ?? 0);
$item = get_content_by_id($id);
if (!$item) die('Контент не найден');

if (isset($_POST['fav']) && is_logged_in()) {
    $uid = (int)$_SESSION['user_id'];
    db_query("INSERT IGNORE INTO favorites (user_id, content_id) VALUES ($uid, $id)");
    redirect("movie.php?id=$id");
}
if (is_logged_in()) {
    $uid = (int)$_SESSION['user_id'];
    db_query("INSERT INTO watch_history (user_id, content_id) VALUES ($uid, $id)");
}

$seasons = $item['type'] === 'series' ? get_seasons($id) : [];
$people = get_people($id);
$similar = db_fetch_all("SELECT id,title,poster,rating,year FROM content WHERE type='{$item['type']}' AND category_id={$item['category_id']} AND id!=$id ORDER BY rating DESC LIMIT 4");

$pageTitle = $item['title'];
require_once 'header.php';
?>
<div class="detail">
    <div class="detail__poster">
        <img src="<?= htmlspecialchars($item['poster']) ?>" alt="<?= htmlspecialchars($item['title']) ?>">
    </div>
    <div>
        <h1 class="detail__title"><?= htmlspecialchars($item['title']) ?></h1>
        <div class="detail__meta">
            <span class="detail__rating"><svg class="icon" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg> <?= $item['rating'] ?></span>
            <span><?= $item['year'] ?></span>
            <span><?= htmlspecialchars($item['cat'] ?? '') ?></span>
            <span><?= $item['type'] === 'series' ? 'Сериал' : 'Фильм' ?></span>
            <?php if ($item['duration'] > 0): ?><span><?= $item['duration'] ?> мин.</span><?php endif; ?>
        </div>
        <p class="detail__desc"><?= nl2br(htmlspecialchars($item['description'])) ?></p>
        <div class="detail__actions">
            <a href="#trailer" class="btn btn-primary"><svg class="icon" viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg> Смотреть</a>
            <?php if (is_logged_in()): ?>
                <form method="POST" style="display:inline">
                    <button class="btn btn-outline" name="fav" value="1"><svg class="icon" viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg> В избранное</button>
                </form>
            <?php endif; ?>
        </div>
    </div>
</div>

<!-- БЛОК ТРЕЙЛЕРА -->
<?php if (!empty($item['trailer_url'])): ?>
<div class="info-block" id="trailer">
    <h3>Трейлер</h3>
    <div class="video-container">
        <?= get_youtube_embed($item['trailer_url']) ?>
    </div>
</div>
<?php endif; ?>

<?php if ($people): ?>
<div class="info-block">
    <h3>Актеры и создатели</h3>
    <div class="cast-grid">
        <?php foreach ($people as $p): ?>
            <div class="cast-card">
                <div class="cast-avatar"><svg class="icon" viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg></div>
                <div class="cast-info"><div class="cast-name"><?= htmlspecialchars($p['name']) ?></div><div class="cast-role"><?= $p['role_type'] === 'director' ? 'Режиссер' : 'Актер' ?></div></div>
            </div>
        <?php endforeach; ?>
    </div>
</div>
<?php endif; ?>

<?php if ($item['type'] === 'series' && $seasons): ?>
<div class="info-block">
    <h3>Сезоны и серии</h3>
    <?php foreach ($seasons as $season): ?>
        <div class="season-box">
            <div class="season-title">Сезон <?= $season['season_number'] ?></div>
            <div class="episode-list">
                <?php foreach (get_episodes($season['id']) as $ep): ?>
                    <div class="episode-item">
                        <span class="ep-num"><?= $ep['episode_number'] ?></span>
                        <span class="ep-title"><?= htmlspecialchars($ep['title']) ?></span>
                        <span class="ep-duration"><?= $ep['duration'] ?> мин.</span>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
    <?php endforeach; ?>
</div>
<?php endif; ?>

<?php if ($similar): ?>
<div class="info-block">
    <h3>Похожие</h3>
    <div class="grid" style="grid-template-columns:repeat(auto-fill,minmax(160px,1fr))">
        <?php foreach ($similar as $s): ?>
            <a href="movie.php?id=<?= $s['id'] ?>" class="card">
                <div class="card__poster">
                    <img src="<?= htmlspecialchars($s['poster']) ?>" alt="">
                    <span class="card__rating"><svg class="icon" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg> <?= $s['rating'] ?></span>
                </div>
                <div class="card__body"><div class="card__title" style="font-size:14px"><?= htmlspecialchars($s['title']) ?></div></div>
            </a>
        <?php endforeach; ?>
    </div>
</div>
<?php endif; ?>

<?php require_once 'footer.php'; ?>
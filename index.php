<?php 
require_once 'config.php';
$searchQuery = trim($_GET['q'] ?? '');
$searchResults = $searchQuery ? search_content($searchQuery) : [];

// Получаем фильм для баннера
$banner = db_fetch_one("SELECT * FROM content WHERE is_banner = 1 LIMIT 1");

$pageTitle = 'Главная';
require_once 'header.php'; 
?>

<?php if ($searchQuery): ?>
    <section class="section">
        <h2 class="section__title">Результаты поиска: «<?= htmlspecialchars($searchQuery) ?>»</h2>
        <?php if (!$searchResults): ?>
            <p style="color:var(--color-text-light)">Ничего не найдено.</p>
        <?php else: ?>
            <div class="grid">
                <?php foreach ($searchResults as $item): ?>
                    <a href="movie.php?id=<?= $item['id'] ?>" class="card">
                        <div class="card__poster">
                            <img src="<?= htmlspecialchars($item['poster']) ?>" alt="<?= htmlspecialchars($item['title']) ?>">
                            <span class="card__rating"><svg class="icon" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg> <?= $item['rating'] ?></span>
                        </div>
                        <div class="card__body"><div class="card__title"><?= htmlspecialchars($item['title']) ?></div><div class="card__meta"><?= $item['year'] ?> • <?= htmlspecialchars($item['cat'] ?? '') ?></div></div>
                    </a>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
    </section>
<?php else: ?>
    
    <!-- ДИНАМИЧЕСКИЙ БАННЕР -->
    <?php if ($banner): ?>
        <section class="hero-banner" style="background-image: url('<?= htmlspecialchars($banner['poster']) ?>');">
            <div class="hero-banner__content">
                <h1><?= htmlspecialchars($banner['title']) ?></h1>
                <p><?= htmlspecialchars($banner['description']) ?></p>
                <div class="hero__actions">
                    <a href="movie.php?id=<?= $banner['id'] ?>" class="btn btn-primary">Смотреть</a>
                </div>
            </div>
        </section>
    <?php else: ?>
        <!-- Баннер по умолчанию, если админ не выбрал -->
        <section class="hero">
            <h1>Смотри <span>кино и сериалы</span> онлайн</h1>
            <p>Тысячи фильмов и сериалов в HD и 4K качестве. Без рекламы. На любых устройствах.</p>
            <div class="hero__actions">
                <a href="subscribe.php" class="btn btn-primary">Оформить подписку</a>
                <a href="movies.php" class="btn btn-outline">Смотреть фильмы</a>
            </div>
        </section>
    <?php endif; ?>

    <section class="section">
        <h2 class="section__title">Топ новинки</h2>
        <div class="grid">
            <?php foreach (db_fetch_all("SELECT c.*, cat.name AS cat FROM content c LEFT JOIN categories cat ON c.category_id=cat.id WHERE c.is_new=1 ORDER BY c.year DESC LIMIT 8") as $item): ?>
                <a href="movie.php?id=<?= $item['id'] ?>" class="card">
                    <div class="card__poster">
                        <img src="<?= htmlspecialchars($item['poster']) ?>" alt="<?= htmlspecialchars($item['title']) ?>">
                        <span class="card__badge">NEW</span>
                        <span class="card__rating"><svg class="icon" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg> <?= $item['rating'] ?></span>
                    </div>
                    <div class="card__body"><div class="card__title"><?= htmlspecialchars($item['title']) ?></div><div class="card__meta"><?= $item['year'] ?> • <?= htmlspecialchars($item['cat'] ?? '') ?></div></div>
                </a>
            <?php endforeach; ?>
        </div>
    </section>

    <section class="section">
        <h2 class="section__title">Популярное</h2>
        <div class="grid">
            <?php foreach (db_fetch_all("SELECT c.*, cat.name AS cat FROM content c LEFT JOIN categories cat ON c.category_id=cat.id WHERE c.is_popular=1 ORDER BY c.rating DESC LIMIT 8") as $item): ?>
                <a href="movie.php?id=<?= $item['id'] ?>" class="card">
                    <div class="card__poster">
                        <img src="<?= htmlspecialchars($item['poster']) ?>" alt="<?= htmlspecialchars($item['title']) ?>">
                        <span class="card__rating"><svg class="icon" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg> <?= $item['rating'] ?></span>
                    </div>
                    <div class="card__body"><div class="card__title"><?= htmlspecialchars($item['title']) ?></div><div class="card__meta"><?= $item['year'] ?> • <?= htmlspecialchars($item['cat'] ?? '') ?></div></div>
                </a>
            <?php endforeach; ?>
        </div>
    </section>
<?php endif; ?>

<?php require_once 'footer.php'; ?>
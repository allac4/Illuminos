<?php 
require_once 'config.php';
$pageTitle = 'Сериалы';
require_once 'header.php'; 
?>
<section class="section">
    <h1 class="section__title">Сериалы</h1>
    <div class="categories">
        <a href="series.php" class="category <?= !isset($_GET['cat']) ? 'category--active' : '' ?>">Все</a>
        <?php foreach (get_categories() as $c): ?>
            <a href="series.php?cat=<?= $c['id'] ?>" class="category <?= (($_GET['cat'] ?? 0) == $c['id']) ? 'category--active' : '' ?>"><?= htmlspecialchars($c['name']) ?></a>
        <?php endforeach; ?>
    </div>
    <div class="grid">
        <?php
        $catId = (int)($_GET['cat'] ?? 0);
        foreach (get_series() as $s):
            if ($catId && $s['category_id'] != $catId) continue;
        ?>
            <a href="movie.php?id=<?= $s['id'] ?>" class="card">
                <div class="card__poster">
                    <img src="<?= htmlspecialchars($s['poster']) ?>" alt="<?= htmlspecialchars($s['title']) ?>">
                    <span class="card__rating"><svg class="icon" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg> <?= $s['rating'] ?></span>
                </div>
                <div class="card__body">
                    <div class="card__title"><?= htmlspecialchars($s['title']) ?></div>
                    <div class="card__meta"><?= $s['year'] ?> • <?= htmlspecialchars($s['cat'] ?? '') ?></div>
                </div>
            </a>
        <?php endforeach; ?>
    </div>
</section>
<?php require_once 'footer.php'; ?>

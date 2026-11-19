<?php 
require_once 'config.php';
$pageTitle = 'Подписка';
require_once 'header.php'; 
?>
<section class="section">
    <h1 class="section__title" style="justify-content:center">Тарифы подписки</h1>
    <div class="tariffs">
        <?php foreach (get_tariffs() as $i => $t): ?>
            <div class="tariff <?= $i === 1 ? 'tariff--popular' : '' ?>">
                <div class="tariff__name"><?= htmlspecialchars($t['name']) ?></div>
                <div class="tariff__price"><?= (int)$t['price'] ?> ₽</div>
                <div class="tariff__period">за <?= $t['duration_days'] ?> дней</div>
                <ul class="tariff__features">
                    <?php foreach (explode(',', $t['features']) as $f): ?>
                        <li><?= htmlspecialchars(trim($f)) ?></li>
                    <?php endforeach; ?>
                </ul>
                <a href="payment.php?tariff=<?= $t['id'] ?>" class="btn btn-primary btn-block">Выбрать</a>
            </div>
        <?php endforeach; ?>
    </div>
</section>
<?php require_once 'footer.php'; ?>
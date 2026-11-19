<?php
require_once 'config.php';
if (!is_logged_in()) redirect('login.php');
$uid = (int)$_SESSION['user_id'];
$user = db_fetch_one("SELECT * FROM users WHERE id=$uid");
$favorites = db_fetch_all("SELECT c.* FROM content c JOIN favorites f ON c.id=f.content_id WHERE f.user_id=$uid");
$history = db_fetch_all("SELECT c.*, h.watched_at FROM content c JOIN watch_history h ON c.id=h.content_id WHERE h.user_id=$uid ORDER BY h.watched_at DESC LIMIT 10");
$orders = db_fetch_all("SELECT o.*, t.name AS tariff_name FROM orders o JOIN tariffs t ON o.tariff_id=t.id WHERE o.user_id=$uid ORDER BY o.created_at DESC");
$tab = $_GET['tab'] ?? 'favorites';
$pageTitle = 'Личный кабинет';
require_once 'header.php';
?>
<div class="profile-header">
    <div class="avatar"><?= mb_strtoupper(mb_substr($user['full_name'], 0, 1)) ?></div>
    <div>
        <h1 style="font-size:28px"><?= htmlspecialchars($user['full_name']) ?></h1>
        <p style="color:var(--color-text-light)"><?= htmlspecialchars($user['email']) ?> • Роль: <?= $user['role'] ?></p>
        <?php if ($user['subscription_until'] && $user['subscription_until'] >= date('Y-m-d')): ?>
            <p style="color:#33ff66">Подписка активна до <?= $user['subscription_until'] ?></p>
        <?php else: ?>
            <p style="color:var(--color-accent)">Подписка не активна — <a href="subscribe.php" style="color:var(--color-accent)">оформить</a></p>
        <?php endif; ?>
    </div>
</div>
<div class="profile-tabs">
    <a href="?tab=favorites" class="profile-tab <?= $tab === 'favorites' ? 'profile-tab--active' : '' ?>">Избранное</a>
    <a href="?tab=history" class="profile-tab <?= $tab === 'history' ? 'profile-tab--active' : '' ?>">История</a>
    <a href="?tab=orders" class="profile-tab <?= $tab === 'orders' ? 'profile-tab--active' : '' ?>">Заказы</a>
</div>
<?php if ($tab === 'favorites'): ?>
    <?php if (!$favorites): ?><p style="color:var(--color-text-light)">В избранном пусто.</p><?php else: ?>
        <div class="grid">
            <?php foreach ($favorites as $f): ?>
                <a href="movie.php?id=<?= $f['id'] ?>" class="card">
                    <div class="card__poster">
                        <img src="<?= htmlspecialchars($f['poster']) ?>" alt="">
                        <span class="card__rating"><svg class="icon" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg> <?= $f['rating'] ?></span>
                    </div>
                    <div class="card__body"><div class="card__title"><?= htmlspecialchars($f['title']) ?></div></div>
                </a>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
<?php elseif ($tab === 'history'): ?>
    <?php if (!$history): ?><p style="color:var(--color-text-light)">История пуста.</p><?php else: ?>
        <ul class="info-block">
            <?php foreach ($history as $h): ?>
                <li><a href="movie.php?id=<?= $h['id'] ?>" style="color:var(--color-text)"><?= htmlspecialchars($h['title']) ?></a> — <?= $h['watched_at'] ?></li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>
<?php else: ?>
    <?php if (!$orders): ?><p style="color:var(--color-text-light)">Заказов нет.</p><?php else: ?>
        <table class="table">
            <tr><th>Тариф</th><th>Сумма</th><th>Статус</th><th>Дата</th></tr>
            <?php foreach ($orders as $o): ?>
                <tr>
                    <td><?= htmlspecialchars($o['tariff_name']) ?></td>
                    <td><?= $o['amount'] ?> ₽</td>
                    <td><span class="badge-status badge-status--<?= $o['status'] ?>"><?= $o['status'] ?></span></td>
                    <td><?= $o['created_at'] ?></td>
                </tr>
            <?php endforeach; ?>
        </table>
    <?php endif; ?>
<?php endif; ?>
<?php require_once 'footer.php'; ?>
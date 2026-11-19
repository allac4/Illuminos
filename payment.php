<?php
require_once 'config.php';
if (!is_logged_in()) redirect('login.php');
$tid = (int)($_GET['tariff'] ?? 0);
$tariff = db_fetch_one("SELECT * FROM tariffs WHERE id=$tid");
if (!$tariff) die('Тариф не найден');
$success = false;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $uid = (int)$_SESSION['user_id'];
    $price = (float)$tariff['price'];
    db_query("INSERT INTO orders (user_id, tariff_id, amount, status) VALUES ($uid, $tid, $price, 'paid')");
    $newDate = date('Y-m-d', strtotime("+{$tariff['duration_days']} days"));
    db_query("UPDATE users SET subscription_until='$newDate', role='subscriber' WHERE id=$uid");
    $_SESSION['role'] = 'subscriber';
    $success = true;
}
$pageTitle = 'Оплата';
require_once 'header.php';
?>
<div class="form-box" style="max-width:540px">
    <?php if ($success): ?>
        <h2 style="display:flex;align-items:center;justify-content:center;gap:10px">
            <svg class="icon icon--lg" viewBox="0 0 24 24" style="color:#33ff66"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>
            Оплата прошла
        </h2>
        <p class="subtitle">Тариф «<?= htmlspecialchars($tariff['name']) ?>» активирован до <?= date('d.m.Y', strtotime("+{$tariff['duration_days']} days")) ?></p>
        <a href="profile.php" class="btn btn-primary btn-block">В личный кабинет</a>
    <?php else: ?>
        <h2>Оплата подписки</h2>
        <p class="subtitle">Тариф «<?= htmlspecialchars($tariff['name']) ?>» — <?= (int)$tariff['price'] ?> ₽</p>
        <form method="POST">
            <div class="form-group"><label>Номер карты</label><input type="text" placeholder="0000 0000 0000 0000" maxlength="19" required></div>
            <div style="display:flex;gap:12px">
                <div class="form-group" style="flex:1"><label>Срок</label><input type="text" placeholder="MM/YY" maxlength="5" required></div>
                <div class="form-group" style="flex:1"><label>CVV</label><input type="password" placeholder="***" maxlength="3" required></div>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Оплатить <?= (int)$tariff['price'] ?> ₽</button>
        </form>
    <?php endif; ?>
</div>
<?php require_once 'footer.php'; ?>
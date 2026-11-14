<?php
require_once 'config.php';
if (!is_admin()) redirect('login.php');

$success = '';
$error = '';
$edit_item = null;

// Режим редактирования
if (isset($_GET['edit'])) {
    $edit_id = (int)$_GET['edit'];
    $edit_item = db_fetch_one("SELECT * FROM content WHERE id=$edit_id");
}

// Обработка добавления или обновления
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    $type = db_escape($_POST['type']);
    $title = db_escape($_POST['title']);
    $desc = db_escape($_POST['description']);
    $poster = db_escape($_POST['poster']);
    $trailer = db_escape($_POST['trailer_url']);
    $duration = (int)$_POST['duration'];
    $rating = (float)$_POST['rating'];
    $year = (int)$_POST['year'];
    $cat = (int)$_POST['category_id'];
    $is_new = isset($_POST['is_new']) ? 1 : 0;
    $is_pop = isset($_POST['is_popular']) ? 1 : 0;
    $is_banner = isset($_POST['is_banner']) ? 1 : 0;
    
    // Если выбран баннером — снимаем этот статус с остальных
    if ($is_banner) {
        db_query("UPDATE content SET is_banner = 0");
    }

    if ($_POST['action'] === 'add') {
        $sql = "INSERT INTO content (type,title,description,poster,trailer_url,duration,rating,year,category_id,is_new,is_popular,is_banner) 
                VALUES ('$type','$title','$desc','$poster','$trailer',$duration,$rating,$year,$cat,$is_new,$is_pop,$is_banner)";
        if (db_query($sql)) $success = 'Контент добавлен!';
        else $error = 'Ошибка: ' . mysqli_error($conn);
    } elseif ($_POST['action'] === 'update') {
        $id = (int)$_POST['id'];
        $sql = "UPDATE content SET type='$type', title='$title', description='$desc', poster='$poster', 
                trailer_url='$trailer', duration=$duration, rating=$rating, year=$year, category_id=$cat, 
                is_new=$is_new, is_popular=$is_pop, is_banner=$is_banner WHERE id=$id";
        if (db_query($sql)) {
            $success = 'Контент обновлён!';
            $edit_item = null;
        } else {
            $error = 'Ошибка: ' . mysqli_error($conn);
        }
    }
}

if (isset($_GET['delete'])) {
    $id = (int)$_GET['delete'];
    if (db_query("DELETE FROM content WHERE id=$id")) $success = 'Удалено!';
    else $error = 'Ошибка удаления';
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['order_status'], $_POST['order_id'])) {
    $oid = (int)$_POST['order_id'];
    $st = db_escape($_POST['order_status']);
    db_query("UPDATE orders SET status='$st' WHERE id=$oid");
    $success = 'Статус заказа обновлён';
}

$content = get_all_content();
$cats = get_categories();
$orders = db_fetch_all("SELECT o.*, u.full_name, t.name AS tariff_name FROM orders o JOIN users u ON o.user_id=u.id JOIN tariffs t ON o.tariff_id=t.id ORDER BY o.created_at DESC");
$pageTitle = 'Админ-панель';
require_once 'header.php';
?>
<div style="padding:20px 0;">
    <?php if ($success): ?><div class="alert alert-success"><?= $success ?></div><?php endif; ?>
    <?php if ($error): ?><div class="alert alert-error"><?= $error ?></div><?php endif; ?>

    <h3 style="margin:32px 0 16px;color:var(--color-accent)">
        <?= $edit_item ? 'Редактировать контент: ' . htmlspecialchars($edit_item['title']) : 'Добавить контент' ?>
    </h3>
    
    <form method="POST" style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:48px;background:var(--color-bg-light);padding:24px;border-radius:var(--border-radius);border:1px solid var(--color-border)">
        <input type="hidden" name="action" value="<?= $edit_item ? 'update' : 'add' ?>">
        <?php if ($edit_item): ?><input type="hidden" name="id" value="<?= $edit_item['id'] ?>"><?php endif; ?>
        
        <select name="type" style="padding:12px;background:var(--color-bg-dark);color:#fff;border:1px solid var(--color-border);border-radius:8px">
            <option value="movie" <?= ($edit_item && $edit_item['type']=='movie') ? 'selected' : '' ?>>Фильм</option>
            <option value="series" <?= ($edit_item && $edit_item['type']=='series') ? 'selected' : '' ?>>Сериал</option>
        </select>
        <select name="category_id" style="padding:12px;background:var(--color-bg-dark);color:#fff;border:1px solid var(--color-border);border-radius:8px">
            <?php foreach ($cats as $c): ?>
                <option value="<?= $c['id'] ?>" <?= ($edit_item && $edit_item['category_id']==$c['id']) ? 'selected' : '' ?>><?= htmlspecialchars($c['name']) ?></option>
            <?php endforeach; ?>
        </select>
        
        <input type="text" name="title" placeholder="Название" value="<?= $edit_item ? htmlspecialchars($edit_item['title']) : '' ?>" required style="padding:12px;background:var(--color-bg-dark);color:#fff;border:1px solid var(--color-border);border-radius:8px">
        <input type="text" name="poster" placeholder="Ссылка на картинку (URL)" value="<?= $edit_item ? htmlspecialchars($edit_item['poster']) : '' ?>" required style="padding:12px;background:var(--color-bg-dark);color:#fff;border:1px solid var(--color-border);border-radius:8px">
        
        <input type="text" name="trailer_url" placeholder="Ссылка на трейлер (YouTube)" value="<?= $edit_item ? htmlspecialchars($edit_item['trailer_url'] ?? '') : '' ?>" style="padding:12px;background:var(--color-bg-dark);color:#fff;border:1px solid var(--color-border);border-radius:8px">
        <input type="number" name="duration" placeholder="Длительность (мин)" value="<?= $edit_item ? $edit_item['duration'] : '' ?>" style="padding:12px;background:var(--color-bg-dark);color:#fff;border:1px solid var(--color-border);border-radius:8px">
        
        <input type="number" name="year" placeholder="Год" value="<?= $edit_item ? $edit_item['year'] : '' ?>" required style="padding:12px;background:var(--color-bg-dark);color:#fff;border:1px solid var(--color-border);border-radius:8px">
        <input type="number" step="0.1" name="rating" placeholder="Рейтинг" value="<?= $edit_item ? $edit_item['rating'] : '' ?>" required style="padding:12px;background:var(--color-bg-dark);color:#fff;border:1px solid var(--color-border);border-radius:8px">
        
        <div style="display:flex; gap:24px; align-items:center; color:#fff; grid-column:span 2;">
            <label><input type="checkbox" name="is_new" <?= ($edit_item && $edit_item['is_new']) ? 'checked' : '' ?>> Новинка</label>
            <label><input type="checkbox" name="is_popular" <?= ($edit_item && $edit_item['is_popular']) ? 'checked' : '' ?>> Популярное</label>
            <label style="color:var(--color-accent); font-weight:bold;"><input type="checkbox" name="is_banner" <?= ($edit_item && ($edit_item['is_banner'] ?? 0)) ? 'checked' : '' ?>> Сделать баннером на главной</label>
        </div>
        
        <textarea name="description" placeholder="Описание" style="grid-column:span 2;padding:12px;background:var(--color-bg-dark);color:#fff;border:1px solid var(--color-border);border-radius:8px;min-height:100px"><?= $edit_item ? htmlspecialchars($edit_item['description']) : '' ?></textarea>
        
        <button type="submit" class="btn btn-primary" style="grid-column:span 2; padding:14px;">
            <?= $edit_item ? 'Сохранить изменения' : 'Добавить' ?>
        </button>
        <?php if ($edit_item): ?>
            <a href="admin.php" class="btn btn-outline" style="grid-column:span 2; text-align:center;">Отмена</a>
        <?php endif; ?>
    </form>

    <h3 style="margin:32px 0 16px;color:var(--color-accent)">Контент</h3>
    <table class="table">
        <tr><th>ID</th><th>Название</th><th>Тип</th><th>Баннер</th><th>Действие</th></tr>
        <?php foreach ($content as $c): ?>
            <tr>
                <td><?= $c['id'] ?></td>
                <td style="font-weight:600;"><?= htmlspecialchars($c['title']) ?></td>
                <td><?= $c['type'] === 'series' ? 'Сериал' : 'Фильм' ?></td>
                <td style="color:var(--color-accent); font-weight:bold;"><?= ($c['is_banner'] ?? 0) ? 'ДА' : '' ?></td>
                <td style="display:flex; gap:12px;">
                    <a href="?edit=<?= $c['id'] ?>" style="color:var(--color-success); font-weight:bold;">Редактировать</a>
                    <a href="?delete=<?= $c['id'] ?>" style="color:var(--color-danger);" onclick="return confirm('Удалить?')">Удалить</a>
                </td>
            </tr>
        <?php endforeach; ?>
    </table>

    <h3 style="margin:32px 0 16px;color:var(--color-accent)">Заказы</h3>
    <table class="table">
        <tr><th>ID</th><th>Пользователь</th><th>Тариф</th><th>Сумма</th><th>Статус</th><th>Действие</th></tr>
        <?php foreach ($orders as $o): ?>
            <tr>
                <td><?= $o['id'] ?></td>
                <td><?= htmlspecialchars($o['full_name']) ?></td>
                <td><?= htmlspecialchars($o['tariff_name']) ?></td>
                <td><?= $o['amount'] ?> ₽</td>
                <td><span class="badge-status badge-status--<?= $o['status'] ?>"><?= $o['status'] ?></span></td>
                <td>
                    <form method="POST" style="display:flex; gap:8px; align-items:center;">
                        <input type="hidden" name="order_id" value="<?= $o['id'] ?>">
                        <select name="order_status" style="background:var(--color-bg-dark);color:#fff;border:1px solid var(--color-border);border-radius:6px;padding:6px 10px;outline:none;">
                            <option value="pending" <?= $o['status'] === 'pending' ? 'selected' : '' ?>>pending</option>
                            <option value="paid" <?= $o['status'] === 'paid' ? 'selected' : '' ?>>paid</option>
                            <option value="cancelled" <?= $o['status'] === 'cancelled' ? 'selected' : '' ?>>cancelled</option>
                        </select>
                        <button class="btn btn-outline btn-small">OK</button>
                    </form>
                </td>
            </tr>
        <?php endforeach; ?>
    </table>
</div>
<?php require_once 'footer.php'; ?>

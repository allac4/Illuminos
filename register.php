<?php
require_once 'config.php';
if (is_logged_in()) redirect('index.php');
$error = '';
$success = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $full_name = trim($_POST['full_name'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';
    $password_confirm = $_POST['password_confirm'] ?? '';
    if (empty($full_name) || empty($email) || empty($password)) {
        $error = 'Заполните все обязательные поля!';
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error = 'Некорректный формат email!';
    } elseif (strlen($password) < 6) {
        $error = 'Пароль должен содержать минимум 6 символов!';
    } elseif ($password !== $password_confirm) {
        $error = 'Пароли не совпадают!';
    } else {
        $email_escaped = db_escape($email);
        $check = db_query("SELECT id FROM users WHERE email = '$email_escaped'");
        if (mysqli_num_rows($check) > 0) {
            $error = 'Пользователь с таким email уже зарегистрирован!';
        } else {
            $hashed = password_hash($password, PASSWORD_DEFAULT);
            $name_escaped = db_escape($full_name);
            if (db_query("INSERT INTO users (full_name, email, password) VALUES ('$name_escaped', '$email_escaped', '$hashed')")) {
                $success = 'Регистрация прошла успешно! Теперь вы можете войти.';
                $full_name = $email = '';
            } else {
                $error = 'Ошибка при регистрации: ' . mysqli_error($conn);
            }
        }
    }
}
$pageTitle = 'Регистрация';
require_once 'header.php';
?>
<div class="form-box">
    <h2 style="display:flex;align-items:center;justify-content:center;gap:10px">
        <svg class="icon icon--lg" viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z"/></svg>
        Регистрация
    </h2>
    <p class="subtitle">Создайте аккаунт Illuminos</p>
    <?php if ($error): ?><div class="alert alert-error"><?= $error ?></div><?php endif; ?>
    <?php if ($success): ?><div class="alert alert-success"><?= $success ?></div><?php endif; ?>
    <form method="POST" action="">
        <div class="form-group"><label>ФИО</label><input type="text" name="full_name" value="<?= htmlspecialchars($full_name ?? '') ?>" required></div>
        <div class="form-group"><label>Email</label><input type="email" name="email" value="<?= htmlspecialchars($email ?? '') ?>" required></div>
        <div class="form-group"><label>Пароль</label><input type="password" name="password" required></div>
        <div class="form-group"><label>Подтверждение пароля</label><input type="password" name="password_confirm" required></div>
        <button type="submit" class="btn btn-primary btn-block">Зарегистрироваться</button>
    </form>
    <div class="form-link">Уже есть аккаунт? <a href="login.php">Войти</a></div>
</div>
<?php require_once 'footer.php'; ?>

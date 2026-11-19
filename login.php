<?php
require_once 'config.php';
if (is_logged_in()) redirect('index.php');
$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';
    if (empty($email) || empty($password)) {
        $error = 'Заполните все поля!';
    } else {
        $email_escaped = db_escape($email);
        $result = db_query("SELECT id, full_name, email, password, role FROM users WHERE email = '$email_escaped'");
        $user = mysqli_fetch_assoc($result);
        if ($user && password_verify($password, $user['password'])) {
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['full_name'] = $user['full_name'];
            $_SESSION['email'] = $user['email'];
            $_SESSION['role'] = $user['role'];
            redirect($user['role'] === 'admin' ? 'admin.php' : 'index.php');
        } else {
            $error = 'Неверный email или пароль!';
        }
    }
}
$pageTitle = 'Вход';
require_once 'header.php';
?>
<div class="form-box">
    <h2 style="display:flex;align-items:center;justify-content:center;gap:10px">
        <svg class="icon icon--lg" viewBox="0 0 24 24"><path d="M18 4l2 4h-3l-2-4h-2l2 4h-3l-2-4H8l2 4H7L5 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V4h-4z"/></svg>
        Вход в Illuminos
    </h2>
    <p class="subtitle">Войдите в свой аккаунт</p>
    <?php if ($error): ?><div class="alert alert-error"><?= $error ?></div><?php endif; ?>
    <form method="POST" action="">
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="admin@illuminos.ru" required>
        </div>
        <div class="form-group">
            <label for="password">Пароль</label>
            <input type="password" id="password" name="password" placeholder="********" required>
        </div>
        <button type="submit" class="btn btn-primary btn-block">Войти</button>
    </form>
    <div class="form-link">Нет аккаунта? <a href="register.php">Зарегистрироваться</a></div>
</div>
<?php require_once 'footer.php'; ?>
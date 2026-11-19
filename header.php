<?php 
if (session_status() === PHP_SESSION_NONE) { session_start(); }
require_once 'config.php'; 
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= isset($pageTitle) ? htmlspecialchars($pageTitle) . ' — ' : '' ?>Illuminos</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/reset.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header class="header">
        <div class="container header__inner">
            <a href="index.php" class="logo">ILLUMINOS<span>.</span></a>
            <nav class="nav">
                <a href="index.php">Главная</a>
                <a href="movies.php">Фильмы</a>
                <a href="series.php">Сериалы</a>
            </nav>
            <form class="search" action="index.php" method="GET">
                <input type="text" name="q" placeholder="Поиск фильмов..." value="<?= htmlspecialchars($_GET['q'] ?? '') ?>">
                <button type="submit">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
                </button>
            </form>
            <div class="auth">
                <?php if (is_logged_in()): ?>
                    <a href="profile.php" class="btn btn-outline btn-small"><?= htmlspecialchars($_SESSION['full_name']) ?></a>
                    <?php if (is_admin()): ?><a href="admin.php" class="btn btn-outline btn-small">Админка</a><?php endif; ?>
                    <a href="logout.php" class="btn btn-primary btn-small">Выйти</a>
                <?php else: ?>
                    <a href="login.php" class="btn btn-outline btn-small">Войти</a>
                    <a href="register.php" class="btn btn-primary btn-small">Регистрация</a>
                <?php endif; ?>
            </div>
        </div>
    </header>
    <main class="container">
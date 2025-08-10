<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Unauthorized Access - PahanaEdu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <style>
        :root {
            --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --gradient-secondary: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
            --gradient-warning: linear-gradient(135deg, #f46b45 0%, #eea849 100%);
            --text-primary: #2c3e50;
            --text-light: #f8f9fa;
            --bg-primary: #f8f9fa;
            --bg-secondary: #ffffff;
            --border-color: rgba(0, 0, 0, 0.1);
            --header-bg: rgba(255, 255, 255, 0.8);
            --form-bg: rgba(255, 255, 255, 0.15);
            --input-bg: rgba(255, 255, 255, 0.85);
        }

        .dark-mode {
            --text-primary: #f8f9fa;
            --text-light: #e9ecef;
            --bg-primary: #121212;
            --bg-secondary: #1e1e1e;
            --border-color: rgba(255, 255, 255, 0.1);
            --header-bg: rgba(30, 30, 30, 0.8);
            --form-bg: rgba(30, 30, 30, 0.5);
            --input-bg: rgba(30, 30, 30, 0.7);
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            background: url('Images/Library.png') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            color: var(--text-primary);
            background-color: var(--bg-primary);
            transition: background-color 0.3s ease, color 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .header-bar {
            height: 80px;
            background: var(--header-bg);
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 40px;
            position: relative;
            z-index: 10;
            backdrop-filter: blur(6px);
            transition: background 0.3s ease;
        }

        .logo {
            font-weight: 700;
            font-size: 1.8rem;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -1px;
        }

        .header-controls {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .time-display {
            font-weight: 500;
            font-size: 0.95rem;
            color: var(--text-primary);
            opacity: 0.8;
        }

        .theme-toggle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--gradient-primary);
            border: none;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .theme-toggle:hover {
            transform: rotate(15deg);
        }

        .auth-container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex: 1;
            padding: 40px 20px;
        }

        .auth-form {
            width: 100%;
            max-width: 500px;
            background: var(--form-bg);
            border-radius: 20px;
            padding: 40px;
            backdrop-filter: blur(12px);
            border: 1px solid var(--border-color);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            text-align: center;
        }

        .error-icon {
            font-size: 4rem;
            color: #dc3545;
            margin-bottom: 1.5rem;
        }

        .btn-primary {
            background-image: var(--gradient-primary);
            border: none;
            padding: 10px 25px;
            border-radius: 10px;
            font-weight: 600;
            color: white;
            transition: all 0.3s;
        }

        .btn-primary:hover {
            background-position: right center;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        @media (max-width: 576px) {
            .header-bar {
                padding: 0 20px;
                height: 70px;
            }

            .auth-form {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>

<div class="header-bar">
    <div class="logo">PahanaEdu</div>
    <div class="header-controls">
        <div class="time-display" id="timeDisplay"></div>
        <button class="theme-toggle" id="themeToggle">
            <i class="bi bi-moon" id="themeIcon"></i>
        </button>
    </div>
</div>

<div class="auth-container">
    <div class="auth-form">
        <i class="bi bi-shield-lock-fill error-icon"></i>
        <h3 class="mb-3">Unauthorized Access</h3>
        <p class="mb-4">You do not have permission.</p>
        <a href="index.html" class="btn btn-primary">
            <i class="bi bi-house-door-fill"></i> Go to Login
        </a>
    </div>
</div>

<script>
    // DOM Elements
    const themeToggle = document.getElementById("themeToggle");
    const themeIcon = document.getElementById("themeIcon");
    const timeDisplay = document.getElementById("timeDisplay");
    const body = document.body;

    // Theme Management
    function toggleTheme() {
        body.classList.toggle('dark-mode');
        const isDarkMode = body.classList.contains('dark-mode');
        localStorage.setItem('darkMode', isDarkMode);
        
        // Update icon
        if (isDarkMode) {
            themeIcon.classList.remove('bi-moon');
            themeIcon.classList.add('bi-sun');
        } else {
            themeIcon.classList.remove('bi-sun');
            themeIcon.classList.add('bi-moon');
        }
    }

    // Check for saved theme preference
    if (localStorage.getItem('darkMode') === 'true') {
        body.classList.add('dark-mode');
        themeIcon.classList.remove('bi-moon');
        themeIcon.classList.add('bi-sun');
    }

    // Update Time
    function updateTime() {
        const now = new Date();
        const options = {
            weekday: 'short',
            month: 'short',
            day: 'numeric',
            hour: 'numeric',
            minute: 'numeric',
            hour12: true
        };
        timeDisplay.textContent = now.toLocaleString('en-US', options);
    }

    // Event Listeners
    themeToggle.addEventListener('click', toggleTheme);
    setInterval(updateTime, 1000);
    updateTime();
</script>

</body>
</html>
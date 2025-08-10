<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    String userType = (String) session.getAttribute("userType");

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - PahanaEdu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <style>
        :root {
            --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --sidebar-bg: #2c3e50;
            --sidebar-active: #1abc9c;
            --text-primary: #2c3e50;
            --text-light: #f8f9fa;
            --bg-primary: #f8f9fa;
            --header-bg: rgba(255, 255, 255, 0.8);
            --border-color: rgba(0, 0, 0, 0.1);
        }

        .dark-mode {
            --sidebar-bg: #1a1a2e;
            --sidebar-active: #0d7377;
            --text-primary: #f8f9fa;
            --text-light: #e9ecef;
            --bg-primary: #121212;
            --header-bg: rgba(30, 30, 30, 0.8);
            --border-color: rgba(255, 255, 255, 0.1);
        }

        html, body {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-primary);
            color: var(--text-primary);
            transition: background-color 0.3s ease, color 0.3s ease;
            height: 100%;
            overflow: hidden;
        }

        .header-bar {
            height: 80px;
            background: var(--header-bg);
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 40px;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 100;
            backdrop-filter: blur(6px);
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

        .user-display {
            font-weight: 600;
            font-size: 1rem;
            color: var(--text-primary);
        }

        .user-badge {
            background: var(--gradient-primary);
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            margin-left: 10px;
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
        }

        .theme-toggle:hover {
            transform: rotate(15deg);
        }

        .main-container {
            display: flex;
            margin-top: 80px;
            height: calc(100vh - 80px);
        }

        .sidebar {
            width: 250px;
            background: var(--sidebar-bg);
            color: white;
            height: 100%;
            position: fixed;
            top: 80px;
            left: 0;
            bottom: 0;
            z-index: 90;
        }

        .sidebar-menu {
            padding: 20px 0;
        }

        .sidebar-item {
            padding: 12px 20px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.2s;
        }

        .sidebar-item:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .sidebar-item.active {
            background: var(--sidebar-active);
        }

        .sidebar-item i {
            font-size: 1.2rem;
        }

        .content-area {
            margin-left: 250px;
            height: 100%;
            flex-grow: 1;
            overflow: hidden;
            background-color: var(--bg-primary);
            position: relative;
        }

        .content-frame {
            width: 100%;
            height: 100%;
            border: none;
            background: white;
            border-radius: 0;
            opacity: 0;
            transition: opacity 0.5s ease-in-out;
        }

        .content-frame.show {
            opacity: 1;
        }

        #loadingOverlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.7);
            z-index: 200;
            display: none;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            animation: fadeIn 0.3s ease-in-out;
        }

        .dark-mode #loadingOverlay {
            background-color: rgba(0, 0, 0, 0.5);
        }

        .spinner-border {
            width: 3.5rem;
            height: 3.5rem;
            margin-bottom: 15px;
        }

        .loading-text {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--text-primary);
            animation: pulse 1.2s infinite ease-in-out;
        }

        @keyframes pulse {
            0%, 100% { opacity: 0.6; }
            50% { opacity: 1; }
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @media (max-width: 992px) {
            .sidebar {
                width: 70px;
            }

            .sidebar-item span {
                display: none;
            }

            .content-area {
                margin-left: 70px;
            }
        }

        @media (max-width: 576px) {
            .header-bar {
                padding: 0 20px;
                height: 70px;
            }

            .sidebar {
                width: 0;
            }

            .content-area {
                margin-left: 0;
            }

            .user-display {
                display: none;
            }
        }
    </style>
</head>
<body>

<div class="header-bar">
    <div class="logo">PahanaEdu</div>
    <div class="header-controls">
        <div class="user-display">
            Welcome, <%= username %> <span class="user-badge"><%= userType %></span>
        </div>
        <div class="time-display" id="timeDisplay"></div>
        <div class="dropdown">
            <button class="btn btn-link text-decoration-none dropdown-toggle" type="button" id="userDropdown" 
                    data-bs-toggle="dropdown" aria-expanded="false">
                <i class="bi bi-person-circle" style="font-size: 1.5rem; color: var(--text-primary);"></i>
            </button>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li><h6 class="dropdown-header"><%= username %> (<%= userType %>)</h6></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="profile.jsp"><i class="bi bi-person me-2"></i>Profile</a></li>
                <li><a class="dropdown-item" href="logout.jsp"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
            </ul>
        </div>
        <button class="theme-toggle" id="themeToggle">
            <i class="bi bi-moon" id="themeIcon"></i>
        </button>
    </div>
</div>

<div class="main-container">
    <div class="sidebar">
        <div class="sidebar-menu">
    <div class="sidebar-item active" onclick="loadPage('welcome.jsp', this)">
        <i class="bi bi-house-door"></i>
        <span>Dashboard</span>
    </div>

    <div class="sidebar-item" onclick="loadPage('book.jsp', this)">
        <i class="bi bi-journal-plus"></i>
        <span>Manage Books</span>
    </div>

    <% if (!"CUSTOMER".equals(userType)) { %>
        <div class="sidebar-item" onclick="loadPage('cart.jsp', this)">
            <i class="bi bi-cart"></i>
            <span>Manage Cart</span>
        </div>
    <% } %>

    <% if ("ADMIN".equals(userType) || "STAFF".equals(userType)) { %>
        <div class="sidebar-item" onclick="loadPage('author.jsp', this)">
            <i class="bi bi-book"></i>
            <span>Author Management</span>
        </div>
        <div class="sidebar-item" onclick="loadPage('bank_account.jsp', this)">
            <i class="bi bi-journal-plus"></i>
            <span>Manage Bank Account</span>
        </div>
        <div class="sidebar-item" onclick="loadPage('customer.jsp', this)">
            <i class="bi bi-people"></i>
            <span>Manage Customers</span>
        </div>
    <% } %>

    <% if ("ADMIN".equals(userType)) { %>
        <div class="sidebar-item" onclick="loadPage('user.jsp', this)">
            <i class="bi bi-person-gear"></i>
            <span>User Management</span>
        </div>
    <% } %>

    <div class="sidebar-item" onclick="loadPage('invoice.jsp', this)">
        <i class="bi bi-receipt-cutoff"></i>
        <span>Invoice</span>
    </div>
</div>

    </div>

    <div class="content-area">
        <!-- Fancy Loading Overlay -->
        <div id="loadingOverlay">
            <div class="spinner-border text-primary" role="status"></div>
            <div class="loading-text">Loading...</div>
        </div>

        <!-- Iframe -->
        <iframe id="contentFrame" class="content-frame" src="welcome.jsp"></iframe>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const themeToggle = document.getElementById("themeToggle");
    const themeIcon = document.getElementById("themeIcon");
    const timeDisplay = document.getElementById("timeDisplay");
    const body = document.body;
    const sidebarItems = document.querySelectorAll('.sidebar-item');
    const contentFrame = document.getElementById('contentFrame');
    const loadingOverlay = document.getElementById('loadingOverlay');

    function toggleTheme() {
        body.classList.toggle('dark-mode');
        const isDark = body.classList.contains('dark-mode');
        localStorage.setItem('darkMode', isDark);
        themeIcon.className = isDark ? 'bi bi-sun' : 'bi bi-moon';
    }

    if (localStorage.getItem('darkMode') === 'true') {
        body.classList.add('dark-mode');
        themeIcon.className = 'bi bi-sun';
    }

    function updateTime() {
        const now = new Date();
        timeDisplay.textContent = now.toLocaleString('en-US', {
            weekday: 'short', month: 'short', day: 'numeric',
            hour: 'numeric', minute: 'numeric', hour12: true
        });
    }

    function loadPage(page, el) {
        loadingOverlay.style.display = 'flex';
        contentFrame.classList.remove('show');
        contentFrame.src = page;
        sidebarItems.forEach(item => item.classList.remove('active'));
        if (el) el.classList.add('active');
    }

    contentFrame.onload = function () {
        loadingOverlay.style.display = 'none';
        contentFrame.classList.add('show');
    };

    themeToggle.addEventListener('click', toggleTheme);
    setInterval(updateTime, 1000);
    updateTime();
</script>

</body>
</html>

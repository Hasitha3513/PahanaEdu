<%@page import="database.DbConnection"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String resetNIC = (String) session.getAttribute("resetNIC");
    if (resetNIC == null) {
        response.sendRedirect("index.html?error=" + java.net.URLEncoder.encode("Unauthorized access to password reset", "UTF-8"));
        return;
    }

    boolean nicExists = false;
    try (Connection conn = DbConnection.getConnection()) {
        String sql = "SELECT * FROM user WHERE nic_no = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, resetNIC);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            nicExists = true;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (!nicExists) {
        session.removeAttribute("resetNIC");
        response.sendRedirect("index.html?error=" + java.net.URLEncoder.encode("NIC number not found in user records", "UTF-8"));
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Reset Password - PahanaEdu</title>
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
            max-width: 450px;
            background: var(--form-bg);
            border-radius: 20px;
            padding: 40px;
            backdrop-filter: blur(12px);
            border: 1px solid var(--border-color);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        .form-title {
            font-weight: 600;
            margin-bottom: 30px;
            font-size: 1.8rem;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
        }

        .form-control {
            height: 50px;
            border-radius: 10px;
            border: 1px solid var(--border-color);
            padding-left: 20px;
            margin-bottom: 20px;
            background: var(--input-bg);
            color: var(--text-primary);
            transition: all 0.3s;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            background: var(--input-bg);
            color: var(--text-primary);
        }

        .btn {
            height: 50px;
            border-radius: 10px;
            font-weight: 600;
            border: none;
            color: white;
            background-size: 200% auto;
            transition: all 0.3s;
        }

        .btn-success {
            background-image: var(--gradient-secondary);
        }

        .btn:hover {
            background-position: right center;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        #alertBox {
            font-size: 0.9rem;
            background-color: rgba(220, 53, 69, 0.2);
            border: 1px solid rgba(220, 53, 69, 0.3);
            color: var(--text-primary);
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
        <div class="card border-0 bg-transparent">
            <h3 class="form-title">Reset Your Password</h3>

            <div id="alertBox" class="alert alert-danger text-center py-2 px-3 hidden" role="alert"></div>

            <form action="ResetPasswordServlet" method="post">
                <input type="hidden" name="nic_no" value="<%= resetNIC %>"/>
                <div class="mb-3">
                    <label class="form-label">New Password</label>
                    <input type="password" name="new_password" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Confirm Password</label>
                    <input type="password" name="confirm_password" class="form-control" required />
                </div>
                <button type="submit" class="btn btn-success w-100">Update Password</button>
            </form>
        </div>
    </div>
</div>

<script>
    // DOM Elements
    const themeToggle = document.getElementById("themeToggle");
    const themeIcon = document.getElementById("themeIcon");
    const timeDisplay = document.getElementById("timeDisplay");
    const body = document.body;
    const alertBox = document.getElementById("alertBox");

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

    // Display error if passed in URL
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('error')) {
        const errorMsg = urlParams.get('error');
        alertBox.textContent = decodeURIComponent(errorMsg);
        alertBox.classList.remove('hidden');
    }
</script>

</body>
</html>
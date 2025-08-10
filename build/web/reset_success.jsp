<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Password Reset Successful - PahanaEdu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        body {
            background: linear-gradient(to right, #e9ecef, #f8f9fa);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card {
            max-width: 420px;
            padding: 2rem;
            border-radius: 1rem;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            text-align: center;
        }
        .card h4 {
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
<div class="card bg-white">
    <i class="bi bi-check-circle-fill text-success" style="font-size: 3rem;"></i>
    <h4 class="text-success">Password Reset Successful</h4>
    <p class="mb-4">You can now log in using your new password.</p>
    <a href="index.html" class="btn btn-primary w-100">
        <i class="bi bi-box-arrow-in-right"></i> Back to Login
    </a>
</div>
</body>
</html>

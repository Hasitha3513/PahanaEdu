<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome to Pahana Edu</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
            color: #333;
        }
        .header {
            background-color: #4a6fa5;
            color: white;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }
        .card {
            background-color: white;
            border-radius: 5px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: center;
        }
        .card h3 {
            margin-top: 0;
            color: #4a6fa5;
        }
        .card .value {
            font-size: 2.5em;
            font-weight: bold;
            margin: 10px 0;
            color: #2c3e50;
        }
        .card .label {
            color: #7f8c8d;
            font-size: 0.9em;
        }
        .sales-container {
            display: flex;
            gap: 20px;
            margin-top: 20px;
        }
        .sales-card {
            flex: 1;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Welcome to Pahana Edu</h1>
        <p>Books Management System</p>
    </div>

    <div class="dashboard">
        <div class="card">
            <h3>Authors</h3>
            <div class="value">100</div>
            <div class="label">Registered Authors</div>
        </div>
        
        <div class="card">
            <h3>Books</h3>
            <div class="value">250</div>
            <div class="label">Available Titles</div>
        </div>
        
        <div class="card">
            <h3>Customers</h3>
            <div class="value">18</div>
            <div class="label">Active Customers</div>
        </div>
        
        <div class="card">
            <h3>Invoices</h3>
            <div class="value">34</div>
            <div class="label">Total Invoices</div>
        </div>
    </div>

    <div class="sales-container">
        <div class="sales-card card">
            <h3>Monthly Sales</h3>
            <div class="value">Rs 55400.00</div>
            <div class="label">Current Month Revenue</div>
        </div>
        
        <div class="sales-card card">
            <h3>Today's Sales</h3>
            <div class="value">Rs 2550.00</div>
            <div class="label">Daily Revenue</div>
        </div>
    </div>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Customer" %>
<%
    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
    String userType = (String) session.getAttribute("userType");
    if (customerList == null) {
        response.sendRedirect("customer");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Customer Management - PahanaEdu</title>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <style>
        :root {
            --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --gradient-warning: linear-gradient(135deg, #f46b45 0%, #eea849 100%);
            --gradient-danger: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
            --gradient-info: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --text-primary: #2c3e50;
            --text-light: #f8f9fa;
            --bg-primary: #f8f9fa;
            --bg-secondary: #ffffff;
            --border-color: rgba(0, 0, 0, 0.1);
            --card-bg: rgba(255, 255, 255, 0.85);
            --modal-bg: rgba(255, 255, 255, 0.9);
        }

        .dark-mode {
            --gradient-primary: linear-gradient(135deg, #8a2be2 0%, #4b0082 100%);
            --gradient-warning: linear-gradient(135deg, #ff7e5f 0%, #feb47b 100%);
            --gradient-danger: linear-gradient(135deg, #ff4d4d 0%, #cc0000 100%);
            --gradient-info: linear-gradient(135deg, #00c6ff 0%, #0072ff 100%);
            --text-primary: #f8f9fa;
            --text-light: #e9ecef;
            --bg-primary: #121212;
            --bg-secondary: #1e1e1e;
            --border-color: rgba(255, 255, 255, 0.1);
            --card-bg: rgba(30, 30, 30, 0.7);
            --modal-bg: rgba(30, 30, 30, 0.85);
        }

        body {
            background: var(--bg-primary);
            color: var(--text-primary);
            transition: background 0.3s ease, color 0.3s ease;
        }

        .card {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
            transition: 0.3s ease;
            border: 1px solid var(--border-color);
        }

        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .btn {
            font-weight: 600;
            border-radius: 10px;
            border: none;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background-image: var(--gradient-primary);
            color: #fff;
        }

        .btn-warning {
            background-image: var(--gradient-warning);
            color: #fff;
        }

        .btn-danger {
            background-image: var(--gradient-danger);
            color: #fff;
        }

        .btn-info {
            background-image: var(--gradient-info);
            color: #fff;
        }

        .customer-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: var(--gradient-primary);
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-weight: bold;
            font-size: 1.4rem;
            margin-right: 15px;
            transition: all 0.3s ease;
        }

        .search-input {
            margin-bottom: 20px;
            background: var(--bg-secondary);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }

        .form-control, .form-select, .form-control:focus {
            background: var(--bg-secondary);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }

        .modal-content {
            background: var(--modal-bg);
            color: var(--text-primary);
        }

        .theme-toggle {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 1000;
        }

        .customer-details {
            flex-grow: 1;
        }

        .customer-info {
            margin-bottom: 8px;
            font-size: 0.9rem;
        }

        .customer-info i {
            width: 20px;
            text-align: center;
            margin-right: 5px;
        }
    </style>
</head>
<body class="<%= session.getAttribute("darkMode") != null && (boolean) session.getAttribute("darkMode") ? "dark-mode" : "" %>">

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Customer Management</h2>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#customerModal">Add Customer</button>
    </div>

    <input type="text" id="searchInput" class="form-control search-input" placeholder="Search by NIC or Name"/>

    <div class="row" id="customerContainer">
        <% for (Customer c : customerList) { %>
        <div class="col-lg-4 col-md-6 mb-4 customer-item">
            <div class="card p-3">
                <div class="d-flex align-items-start">
                    <div class="customer-avatar">
                        <%= c.getFirstName().charAt(0) %><%= c.getLastName().charAt(0) %>
                    </div>
                    <div class="customer-details">
                        <h5><%= c.getFirstName() %> <%= c.getLastName() %></h5>
                        <div class="customer-info">
                            <i class="bi bi-credit-card"></i> NIC: <%= c.getNicNo() %>
                        </div>
                        <div class="customer-info">
                            <i class="bi bi-phone"></i> Mobile: <%= c.getMobileNo() %>
                        </div>
                        <% if (c.getTelephoneNo() != null && !c.getTelephoneNo().isEmpty()) { %>
                        <div class="customer-info">
                            <i class="bi bi-telephone"></i> Tel: <%= c.getTelephoneNo() %>
                        </div>
                        <% } %>
                        <% if (c.getAddress() != null && !c.getAddress().isEmpty()) { %>
                        <div class="customer-info">
                            <i class="bi bi-house"></i> Address: <%= c.getAddress() %>
                        </div>
                        <% } %>
                        <div class="d-flex gap-2 mt-2">
                            <button class="btn btn-warning btn-sm edit-btn"
                                    data-id="<%= c.getCustomerId() %>"
                                    data-first="<%= c.getFirstName() %>"
                                    data-last="<%= c.getLastName() %>"
                                    data-nic="<%= c.getNicNo() %>"
                                    data-mobile="<%= c.getMobileNo() %>"
                                    data-telephone="<%= c.getTelephoneNo() %>"
                                    data-address="<%= c.getAddress() %>">
                                <i class="bi bi-pencil"></i> Edit
                            </button>
                            <% if ("ADMIN".equalsIgnoreCase(userType)) { %>
                            <form method="post" action="customer">
                                <input type="hidden" name="customer_id" value="<%= c.getCustomerId() %>">
                                <button class="btn btn-danger btn-sm" name="action" value="delete"
                                        onclick="return confirm('Are you sure you want to delete this customer?');">
                                    <i class="bi bi-trash"></i> Delete
                                </button>
                            </form>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<!-- Theme Toggle Button -->
<button class="btn btn-info btn-lg rounded-circle theme-toggle" id="themeToggle">
    <i class="bi bi-moon-fill" id="themeIcon"></i>
</button>

<!-- Modal Form -->
<div class="modal fade" id="customerModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="customer" id="customerForm">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Add Customer</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="customer_id" id="customer_id">
                    <input type="hidden" name="action" id="formAction" value="save">
                    <div class="mb-3">
                        <label class="form-label">First Name</label>
                        <input type="text" class="form-control" name="first_name" id="first_name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Last Name</label>
                        <input type="text" class="form-control" name="last_name" id="last_name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">NIC No</label>
                        <input type="text" class="form-control" name="nic_no" id="nic_no" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mobile No</label>
                        <input type="text" class="form-control" name="mobile_no" id="mobile_no" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Telephone No</label>
                        <input type="text" class="form-control" name="telephone_no" id="telephone_no">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Address</label>
                        <textarea class="form-control" name="address" id="address" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Save</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Theme management with localStorage
    document.addEventListener('DOMContentLoaded', function() {
        const themeToggle = document.getElementById('themeToggle');
        const themeIcon = document.getElementById('themeIcon');
        const body = document.body;
        
        // Check localStorage for theme preference
        const savedTheme = localStorage.getItem('theme') || 'light';
        const isDark = savedTheme === 'dark';
        
        // Apply saved theme
        if (isDark) {
            body.classList.add('dark-mode');
            themeIcon.classList.remove('bi-moon-fill');
            themeIcon.classList.add('bi-sun-fill');
        }
        
        // Toggle theme
        themeToggle.addEventListener('click', function() {
            body.classList.toggle('dark-mode');
            const isNowDark = body.classList.contains('dark-mode');
            
            // Update icon
            if (isNowDark) {
                themeIcon.classList.remove('bi-moon-fill');
                themeIcon.classList.add('bi-sun-fill');
            } else {
                themeIcon.classList.remove('bi-sun-fill');
                themeIcon.classList.add('bi-moon-fill');
            }
            
            // Save preference
            localStorage.setItem('theme', isNowDark ? 'dark' : 'light');
            
            // Send to server if needed (optional)
            fetch('theme?darkMode=' + isNowDark, { method: 'POST' });
        });
    });

    // Search filter
    document.getElementById('searchInput').addEventListener('input', function() {
        const value = this.value.toLowerCase();
        document.querySelectorAll('.customer-item').forEach(item => {
            const name = item.querySelector('h5').textContent.toLowerCase();
            const nic = item.querySelector('.customer-info').textContent.toLowerCase();
            item.style.display = name.includes(value) || nic.includes(value) ? 'block' : 'none';
        });
    });

    // Edit handler
    document.querySelectorAll('.edit-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.getElementById('modalTitle').textContent = 'Edit Customer';
            document.getElementById('customer_id').value = btn.dataset.id;
            document.getElementById('first_name').value = btn.dataset.first;
            document.getElementById('last_name').value = btn.dataset.last;
            document.getElementById('nic_no').value = btn.dataset.nic;
            document.getElementById('mobile_no').value = btn.dataset.mobile;
            document.getElementById('telephone_no').value = btn.dataset.telephone || '';
            document.getElementById('address').value = btn.dataset.address || '';
            document.getElementById('formAction').value = 'update';
            const modal = new bootstrap.Modal(document.getElementById('customerModal'));
            modal.show();
        });
    });

    // Reset modal on close
    document.getElementById('customerModal').addEventListener('hidden.bs.modal', function() {
        document.getElementById('modalTitle').textContent = 'Add Customer';
        document.getElementById('customerForm').reset();
        document.getElementById('formAction').value = 'save';
        document.getElementById('customer_id').value = '';
    });

    // NIC validation
    document.getElementById('customerForm').addEventListener('submit', function(e) {
        const nic = document.getElementById('nic_no').value.trim();
        if (!/^\d{9}[vVxX]?$|^\d{12}$/.test(nic)) {
            alert('Invalid NIC format. Please enter a valid NIC number (old format: 9 digits with optional V/X, new format: 12 digits)');
            e.preventDefault();
        }
        
        const mobile = document.getElementById('mobile_no').value.trim();
        if (!/^0\d{9}$/.test(mobile)) {
            alert('Invalid mobile number format. Please enter a 10-digit number starting with 0');
            e.preventDefault();
        }
        
        const telephone = document.getElementById('telephone_no').value.trim();
        if (telephone && !/^0\d{9}$/.test(telephone)) {
            alert('Invalid telephone number format. Please enter a 10-digit number starting with 0 or leave blank');
            e.preventDefault();
        }
    });
</script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Author" %>
<%
    List<Author> authorList = (List<Author>) request.getAttribute("authorList");
    if (authorList == null) {
        response.sendRedirect("author");
        return;
    }
    String userType = (String) session.getAttribute("userType");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Author Management - PahanaEdu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <style>
        :root {
            --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --gradient-warning: linear-gradient(135deg, #f46b45 0%, #eea849 100%);
            --gradient-danger: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
            --text-primary: #2c3e50;
            --text-light: #f8f9fa;
            --bg-primary: #f8f9fa;
            --bg-secondary: #ffffff;
            --border-color: rgba(0, 0, 0, 0.1);
            --card-bg: rgba(255, 255, 255, 0.85);
            --modal-bg: rgba(255, 255, 255, 0.9);
        }

        .dark-mode {
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
        }

        .card {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
            transition: 0.3s ease;
        }

        .card:hover {
            transform: translateY(-4px);
        }

        .btn {
            font-weight: 600;
            border-radius: 10px;
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

        .author-avatar {
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
        }

        .search-input {
            margin-bottom: 20px;
        }
    </style>
</head>
<body class="<%= session.getAttribute("darkMode") != null && (boolean) session.getAttribute("darkMode") ? "dark-mode" : "" %>">

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Author Management</h2>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#authorModal">Add Author</button>
    </div>

    <input type="text" id="authorSearch" class="form-control search-input" placeholder="Search by name or NIC">

    <div class="row" id="authorsContainer">
        <% for (Author a : authorList) { %>
            <div class="col-lg-4 col-md-6 mb-4 author-item">
                <div class="card p-3">
                    <div class="d-flex align-items-center">
                        <div class="author-avatar">
                            <%= a.getFirstName().charAt(0) %><%= a.getLastName().charAt(0) %>
                        </div>
                        <div class="flex-grow-1">
                            <h5><%= a.getFirstName() %> <%= a.getLastName() %></h5>
                            <p class="mb-1">NIC: <%= a.getNicNo() %></p>
                            <div class="d-flex gap-2">
                                <button class="btn btn-warning btn-sm edit-btn"
                                        data-id="<%= a.getAuthorId() %>"
                                        data-first="<%= a.getFirstName() %>"
                                        data-last="<%= a.getLastName() %>"
                                        data-nic="<%= a.getNicNo() %>">
                                    <i class="bi bi-pencil"></i> Edit
                                </button>
                                <% if ("ADMIN".equalsIgnoreCase(userType)) { %>
                                <form method="post" action="author">
                                    <input type="hidden" name="author_id" value="<%= a.getAuthorId() %>">
                                    <button class="btn btn-danger btn-sm" name="action" value="delete"
                                            onclick="return confirm('Are you sure you want to delete this author?');">
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

<!-- Modal -->
<div class="modal fade" id="authorModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="author" id="authorForm">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Add Author</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="author_id" id="author_id">
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
    // Search filter
    document.getElementById('authorSearch').addEventListener('input', function () {
        const value = this.value.toLowerCase();
        document.querySelectorAll('.author-item').forEach(item => {
            const name = item.querySelector('h5').textContent.toLowerCase();
            const nic = item.querySelector('p').textContent.toLowerCase();
            item.style.display = name.includes(value) || nic.includes(value) ? 'block' : 'none';
        });
    });

    // Edit handler
    document.querySelectorAll('.edit-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.getElementById('modalTitle').textContent = 'Edit Author';
            document.getElementById('author_id').value = btn.dataset.id;
            document.getElementById('first_name').value = btn.dataset.first;
            document.getElementById('last_name').value = btn.dataset.last;
            document.getElementById('nic_no').value = btn.dataset.nic;
            document.getElementById('formAction').value = 'update';
            const modal = new bootstrap.Modal(document.getElementById('authorModal'));
            modal.show();
        });
    });

    // Reset modal on close
    document.getElementById('authorModal').addEventListener('hidden.bs.modal', function () {
        document.getElementById('modalTitle').textContent = 'Add Author';
        document.getElementById('authorForm').reset();
        document.getElementById('formAction').value = 'save';
        document.getElementById('author_id').value = '';
    });

    // NIC validation
    document.getElementById('authorForm').addEventListener('submit', function (e) {
        const nic = document.getElementById('nic_no').value.trim();
        if (!/^[0-9]{9}[vVxX]?$/.test(nic)) {
            alert('Invalid NIC format');
            e.preventDefault();
        }
    });
</script>
</body>
</html>

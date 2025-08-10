<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.BankAccount, model.Customer" %>
<%
    List<BankAccount> bankAccountList = (List<BankAccount>) request.getAttribute("bankAccountList");
    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
    String userType = (String) session.getAttribute("userType");

    if (bankAccountList == null || customerList == null) {
        response.sendRedirect("bankAccount");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bank Account Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<div class="container py-4">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1">Bank Accounts</h2>
            <p class="text-muted mb-0">Manage linked customer bank accounts</p>
        </div>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addAccountModal">
            <i class="bi bi-plus-circle"></i> Add Bank Account
        </button>
    </div>

    <!-- Table -->
    <div class="table-responsive">
        <table class="table table-striped align-middle">
            <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Customer</th>
                <th>Bank Name</th>
                <th>Branch</th>
                <th>Account Number</th>
                <th>Created At</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <% if (bankAccountList.isEmpty()) { %>
                <tr>
                    <td colspan="7" class="text-center text-muted">No bank accounts found.</td>
                </tr>
            <% } else {
                for (BankAccount b : bankAccountList) { %>
                    <tr>
                        <td><%= b.getBankAccountId() %></td>
                        <td><%= b.getCustomerName() %></td>
                        <td><%= b.getBankName() %></td>
                        <td><%= b.getBankBranch() != null ? b.getBankBranch() : "-" %></td>
                        <td><%= b.getAccountNumber() %></td>
                        <td><%= b.getCreatedAt() != null ? b.getCreatedAt() : "-" %></td>
                        <td>
                            <!-- Edit -->
                            <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editModal<%= b.getBankAccountId() %>">
                                <i class="bi bi-pencil"></i>
                            </button>
                            <!-- Delete (ADMIN only) -->
                            <% if ("ADMIN".equals(userType)) { %>
                                <form action="bankAccount" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="delete"/>
                                    <input type="hidden" name="bank_account_id" value="<%= b.getBankAccountId() %>"/>
                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Delete this account?');">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            <% } %>
                        </td>
                    </tr>
                <% }
            } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Add Modal -->
<div class="modal fade" id="addAccountModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="bankAccount" method="post">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="bi bi-plus-circle"></i> Add Bank Account</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="save"/>
                    <div class="mb-3">
                        <label class="form-label">Customer</label>
                        <select name="customer_id" class="form-select" required>
                            <option value="">Select Customer</option>
                            <% for (Customer c : customerList) { %>
                                <option value="<%= c.getCustomerId() %>"><%= c.getFirstName() %> <%= c.getLastName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Bank Name</label>
                        <input type="text" name="bank_name" class="form-control" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Branch</label>
                        <input type="text" name="bank_branch" class="form-control"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Account Number</label>
                        <input type="text" name="account_number" class="form-control" required/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button class="btn btn-primary" type="submit">Add Account</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Modals -->
<% for (BankAccount b : bankAccountList) { %>
    <div class="modal fade" id="editModal<%= b.getBankAccountId() %>" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="bankAccount" method="post">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title"><i class="bi bi-pencil"></i> Edit Bank Account</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update"/>
                        <input type="hidden" name="bank_account_id" value="<%= b.getBankAccountId() %>"/>

                        <div class="mb-3">
                            <label class="form-label">Customer</label>
                            <select name="customer_id" class="form-select" required>
                                <% for (Customer c : customerList) { %>
                                    <option value="<%= c.getCustomerId() %>" <%= c.getCustomerId() == b.getCustomerId() ? "selected" : "" %>>
                                        <%= c.getFirstName() %> <%= c.getLastName() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Bank Name</label>
                            <input type="text" name="bank_name" class="form-control" value="<%= b.getBankName() %>" required/>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Branch</label>
                            <input type="text" name="bank_branch" class="form-control" value="<%= b.getBankBranch() != null ? b.getBankBranch() : "" %>"/>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Account Number</label>
                            <input type="text" name="account_number" class="form-control" value="<%= b.getAccountNumber() %>" required/>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button class="btn btn-primary" type="submit">Update Account</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.User" %>
<%@ page import="model.Customer" %>
<%
    List<User> userList = (List<User>) request.getAttribute("userList");
    String userType = (String) session.getAttribute("userType");
    if (userList == null) {
        response.sendRedirect("user");
        return;
    }
%>
<%
    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>User Management</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    </head>
    <body>
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1">User Management</h2>
                    <p class="text-muted mb-0">Manage system users</p>
                </div>
                <% if ("ADMIN".equals(userType)) { %>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                    <i class="bi bi-plus-circle"></i> Add User
                </button>
                <% } %>
            </div>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>NIC</th>
                            <th>User Type</th>
                            <th>Status</th>
                            <% if ("ADMIN".equals(userType)) { %><th>Actions</th><% } %>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (User u : userList) {%>
                        <tr>
                            <td><%= u.getUserId()%></td>
                            <td><%= u.getUsername()%></td>
                            <td><%= u.getNicNo()%></td>
                            <td><%= u.getUserType()%></td>
                            <td>
                                <span class="badge <%= u.getIsActive() ? "bg-success" : "bg-secondary"%>">
                                    <%= u.getIsActive() ? "Active" : "Inactive"%>
                                </span>
                            </td>
                            <% if ("ADMIN".equals(userType)) {%>
                            <td>
                                <button class="btn btn-warning btn-sm" data-bs-toggle="modal"
                                        data-bs-target="#editUserModal<%= u.getUserId()%>">
                                    <i class="bi bi-pencil-square"></i>
                                </button>
                                <form action="user" method="post" style="display:inline;" onsubmit="return confirm('Are you sure?');">
                                    <input type="hidden" name="action" value="delete"/>
                                    <input type="hidden" name="user_id" value="<%= u.getUserId()%>"/>
                                    <button class="btn btn-danger btn-sm" type="submit">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </td>
                            <% } %>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Add User Modal -->
        <div class="modal fade" id="addUserModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <form method="post" action="user" class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title"><i class="bi bi-person-plus"></i> Add User</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="save"/>
                        <div class="mb-3">
                            <label>Username</label>
                            <input type="text" name="username" class="form-control" required/>
                        </div>
                        <div class="mb-3">
                            <label>Password</label>
                            <input type="password" name="password" class="form-control" required/>
                        </div>
                        <div class="mb-3">
                            <label>Linked Customer (optional)</label>
                            <select name="customer_id" class="form-select">
                                <option value="">-- None --</option>
                                <% for (Customer c : customerList) {%>
                                <option value="<%= c.getCustomerId()%>">
                                    <%= c.getFirstName()%> <%= c.getLastName()%> - <%= c.getNicNo()%>
                                </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label>NIC</label>
                            <input type="text" name="nic_no" class="form-control" required/>
                        </div>
                        <div class="mb-3">
                            <label>User Type</label>
                            <select name="user_type" class="form-select" required>
                                <option value="STAFF">STAFF</option>
                                <option value="ADMIN">ADMIN</option>
                                <option value="CUSTOMER">CUSTOMER</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label>Status</label>
                            <select name="is_active" class="form-select">
                                <option value="true">Active</option>
                                <option value="false">Inactive</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add User</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Edit Modals -->
        <% for (User u : userList) {%>
        <div class="modal fade" id="editUserModal<%= u.getUserId()%>" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <form method="post" action="user" class="modal-content">
                    <div class="modal-header bg-warning text-dark">
                        <h5 class="modal-title"><i class="bi bi-pencil-square"></i> Edit User</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update"/>
                        <input type="hidden" name="user_id" value="<%= u.getUserId()%>"/>
                        <div class="mb-3">
                            <label>Username</label>
                            <input type="text" name="username" class="form-control" value="<%= u.getUsername()%>" required/>
                        </div>
                        <div class="mb-3">
                            <label>Password</label>
                            <input type="password" name="password" class="form-control" placeholder="Leave blank to keep current password"/>
                        </div>
                        <div class="mb-3">
                            <label>Linked Customer (optional)</label>
                            <select name="customer_id" class="form-select">
                                <option value="">-- None --</option>
                                <% for (Customer c : customerList) {
                                        boolean selected = u.getCustomerId() != null && u.getCustomerId() == c.getCustomerId();
                                %>
                                <option value="<%= c.getCustomerId()%>" <%= selected ? "selected" : ""%>>
                                    <%= c.getFirstName()%> <%= c.getLastName()%> - <%= c.getNicNo()%>
                                </option>
                                <% }%>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label>NIC</label>
                            <input type="text" name="nic_no" class="form-control" value="<%= u.getNicNo()%>" required/>
                        </div>
                        <div class="mb-3">
                            <label>User Type</label>
                            <select name="user_type" class="form-select">
                                <option value="STAFF" <%= "STAFF".equals(u.getUserType()) ? "selected" : ""%>>STAFF</option>
                                <option value="ADMIN" <%= "ADMIN".equals(u.getUserType()) ? "selected" : ""%>>ADMIN</option>
                                <option value="CUSTOMER" <%= "CUSTOMER".equals(u.getUserType()) ? "selected" : ""%>>CUSTOMER</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label>Status</label>
                            <select name="is_active" class="form-select">
                                <option value="true" <%= u.getIsActive() ? "selected" : ""%>>Active</option>
                                <option value="false" <%= !u.getIsActive() ? "selected" : ""%>>Inactive</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-warning">Update</button>
                    </div>
                </form>
            </div>
        </div>
        <% }%>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

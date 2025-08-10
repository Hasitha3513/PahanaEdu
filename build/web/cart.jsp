<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Cart, model.CartItem, model.Customer" %>
<%@ page import="java.util.*" %>
<%
    Cart cart = (Cart) session.getAttribute("cart");
    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
    String userType = (String) session.getAttribute("userType");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cart Summary</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container py-4">
    <h3 class="mb-4">Cart Summary</h3>

    <% if (cart == null || cart.getItems().isEmpty()) { %>
        <div class="alert alert-warning">Your cart is empty.</div>
    <% } else { %>
        <table class="table table-bordered">
            <thead>
            <tr>
                <th>Book</th>
                <th>Qty</th>
                <th>Price</th>
                <th>Discount</th>
                <th>Line Total</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <% for (CartItem item : cart.getItems()) { %>
                <tr>
                    <td><%= item.getBookName() %></td>
                    <td><%= item.getQuantity() %></td>
                    <td>Rs. <%= item.getUnitPrice() %></td>
                    <td>Rs. <%= item.getDiscount() %></td>
                    <td>Rs. <%= item.getLineTotal() %></td>
                    <td>
                        <form method="post" action="cart">
                            <input type="hidden" name="action" value="remove"/>
                            <input type="hidden" name="book_id" value="<%= item.getBookId() %>"/>
                            <button class="btn btn-danger btn-sm">Remove</button>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>

        <p><strong>Subtotal:</strong> Rs. <%= cart.getSubtotal() %></p>
        <p><strong>Total Discount:</strong> Rs. <%= cart.getTotalDiscount() %></p>
        <p><strong>Grand Total:</strong> Rs. <%= cart.getTotal() %></p>

        <% if (!"CUSTOMER".equalsIgnoreCase(userType)) { %>
            <!-- Customer Dropdown for Admin/Staff -->
            <form method="post" action="checkout">
                <div class="mb-3">
                    <label for="customer_id" class="form-label">Select Customer</label>
                    <select name="customer_id" id="customer_id" class="form-select" required>
                        <option value="">-- Choose Customer --</option>
                        <% if (customerList != null) {
                            for (Customer c : customerList) { %>
                                <option value="<%= c.getCustomerId() %>">
                                    <%= c.getFirstName() %> <%= c.getLastName() %> (NIC: <%= c.getNicNo() %>)
                                </option>
                        <%   } 
                           } else { %>
                            <option value="">No customers available</option>
                        <% } %>
                    </select>
                </div>
                <button class="btn btn-success">Complete Purchase</button>
            </form>
        <% } else { %>
            <form method="post" action="checkout">
                <button class="btn btn-success">Complete Purchase</button>
            </form>
        <% } %>
    <% } %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%@ page import="java.util.*" %>
<%
    Map<String, Object> invoice = (Map<String, Object>) request.getAttribute("invoice");
    List<Map<String, Object>> invoiceItems = (List<Map<String, Object>>) request.getAttribute("invoiceItems");
%>

<h3>Invoice #<%= invoice.get("invoice_id") %></h3>
<p><strong>Customer:</strong> <%= invoice.get("customer_name") %></p>
<p><strong>Date:</strong> <%= invoice.get("invoice_date") %></p>
<p><strong>Status:</strong> <span class="badge bg-info"><%= invoice.get("status") %></span></p>
<p><strong>Discount:</strong> ?<%= invoice.get("discount") %></p>
<p><strong>Total:</strong> ?<%= invoice.get("total_amount") %></p>

<hr>
<h5>Items</h5>
<table class="table table-bordered">
    <thead>
        <tr><th>Book</th><th>Quantity</th><th>Unit Price</th><th>Line Total</th></tr>
    </thead>
    <tbody>
    <% for (Map<String, Object> item : invoiceItems) { %>
        <tr>
            <td><%= item.get("book_name") %></td>
            <td><%= item.get("quantity") %></td>
            <td>?<%= item.get("unit_price") %></td>
            <td>?<%= item.get("line_total") %></td>
        </tr>
    <% } %>
    </tbody>
</table>

<a href="invoice" class="btn btn-secondary">? Back to Invoices</a>

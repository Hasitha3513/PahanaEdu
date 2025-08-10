<%@ page import="java.sql.*, database.DbConnection" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    String invoiceIdStr = request.getParameter("id");
    DecimalFormat df = new DecimalFormat("#,##0.00");
    if (invoiceIdStr == null) {
%>
    <p class="text-danger">Invalid invoice ID.</p>
<%
        return;
    }

    int invoiceId = Integer.parseInt(invoiceIdStr);
    Connection conn = DbConnection.getConnection();

    PreparedStatement ps = conn.prepareStatement(
        "SELECT i.*, c.first_name, c.last_name, u.username " +
        "FROM invoice i " +
        "JOIN customer c ON i.customer_id = c.customer_id " +
        "LEFT JOIN user u ON i.created_by = u.user_id " +
        "WHERE i.invoice_id = ?"
    );
    ps.setInt(1, invoiceId);
    ResultSet rs = ps.executeQuery();

    if (!rs.next()) {
%>
    <p class="text-danger">Invoice not found.</p>
<%
        return;
    }

    String customerName = rs.getString("first_name") + " " + rs.getString("last_name");
    String createdBy = rs.getString("username");
    Timestamp date = rs.getTimestamp("invoice_date");
    String status = rs.getString("status");
    double totalAmount = rs.getDouble("total_amount");
    double discount = rs.getDouble("discount");

    rs.close();
    ps.close();

    // Fetch items
    ps = conn.prepareStatement(
        "SELECT ii.*, b.book_name " +
        "FROM invoice_item ii " +
        "JOIN book b ON ii.book_id = b.book_id " +
        "WHERE ii.invoice_id = ?"
    );
    ps.setInt(1, invoiceId);
    rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Invoice #<%= invoiceId %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        @media print {
            .no-print { display: none; }
        }
    </style>
</head>
<body class="p-4">
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4>Invoice #<%= invoiceId %></h4>
        <button onclick="window.print()" class="btn btn-sm btn-outline-dark no-print"><i class="bi bi-printer"></i> Print</button>
    </div>

    <div class="mb-3">
        <strong>Customer:</strong> <%= customerName %><br/>
        <strong>Created By:</strong> <%= createdBy != null ? createdBy : "-" %><br/>
        <strong>Date:</strong> <%= date %><br/>
        <strong>Status:</strong> <%= status %><br/>
    </div>

    <table class="table table-bordered">
        <thead class="table-light">
        <tr>
            <th>#</th>
            <th>Book</th>
            <th>Qty</th>
            <th>Unit Price</th>
            <th>Line Total</th>
        </tr>
        </thead>
        <tbody>
        <%
            int i = 1;
            double subTotal = 0;
            while (rs.next()) {
                int qty = rs.getInt("quantity");
                double price = rs.getDouble("unit_price");
                double lineTotal = qty * price;
                subTotal += lineTotal;
        %>
        <tr>
            <td><%= i++ %></td>
            <td><%= rs.getString("book_name") %></td>
            <td><%= qty %></td>
            <td>Rs. <%= df.format(price) %></td>
            <td>Rs. <%= df.format(lineTotal) %></td>
        </tr>
        <%
            }
            rs.close();
            ps.close();
            conn.close();

            double discountAmount = subTotal * (discount / 100.0);
            double grandTotal = subTotal - discountAmount;
        %>
        </tbody>
        <tfoot>
        <tr>
            <th colspan="4" class="text-end">Subtotal</th>
            <th>Rs. <%= df.format(subTotal) %></th>
        </tr>
        <tr>
            <th colspan="4" class="text-end">Discount (<%= discount %>%)</th>
            <th>- Rs. <%= df.format(discountAmount) %></th>
        </tr>
        <tr class="table-success">
            <th colspan="4" class="text-end">Grand Total</th>
            <th>Rs. <%= df.format(grandTotal) %></th>
        </tr>
        </tfoot>
    </table>
</div>
</body>
</html>

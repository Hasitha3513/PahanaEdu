<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Invoice" %>
<%
    List<Invoice> invoiceList = (List<Invoice>) request.getAttribute("invoiceList");
    if (invoiceList == null) {
        response.sendRedirect("invoice");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Invoice List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="p-4 bg-light">
<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">Invoice List</h2>
        <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

    <div class="card shadow-sm">
        <div class="card-header bg-dark text-white fw-bold">All Invoices</div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Customer</th>
                        <th>Total</th>
                        <th>Discount</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Created By</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (!invoiceList.isEmpty()) {
                        for (Invoice i : invoiceList) { %>
                        <tr>
                            <td><%= i.getInvoiceId() %></td>
                            <td><%= i.getCustomerName() %></td>
                            <td>Rs. <%= String.format("%.2f", i.getTotalAmount()) %></td>
                            <td><%= i.getDiscount() %> %</td>
                            <td>
                                <span class="badge bg-<%= 
                                    "PAID".equals(i.getStatus()) ? "success" :
                                    "CANCELLED".equals(i.getStatus()) ? "danger" : "warning" %>">
                                    <%= i.getStatus() %>
                                </span>
                            </td>
                            <td><%= i.getInvoiceDate() %></td>
                            <td><%= i.getCreatedByUsername() != null ? i.getCreatedByUsername() : "-" %></td>
                            <td>
                                <button class="btn btn-sm btn-primary view-btn" data-id="<%= i.getInvoiceId() %>">
                                    <i class="bi bi-eye"></i> View
                                </button>
                            </td>
                        </tr>
                    <% } 
                    } else { %>
                        <tr>
                            <td colspan="8" class="text-center text-muted">No invoices found.</td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- ✅ Bootstrap Modal -->
<div class="modal fade" id="invoiceModal" tabindex="-1" aria-labelledby="invoiceModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title" id="invoiceModalLabel">Invoice Preview</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="invoiceModalContent">
                <div class="text-center">
                    <div class="spinner-border text-primary" role="status"></div>
                    <p>Loading...</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ✅ Bootstrap JS (Required for Modal) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- ✅ AJAX Script to Load View Invoice -->
<script>
    $(document).ready(function () {
        $('.view-btn').click(function () {
            const invoiceId = $(this).data('id');
            $('#invoiceModalContent').html('<div class="text-center"><div class="spinner-border text-primary"></div><p>Loading...</p></div>');
            const modal = new bootstrap.Modal(document.getElementById('invoiceModal'));
            modal.show();
            $.get('view_invoice.jsp', { id: invoiceId }, function (data) {
                $('#invoiceModalContent').html(data);
            });
        });
    });
</script>
</body>
</html>

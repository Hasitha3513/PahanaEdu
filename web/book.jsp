<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Book, model.Author" %>
<%
    List<Book> bookList = (List<Book>) request.getAttribute("bookList");
    List<Author> authorList = (List<Author>) request.getAttribute("authorList");
    String userType = (String) session.getAttribute("userType");
    if (bookList == null || authorList == null) {
        response.sendRedirect("book");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Book Management System</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            :root {
                --primary-color: #4361ee;
                --secondary-color: #3f37c9;
                --accent-color: #4895ef;
                --light-color: #f8f9fa;
                --dark-color: #212529;
                --success-color: #4cc9f0;
                --danger-color: #f72585;
            }

            body {
                background-color: #f5f7fa;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .table-container {
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                padding: 20px;
            }

            .table thead th {
                border-bottom: 2px solid #e9ecef;
                font-weight: 600;
                color: #495057;
            }

            .table tbody tr {
                transition: all 0.2s ease;
            }

            .table tbody tr:hover {
                background-color: rgba(67, 97, 238, 0.05);
            }

            .action-btn {
                width: 30px;
                height: 30px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
                margin: 0 3px;
            }

            .view-btn {
                background-color: rgba(73, 80, 87, 0.1);
                color: #495057;
            }

            .edit-btn {
                background-color: rgba(255, 193, 7, 0.1);
                color: #ffc107;
            }

            .delete-btn {
                background-color: rgba(220, 53, 69, 0.1);
                color: #dc3545;
            }

            .badge-stock {
                background-color: #e9ecef;
                color: var(--dark-color);
                font-weight: 500;
                padding: 5px 10px;
                border-radius: 20px;
            }

            .badge-out-of-stock {
                background-color: #fff3cd;
                color: #856404;
            }

            .badge-in-stock {
                background-color: #d4edda;
                color: #155724;
            }

            .author-chip {
                display: inline-block;
                background-color: #e0e7ff;
                color: var(--primary-color);
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 0.85rem;
            }

            .modal-book-cover {
                height: 120px;
                background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 2rem;
                margin-bottom: 20px;
                border-radius: 8px;
            }

            .book-detail-item {
                margin-bottom: 12px;
            }

            .book-detail-label {
                font-weight: 600;
                color: #6c757d;
                margin-bottom: 4px;
            }

            .book-detail-value {
                font-size: 1.05rem;
            }
        </style>
    </head>
    <body>
        <div class="container py-4">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1">Book Management</h2>
                    <p class="text-muted mb-0">Manage your book collection in table view</p>
                </div>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newBookModal">
                    <i class="bi bi-plus-lg me-1"></i> Add Book
                </button>
            </div>

            <!-- Book Table -->
            <div class="table-container">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Book Title</th>
                                <th>Author</th>
                                <th>ISBN</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (bookList.isEmpty()) { %>
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">
                                    <i class="bi bi-book" style="font-size: 2rem;"></i>
                                    <p class="mt-2 mb-0">No books found. Add your first book!</p>
                                </td>
                            </tr>
                            <% } else {
                                for (Book b : bookList) {
                                    String authorName = "Unknown Author";
                                    for (Author a : authorList) {
                                        if (a.getAuthorId() == b.getAuthorId()) {
                                            authorName = a.getFirstName() + " " + a.getLastName();
                                            break;
                                        }
                                    }
                                    String stockClass = b.getStockQuantity() > 0 ? "badge-in-stock" : "badge-out-of-stock";
                                    String stockText = b.getStockQuantity() > 0 ? "In Stock (" + b.getStockQuantity() + ")" : "Out of Stock";
                            %>
                            <tr>
                                <td><%= b.getBookId()%></td>
                                <td><strong><%= b.getBookName()%></strong></td>
                                <td><span class="author-chip"><i class="bi bi-person"></i> <%= authorName%></span></td>
                                <td><%= b.getIsbnNo() != null ? b.getIsbnNo() : "-"%></td>
                                <td>Rs <%= String.format("%.2f", b.getPrice())%></td>
                                <td><span class="badge <%= stockClass%>"><%= stockText%></span></td>
                                <td class="d-flex flex-wrap align-items-center">
                                    <button class="action-btn view-btn" data-bs-toggle="modal"
                                            data-bs-target="#viewBookModal"
                                            data-book-id="<%= b.getBookId()%>"
                                            data-book-name="<%= b.getBookName()%>"
                                            data-author-name="<%= authorName%>"
                                            data-isbn="<%= b.getIsbnNo() != null ? b.getIsbnNo() : "N/A"%>"
                                            data-price="<%= String.format("%.2f", b.getPrice())%>"
                                            data-stock="<%= b.getStockQuantity()%>"
                                            data-created="<%= b.getCreatedAt() != null ? b.getCreatedAt() : "N/A"%>">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button class="action-btn edit-btn" data-bs-toggle="modal"
                                            data-bs-target="#editBookModal<%= b.getBookId()%>">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <% if ("ADMIN".equals(userType)) {%>
                                    <form method="post" action="book" class="d-inline">
                                        <input type="hidden" name="action" value="delete"/>
                                        <input type="hidden" name="book_id" value="<%= b.getBookId()%>"/>
                                        <button type="submit" class="action-btn delete-btn"
                                                onclick="return confirm('Are you sure you want to delete this book?');">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                    <% }%>
                                    <%-- Add to Cart --%>
                                    <form method="post" action="cart" class="d-inline-flex align-items-center">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="book_id" value="<%= b.getBookId()%>">
                                        <input type="hidden" name="book_name" value="<%= b.getBookName()%>">
                                        <input type="hidden" name="unit_price" value="<%= b.getPrice()%>">
                                        <div class="input-group input-group-sm">
                                            <input type="number" name="quantity" min="1" max="<%= b.getStockQuantity()%>" value="1" class="form-control" style="width: 70px;">
                                            <input type="number" name="discount" min="0" step="0.01" value="0" class="form-control" placeholder="Discount">
                                            <button type="submit" class="btn btn-success">
                                                <i class="bi bi-cart-plus"></i>
                                            </button>
                                        </div>
                                    </form>

                                </td>
                            </tr>
                            <% }
                                } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- View Book Modal -->
        <div class="modal fade" id="viewBookModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title"><i class="bi bi-book"></i> Book Details</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="modal-book-cover">
                            <i class="bi bi-book-half"></i>
                        </div>

                        <div class="book-detail-item">
                            <div class="book-detail-label">Book Title</div>
                            <div class="book-detail-value" id="viewBookName"></div>
                        </div>

                        <div class="book-detail-item">
                            <div class="book-detail-label">Author</div>
                            <div class="book-detail-value" id="viewAuthorName"></div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 book-detail-item">
                                <div class="book-detail-label">ISBN</div>
                                <div class="book-detail-value" id="viewIsbn"></div>
                            </div>
                            <div class="col-md-6 book-detail-item">
                                <div class="book-detail-label">Price</div>
                                <div class="book-detail-value">Rs<span id="viewPrice"></span></div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 book-detail-item">
                                <div class="book-detail-label">Stock Quantity</div>
                                <div class="book-detail-value" id="viewStock"></div>
                            </div>
                            <div class="col-md-6 book-detail-item">
                                <div class="book-detail-label">Added On</div>
                                <div class="book-detail-value" id="viewCreated"></div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- New Book Modal -->
        <div class="modal fade" id="newBookModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title"><i class="bi bi-plus-lg"></i> Add New Book</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="book">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="save"/>

                            <div class="mb-3">
                                <label class="form-label">Book Title</label>
                                <input type="text" name="book_name" class="form-control" placeholder="Enter book title" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Author</label>
                                <select name="author_id" class="form-select" required>
                                    <option value="">Select Author</option>
                                    <% for (Author a : authorList) {%>
                                    <option value="<%= a.getAuthorId()%>"><%= a.getFirstName()%> <%= a.getLastName()%></option>
                                    <% } %>
                                </select>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Price (Rs)</label>
                                    <input type="number" name="price" step="0.01" class="form-control" placeholder="0.00" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Stock Quantity</label>
                                    <input type="number" name="stock_quantity" class="form-control" placeholder="0" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">ISBN Number</label>
                                <input type="text" name="isbn_no" class="form-control" placeholder="Optional">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Add Book</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Edit Book Modals -->
        <% for (Book b : bookList) {
                String authorName = "Unknown Author";
                for (Author a : authorList) {
                    if (a.getAuthorId() == b.getAuthorId()) {
                        authorName = a.getFirstName() + " " + a.getLastName();
                        break;
                    }
                }
        %>
        <div class="modal fade" id="editBookModal<%= b.getBookId()%>" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title"><i class="bi bi-pencil"></i> Edit Book</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="book">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="update"/>
                            <input type="hidden" name="book_id" value="<%= b.getBookId()%>"/>

                            <div class="mb-3">
                                <label class="form-label">Book Title</label>
                                <input type="text" name="book_name" class="form-control" value="<%= b.getBookName()%>" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Author</label>
                                <select name="author_id" class="form-select" required>
                                    <% for (Author a : authorList) {%>
                                    <option value="<%= a.getAuthorId()%>" <%= (a.getAuthorId() == b.getAuthorId()) ? "selected" : ""%>>
                                        <%= a.getFirstName()%> <%= a.getLastName()%>
                                    </option>
                                    <% }%>
                                </select>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Price (Rs)</label>
                                    <input type="number" name="price" step="0.01" class="form-control" value="<%= b.getPrice()%>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Stock Quantity</label>
                                    <input type="number" name="stock_quantity" class="form-control" value="<%= b.getStockQuantity()%>" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">ISBN Number</label>
                                <input type="text" name="isbn_no" class="form-control" value="<%= b.getIsbnNo() != null ? b.getIsbnNo() : ""%>">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <% }%>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                    // View Book Modal Data Binding
                                                    document.getElementById('viewBookModal').addEventListener('show.bs.modal', function (event) {
                                                        var button = event.relatedTarget;
                                                        document.getElementById('viewBookName').textContent = button.getAttribute('data-book-name');
                                                        document.getElementById('viewAuthorName').textContent = button.getAttribute('data-author-name');
                                                        document.getElementById('viewIsbn').textContent = button.getAttribute('data-isbn');
                                                        document.getElementById('viewPrice').textContent = button.getAttribute('data-price');
                                                        document.getElementById('viewStock').textContent = button.getAttribute('data-stock');
                                                        document.getElementById('viewCreated').textContent = button.getAttribute('data-created');
                                                    });
        </script>
    </body>
</html>
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.*;
import model.Cart;
import model.CartItem;
import dao.BookDAO;
import dao.InvoiceDAO;
import dao.InvoiceItemDAO;
import model.Invoice;
import model.InvoiceItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;

/**
 *
 * @author hasit
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) {
            resp.sendRedirect("cart.jsp?error=empty");
            return;
        }

        String userType = (String) session.getAttribute("userType");
        Integer createdBy = (Integer) session.getAttribute("userId");

        int customerId;
        if ("ADMIN".equalsIgnoreCase(userType) || "STAFF".equalsIgnoreCase(userType)) {
            customerId = Integer.parseInt(req.getParameter("customer_id"));
        } else {
            customerId = (int) session.getAttribute("customerId");
        }

        // Create Invoice
        Invoice invoice = new Invoice();
        invoice.setCustomerId(customerId);
        invoice.setDiscount(cart.getTotalDiscount()); // ✅ use correct method
        invoice.setTotalAmount(cart.getTotalAfterDiscount());
        invoice.setCreatedBy(createdBy);
        invoice.setStatus("PAID");

        int invoiceId = new InvoiceDAO().saveInvoice(invoice);

        if (invoiceId != -1) {
            InvoiceItemDAO itemDAO = new InvoiceItemDAO();
            BookDAO bookDAO = new BookDAO();

            for (CartItem item : cart.getItems()) {
                InvoiceItem invoiceItem = new InvoiceItem();
                invoiceItem.setInvoiceId(invoiceId);
                invoiceItem.setBookId(item.getBookId());
                invoiceItem.setQuantity(item.getQuantity());
                invoiceItem.setUnitPrice(item.getUnitPrice());

                itemDAO.saveInvoiceItem(invoiceItem);

                try {
                    bookDAO.decreaseStock(item.getBookId(), item.getQuantity());
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            // Clear cart
            session.removeAttribute("cart");
            resp.sendRedirect("invoice.jsp?success");
        } else {
            resp.sendRedirect("cart.jsp?error=save_failed");
        }
    }
}
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import database.DbConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

/**
 *
 * @author hasit
 */
@WebServlet("/invoice-detail")
public class InvoiceDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int invoiceId = Integer.parseInt(req.getParameter("invoice_id"));

        Map<String, Object> invoice = new HashMap<>();
        List<Map<String, Object>> items = new ArrayList<>();

        try (Connection conn = DbConnection.getConnection()) {

            // Load invoice header
            PreparedStatement invoiceStmt = conn.prepareStatement(
                    "SELECT i.*, c.first_name, c.last_name FROM invoice i " +
                    "JOIN customer c ON i.customer_id = c.customer_id " +
                    "WHERE i.invoice_id = ?");
            invoiceStmt.setInt(1, invoiceId);
            ResultSet rs1 = invoiceStmt.executeQuery();

            if (rs1.next()) {
                invoice.put("invoice_id", rs1.getInt("invoice_id"));
                invoice.put("customer_name", rs1.getString("first_name") + " " + rs1.getString("last_name"));
                invoice.put("invoice_date", rs1.getTimestamp("invoice_date"));
                invoice.put("total_amount", rs1.getDouble("total_amount"));
                invoice.put("discount", rs1.getDouble("discount"));
                invoice.put("status", rs1.getString("status"));
            }

            // Load items
            PreparedStatement itemStmt = conn.prepareStatement(
                    "SELECT ii.*, b.book_name FROM invoice_item ii " +
                    "JOIN book b ON ii.book_id = b.book_id " +
                    "WHERE ii.invoice_id = ?");
            itemStmt.setInt(1, invoiceId);
            ResultSet rs2 = itemStmt.executeQuery();

            while (rs2.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("book_name", rs2.getString("book_name"));
                item.put("quantity", rs2.getInt("quantity"));
                item.put("unit_price", rs2.getDouble("unit_price"));
                item.put("line_total", rs2.getDouble("line_total"));
                items.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        req.setAttribute("invoice", invoice);
        req.setAttribute("invoiceItems", items);
        req.getRequestDispatcher("invoice_detail.jsp").forward(req, resp);
    }
}
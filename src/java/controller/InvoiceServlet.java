/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import database.DbConnection;
import model.Invoice;

import database.DbConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Invoice;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.io.IOException;

/**
 *
 * @author hasit
 */
@WebServlet("/invoice")
public class InvoiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String userType = (String) req.getSession().getAttribute("userType");
        Integer customerId = (Integer) req.getSession().getAttribute("customerId");

        List<Invoice> invoiceList = new ArrayList<>();
        String sql;

        // Query varies by role
        if ("CUSTOMER".equalsIgnoreCase(userType)) {
            sql = "SELECT i.*, c.first_name, c.last_name, u.username FROM invoice i " +
                  "JOIN customer c ON i.customer_id = c.customer_id " +
                  "LEFT JOIN user u ON i.created_by = u.user_id " +
                  "WHERE i.customer_id = ? ORDER BY i.invoice_date DESC";
        } else {
            sql = "SELECT i.*, c.first_name, c.last_name, u.username FROM invoice i " +
                  "JOIN customer c ON i.customer_id = c.customer_id " +
                  "LEFT JOIN user u ON i.created_by = u.user_id " +
                  "ORDER BY i.invoice_date DESC";
        }

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if ("CUSTOMER".equalsIgnoreCase(userType)) {
                stmt.setInt(1, customerId);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setInvoiceId(rs.getInt("invoice_id"));
                invoice.setCustomerId(rs.getInt("customer_id"));
                invoice.setCustomerName(rs.getString("first_name") + " " + rs.getString("last_name"));
                invoice.setInvoiceDate(rs.getTimestamp("invoice_date"));
                invoice.setDiscount(rs.getDouble("discount"));
                invoice.setTotalAmount(rs.getDouble("total_amount"));
                invoice.setCreatedBy(rs.getInt("created_by"));
                invoice.setCreatedByUsername(rs.getString("username"));
                invoice.setStatus(rs.getString("status"));

                invoiceList.add(invoice);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        req.setAttribute("invoiceList", invoiceList);
        req.getRequestDispatcher("invoice.jsp").forward(req, resp);
    }
}
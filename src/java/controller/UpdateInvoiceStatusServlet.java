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
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author hasit
 */
@WebServlet("/update-invoice-status")
public class UpdateInvoiceStatusServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int invoiceId = Integer.parseInt(req.getParameter("invoice_id"));
        String newStatus = req.getParameter("status");

        try (Connection conn = DbConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("UPDATE invoice SET status = ? WHERE invoice_id = ?");
            stmt.setString(1, newStatus);
            stmt.setInt(2, invoiceId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("invoice");
    }
}
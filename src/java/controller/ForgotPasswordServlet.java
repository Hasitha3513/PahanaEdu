/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import database.DbConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author hasit
 */
public class ForgotPasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String identifier = request.getParameter("identifier");

        try (Connection conn = DbConnection.getConnection()) {
            String sql = "SELECT * FROM user WHERE nic_no = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, identifier);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // NIC found, allow reset
                HttpSession session = request.getSession();
                session.setAttribute("resetNIC", identifier);
                response.sendRedirect("reset_password.jsp");
            } else {
                // NIC not found, show error
                request.setAttribute("error", "NIC number not found. Please try again.");
                request.getRequestDispatcher("index.html").forward(request, response);
            }

        } catch (Exception e) {
            response.sendRedirect("index.html?reset=fail");
        }
    }
}
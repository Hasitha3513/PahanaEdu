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
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author hasit
 */
public class ResetPasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nicNo = request.getParameter("nic_no");
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("reset_password.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DbConnection.getConnection()) {
            String sql = "UPDATE user SET password = ? WHERE nic_no = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, newPassword); // In production, use hashed password
            stmt.setString(2, nicNo);

            int updated = stmt.executeUpdate();
            if (updated > 0) {
                request.getSession().removeAttribute("resetNIC");
                response.sendRedirect("index.html?reset=success");
            } else {
                request.setAttribute("error", "NIC not found.");
                request.getRequestDispatcher("reset_password.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.html?reset=fail");
        }
    }
}

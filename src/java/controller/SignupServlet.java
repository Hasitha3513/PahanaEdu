/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.UserDAO;
import jakarta.servlet.annotation.WebServlet;
import model.User;
import java.io.IOException;

/**
 *
 * @author hasit
 */
//@WebServlet("/SignupServlet") // ✅ Make sure this is present
public class SignupServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            UserDAO dao = new UserDAO();

            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String nicNo = request.getParameter("nic_no");

            if (dao.isUsernameOrNICExists(username, nicNo)) {
                response.sendRedirect("index.html?error=Username or NIC already exists");
                return;
            }

            User user = new User();
            user.setUsername(username);
            user.setPassword(password); // ⚠️ Hash in real app
            user.setNicNo(nicNo);

            if (dao.isUserTableEmpty()) {
                user.setUserType("ADMIN");
            } else {
                user.setUserType("STAFF");
            }

            boolean inserted = dao.insertDefaultUser(user);

            if (inserted) {
                response.sendRedirect("index.html?message=success");
            } else {
                response.sendRedirect("index.html?error=Signup failed. Try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.html?error=Internal server error");
        }
    }
}
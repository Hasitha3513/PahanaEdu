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
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;

/**
 *
 * @author hasit
 */
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            UserDAO dao = new UserDAO();
            User user = dao.login(username, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("username", user.getUsername());
                session.setAttribute("userType", user.getUserType());
                session.setAttribute("userId", user.getUserId());
                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("Unauthorized.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Unauthorized.jsp?error=true");
        }
    }
}
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.*;
import dao.AuthorDAO;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;


/**
 *
 * @author hasit
 */
@WebServlet("/welcome")
public class WelcomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AuthorDAO authorDAO = new AuthorDAO();
        int authorCount = authorDAO.getAuthorCount(); // ✅ get count

        request.setAttribute("authorCount", authorCount); // ✅ set to request

        // ✅ forward to JSP with data
        RequestDispatcher dispatcher = request.getRequestDispatcher("welcome.jsp");
        dispatcher.forward(request, response);
    }
}
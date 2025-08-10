/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AuthorDAO;
import model.Author;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;


/**
 *
 * @author hasit
 */
@WebServlet("/author")
public class AuthorServlet extends HttpServlet {
    private final AuthorDAO authorDAO = new AuthorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Author> authorList = authorDAO.getAllAuthors();
        request.setAttribute("authorList", authorList);
        request.getRequestDispatcher("author.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String nicNo = request.getParameter("nic_no");
        String idStr = request.getParameter("author_id");

        if ("save".equals(action)) {
            Author author = new Author();
            author.setFirstName(firstName);
            author.setLastName(lastName);
            author.setNicNo(nicNo);
            authorDAO.saveAuthor(author);
        } else if ("update".equals(action)) {
            Author author = new Author();
            author.setAuthorId(Integer.parseInt(idStr));
            author.setFirstName(firstName);
            author.setLastName(lastName);
            author.setNicNo(nicNo);
            authorDAO.updateAuthor(author);
        } else if ("delete".equals(action)) {
            int authorId = Integer.parseInt(request.getParameter("author_id"));
            authorDAO.deleteAuthor(authorId);
        }

        response.sendRedirect("author");
    }
}
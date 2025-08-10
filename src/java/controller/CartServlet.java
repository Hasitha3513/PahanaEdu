/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.*;
import dao.CustomerDAO;
import jakarta.servlet.annotation.WebServlet;
import model.Cart;
import model.CartItem;
import model.Customer;

import java.io.IOException;
import java.util.List;

/**
 *
 * @author hasit
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        // Load or create cart from session
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        // Load all customers for dropdown
        List<Customer> customerList = customerDAO.getAllCustomers();
        req.setAttribute("customerList", customerList);

        // Forward to cart.jsp
        req.getRequestDispatcher("cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) cart = new Cart();

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            int bookId = Integer.parseInt(req.getParameter("book_id"));

            if ("add".equals(action)) {
                String bookName = req.getParameter("book_name");
                double unitPrice = Double.parseDouble(req.getParameter("unit_price"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                double discount = Double.parseDouble(req.getParameter("discount"));

                CartItem item = new CartItem(bookId, bookName, unitPrice, quantity, discount);
                cart.addItem(item);
            } else if ("remove".equals(action)) {
                cart.removeItem(bookId);
            }
        } catch (NumberFormatException | NullPointerException e) {
            e.printStackTrace(); // Log error for debugging
        }

        session.setAttribute("cart", cart);
        resp.sendRedirect("cart");
    }
}
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.CustomerDAO;
import model.Customer;

import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author hasit
 */
@WebServlet("/customer")
public class CustomerServlet extends HttpServlet {
    private final CustomerDAO dao = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Customer> list = dao.getAllCustomers();
        req.setAttribute("customerList", list);
        req.getRequestDispatcher("customer.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        Customer c = new Customer();
        c.setFirstName(req.getParameter("first_name"));
        c.setLastName(req.getParameter("last_name"));
        c.setNicNo(req.getParameter("nic_no"));
        c.setMobileNo(req.getParameter("mobile_no"));
        c.setTelephoneNo(req.getParameter("telephone_no"));
        c.setAddress(req.getParameter("address"));

        if ("save".equals(action)) {
            dao.saveCustomer(c);
        } else if ("update".equals(action)) {
            c.setCustomerId(Integer.parseInt(req.getParameter("customer_id")));
            dao.updateCustomer(c);
        } else if ("delete".equals(action)) {
            dao.deleteCustomer(Integer.parseInt(req.getParameter("customer_id")));
        }

        resp.sendRedirect("customer");
    }
}
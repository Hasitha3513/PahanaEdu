    /*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
     */
    package controller;

import dao.CustomerDAO;
    import dao.UserDAO;
    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.*;
    import model.User;

    import java.io.IOException;
    import java.util.List;
import model.Customer;

    /**
     *
     * @author hasit
     */
    @WebServlet("/user")
public class UserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<User> userList = userDAO.getAllUsers();
            List<Customer> customerList = customerDAO.getAllCustomers(); // ✅ preload customers

            request.setAttribute("userList", userList);
            request.setAttribute("customerList", customerList); // ✅ pass to user.jsp

            request.getRequestDispatcher("user.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("user_id"));
                userDAO.deleteUser(userId);

            } else {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String userType = request.getParameter("user_type");
                String nicNo = request.getParameter("nic_no");
                boolean isActive = request.getParameter("is_active") != null;

                // 🔄 Customer ID (can be null)
                String customerIdStr = request.getParameter("customer_id");
                Integer customerId = (customerIdStr != null && !customerIdStr.isEmpty())
                        ? Integer.parseInt(customerIdStr) : null;

                User user = new User();
                user.setUsername(username);
                user.setUserType(userType);
                user.setNicNo(nicNo);
                user.setIsActive(isActive);
                user.setCustomerId(customerId); // ✅

                if ("save".equals(action)) {
                    user.setPassword(password); // required on save
                    userDAO.saveUser(user);

                } else if ("update".equals(action)) {
                    int userId = Integer.parseInt(request.getParameter("user_id"));
                    user.setUserId(userId);

                    // Retain old password if not provided
                    if (password != null && !password.trim().isEmpty()) {
                        user.setPassword(password);
                    } else {
                        User existing = userDAO.getUserById(userId);
                        if (existing != null) {
                            user.setPassword(existing.getPassword());
                        }
                    }

                    userDAO.updateUser(user);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("user");
    }
}
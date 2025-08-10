/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;


import dao.BankAccountDAO;
import dao.CustomerDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.BankAccount;
import model.Customer;

import java.io.IOException;
import java.util.List;

/**
 *
 * @author hasit
 */
@WebServlet("/bankAccount")
public class BankAccountServlet extends HttpServlet {

    private final BankAccountDAO bankAccountDAO = new BankAccountDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<BankAccount> bankAccounts = bankAccountDAO.getAllBankAccounts();
        List<Customer> customerList = customerDAO.getAllCustomers();

        request.setAttribute("bankAccountList", bankAccounts);
        request.setAttribute("customerList", customerList);
        request.getRequestDispatcher("bank_account.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("bankAccount");
            return;
        }

        int bankAccountId = parseInt(request.getParameter("bank_account_id"));
        String bankName = request.getParameter("bank_name");
        String bankBranch = request.getParameter("bank_branch");
        String accountNumber = request.getParameter("account_number");
        int customerId = parseInt(request.getParameter("customer_id"));

        BankAccount b = new BankAccount();
        b.setBankAccountId(bankAccountId);
        b.setBankName(bankName);
        b.setBankBranch(bankBranch);
        b.setAccountNumber(accountNumber);
        b.setCustomerId(customerId);

        switch (action) {
            case "save":
                bankAccountDAO.saveBankAccount(b);
                break;
            case "update":
                bankAccountDAO.updateBankAccount(b);
                break;
            case "delete":
                bankAccountDAO.deleteBankAccount(bankAccountId);
                break;
        }

        response.sendRedirect("bankAccount");
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return 0;
        }
    }
}
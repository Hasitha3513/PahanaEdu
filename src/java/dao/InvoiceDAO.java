/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import database.DbConnection;
import model.Invoice;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author hasit
 */
public class InvoiceDAO {

    // Save invoice and return generated invoice_id
    public int saveInvoice(Invoice invoice) {
        int invoiceId = -1;
        String sql = "INSERT INTO invoice (customer_id, invoice_date, total_amount, created_by, discount, status) " +
                     "VALUES (?, NOW(), ?, ?, ?, ?)";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, invoice.getCustomerId());
            stmt.setDouble(2, invoice.getTotalAmount());
            stmt.setInt(3, invoice.getCreatedBy());
            stmt.setDouble(4, invoice.getDiscount());
            stmt.setString(5, invoice.getStatus());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    invoiceId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoiceId;
    }

    // Fetch all invoices with customer and user names
    public List<Invoice> getAllInvoices() {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT i.*, " +
                     "c.first_name AS customer_first, c.last_name AS customer_last, " +
                     "u.username AS created_by_name " +
                     "FROM invoice i " +
                     "JOIN customer c ON i.customer_id = c.customer_id " +
                     "LEFT JOIN user u ON i.created_by = u.user_id " +
                     "ORDER BY i.invoice_date DESC";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Invoice inv = new Invoice();
                inv.setInvoiceId(rs.getInt("invoice_id"));
                inv.setCustomerId(rs.getInt("customer_id"));
                inv.setInvoiceDate(rs.getTimestamp("invoice_date"));
                inv.setTotalAmount(rs.getDouble("total_amount"));
                inv.setDiscount(rs.getDouble("discount"));
                inv.setCreatedBy(rs.getInt("created_by"));
                inv.setStatus(rs.getString("status"));

                String customerName = rs.getString("customer_first") + " " + rs.getString("customer_last");
                inv.setCustomerName(customerName);
                inv.setCreatedByUsername(rs.getString("created_by_name"));

                list.add(inv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
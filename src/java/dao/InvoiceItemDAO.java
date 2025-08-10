/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import database.DbConnection;
import model.InvoiceItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author hasit
 */
public class InvoiceItemDAO {
    public void saveInvoiceItem(InvoiceItem item) {
        String sql = "INSERT INTO invoice_item (invoice_id, book_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, item.getInvoiceId());
            stmt.setInt(2, item.getBookId());
            stmt.setInt(3, item.getQuantity());
            stmt.setDouble(4, item.getUnitPrice());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<InvoiceItem> getItemsByInvoiceId(int invoiceId) {
        List<InvoiceItem> list = new ArrayList<>();
        String sql = "SELECT * FROM invoice_item WHERE invoice_id=?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, invoiceId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    InvoiceItem item = new InvoiceItem();
                    item.setInvoiceItemId(rs.getInt("invoice_item_id"));
                    item.setInvoiceId(rs.getInt("invoice_id"));
                    item.setBookId(rs.getInt("book_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getDouble("unit_price"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import database.DbConnection;
import model.Customer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author hasit
 */
public class CustomerDAO {

    // Get all customers
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customer ORDER BY created_at DESC";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Customer c = new Customer();
                c.setCustomerId(rs.getInt("customer_id"));
                c.setFirstName(rs.getString("first_name"));
                c.setLastName(rs.getString("last_name"));
                c.setNicNo(rs.getString("nic_no"));
                c.setMobileNo(rs.getString("mobile_no"));
                c.setTelephoneNo(rs.getString("telephone_no"));
                c.setAddress(rs.getString("address"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                customers.add(c);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return customers;
    }

    // Save new customer
    public boolean saveCustomer(Customer c) {
        String sql = "INSERT INTO customer (first_name, last_name, nic_no, mobile_no, telephone_no, address) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, c.getFirstName());
            stmt.setString(2, c.getLastName());
            stmt.setString(3, c.getNicNo());
            stmt.setString(4, c.getMobileNo());
            stmt.setString(5, c.getTelephoneNo());
            stmt.setString(6, c.getAddress());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Update customer
    public boolean updateCustomer(Customer c) {
        String sql = "UPDATE customer SET first_name = ?, last_name = ?, nic_no = ?, mobile_no = ?, telephone_no = ?, address = ? WHERE customer_id = ?";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, c.getFirstName());
            stmt.setString(2, c.getLastName());
            stmt.setString(3, c.getNicNo());
            stmt.setString(4, c.getMobileNo());
            stmt.setString(5, c.getTelephoneNo());
            stmt.setString(6, c.getAddress());
            stmt.setInt(7, c.getCustomerId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Delete customer by ID
    public boolean deleteCustomer(int customerId) {
        String sql = "DELETE FROM customer WHERE customer_id = ?";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Get single customer by ID
    public Customer getCustomerById(int id) {
        String sql = "SELECT * FROM customer WHERE customer_id = ?";
        Customer c = null;

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                c = new Customer();
                c.setCustomerId(rs.getInt("customer_id"));
                c.setFirstName(rs.getString("first_name"));
                c.setLastName(rs.getString("last_name"));
                c.setNicNo(rs.getString("nic_no"));
                c.setMobileNo(rs.getString("mobile_no"));
                c.setTelephoneNo(rs.getString("telephone_no"));
                c.setAddress(rs.getString("address"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return c;
    }
}
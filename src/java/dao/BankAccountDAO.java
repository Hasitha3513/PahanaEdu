/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import database.DbConnection;
import model.BankAccount;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author hasit
 */
public class BankAccountDAO {

    public List<BankAccount> getAllBankAccounts() {
        List<BankAccount> list = new ArrayList<>();
        String sql = "SELECT ba.*, CONCAT(c.first_name, ' ', c.last_name) AS customer_name " +
                     "FROM bank_account ba " +
                     "JOIN customer c ON ba.customer_id = c.customer_id " +
                     "ORDER BY ba.created_at DESC";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                BankAccount b = new BankAccount();
                b.setBankAccountId(rs.getInt("bank_account_id"));
                b.setBankName(rs.getString("bank_name"));
                b.setBankBranch(rs.getString("bank_branch"));
                b.setAccountNumber(rs.getString("account_number"));
                b.setCustomerId(rs.getInt("customer_id"));
                b.setCustomerName(rs.getString("customer_name"));
                b.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(b);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean saveBankAccount(BankAccount b) {
        String sql = "INSERT INTO bank_account (bank_name, bank_branch, account_number, customer_id) " +
                     "VALUES (?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, b.getBankName());
            stmt.setString(2, b.getBankBranch());
            stmt.setString(3, b.getAccountNumber());
            stmt.setInt(4, b.getCustomerId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateBankAccount(BankAccount b) {
        String sql = "UPDATE bank_account SET bank_name=?, bank_branch=?, account_number=?, customer_id=? " +
                     "WHERE bank_account_id=?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, b.getBankName());
            stmt.setString(2, b.getBankBranch());
            stmt.setString(3, b.getAccountNumber());
            stmt.setInt(4, b.getCustomerId());
            stmt.setInt(5, b.getBankAccountId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteBankAccount(int id) {
        String sql = "DELETE FROM bank_account WHERE bank_account_id=?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
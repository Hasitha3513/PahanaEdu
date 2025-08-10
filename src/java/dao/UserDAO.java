/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.User;
import database.DbConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author hasit
 */
public class UserDAO {
    private final Connection conn = DbConnection.getConnection();

    // ✅ Check if the user table is empty
    public boolean isUserTableEmpty() throws SQLException {
        String sql = "SELECT COUNT(*) FROM user";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            rs.next();
            return rs.getInt(1) == 0;
        }
    }

    // ✅ Check if username or NIC already exists
    public boolean isUsernameOrNICExists(String username, String nicNo) {
        String sql = "SELECT COUNT(*) FROM user WHERE username = ? OR nic_no = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, nicNo);
            ResultSet rs = stmt.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }

    // ✅ Insert default user (first-time ADMIN)
    public boolean insertDefaultUser(User user) throws SQLException {
        String sql = "INSERT INTO user (username, password, user_type, nic_no, is_active) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getUserType());
            stmt.setString(4, user.getNicNo());
            stmt.setBoolean(5, user.isActive());
            return stmt.executeUpdate() > 0;
        }
    }

    // ✅ Login
    public User login(String username, String password) throws SQLException {
        String sql = "SELECT * FROM user WHERE username = ? AND password = ? AND is_active = TRUE";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractUser(rs);
            }
        }
        return null;
    }

    // ✅ Get all users
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM user ORDER BY created_at DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                User u = extractUser(rs);
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Save new user with customer_id support
    public boolean saveUser(User u) {
        String sql = "INSERT INTO user (username, password, user_type, nic_no, is_active, customer_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, u.getUsername());
            stmt.setString(2, u.getPassword());
            stmt.setString(3, u.getUserType());
            stmt.setString(4, u.getNicNo());
            stmt.setBoolean(5, u.isActive());
            if (u.getCustomerId() != null) {
                stmt.setInt(6, u.getCustomerId());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Update existing user with customer_id
    public boolean updateUser(User u) {
        String sql = "UPDATE user SET username=?, password=?, user_type=?, nic_no=?, is_active=?, customer_id=? WHERE user_id=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, u.getUsername());
            stmt.setString(2, u.getPassword());
            stmt.setString(3, u.getUserType());
            stmt.setString(4, u.getNicNo());
            stmt.setBoolean(5, u.isActive());
            if (u.getCustomerId() != null) {
                stmt.setInt(6, u.getCustomerId());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }
            stmt.setInt(7, u.getUserId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Delete user by ID
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM user WHERE user_id=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Get single user by ID
    public User getUserById(int userId) {
        String sql = "SELECT * FROM user WHERE user_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 🔧 Helper: extract User from ResultSet
    private User extractUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setUserType(rs.getString("user_type"));
        u.setNicNo(rs.getString("nic_no"));
        u.setIsActive(rs.getBoolean("is_active"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        Object cid = rs.getObject("customer_id");
        if (cid != null) {
            u.setCustomerId((Integer) cid);
        }
        return u;
    }
}
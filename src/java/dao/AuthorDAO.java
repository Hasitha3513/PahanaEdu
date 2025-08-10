/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Author;

import java.util.ArrayList;
import java.util.List;
import database.DbConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.*;

/**
 *
 * @author hasit
 */
public class AuthorDAO {
    
    public int getAuthorCount() {
        int count = 0;
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM author");
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
                System.out.println("✅ Author Count = " + count);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // ✅ Get all authors (for dropdowns or listings)
    public List<Author> getAllAuthors() {
        List<Author> list = new ArrayList<>();
        String sql = "SELECT * FROM author ORDER BY created_at DESC";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Author author = new Author();
                author.setAuthorId(rs.getInt("author_id"));
                author.setFirstName(rs.getString("first_name"));
                author.setLastName(rs.getString("last_name"));
                author.setNicNo(rs.getString("nic_no"));
                list.add(author);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching authors: " + e.getMessage());
        }
        return list;
    }

    // ✅ Save new author
    public boolean saveAuthor(Author author) {
        String sql = "INSERT INTO author (first_name, last_name, nic_no) VALUES (?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, author.getFirstName());
            stmt.setString(2, author.getLastName());
            stmt.setString(3, author.getNicNo());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate")) {
                System.err.println("NIC already exists!");
            }
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Update existing author
    public boolean updateAuthor(Author author) {
        String sql = "UPDATE author SET first_name = ?, last_name = ?, nic_no = ? WHERE author_id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, author.getFirstName());
            stmt.setString(2, author.getLastName());
            stmt.setString(3, author.getNicNo());
            stmt.setInt(4, author.getAuthorId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate")) {
                System.err.println("NIC already exists!");
            }
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Delete author by ID
    public boolean deleteAuthor(int authorId) {
        String sql = "DELETE FROM author WHERE author_id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, authorId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Optional: Find author by ID (for update dropdown pre-fill)
    public Author getAuthorById(int authorId) {
        String sql = "SELECT * FROM author WHERE author_id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, authorId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Author author = new Author();
                author.setAuthorId(rs.getInt("author_id"));
                author.setFirstName(rs.getString("first_name"));
                author.setLastName(rs.getString("last_name"));
                author.setNicNo(rs.getString("nic_no"));
                return author;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
}
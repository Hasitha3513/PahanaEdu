/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import database.DbConnection;
import model.Book;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author hasit
 */
public class BookDAO {

    public List<Book> getAllBooks() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM book ORDER BY created_at DESC";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Book b = new Book();
                b.setBookId(rs.getInt("book_id"));
                b.setBookName(rs.getString("book_name"));
                b.setAuthorId(rs.getInt("author_id"));
                b.setIsbnNo(rs.getString("isbn_no"));
                b.setPrice(rs.getDouble("price"));
                b.setStockQuantity(rs.getInt("stock_quantity"));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean saveBook(Book b) {
        String sql = "INSERT INTO book (book_name, author_id, isbn_no, price, stock_quantity) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, b.getBookName());
            stmt.setInt(2, b.getAuthorId());
            stmt.setString(3, b.getIsbnNo());
            stmt.setDouble(4, b.getPrice());
            stmt.setInt(5, b.getStockQuantity());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateBook(Book b) {
        String sql = "UPDATE book SET book_name=?, author_id=?, isbn_no=?, price=?, stock_quantity=? WHERE book_id=?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, b.getBookName());
            stmt.setInt(2, b.getAuthorId());
            stmt.setString(3, b.getIsbnNo());
            stmt.setDouble(4, b.getPrice());
            stmt.setInt(5, b.getStockQuantity());
            stmt.setInt(6, b.getBookId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteBook(int bookId) {
        String sql = "DELETE FROM book WHERE book_id=?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean decreaseStock(int bookId, int quantity) throws SQLException {
    String sql = "UPDATE book SET stock_quantity = stock_quantity - ? WHERE book_id = ? AND stock_quantity >= ?";
    try (Connection conn = DbConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, quantity);
        stmt.setInt(2, bookId);
        stmt.setInt(3, quantity);

        return stmt.executeUpdate() > 0;
    }
}
    
    public int getTotalBooksCount() {
    String sql = "SELECT COUNT(*) FROM book";
    try (Connection conn = DbConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}



}
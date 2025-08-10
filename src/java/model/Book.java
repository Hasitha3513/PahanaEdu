/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author hasit
 */
public class Book {
    private int bookId;
    private String bookName;
    private int authorId;
    private String isbnNo;
    private double price;
    private int stockQuantity;
    private Timestamp createdAt; // ✅ This line is required

    public Book() {
    }

    public Book(int bookId, String bookName, int authorId, String isbnNo, double price, int stockQuantity, Timestamp createdAt) {
        this.bookId = bookId;
        this.bookName = bookName;
        this.authorId = authorId;
        this.isbnNo = isbnNo;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.createdAt = createdAt;
    }

    // --- Getters and Setters ---

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getBookName() {
        return bookName;
    }

    public void setBookName(String bookName) {
        this.bookName = bookName;
    }

    public int getAuthorId() {
        return authorId;
    }

    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }

    public String getIsbnNo() {
        return isbnNo;
    }

    public void setIsbnNo(String isbnNo) {
        this.isbnNo = isbnNo;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public Timestamp getCreatedAt() { // ✅ Add this getter
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) { // ✅ And this setter
        this.createdAt = createdAt;
    }
}
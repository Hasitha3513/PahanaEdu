/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author hasit
 */
public class Cart {
    private List<CartItem> items;

    public Cart() {
        items = new ArrayList<>();
    }

    // Add item to cart (merge quantity and discount if same book)
    public void addItem(CartItem item) {
        for (CartItem existing : items) {
            if (existing.getBookId() == item.getBookId()) {
                existing.setQuantity(existing.getQuantity() + item.getQuantity());
                existing.setDiscount(existing.getDiscount() + item.getDiscount());
                return;
            }
        }
        items.add(item);
    }

    // Remove item from cart
    public void removeItem(int bookId) {
        items.removeIf(i -> i.getBookId() == bookId);
    }

    // Get list of cart items
    public List<CartItem> getItems() {
        return items;
    }

    // Calculate subtotal (without discount)
    public double getSubtotal() {
        double subtotal = 0;
        for (CartItem item : items) {
            subtotal += item.getUnitPrice() * item.getQuantity();
        }
        return subtotal;
    }

    // Calculate total discount
    public double getTotalDiscount() {
        double discount = 0;
        for (CartItem item : items) {
            discount += item.getDiscount();
        }
        return discount;
    }

    // Subtotal - total discount
    public double getTotalAfterDiscount() {
        return getSubtotal() - getTotalDiscount();
    }

    // Alias for grand total
    public double getTotal() {
        return getTotalAfterDiscount();
    }

    // Clear the cart
    public void clear() {
        items.clear();
    }
}
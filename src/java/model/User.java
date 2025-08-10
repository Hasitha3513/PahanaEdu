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
public class User {

    private int userId;
    private String username;
    private String password;
    private String userType;
    private String nicNo;
    private boolean isActive;
    private Timestamp createdAt;
    private Integer customerId;

    // Default constructor
    public User() {
    }

    // Constructor with selected fields
    public User(int userId, String username, String password, String userType, String nicNo, boolean isActive) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.userType = userType;
        this.nicNo = nicNo;
        this.isActive = isActive;
    }

    // --- Getters and Setters ---
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public String getNicNo() {
        return nicNo;
    }

    public void setNicNo(String nicNo) {
        this.nicNo = nicNo;
    }

    public boolean isActive() {
        return isActive;
    }

    public boolean getIsActive() { // ✅ For compatibility with getX() naming
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

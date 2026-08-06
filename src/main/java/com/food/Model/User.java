package com.food.Model;

import java.sql.Timestamp;

public class User {

	 private int userId;
	 private String userName;
	 private String email;
	 private String password;
	 private String address;
	 private String role;
	 private Timestamp createDate;
	 private Timestamp loginLastDate;
	 
	 public User(){ 
		 
	 }
	 
	 

	 public User(int userId, String userName, String email, String password, String address, String role,
			Timestamp createDate, Timestamp loginLastDate) {
		super();
		this.userId = userId;
		this.userName = userName;
		this.email = email;
		this.password = password;
		this.address = address;
		this.role = role;
		this.createDate = createDate;
		this.loginLastDate = loginLastDate;
	}



	 public User(String userName, String email, String password, String address, String role) {
		super();
		this.userName = userName;
		this.email = email;
		this.password = password;
		this.address = address;
		this.role = role;
	}



	 public User(String userName, String email, String password,String address, String role, Timestamp createDate,
			Timestamp loginLastDate) {
		super();
		this.userName = userName;
		this.email = email;
		this.password = password;
		this.address = address;
		this.role = role;
		this.createDate = createDate;
		this.loginLastDate = loginLastDate;
	 }

	 public int getUserId() {
		 return userId;
	 }

	 public void setUserId(int userId) {
		 this.userId = userId;
	 }

	 public String getUserName() {
		 return userName;
	 }

	 public void setUserName(String userName) {
		 this.userName = userName;
	 }

	 public String getEmail() {
		 return email;
	 }

	 public void setEmail(String email) {
		 this.email = email;
	 }

	 public String getPassword() {
		 return password;
	 }

	 public void setPassword(String password) {
		 this.password = password;
	 }

	 public String getRole() {
		 return role;
	 }

	 public void setRole(String role) {
		 this.role = role;
	 }

	 public Timestamp getCreateDate() {
		 return createDate;
	 }

	 public void setCreateDate(Timestamp createDate) {
		 this.createDate = createDate;
	 }

	 public Timestamp getLoginLastDate() {
		 return loginLastDate;
	 }

	 public void setLoginLastDate(Timestamp loginLastDate) {
		 this.loginLastDate = loginLastDate;
	 }

	 @Override
	 public String toString() {
		return "User [userId=" + userId + ", userName=" + userName + ", email=" + email + ", password=" + password
				+ ", role=" + role + ", createDate=" + createDate + ", loginLastDate=" + loginLastDate + "]";
	 }

	 public String getAddress() {
		return address;
	 }

	 public void setAddress(String address) {
		this.address = address;
	 }
	 
}

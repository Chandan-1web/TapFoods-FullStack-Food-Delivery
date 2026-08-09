package com.food.Model;

import java.sql.Timestamp;

public class Payment {

	private int paymentID;
	private int orderID;
	private String razorpayOrderID;
	private String razorpayPaymentID;
	private String razorpaySignature;
	private double amount;
	private String paymentStatus;
	private Timestamp paymentDate;

	public Payment() {
	}

	public Payment(
			int paymentID,
			int orderID,
			String razorpayOrderID,
			String razorpayPaymentID,
			String razorpaySignature,
			double amount,
			String paymentStatus,
			Timestamp paymentDate) {

		this.paymentID = paymentID;
		this.orderID = orderID;
		this.razorpayOrderID = razorpayOrderID;
		this.razorpayPaymentID = razorpayPaymentID;
		this.razorpaySignature = razorpaySignature;
		this.amount = amount;
		this.paymentStatus = paymentStatus;
		this.paymentDate = paymentDate;
	}

	public Payment(
			int orderID,
			String razorpayOrderID,
			String razorpayPaymentID,
			String razorpaySignature,
			double amount,
			String paymentStatus) {

		this.orderID = orderID;
		this.razorpayOrderID = razorpayOrderID;
		this.razorpayPaymentID = razorpayPaymentID;
		this.razorpaySignature = razorpaySignature;
		this.amount = amount;
		this.paymentStatus = paymentStatus;
	}

	public int getPaymentID() {
		return paymentID;
	}

	public void setPaymentID(int paymentID) {
		this.paymentID = paymentID;
	}

	public int getOrderID() {
		return orderID;
	}

	public void setOrderID(int orderID) {
		this.orderID = orderID;
	}

	public String getRazorpayOrderID() {
		return razorpayOrderID;
	}

	public void setRazorpayOrderID(String razorpayOrderID) {
		this.razorpayOrderID = razorpayOrderID;
	}

	public String getRazorpayPaymentID() {
		return razorpayPaymentID;
	}

	public void setRazorpayPaymentID(String razorpayPaymentID) {
		this.razorpayPaymentID = razorpayPaymentID;
	}

	public String getRazorpaySignature() {
		return razorpaySignature;
	}

	public void setRazorpaySignature(String razorpaySignature) {
		this.razorpaySignature = razorpaySignature;
	}

	public double getAmount() {
		return amount;
	}

	public void setAmount(double amount) {
		this.amount = amount;
	}

	public String getPaymentStatus() {
		return paymentStatus;
	}

	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}

	public Timestamp getPaymentDate() {
		return paymentDate;
	}

	public void setPaymentDate(Timestamp paymentDate) {
		this.paymentDate = paymentDate;
	}

	@Override
	public String toString() {
		return "Payment [paymentID=" + paymentID
				+ ", orderID=" + orderID
				+ ", razorpayOrderID=" + razorpayOrderID
				+ ", razorpayPaymentID=" + razorpayPaymentID
				+ ", amount=" + amount
				+ ", paymentStatus=" + paymentStatus
				+ ", paymentDate=" + paymentDate
				+ "]";
	}
}
package com.food.DAO;

import com.food.Model.Payment;

public interface PaymentDAO {

	int addPayment(Payment payment);

	Payment getPaymentById(int paymentID);

	Payment getPaymentByOrderId(int orderID);

	boolean updatePaymentStatus(
			int paymentID,
			String paymentStatus);

	boolean updatePaymentAfterSuccess(
			int paymentID,
			String razorpayPaymentID,
			String razorpaySignature,
			String paymentStatus);
}
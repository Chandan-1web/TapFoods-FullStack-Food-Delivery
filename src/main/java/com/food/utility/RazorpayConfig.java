package com.food.utility;

public class RazorpayConfig {

	private RazorpayConfig() {
	}

	public static String getKeyId() {

		String keyId =
				System.getenv("RAZORPAY_KEY_ID");

		if (keyId == null || keyId.trim().isEmpty()) {
			throw new IllegalStateException(
					"RAZORPAY_KEY_ID is not configured.");
		}

		return keyId;
	}

	public static String getKeySecret() {

		String keySecret =
				System.getenv("RAZORPAY_KEY_SECRET");

		if (keySecret == null || keySecret.trim().isEmpty()) {
			throw new IllegalStateException(
					"RAZORPAY_KEY_SECRET is not configured.");
		}

		return keySecret;
	}
}
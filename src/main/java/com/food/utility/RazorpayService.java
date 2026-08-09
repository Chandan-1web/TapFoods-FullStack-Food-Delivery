package com.food.utility;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.json.JSONObject;

public class RazorpayService {

	private static final String CREATE_ORDER_URL =
			"https://api.razorpay.com/v1/orders";

	private final HttpClient httpClient;

	public RazorpayService() {

		httpClient =
				HttpClient.newHttpClient();
	}

	public JSONObject createRazorpayOrder(
			double amount,
			String receipt)
			throws IOException, InterruptedException {

		/*
		 * Razorpay expects INR amount in paise.
		 *
		 * Example:
		 * ₹187.00 -> 18700
		 */
		long amountInPaise =
				Math.round(amount * 100);

		JSONObject requestBody =
				new JSONObject();

		requestBody.put(
				"amount",
				amountInPaise);

		requestBody.put(
				"currency",
				"INR");

		requestBody.put(
				"receipt",
				receipt);

		String credentials =
				RazorpayConfig.getKeyId()
				+ ":"
				+ RazorpayConfig.getKeySecret();

		String encodedCredentials =
				Base64.getEncoder()
						.encodeToString(
								credentials.getBytes(
										StandardCharsets.UTF_8));

		HttpRequest request =
				HttpRequest.newBuilder()
						.uri(
								URI.create(
										CREATE_ORDER_URL))
						.header(
								"Authorization",
								"Basic "
								+ encodedCredentials)
						.header(
								"Content-Type",
								"application/json")
						.POST(
								HttpRequest.BodyPublishers
										.ofString(
												requestBody.toString()))
						.build();

		HttpResponse<String> response =
				httpClient.send(
						request,
						HttpResponse.BodyHandlers.ofString());

		if (response.statusCode() < 200
				|| response.statusCode() >= 300) {

			throw new IOException(
					"Razorpay order creation failed. HTTP "
					+ response.statusCode()
					+ ": "
					+ response.body());
		}

		return new JSONObject(
				response.body());
	}

	public boolean verifyPaymentSignature(
			String razorpayOrderId,
			String razorpayPaymentId,
			String razorpaySignature) {

		try {

			String payload =
					razorpayOrderId
					+ "|"
					+ razorpayPaymentId;

			Mac mac =
					Mac.getInstance(
							"HmacSHA256");

			SecretKeySpec secretKey =
					new SecretKeySpec(
							RazorpayConfig
									.getKeySecret()
									.getBytes(
											StandardCharsets.UTF_8),
							"HmacSHA256");

			mac.init(secretKey);

			byte[] hash =
					mac.doFinal(
							payload.getBytes(
									StandardCharsets.UTF_8));

			String generatedSignature =
					bytesToHex(hash);

			return generatedSignature
					.equalsIgnoreCase(
							razorpaySignature);

		}
		catch (Exception exception) {

			exception.printStackTrace();

			return false;
		}
	}

	private String bytesToHex(
			byte[] bytes) {

		StringBuilder result =
				new StringBuilder();

		for (byte value : bytes) {

			result.append(
					String.format(
							"%02x",
							value));
		}

		return result.toString();
	}
}
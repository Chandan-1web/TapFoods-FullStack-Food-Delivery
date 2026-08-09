package com.food.servlets;

import java.io.IOException;

import com.food.utility.RazorpayConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RazorpayConfigTest")
public class RazorpayConfigTestServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(
			HttpServletRequest request,
			HttpServletResponse response)
			throws ServletException, IOException {

		try {

			String keyId =
					RazorpayConfig.getKeyId();

			String keySecret =
					RazorpayConfig.getKeySecret();

			if (keyId != null
					&& !keyId.isBlank()
					&& keySecret != null
					&& !keySecret.isBlank()) {

				response.getWriter()
						.println(
								"Razorpay configuration loaded successfully.");

			}
			else {

				response.getWriter()
						.println(
								"Razorpay configuration missing.");
			}

		}
		catch (Exception exception) {

			response.getWriter()
					.println(
							"Razorpay configuration error: "
							+ exception.getMessage());
		}
	}
}
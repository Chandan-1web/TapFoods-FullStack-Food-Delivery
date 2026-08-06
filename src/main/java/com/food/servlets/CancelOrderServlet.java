package com.food.servlets;

import java.io.IOException;

import com.food.DAOImpl.OrderDAOImpl;
import com.food.Model.Order;
import com.food.Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CancelOrderServlet")
public class CancelOrderServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(
			HttpServletRequest request,
			HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session =
				request.getSession(false);

		if (session == null) {

			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");

			return;
		}

		User loggedInUser =
				(User) session.getAttribute("user");

		if (loggedInUser == null) {

			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");

			return;
		}

		String orderIdValue =
				request.getParameter("orderId");

		int orderId;

		try {

			orderId =
					Integer.parseInt(orderIdValue);

		}
		catch (Exception exception) {

			session.setAttribute(
					"orderError",
					"Invalid order selected.");

			response.sendRedirect(
					request.getContextPath()
					+ "/MyOrdersServlet");

			return;
		}

		OrderDAOImpl orderDAO =
				new OrderDAOImpl();

		Order order =
				orderDAO.getOrderById(orderId);

		if (order == null) {

			session.setAttribute(
					"orderError",
					"Order could not be found.");

			response.sendRedirect(
					request.getContextPath()
					+ "/MyOrdersServlet");

			return;
		}

		/*
		 * The logged-in customer can cancel only their own order.
		 */
		if (order.getUserID()
				!= loggedInUser.getUserId()) {

			session.setAttribute(
					"orderError",
					"You are not allowed to cancel this order.");

			response.sendRedirect(
					request.getContextPath()
					+ "/MyOrdersServlet");

			return;
		}

		String currentStatus =
				order.getStatus() != null
					? order.getStatus()
							.trim()
							.toUpperCase()
					: "";

		/*
		 * Allow cancellation only before preparation starts.
		 */
		boolean canCancel =
				"PLACED".equals(currentStatus)
				|| "PENDING".equals(currentStatus);

		if (!canCancel) {

			session.setAttribute(
					"orderError",
					"This order can no longer be cancelled.");

			response.sendRedirect(
					request.getContextPath()
					+ "/MyOrdersServlet");

			return;
		}

		boolean cancelled =
				orderDAO.updateOrderStatus(
						orderId,
						"CANCELLED");

		if (cancelled) {

			session.setAttribute(
					"orderMessage",
					"Order #" + orderId
					+ " cancelled successfully.");

		}
		else {

			session.setAttribute(
					"orderError",
					"Order cancellation failed. Please try again.");
		}

		response.sendRedirect(
				request.getContextPath()
				+ "/MyOrdersServlet");
	}
}
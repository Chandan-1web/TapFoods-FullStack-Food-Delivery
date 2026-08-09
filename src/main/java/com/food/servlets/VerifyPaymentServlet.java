package com.food.servlets;

import java.io.IOException;

import com.food.DAOImpl.OrderDAOImpl;
import com.food.DAOImpl.OrderItemDAOImpl;
import com.food.DAOImpl.PaymentDAOImpl;
import com.food.Model.Cart;
import com.food.Model.CartItem;
import com.food.Model.Order;
import com.food.Model.OrderItem;
import com.food.Model.Payment;
import com.food.Model.User;
import com.food.utility.RazorpayService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/VerifyPaymentServlet")
public class VerifyPaymentServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(
			HttpServletRequest req,
			HttpServletResponse resp)
			throws ServletException, IOException {

		HttpSession session =
				req.getSession(false);

		if (session == null) {

			resp.sendRedirect(
					req.getContextPath()
					+ "/Login.jsp");

			return;
		}

		User user =
				(User) session.getAttribute("user");

		Cart cart =
				(Cart) session.getAttribute("cart");

		if (user == null) {

			resp.sendRedirect(
					req.getContextPath()
					+ "/Login.jsp");

			return;
		}

		if (cart == null
				|| cart.getItems() == null
				|| cart.getItems().isEmpty()) {

			resp.sendRedirect(
					req.getContextPath()
					+ "/Cart.jsp");

			return;
		}

		/*
		 * Values returned by Razorpay Checkout.
		 */
		String razorpayPaymentId =
				req.getParameter(
						"razorpay_payment_id");

		String returnedRazorpayOrderId =
				req.getParameter(
						"razorpay_order_id");

		String razorpaySignature =
				req.getParameter(
						"razorpay_signature");

		/*
		 * IMPORTANT:
		 * Get the Razorpay Order ID from OUR SERVER SESSION.
		 * Do not trust only the value returned from the browser.
		 */
		String serverRazorpayOrderId =
				(String) session.getAttribute(
						"razorpayOrderId");

		String customerName =
				(String) session.getAttribute(
						"pendingCustomerName");

		String address =
				(String) session.getAttribute(
						"pendingAddress");

		String phone =
				(String) session.getAttribute(
						"pendingPhone");

		String paymentMode =
				(String) session.getAttribute(
						"pendingPaymentMode");

		Double grandTotal =
				(Double) session.getAttribute(
						"pendingGrandTotal");

		Integer restaurantId =
				(Integer) session.getAttribute(
						"pendingRestaurantId");

		/*
		 * Validate all required payment/session information.
		 */
		if (razorpayPaymentId == null
				|| razorpayPaymentId.trim().isEmpty()
				|| returnedRazorpayOrderId == null
				|| returnedRazorpayOrderId.trim().isEmpty()
				|| razorpaySignature == null
				|| razorpaySignature.trim().isEmpty()
				|| serverRazorpayOrderId == null
				|| grandTotal == null
				|| restaurantId == null
				|| paymentMode == null) {

			session.setAttribute(
					"checkoutError",
					"Payment information is incomplete. Please try again.");

			resp.sendRedirect(
					req.getContextPath()
					+ "/Checkout.jsp");

			return;
		}

		/*
		 * Ensure the order ID returned by the browser is the same
		 * Razorpay Order ID that our server originally created.
		 */
		if (!serverRazorpayOrderId.equals(
				returnedRazorpayOrderId)) {

			session.setAttribute(
					"checkoutError",
					"Payment verification failed.");

			resp.sendRedirect(
					req.getContextPath()
					+ "/Checkout.jsp");

			return;
		}

		RazorpayService razorpayService =
				new RazorpayService();

		boolean signatureValid =
				razorpayService
						.verifyPaymentSignature(
								serverRazorpayOrderId,
								razorpayPaymentId,
								razorpaySignature);

		if (!signatureValid) {

			session.setAttribute(
					"checkoutError",
					"Payment could not be verified. Please try again.");

			resp.sendRedirect(
					req.getContextPath()
					+ "/Checkout.jsp");

			return;
		}

		/*
		 * ==========================================
		 * PAYMENT VERIFIED
		 * NOW CREATE THE TAPFOODS ORDER
		 * ==========================================
		 */

		Order order =
				new Order();

		order.setUserID(
				user.getUserId());

		order.setRestaurantID(
				restaurantId);

		order.setOrderDate(
				new java.util.Date());

		order.setTotalAmount(
				grandTotal);

		order.setStatus(
				"PLACED");

		order.setPaymentMethod(
				paymentMode);

		OrderDAOImpl orderDAO =
				new OrderDAOImpl();

		int orderId =
				orderDAO.placeOrder(
						order);

		if (orderId <= 0) {

			session.setAttribute(
					"checkoutError",
					"Payment succeeded, but the order could not be created. Please contact support.");

			resp.sendRedirect(
					req.getContextPath()
					+ "/Checkout.jsp");

			return;
		}

		order.setOrderID(
				orderId);

		/*
		 * Save all order items.
		 */
		OrderItemDAOImpl orderItemDAO =
				new OrderItemDAOImpl();

		boolean allItemsInserted =
				true;

		for (CartItem cartItem
				: cart.getItems().values()) {

			OrderItem orderItem =
					new OrderItem();

			orderItem.setOrderID(
					orderId);

			orderItem.setMenuID(
					cartItem.getMenuId());

			orderItem.setQuantity(
					cartItem.getQty());

			orderItem.setItemTotal(
					cartItem.getTotalPrice());

			boolean inserted =
					orderItemDAO
							.addOrderItem(
									orderItem);

			if (!inserted) {

				allItemsInserted =
						false;

				break;
			}
		}

		if (!allItemsInserted) {

			session.setAttribute(
					"checkoutError",
					"Payment succeeded, but some order items could not be saved.");

			resp.sendRedirect(
					req.getContextPath()
					+ "/Checkout.jsp");

			return;
		}

		/*
		 * ==========================================
		 * SAVE PAYMENT INFORMATION
		 * ==========================================
		 */

		Payment payment =
				new Payment();

		payment.setOrderID(
				orderId);

		payment.setRazorpayOrderID(
				serverRazorpayOrderId);

		payment.setRazorpayPaymentID(
				razorpayPaymentId);

		payment.setRazorpaySignature(
				razorpaySignature);

		payment.setAmount(
				grandTotal);

		payment.setPaymentStatus(
				"PAID");

		PaymentDAOImpl paymentDAO =
				new PaymentDAOImpl();

		int paymentId =
				paymentDAO.addPayment(
						payment);

		if (paymentId <= 0) {

			session.setAttribute(
					"checkoutError",
					"Payment succeeded, but payment details could not be saved.");

			resp.sendRedirect(
					req.getContextPath()
					+ "/Checkout.jsp");

			return;
		}

		payment.setPaymentID(
				paymentId);

		/*
		 * ==========================================
		 * PREPARE ORDER SUCCESS PAGE
		 * ==========================================
		 */

		session.setAttribute(
				"lastOrder",
				order);

		session.setAttribute(
				"lastOrderId",
				orderId);

		session.setAttribute(
				"lastPayment",
				payment);

		session.setAttribute(
				"orderCustomerName",
				customerName);

		session.setAttribute(
				"orderDeliveryAddress",
				address);

		session.setAttribute(
				"orderPhone",
				phone);

		session.setAttribute(
				"orderPaymentMode",
				paymentMode);

		session.setAttribute(
				"orderGrandTotal",
				grandTotal);

		session.setAttribute(
				"completedOrderCart",
				cart);

		/*
		 * Clear shopping cart only AFTER successful
		 * payment verification and database save.
		 */
		session.removeAttribute(
				"cart");

		session.removeAttribute(
				"restaurantId");

		session.removeAttribute(
				"grandTotal");

		clearPendingPaymentData(
				session);

		resp.sendRedirect(
				req.getContextPath()
				+ "/OrderSuccess.jsp");
	}

	private void clearPendingPaymentData(
			HttpSession session) {

		session.removeAttribute(
				"pendingCustomerName");

		session.removeAttribute(
				"pendingAddress");

		session.removeAttribute(
				"pendingPhone");

		session.removeAttribute(
				"pendingPaymentMode");

		session.removeAttribute(
				"pendingGrandTotal");

		session.removeAttribute(
				"pendingRestaurantId");

		session.removeAttribute(
				"razorpayOrderId");

		session.removeAttribute(
				"razorpayAmount");

		session.removeAttribute(
				"razorpayKeyId");
	}
}
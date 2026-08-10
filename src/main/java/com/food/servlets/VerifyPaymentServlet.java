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

		System.out.println("========== RAZORPAY VERIFY START ==========");

		/*
		 * ==========================================
		 * SESSION CHECK
		 * ==========================================
		 */
		if (session == null) {

			System.out.println("Session exists: false");

			resp.sendRedirect(
					req.getContextPath()
					+ "/Login.jsp");

			return;
		}

		System.out.println("Session exists: true");

		User user =
				(User) session.getAttribute("user");

		Cart cart =
				(Cart) session.getAttribute("cart");

		System.out.println(
				"User exists: "
				+ (user != null));

		System.out.println(
				"Cart exists: "
				+ (cart != null));

		if (user == null) {

			System.out.println(
					"STOPPED: User missing");

			resp.sendRedirect(
					req.getContextPath()
					+ "/Login.jsp");

			return;
		}

		if (cart == null
				|| cart.getItems() == null
				|| cart.getItems().isEmpty()) {

			System.out.println(
					"STOPPED: Cart missing or empty");

			resp.sendRedirect(
					req.getContextPath()
					+ "/Cart.jsp");

			return;
		}

		/*
		 * ==========================================
		 * VALUES RETURNED BY RAZORPAY
		 * ==========================================
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

		String serverRazorpayOrderId =
				(String) session.getAttribute(
						"razorpayOrderId");

		System.out.println(
				"Payment ID received: "
				+ (razorpayPaymentId != null
				&& !razorpayPaymentId.isBlank()));

		System.out.println(
				"Returned Order ID received: "
				+ (returnedRazorpayOrderId != null
				&& !returnedRazorpayOrderId.isBlank()));

		System.out.println(
				"Signature received: "
				+ (razorpaySignature != null
				&& !razorpaySignature.isBlank()));

		System.out.println(
				"Server Order ID exists: "
				+ (serverRazorpayOrderId != null));

		System.out.println(
				"Order IDs match: "
				+ (serverRazorpayOrderId != null
				&& serverRazorpayOrderId.equals(
						returnedRazorpayOrderId)));

		/*
		 * ==========================================
		 * PENDING CHECKOUT SESSION DATA
		 * ==========================================
		 */
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

		System.out.println(
				"Grand total exists: "
				+ (grandTotal != null));

		System.out.println(
				"Restaurant ID exists: "
				+ (restaurantId != null));

		System.out.println(
				"Payment mode exists: "
				+ (paymentMode != null));

		System.out.println(
				"Customer name exists: "
				+ (customerName != null));

		System.out.println(
				"Address exists: "
				+ (address != null));

		System.out.println(
				"Phone exists: "
				+ (phone != null));

		/*
		 * ==========================================
		 * VALIDATE REQUIRED INFORMATION
		 * ==========================================
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

			System.out.println(
					"STOPPED: Payment/session information incomplete");

			session.setAttribute(
					"checkoutError",
					"Payment information is incomplete. Please try again.");

			resp.sendRedirect(
					req.getContextPath()
					+ "/Checkout.jsp");

			return;
		}

		/*
		 * ==========================================
		 * VERIFY ORDER ID
		 * ==========================================
		 */
		if (!serverRazorpayOrderId.equals(
				returnedRazorpayOrderId)) {

			System.out.println(
					"STOPPED: Razorpay Order ID mismatch");

			session.setAttribute(
					"checkoutError",
					"Payment verification failed.");

			resp.sendRedirect(
					req.getContextPath()
					+ "/Checkout.jsp");

			return;
		}

		/*
		 * ==========================================
		 * VERIFY SIGNATURE
		 * ==========================================
		 */
		RazorpayService razorpayService =
				new RazorpayService();

		boolean signatureValid =
				razorpayService
						.verifyPaymentSignature(
								serverRazorpayOrderId,
								razorpayPaymentId,
								razorpaySignature);

		System.out.println(
				"Signature valid: "
				+ signatureValid);

		if (!signatureValid) {

			System.out.println(
					"STOPPED: Razorpay signature invalid");

			session.setAttribute(
					"checkoutError",
					"Payment could not be verified. Please try again.");

			resp.sendRedirect(
					req.getContextPath()
					+ "/Checkout.jsp");

			return;
		}

		System.out.println(
				"Payment verification passed");

		/*
		 * ==========================================
		 * CREATE TAPFOODS ORDER
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

		System.out.println(
				"Attempting order insert...");

		int orderId =
				orderDAO.placeOrder(
						order);

		System.out.println(
				"Generated TapFoods Order ID valid: "
				+ (orderId > 0));

		if (orderId <= 0) {

			System.out.println(
					"STOPPED: Order insert failed");

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
		 * ==========================================
		 * SAVE ORDER ITEMS
		 * ==========================================
		 */
		OrderItemDAOImpl orderItemDAO =
				new OrderItemDAOImpl();

		boolean allItemsInserted =
				true;

		System.out.println(
				"Attempting order item inserts...");

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

		System.out.println(
				"All order items inserted: "
				+ allItemsInserted);

		if (!allItemsInserted) {

			System.out.println(
					"STOPPED: Order item insert failed");

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
		 * SAVE PAYMENT
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

		System.out.println(
				"Attempting payment insert...");

		int paymentId =
				paymentDAO.addPayment(
						payment);

		System.out.println(
				"Generated Payment ID valid: "
				+ (paymentId > 0));

		if (paymentId <= 0) {

			System.out.println(
					"STOPPED: Payment insert failed");

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
		 * SUCCESS PAGE DATA
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
		 * Clear cart only after everything succeeds.
		 */
		session.removeAttribute(
				"cart");

		session.removeAttribute(
				"restaurantId");

		session.removeAttribute(
				"grandTotal");

		clearPendingPaymentData(
				session);

		System.out.println(
				"RAZORPAY ORDER COMPLETED SUCCESSFULLY");

		System.out.println(
				"========== RAZORPAY VERIFY END ==========");

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
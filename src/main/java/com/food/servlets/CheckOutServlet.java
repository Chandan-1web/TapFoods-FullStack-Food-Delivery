package com.food.servlets;

import java.io.IOException;

import org.json.JSONObject;

import com.food.DAOImpl.OrderDAOImpl;
import com.food.DAOImpl.OrderItemDAOImpl;
import com.food.Model.Cart;
import com.food.Model.CartItem;
import com.food.Model.Order;
import com.food.Model.OrderItem;
import com.food.Model.User;
import com.food.utility.RazorpayConfig;
import com.food.utility.RazorpayService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CheckOutServlet")
public class CheckOutServlet extends HttpServlet {

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
				(User) session.getAttribute(
						"user");

		if (user == null) {

			resp.sendRedirect(
					req.getContextPath()
					+ "/Login.jsp");

			return;
		}

		Cart cart =
				(Cart) session.getAttribute(
						"cart");

		if (cart == null
				|| cart.getItems() == null
				|| cart.getItems().isEmpty()) {

			resp.sendRedirect(
					req.getContextPath()
					+ "/Cart.jsp");

			return;
		}

		Integer restaurantObject =
				(Integer) session.getAttribute(
						"restaurantId");

		int restaurantId =
				restaurantObject != null
				? restaurantObject
				: 0;

		if (restaurantId == 0) {

			for (CartItem cartItem
					: cart.getItems().values()) {

				restaurantId =
						cartItem.getRestaurantId();

				break;
			}
		}

		if (restaurantId == 0) {

			req.setAttribute(
					"checkoutError",
					"Restaurant information is missing.");

			req.getRequestDispatcher(
					"/Checkout.jsp")
					.forward(req, resp);

			return;
		}

		String customerName =
				req.getParameter(
						"customerName");

		String address =
				req.getParameter(
						"address");

		String phone =
				req.getParameter(
						"phone");

		String paymentMode =
				req.getParameter(
						"paymentMode");

		if (customerName == null
				|| customerName.trim().isEmpty()
				|| address == null
				|| address.trim().isEmpty()
				|| phone == null
				|| phone.trim().isEmpty()
				|| paymentMode == null
				|| paymentMode.trim().isEmpty()) {

			req.setAttribute(
					"checkoutError",
					"Please fill all checkout details.");

			req.getRequestDispatcher(
					"/Checkout.jsp")
					.forward(req, resp);

			return;
		}

		paymentMode =
				paymentMode.trim()
						.toUpperCase();

		/*
		 * Calculate amount on the SERVER.
		 * Never trust the hidden grandTotal
		 * received from the browser.
		 */
		double subtotal = 0.0;

		for (CartItem item
				: cart.getItems().values()) {

			subtotal +=
					item.getTotalPrice();
		}

		double deliveryCharge =
				subtotal > 0
				? 40.00
				: 0.00;

		double gst =
				subtotal * 0.05;

		double grandTotal =
				subtotal
				+ deliveryCharge
				+ gst;

		/*
		 * Save checkout data temporarily
		 * because Razorpay needs it later.
		 */
		session.setAttribute(
				"pendingCustomerName",
				customerName.trim());

		session.setAttribute(
				"pendingAddress",
				address.trim());

		session.setAttribute(
				"pendingPhone",
				phone.trim());

		session.setAttribute(
				"pendingPaymentMode",
				paymentMode);

		session.setAttribute(
				"pendingGrandTotal",
				grandTotal);

		session.setAttribute(
				"pendingRestaurantId",
				restaurantId);

		/*
		 * =====================================
		 * CASH ON DELIVERY
		 * =====================================
		 */
		if ("COD".equals(paymentMode)) {

			completeOrder(
					req,
					resp,
					session,
					user,
					cart,
					restaurantId,
					customerName,
					address,
					phone,
					paymentMode,
					grandTotal);

			return;
		}

		/*
		 * =====================================
		 * ONLINE PAYMENT
		 * UPI / CARD → Razorpay
		 * =====================================
		 */
		if ("RAZORPAY".equals(paymentMode)) {
			try {

				RazorpayService razorpayService =
						new RazorpayService();

				String receipt =
						"tapfoods_"
						+ user.getUserId()
						+ "_"
						+ System.currentTimeMillis();

				JSONObject razorpayOrder =
						razorpayService
								.createRazorpayOrder(
										grandTotal,
										receipt);

				String razorpayOrderId =
						razorpayOrder.getString(
								"id");

				long razorpayAmount =
						razorpayOrder.getLong(
								"amount");

				session.setAttribute(
						"razorpayOrderId",
						razorpayOrderId);

				session.setAttribute(
						"razorpayAmount",
						razorpayAmount);

				session.setAttribute(
						"razorpayKeyId",
						RazorpayConfig.getKeyId());

				resp.sendRedirect(
						req.getContextPath()
						+ "/RazorpayPayment.jsp");

				return;

			}
			catch (Exception exception) {

				exception.printStackTrace();

				req.setAttribute(
						"checkoutError",
						"Unable to start online payment. Please try again.");

				req.getRequestDispatcher(
						"/Checkout.jsp")
						.forward(req, resp);

				return;
			}
		}

		req.setAttribute(
				"checkoutError",
				"Invalid payment method.");

		req.getRequestDispatcher(
				"/Checkout.jsp")
				.forward(req, resp);
	}

	private void completeOrder(
			HttpServletRequest req,
			HttpServletResponse resp,
			HttpSession session,
			User user,
			Cart cart,
			int restaurantId,
			String customerName,
			String address,
			String phone,
			String paymentMode,
			double grandTotal)
			throws ServletException, IOException {

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

		OrderDAOImpl orderDAOImpl =
				new OrderDAOImpl();

		int orderId =
				orderDAOImpl.placeOrder(
						order);

		if (orderId <= 0) {

			req.setAttribute(
					"checkoutError",
					"Order could not be created.");

			req.getRequestDispatcher(
					"/Checkout.jsp")
					.forward(req, resp);

			return;
		}

		order.setOrderID(
				orderId);

		OrderItemDAOImpl orderItemDAOImpl =
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
					orderItemDAOImpl
							.addOrderItem(
									orderItem);

			if (!inserted) {

				allItemsInserted =
						false;

				break;
			}
		}

		if (!allItemsInserted) {

			req.setAttribute(
					"checkoutError",
					"Some order items could not be saved.");

			req.getRequestDispatcher(
					"/Checkout.jsp")
					.forward(req, resp);

			return;
		}

		session.setAttribute(
				"lastOrder",
				order);

		session.setAttribute(
				"lastOrderId",
				orderId);

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

		session.removeAttribute(
				"cart");

		session.removeAttribute(
				"restaurantId");

		session.removeAttribute(
				"grandTotal");

		clearPendingCheckout(
				session);

		resp.sendRedirect(
				req.getContextPath()
				+ "/OrderSuccess.jsp");
	}

	private void clearPendingCheckout(
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
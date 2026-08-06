package com.food.servlets;

import java.io.IOException;

import com.food.DAOImpl.OrderDAOImpl;
import com.food.DAOImpl.OrderItemDAOImpl;
import com.food.Model.Cart;
import com.food.Model.CartItem;
import com.food.Model.Order;
import com.food.Model.OrderItem;
import com.food.Model.User;

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

		HttpSession session = req.getSession(false);

		if (session == null) {
			resp.sendRedirect(req.getContextPath() + "/Login.jsp");
			return;
		}

		User user = (User) session.getAttribute("user");

		if (user == null) {
			resp.sendRedirect(req.getContextPath() + "/Login.jsp");
			return;
		}

		Cart cart = (Cart) session.getAttribute("cart");

		if (cart == null ||
			cart.getItems() == null ||
			cart.getItems().isEmpty()) {

			resp.sendRedirect(req.getContextPath() + "/Cart.jsp");
			return;
		}

		Integer restaurantObject =
				(Integer) session.getAttribute("restaurantId");

		int restaurantId =
				restaurantObject != null ? restaurantObject : 0;

		if (restaurantId == 0) {
			for (CartItem cartItem : cart.getItems().values()) {
				restaurantId = cartItem.getRestaurantId();
				break;
			}
		}

		if (restaurantId == 0) {
			req.setAttribute(
					"checkoutError",
					"Restaurant information is missing.");

			req.getRequestDispatcher("/Checkout.jsp")
					.forward(req, resp);

			return;
		}

		String customerName = req.getParameter("customerName");
		String address = req.getParameter("address");
		String phone = req.getParameter("phone");
		String paymentMode = req.getParameter("paymentMode");
		String grandTotalValue = req.getParameter("grandTotal");

		if (customerName == null ||
			customerName.trim().isEmpty() ||
			address == null ||
			address.trim().isEmpty() ||
			phone == null ||
			phone.trim().isEmpty() ||
			paymentMode == null ||
			paymentMode.trim().isEmpty()) {

			req.setAttribute(
					"checkoutError",
					"Please fill all checkout details.");

			req.getRequestDispatcher("/Checkout.jsp")
					.forward(req, resp);

			return;
		}

		double grandTotal;

		try {
			grandTotal = Double.parseDouble(grandTotalValue);
		}
		catch (Exception e) {
			req.setAttribute(
					"checkoutError",
					"Invalid grand total.");

			req.getRequestDispatcher("/Checkout.jsp")
					.forward(req, resp);

			return;
		}

		Order order = new Order();

		order.setUserID(user.getUserId());
		order.setRestaurantID(restaurantId);
		order.setOrderDate(new java.util.Date());
		order.setTotalAmount(grandTotal);

		/*
		 * Database enum expects PLACED.
		 */
		order.setStatus("PLACED");

		/*
		 * Database enum expects UPI, COD, or CARD.
		 */
		order.setPaymentMethod(paymentMode);

		OrderDAOImpl orderDAOImpl = new OrderDAOImpl();

		int orderId = orderDAOImpl.placeOrder(order);

		if (orderId <= 0) {
			req.setAttribute(
					"checkoutError",
					"Order could not be created.");

			req.getRequestDispatcher("/Checkout.jsp")
					.forward(req, resp);

			return;
		}

		order.setOrderID(orderId);

		OrderItemDAOImpl orderItemDAOImpl =
				new OrderItemDAOImpl();

		boolean allItemsInserted = true;

		for (CartItem cartItem : cart.getItems().values()) {

			OrderItem orderItem = new OrderItem();

			orderItem.setOrderID(orderId);
			orderItem.setMenuID(cartItem.getMenuId());
			orderItem.setQuantity(cartItem.getQty());
			orderItem.setItemTotal(cartItem.getTotalPrice());

			boolean inserted =
					orderItemDAOImpl.addOrderItem(orderItem);

			if (!inserted) {
				allItemsInserted = false;
				break;
			}
		}

		if (!allItemsInserted) {
			req.setAttribute(
					"checkoutError",
					"Some order items could not be saved.");

			req.getRequestDispatcher("/Checkout.jsp")
					.forward(req, resp);

			return;
		}

		session.setAttribute("lastOrder", order);
		session.setAttribute("lastOrderId", orderId);
		session.setAttribute("orderCustomerName", customerName);
		session.setAttribute("orderDeliveryAddress", address);
		session.setAttribute("orderPhone", phone);
		session.setAttribute("orderPaymentMode", paymentMode);
		session.setAttribute("orderGrandTotal", grandTotal);
		session.setAttribute("completedOrderCart", cart);

		session.removeAttribute("cart");
		session.removeAttribute("restaurantId");
		session.removeAttribute("grandTotal");

		resp.sendRedirect(req.getContextPath() + "/OrderSuccess.jsp");
	}
}
package com.food.servlets;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.food.DAOImpl.MenuDAOImpl;
import com.food.DAOImpl.OrderDAOImpl;
import com.food.DAOImpl.OrderItemDAOImpl;
import com.food.DAOImpl.RestaurantDAOImpl;
import com.food.Model.Menu;
import com.food.Model.Order;
import com.food.Model.OrderItem;
import com.food.Model.Restaurant;
import com.food.Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/MyOrdersServlet")
public class MyOrdersServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(
			HttpServletRequest request,
			HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session =
				request.getSession(false);

		/*
		 * User must be logged in.
		 */
		if (session == null) {

			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");

			return;
		}

		User user =
				(User) session.getAttribute("user");

		if (user == null) {

			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");

			return;
		}

		OrderDAOImpl orderDAO =
				new OrderDAOImpl();

		OrderItemDAOImpl orderItemDAO =
				new OrderItemDAOImpl();

		RestaurantDAOImpl restaurantDAO =
				new RestaurantDAOImpl();

		MenuDAOImpl menuDAO =
				new MenuDAOImpl();

		/*
		 * Get all orders placed by the logged-in user.
		 */
		List<Order> orderList =
				orderDAO.getOrdersByUser(
						user.getUserId());

		/*
		 * Store restaurant information by RestaurantID.
		 */
		Map<Integer, Restaurant> restaurantMap =
				new HashMap<>();

		/*
		 * Store every order's item list by OrderID.
		 */
		Map<Integer, List<OrderItem>> orderItemsMap =
				new HashMap<>();

		/*
		 * Store menu information by MenuID.
		 */
		Map<Integer, Menu> menuMap =
				new HashMap<>();

		if (orderList != null) {

			for (Order order : orderList) {

				/*
				 * Load restaurant once.
				 */
				if (!restaurantMap.containsKey(
						order.getRestaurantID())) {

					Restaurant restaurant =
							restaurantDAO
									.getRestaurantById(
											order.getRestaurantID());

					restaurantMap.put(
							order.getRestaurantID(),
							restaurant);
				}

				/*
				 * Load all ordered items.
				 */
				List<OrderItem> orderItems =
						orderItemDAO.getItemsByOrder(
								order.getOrderID());

				orderItemsMap.put(
						order.getOrderID(),
						orderItems);

				/*
				 * Load menu details for each order item.
				 */
				if (orderItems != null) {

					for (OrderItem orderItem :
							orderItems) {

						if (!menuMap.containsKey(
								orderItem.getMenuID())) {

							Menu menu =
									menuDAO.getMenuById(
											orderItem.getMenuID());

							menuMap.put(
									orderItem.getMenuID(),
									menu);
						}
					}
				}
			}
		}

		/*
		 * Send everything to MyOrders.jsp.
		 */
		request.setAttribute(
				"orderList",
				orderList);

		request.setAttribute(
				"restaurantMap",
				restaurantMap);

		request.setAttribute(
				"orderItemsMap",
				orderItemsMap);

		request.setAttribute(
				"menuMap",
				menuMap);

		request.getRequestDispatcher(
				"/MyOrders.jsp")
				.forward(request, response);
	}

	@Override
	protected void doPost(
			HttpServletRequest request,
			HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}
}
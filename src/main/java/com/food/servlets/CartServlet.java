package com.food.servlets;

import java.io.IOException;

import com.food.DAOImpl.MenuDAOImpl;
import com.food.Model.Cart;
import com.food.Model.CartItem;
import com.food.Model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet{

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		HttpSession session = req.getSession();
		Cart cart = (Cart)session.getAttribute("cart");

		int newRestaurantId = Integer.parseInt(req.getParameter("restaurantId"));
		Integer restaurantId = (Integer)session.getAttribute("restaurantId");

		//WHEN TO CREATE A CART 
		if(cart == null || restaurantId != newRestaurantId)
		{
			cart = new Cart();
			session.setAttribute("cart", cart);
			session.setAttribute("restaurantId", newRestaurantId);

		}


		String action = req.getParameter("action");

		if("add".equals(action))
		{
		    addItemtoCart(req, cart);
		}
		else if("update".equals(action))
		{
		    updateItemtoCart(req, cart);
		}
		else if("delete".equals(action))
		{
		    removeItemtoCart(req, cart);
		}
		

		RequestDispatcher rd = req.getRequestDispatcher("Cart.jsp");
		rd.forward(req, resp);

	}

	private void removeItemtoCart(HttpServletRequest req, Cart cart) {

		int menuId = Integer.parseInt(req.getParameter("menuId"));
		cart.remove(menuId);
	}

	private void updateItemtoCart(HttpServletRequest req, Cart cart) {

		int menuId = Integer.parseInt(req.getParameter("menuId"));
		int quantity = Integer.parseInt(req.getParameter("quantity"));

		cart.updateItem(menuId, quantity);
	}

	private void addItemtoCart(HttpServletRequest req, Cart cart) {

		int menuId = Integer.parseInt(req.getParameter("menuId"));
		int qty = Integer.parseInt(req.getParameter("qty"));

		MenuDAOImpl menuDAOImpl = new MenuDAOImpl();
		Menu menu = menuDAOImpl.getMenuById(menuId);

		HttpSession session = req.getSession();
		session.setAttribute("restaurantId", menu.getRestaurantID());

		CartItem cartItem = new CartItem(menu.getMenuID(),
				menu.getRestaurantID(), 
				menu.getItemName(),
				menu.getPrice(),
				qty);

		cart.addItem(cartItem);



	}

}

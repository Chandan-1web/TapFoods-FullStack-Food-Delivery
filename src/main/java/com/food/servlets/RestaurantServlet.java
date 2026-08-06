package com.food.servlets;

import java.io.IOException;
import java.util.List;

import com.food.DAOImpl.RestaurantDAOImpl;
import com.food.Model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/restaurant")
public class RestaurantServlet extends HttpServlet {

	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		RestaurantDAOImpl dao = new RestaurantDAOImpl();

		List<Restaurant> allRestaurants = dao.getAllRestaurants();

		for(Restaurant restaurant :allRestaurants)
		{
			System.out.println(restaurant);
		}

		req.setAttribute("allRestaurants", allRestaurants);

		RequestDispatcher rd = req.getRequestDispatcher("Restaurant.jsp");
		rd.forward(req, resp);
	}
}

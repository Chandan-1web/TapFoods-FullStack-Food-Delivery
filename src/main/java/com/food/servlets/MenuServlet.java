package com.food.servlets;

import java.io.IOException;
import java.util.List;

import com.food.DAOImpl.MenuDAOImpl;
import com.food.Model.Menu;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Menu")
public class MenuServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));

        MenuDAOImpl menuDAOImpl = new MenuDAOImpl();
        
        List<Menu> menuList = menuDAOImpl.getMenuByRestaurantId(restaurantId);
        for(Menu menu :menuList)
        {
        	System.out.println(menu);
        }

        req.setAttribute("menuList", menuList);
        
        req.getRequestDispatcher("Menu.jsp").forward(req, resp);
    }
}
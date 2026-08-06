package com.food.DAO;

import com.food.Model.Order;
import java.util.List;

public interface OrderDAO {
    int placeOrder(Order order);
    Order getOrderById(int orderID);
    List<Order> getOrdersByUser(int userID);
    List<Order> getOrdersByRestaurant(int restaurantID);
    boolean updateOrderStatus(int orderID, String status);
}
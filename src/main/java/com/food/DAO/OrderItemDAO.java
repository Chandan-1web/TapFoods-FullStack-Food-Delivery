package com.food.DAO;

import com.food.Model.OrderItem;
import java.util.List;

public interface OrderItemDAO {
    boolean addOrderItem(OrderItem item);
    List<OrderItem> getItemsByOrder(int orderID);
}
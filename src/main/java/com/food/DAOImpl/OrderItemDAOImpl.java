package com.food.DAOImpl;

import com.food.DAO.OrderItemDAO;
import com.food.Model.OrderItem;
import com.food.utility.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDAOImpl implements OrderItemDAO {

    Connection con = DBConnection.getConnection();

    @Override
    public boolean addOrderItem(OrderItem item) {
        String query = "INSERT INTO orderitem (OrderID, MenuID, Quantity, ItemTotal) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, item.getOrderID());
            ps.setInt(2, item.getMenuID());
            ps.setInt(3, item.getQuantity());
            ps.setDouble(4, item.getItemTotal());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<OrderItem> getItemsByOrder(int orderID) {
        List<OrderItem> list = new ArrayList<>();
        String query = "SELECT * FROM orderitem WHERE OrderID = ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemID(rs.getInt("OrderItemID"));
                item.setOrderID(rs.getInt("OrderID"));
                item.setMenuID(rs.getInt("MenuID"));
                item.setQuantity(rs.getInt("Quantity"));
                item.setItemTotal(rs.getDouble("ItemTotal"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
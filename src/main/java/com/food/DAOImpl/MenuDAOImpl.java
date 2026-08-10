package com.food.DAOImpl;

import com.food.DAO.MenuDAO;
import com.food.Model.Menu;
import com.food.utility.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MenuDAOImpl implements MenuDAO {

    Connection con = DBConnection.getConnection();

    @Override
    public List<Menu> getAllMenus() {

        List<Menu> list = new ArrayList<>();

        String query = "SELECT * FROM menu";

        try {

            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while(rs.next()) {

                Menu menu = new Menu();

                menu.setMenuID(rs.getInt("MenuID"));
                menu.setRestaurantID(rs.getInt("RestaurantID"));
                menu.setItemName(rs.getString("ItemName"));
                menu.setDescription(rs.getString("Description"));
                menu.setPrice(rs.getDouble("Price"));
                menu.setAvailable(rs.getBoolean("IsAvailable"));
                menu.setImagePath(rs.getString("ImagePath"));

                list.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public Menu getMenuById(int menuID) {

        Menu menu = null;

        String query = "SELECT * FROM menu WHERE MenuID=?";

        try {

            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, menuID);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {

                menu = new Menu();

                menu.setMenuID(rs.getInt("MenuID"));
                menu.setRestaurantID(rs.getInt("RestaurantID"));
                menu.setItemName(rs.getString("ItemName"));
                menu.setDescription(rs.getString("Description"));
                menu.setPrice(rs.getDouble("Price"));
                menu.setAvailable(rs.getBoolean("IsAvailable"));
                menu.setImagePath(rs.getString("ImagePath"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menu;
    }

    @Override
    public List<Menu> getMenuByRestaurantId(int restaurantID) {

        List<Menu> list = new ArrayList<>();

        String query = "SELECT * FROM menu WHERE RestaurantID=?";

        try {

            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, restaurantID);

            ResultSet rs = ps.executeQuery();

            while(rs.next()) {

                Menu menu = new Menu();

                menu.setMenuID(rs.getInt("MenuID"));
                menu.setRestaurantID(rs.getInt("RestaurantID"));
                menu.setItemName(rs.getString("ItemName"));
                menu.setDescription(rs.getString("Description"));
                menu.setPrice(rs.getDouble("Price"));
                menu.setAvailable(rs.getBoolean("IsAvailable"));
                menu.setImagePath(rs.getString("ImagePath"));

                list.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public boolean addMenu(Menu menu) {

        String query = "INSERT INTO menu(RestaurantID,ItemName,Description,Price,IsAvailable,ImagePath) VALUES(?,?,?,?,?,?)";

        try {

            PreparedStatement ps = con.prepareStatement(query);

            ps.setInt(1, menu.getRestaurantID());
            ps.setString(2, menu.getItemName());
            ps.setString(3, menu.getDescription());
            ps.setDouble(4, menu.getPrice());
            ps.setBoolean(5, menu.isAvailable());
            ps.setString(6, menu.getImagePath());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean updateMenu(Menu menu) {

        String query = "UPDATE menu SET RestaurantID=?,ItemName=?,Description=?,Price=?,IsAvailable=?,ImagePath=? WHERE MenuID=?";

        try {

            PreparedStatement ps = con.prepareStatement(query);

            ps.setInt(1, menu.getRestaurantID());
            ps.setString(2, menu.getItemName());
            ps.setString(3, menu.getDescription());
            ps.setDouble(4, menu.getPrice());
            ps.setBoolean(5, menu.isAvailable());
            ps.setString(6, menu.getImagePath());
            ps.setInt(7, menu.getMenuID());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteMenu(int menuID) {

        String query = "DELETE FROM menu WHERE MenuID=?";

        try {

            PreparedStatement ps = con.prepareStatement(query);

            ps.setInt(1, menuID);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
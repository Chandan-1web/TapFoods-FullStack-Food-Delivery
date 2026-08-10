package com.food.DAOImpl;

import com.food.DAO.RestaurantDAO;
import com.food.Model.Restaurant;
import com.food.utility.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RestaurantDAOImpl implements RestaurantDAO {

    private Connection con;

    public RestaurantDAOImpl() {
        con = DBConnection.getConnection();
        System.out.println("RestaurantDAOImpl Connection = " + con);
    }

    @Override
    public List<Restaurant> getAllRestaurants() {

        List<Restaurant> list = new ArrayList<>();

        String query = "SELECT * FROM restaurant";

        try {
            if (con == null) {
                throw new RuntimeException("Database connection is NULL");
            }

            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Restaurant r = new Restaurant();

                r.setRestaurantID(rs.getInt("RestaurantID"));
                r.setName(rs.getString("Name"));
                r.setCuisineType(rs.getString("CuisineType"));
                r.setDeliveryTime(rs.getInt("DeliveryTime"));
                r.setAddress(rs.getString("Address"));
                r.setRating(rs.getDouble("Rating"));
                r.setActive(rs.getBoolean("IsActive"));
                r.setImagePath(rs.getString("ImagePath"));

                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public Restaurant getRestaurantById(int restaurantID) {

        Restaurant r = null;

        String query = "SELECT * FROM restaurant WHERE RestaurantID=?";

        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, restaurantID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                r = new Restaurant();

                r.setRestaurantID(rs.getInt("RestaurantID"));
                r.setName(rs.getString("Name"));
                r.setCuisineType(rs.getString("CuisineType"));
                r.setDeliveryTime(rs.getInt("DeliveryTime"));
                r.setAddress(rs.getString("Address"));
                r.setRating(rs.getDouble("Rating"));
                r.setActive(rs.getBoolean("IsActive"));
                r.setImagePath(rs.getString("ImagePath"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return r;
    }

    @Override
    public boolean addRestaurant(Restaurant restaurant) {

        String query =
                "INSERT INTO restaurant(Name,CuisineType,DeliveryTime,Address,Rating,IsActive,ImagePath) VALUES(?,?,?,?,?,?,?)";

        try {
            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setInt(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setDouble(5, restaurant.getRating());
            ps.setBoolean(6, restaurant.isActive());
            ps.setString(7, restaurant.getImagePath());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean updateRestaurant(Restaurant restaurant) {

        String query =
                "UPDATE restaurant SET Name=?,CuisineType=?,DeliveryTime=?,Address=?,Rating=?,IsActive=?,ImagePath=? WHERE RestaurantID=?";

        try {
            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setInt(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setDouble(5, restaurant.getRating());
            ps.setBoolean(6, restaurant.isActive());
            ps.setString(7, restaurant.getImagePath());
            ps.setInt(8, restaurant.getRestaurantID());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteRestaurant(int restaurantID) {

        String query = "DELETE FROM restaurant WHERE RestaurantID=?";

        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, restaurantID);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
package com.food.DAO;

import java.util.List;
import com.food.Model.Restaurant;

public interface RestaurantDAO {

    List<Restaurant> getAllRestaurants();

    Restaurant getRestaurantById(int restaurantID);

    boolean addRestaurant(Restaurant restaurant);

    boolean updateRestaurant(Restaurant restaurant);

    boolean deleteRestaurant(int restaurantID);

}
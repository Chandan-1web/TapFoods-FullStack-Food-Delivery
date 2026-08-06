package com.food.DAO;

import java.util.List;
import com.food.Model.Menu;

public interface MenuDAO {

    List<Menu> getAllMenus();

    Menu getMenuById(int menuID);

    List<Menu> getMenuByRestaurantId(int restaurantID);

    boolean addMenu(Menu menu);

    boolean updateMenu(Menu menu);

    boolean deleteMenu(int menuID);
}
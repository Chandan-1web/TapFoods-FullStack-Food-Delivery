package com.food.Model;

import java.util.HashMap;
import java.util.Map;

public class Cart {

	Map<Integer, CartItem> items;
	
	public Cart() {
		
		items = new HashMap<Integer, CartItem>();
	}
	//GETTERS

	public Map<Integer, CartItem> getItems() {
		return items;
	}
	
	//SETTERS
	public void addItem(CartItem cartItem) {
		
		int menuId = cartItem.getMenuId();
		
		if(items.containsKey(menuId))
		{
			CartItem existingCartItem = items.get(menuId);
			existingCartItem.setQty(existingCartItem.getQty()+1);	
		}
		else
		{
			items.put(menuId, cartItem);
		}
	}

	public void updateItem(int menuId, int quantity) {

		
		if(items.containsKey(menuId))
		{
			CartItem cartItem = items.get(menuId);
			if(quantity < 1)
			{
				items.remove(menuId);
			}
			else
			{
			cartItem.setQty(quantity);
			items.put(menuId, cartItem);
			}
					}
	}

	public void remove(int menuId) {

		items.remove(menuId);
	}

}

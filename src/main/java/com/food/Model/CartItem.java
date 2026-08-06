package com.food.Model;

public class CartItem {
	
	private int menuId;
	private int restaurantId;
	private String name;
	private double price;
	private int qty;
	
	
	public CartItem() {
		
	}


	public CartItem(int menuId, int restaurantId, String name, double price, int qty) {
		super();
		this.menuId = menuId;
		this.restaurantId = restaurantId;
		this.name = name;
		this.price = price;
		this.qty = qty;
	}


	public int getMenuId() {
		return menuId;
	}


	public void setMenuId(int menuId) {
		this.menuId = menuId;
	}


	public int getRestaurantId() {
		return restaurantId;
	}


	public void setRestaurantId(int restaurantId) {
		this.restaurantId = restaurantId;
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public double getPrice() {
		return price;
	}


	public void setPrice(double price) {
		this.price = price;
	}


	public int getQty() {
		return qty;
	}


	public void setQty(int qty) {
		this.qty = qty;
	}


	@Override
	public String toString() {
		return "CartItem [menuId=" + menuId + ", restaurantId=" + restaurantId + ", name=" + name + ", price=" + price
				+ ", qty=" + qty + "]";
	}
	
	public double getTotalPrice()
	{
		return qty*price;
	}
	

}

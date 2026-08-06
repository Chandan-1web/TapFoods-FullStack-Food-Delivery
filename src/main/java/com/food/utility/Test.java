package com.food.utility;

import java.sql.Connection;

public class Test {

    public static void main(String[] args) {

        Connection con = DBConnection.getConnection();

        if(con == null) {
            System.out.println("Connection is NULL");
        } else {
            System.out.println("Connection Successful");
        }
    }
}
//////        // ── 2. GET ALL restaurants ───────────────────────
//////        List<Restaurent> list = dao.getAllRestaurants();
//////        for (Restaurent res : list) {
//////            System.out.println(res.getRestaurantID() + " | " + 
//////                               res.getName() + " | " + 
//////                               res.getCuisineType());
//////        }
//////
////        // ── 3. GET BY ID ─────────────────────────────────
//////        Restaurent single = dao.getRestaurantById(2);
//////        System.out.println("Found: " + single.getName());
//////    }
//////}
//////        // ── 4. UPDATE ────────────────────────────────────
//////        single.setDeliveryTime(20);
//////        boolean updated = dao.updateRestaurant(single);
//////        System.out.println("Updated: " + updated);
//////
//        // ── 5. DELETE ────────────────────────────────────
////         boolean deleted = dao.deleteRestaurant(1);
////         System.out.println("Deleted: " + deleted);
//    }
//}
////}

//package com.food.utility;
//
//import com.food.DAOImpl.*;
//import com.food.Model.*;
//import java.util.List;
//
//public class Test1 {
//
//	public static void main(String[] args) {
//
//		// ════════════════════════════════════
//		// STEP 1 — TEST MENU
//		// ════════════════════════════════════
//		MenuDAOImpl menuDAO = new MenuDAOImpl();
//
//		// Add menu item
//		Menu m = new Menu();
//		m.setRestaurantID(1);
//		m.setItemName("Chicken Biryani");
//		m.setDescription("Spicy chicken biryani");
//		m.setPrice(180.00);
//		m.setAvailable(true);
//		m.setCategory("Biryani");
//
//		boolean menuAdded = menuDAO.addMenuItem(m);
//		System.out.println("Menu Added: " + menuAdded);
//
//		// Get menu by restaurant
//		List<Menu> menuList = menuDAO.getMenuByRestaurant(1);
//		System.out.println("Menu Items for Restaurant 1:");
//		for (Menu item : menuList) {
//			System.out.println(item.getMenuID() + " | " +
//					item.getItemName() + " | Rs." +
//					item.getPrice());
//		}
//	}
//}
//        // ════════════════════════════════════
//        // STEP 2 — TEST ORDER
//        // ════════════════════════════════════
//        OrderDAOImpl orderDAO = new OrderDAOImpl();
//
//        // Place order
//        Order o = new Order();
//        o.setUserID(1);
//        o.setRestaurantID(1);
//        o.setTotalAmount(360.00);
//        o.setStatus("Pending");
//        o.setPaymentMethod("COD");
//
//        boolean orderPlaced = orderDAO.placeOrder(o);
//        System.out.println("\nOrder Placed: " + orderPlaced);
//
//        // Get orders by user
//        List<Order> orderList = orderDAO.getOrdersByUser(1);
//        System.out.println("Orders for User 1:");
//        for (Order order : orderList) {
//            System.out.println(order.getOrderID() + " | " +
//                               order.getStatus() + " | Rs." +
//                               order.getTotalAmount());
//        }
//
//        // Update order status
//        boolean statusUpdated = orderDAO.updateOrderStatus(1, "Confirmed");
//        System.out.println("Status Updated: " + statusUpdated);
//
//        // ════════════════════════════════════
//        // STEP 3 — TEST ORDER ITEM
//        // ════════════════════════════════════
//        OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
//
//        // Add order item
//        OrderItem oi = new OrderItem();
//        oi.setOrderID(1);
//        oi.setMenuID(1);
//        oi.setQuantity(2);
//        oi.setItemTotal(360.00);
//
//        boolean itemAdded = orderItemDAO.addOrderItem(oi);
//        System.out.println("\nOrder Item Added: " + itemAdded);
//
//        // Get items by order
//        List<OrderItem> items = orderItemDAO.getItemsByOrder(1);
//        System.out.println("Items in Order 1:");
//        for (OrderItem item : items) {
//            System.out.println(item.getOrderItemID() + " | MenuID: " +
//                               item.getMenuID() + " | Qty: " +
//                               item.getQuantity() + " | Total: Rs." +
//                               item.getItemTotal());
//        }
//    }
//}
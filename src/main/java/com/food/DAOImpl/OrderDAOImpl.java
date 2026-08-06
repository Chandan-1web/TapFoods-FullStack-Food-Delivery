package com.food.DAOImpl;

import com.food.DAO.OrderDAO;
import com.food.Model.Order;
import com.food.utility.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAOImpl implements OrderDAO {

	private final Connection con =
			DBConnection.getConnection();

	@Override
	public int placeOrder(Order order) {

		String query =
				"INSERT INTO ordertable "
				+ "(UserID, RestaurantID, OrderDate, TotalAmount, Status, PaymentMethod) "
				+ "VALUES (?, ?, ?, ?, ?, ?)";

		int orderId = 0;

		try (
			PreparedStatement ps =
					con.prepareStatement(
							query,
							Statement.RETURN_GENERATED_KEYS)
		) {

			ps.setInt(1, order.getUserID());
			ps.setInt(2, order.getRestaurantID());

			ps.setTimestamp(
					3,
					new java.sql.Timestamp(
							order.getOrderDate().getTime()));

			ps.setDouble(4, order.getTotalAmount());
			ps.setString(5, order.getStatus());
			ps.setString(6, order.getPaymentMethod());

			int affectedRows = ps.executeUpdate();

			if (affectedRows > 0) {
				try (ResultSet rs = ps.getGeneratedKeys()) {
					if (rs.next()) {
						orderId = rs.getInt(1);
					}
				}
			}
		}
		catch (SQLException e) {
			System.out.println(
					"ORDER INSERT ERROR: "
					+ e.getMessage());

			System.out.println(
					"SQL STATE: "
					+ e.getSQLState());

			e.printStackTrace();
		}

		return orderId;
	}

	@Override
	public Order getOrderById(int orderID) {

		Order order = null;

		String query =
				"SELECT * FROM ordertable WHERE OrderID = ?";

		try (
			PreparedStatement ps =
					con.prepareStatement(query)
		) {

			ps.setInt(1, orderID);

			try (ResultSet rs = ps.executeQuery()) {

				if (rs.next()) {
					order = mapOrder(rs);
				}
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return order;
	}

	@Override
	public List<Order> getOrdersByUser(int userID) {

		List<Order> orders = new ArrayList<>();

		String query =
				"SELECT * FROM ordertable "
				+ "WHERE UserID = ? "
				+ "ORDER BY OrderDate DESC";

		try (
			PreparedStatement ps =
					con.prepareStatement(query)
		) {

			ps.setInt(1, userID);

			try (ResultSet rs = ps.executeQuery()) {

				while (rs.next()) {
					orders.add(mapOrder(rs));
				}
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return orders;
	}

	@Override
	public List<Order> getOrdersByRestaurant(
			int restaurantID) {

		List<Order> orders = new ArrayList<>();

		String query =
				"SELECT * FROM ordertable "
				+ "WHERE RestaurantID = ? "
				+ "ORDER BY OrderDate DESC";

		try (
			PreparedStatement ps =
					con.prepareStatement(query)
		) {

			ps.setInt(1, restaurantID);

			try (ResultSet rs = ps.executeQuery()) {

				while (rs.next()) {
					orders.add(mapOrder(rs));
				}
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return orders;
	}

	@Override
	public boolean updateOrderStatus(
			int orderID,
			String status) {

		String query =
				"UPDATE ordertable "
				+ "SET Status = ? "
				+ "WHERE OrderID = ?";

		try (
			PreparedStatement ps =
					con.prepareStatement(query)
		) {

			ps.setString(1, status);
			ps.setInt(2, orderID);

			return ps.executeUpdate() > 0;
		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}

	private Order mapOrder(ResultSet rs)
			throws SQLException {

		Order order = new Order();

		order.setOrderID(
				rs.getInt("OrderID"));

		order.setUserID(
				rs.getInt("UserID"));

		order.setRestaurantID(
				rs.getInt("RestaurantID"));

		order.setOrderDate(
				rs.getTimestamp("OrderDate"));

		order.setTotalAmount(
				rs.getDouble("TotalAmount"));

		order.setStatus(
				rs.getString("Status"));

		order.setPaymentMethod(
				rs.getString("PaymentMethod"));

		return order;
	}
}
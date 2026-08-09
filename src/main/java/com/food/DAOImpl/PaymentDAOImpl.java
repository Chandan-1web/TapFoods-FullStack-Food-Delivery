package com.food.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.food.DAO.PaymentDAO;
import com.food.Model.Payment;
import com.food.utility.DBConnection;

public class PaymentDAOImpl implements PaymentDAO {

	private final Connection con =
			DBConnection.getConnection();

	@Override
	public int addPayment(Payment payment) {

		String query =
				"INSERT INTO payment "
				+ "(OrderID, RazorpayOrderID, RazorpayPaymentID, "
				+ "RazorpaySignature, Amount, PaymentStatus) "
				+ "VALUES (?, ?, ?, ?, ?, ?)";

		int paymentID = 0;

		try (
			PreparedStatement ps =
					con.prepareStatement(
							query,
							Statement.RETURN_GENERATED_KEYS)
		) {

			ps.setInt(
					1,
					payment.getOrderID());

			ps.setString(
					2,
					payment.getRazorpayOrderID());

			ps.setString(
					3,
					payment.getRazorpayPaymentID());

			ps.setString(
					4,
					payment.getRazorpaySignature());

			ps.setDouble(
					5,
					payment.getAmount());

			ps.setString(
					6,
					payment.getPaymentStatus());

			int affectedRows =
					ps.executeUpdate();

			if (affectedRows > 0) {

				try (
					ResultSet rs =
							ps.getGeneratedKeys()
				) {

					if (rs.next()) {
						paymentID =
								rs.getInt(1);
					}
				}
			}

		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return paymentID;
	}

	@Override
	public Payment getPaymentById(
			int paymentID) {

		String query =
				"SELECT * FROM payment "
				+ "WHERE PaymentID = ?";

		try (
			PreparedStatement ps =
					con.prepareStatement(query)
		) {

			ps.setInt(
					1,
					paymentID);

			try (
				ResultSet rs =
						ps.executeQuery()
			) {

				if (rs.next()) {
					return mapPayment(rs);
				}
			}

		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return null;
	}

	@Override
	public Payment getPaymentByOrderId(
			int orderID) {

		String query =
				"SELECT * FROM payment "
				+ "WHERE OrderID = ?";

		try (
			PreparedStatement ps =
					con.prepareStatement(query)
		) {

			ps.setInt(
					1,
					orderID);

			try (
				ResultSet rs =
						ps.executeQuery()
			) {

				if (rs.next()) {
					return mapPayment(rs);
				}
			}

		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return null;
	}

	@Override
	public boolean updatePaymentStatus(
			int paymentID,
			String paymentStatus) {

		String query =
				"UPDATE payment "
				+ "SET PaymentStatus = ? "
				+ "WHERE PaymentID = ?";

		try (
			PreparedStatement ps =
					con.prepareStatement(query)
		) {

			ps.setString(
					1,
					paymentStatus);

			ps.setInt(
					2,
					paymentID);

			return ps.executeUpdate() > 0;

		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}

	@Override
	public boolean updatePaymentAfterSuccess(
			int paymentID,
			String razorpayPaymentID,
			String razorpaySignature,
			String paymentStatus) {

		String query =
				"UPDATE payment "
				+ "SET RazorpayPaymentID = ?, "
				+ "RazorpaySignature = ?, "
				+ "PaymentStatus = ? "
				+ "WHERE PaymentID = ?";

		try (
			PreparedStatement ps =
					con.prepareStatement(query)
		) {

			ps.setString(
					1,
					razorpayPaymentID);

			ps.setString(
					2,
					razorpaySignature);

			ps.setString(
					3,
					paymentStatus);

			ps.setInt(
					4,
					paymentID);

			return ps.executeUpdate() > 0;

		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}

	private Payment mapPayment(
			ResultSet rs)
			throws SQLException {

		Payment payment =
				new Payment();

		payment.setPaymentID(
				rs.getInt(
						"PaymentID"));

		payment.setOrderID(
				rs.getInt(
						"OrderID"));

		payment.setRazorpayOrderID(
				rs.getString(
						"RazorpayOrderID"));

		payment.setRazorpayPaymentID(
				rs.getString(
						"RazorpayPaymentID"));

		payment.setRazorpaySignature(
				rs.getString(
						"RazorpaySignature"));

		payment.setAmount(
				rs.getDouble(
						"Amount"));

		payment.setPaymentStatus(
				rs.getString(
						"PaymentStatus"));

		payment.setPaymentDate(
				rs.getTimestamp(
						"PaymentDate"));

		return payment;
	}
}
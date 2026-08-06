package com.food.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.food.DAO.UserDAO;
import com.food.Model.User;
import com.food.utility.DBConnection;

public class UserDAOImpl implements UserDAO {

	private static final String INSERT_QUERY =
			"INSERT INTO `user` "
			+ "(`userName`, `email`, `password`, `address`, `role`, `lastLoginDate`) "
			+ "VALUES (?, ?, ?, ?, ?, ?)";

	private static final String GET_BY_ID_QUERY =
			"SELECT * FROM `user` WHERE userId = ?";

	private static final String GET_BY_USERNAME_QUERY =
			"SELECT * FROM `user` WHERE userName = ?";

	private static final String GET_BY_EMAIL_QUERY =
			"SELECT * FROM `user` WHERE email = ?";

	private static final String GET_ALL_USERS_QUERY =
			"SELECT * FROM `user`";

	private static final String UPDATE_PROFILE_QUERY =
			"UPDATE `user` "
			+ "SET userName = ?, email = ?, address = ? "
			+ "WHERE userId = ?";

	private static final String UPDATE_PASSWORD_QUERY =
			"UPDATE `user` "
			+ "SET password = ? "
			+ "WHERE userId = ?";

	private static final String UPDATE_USER_QUERY =
			"UPDATE `user` "
			+ "SET userName = ?, email = ?, password = ?, address = ? "
			+ "WHERE userId = ?";

	private static final String DELETE_USER_QUERY =
			"DELETE FROM `user` WHERE userId = ?";

	@Override
	public int addUser(User user) {

		int rowsInserted = 0;

		try (
			Connection connection =
					DBConnection.getConnection();

			PreparedStatement pstmt =
					connection.prepareStatement(INSERT_QUERY)
		) {

			pstmt.setString(1, user.getUserName());
			pstmt.setString(2, user.getEmail());
			pstmt.setString(3, user.getPassword());
			pstmt.setString(4, user.getAddress());
			pstmt.setString(5, user.getRole());

			pstmt.setNull(
					6,
					java.sql.Types.TIMESTAMP
			);
			rowsInserted = pstmt.executeUpdate();

		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return rowsInserted;
	}

	@Override
	public User getUser(int userId) {

		User user = null;

		try (
			Connection connection =
					DBConnection.getConnection();

			PreparedStatement pstmt =
					connection.prepareStatement(GET_BY_ID_QUERY)
		) {

			pstmt.setInt(1, userId);

			try (ResultSet rs = pstmt.executeQuery()) {

				if (rs.next()) {
					user = mapUser(rs);
				}
			}

		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return user;
	}

	@Override
	public User getUserByUsername(String username) {

		User user = null;

		try (
			Connection connection =
					DBConnection.getConnection();

			PreparedStatement pstmt =
					connection.prepareStatement(
							GET_BY_USERNAME_QUERY)
		) {

			pstmt.setString(1, username);

			try (ResultSet rs = pstmt.executeQuery()) {

				if (rs.next()) {
					user = mapUser(rs);
				}
			}

		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return user;
	}

	@Override
	public User getUserByEmail(String email) {

		User user = null;

		try (
			Connection connection =
					DBConnection.getConnection();

			PreparedStatement pstmt =
					connection.prepareStatement(
							GET_BY_EMAIL_QUERY)
		) {

			pstmt.setString(1, email);

			try (ResultSet rs = pstmt.executeQuery()) {

				if (rs.next()) {
					user = mapUser(rs);
				}
			}

		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return user;
	}

	@Override
	public List<User> getAllUser() {

		List<User> users = new ArrayList<>();

		try (
			Connection connection =
					DBConnection.getConnection();

			Statement statement =
					connection.createStatement();

			ResultSet rs =
					statement.executeQuery(
							GET_ALL_USERS_QUERY)
		) {

			while (rs.next()) {
				users.add(mapUser(rs));
			}

		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return users;
	}

	@Override
	public boolean updateProfile(
			int userId,
			String userName,
			String email,
			String address) {

		try (
			Connection connection =
					DBConnection.getConnection();

			PreparedStatement pstmt =
					connection.prepareStatement(
							UPDATE_PROFILE_QUERY)
		) {

			pstmt.setString(1, userName);
			pstmt.setString(2, email);
			pstmt.setString(3, address);
			pstmt.setInt(4, userId);

			return pstmt.executeUpdate() > 0;

		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}

	@Override
	public boolean updatePassword(
			int userId,
			String encryptedPassword) {

		try (
			Connection connection =
					DBConnection.getConnection();

			PreparedStatement pstmt =
					connection.prepareStatement(
							UPDATE_PASSWORD_QUERY)
		) {

			pstmt.setString(1, encryptedPassword);
			pstmt.setInt(2, userId);

			return pstmt.executeUpdate() > 0;

		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}

	@Override
	public void updateUser(User user) {

		try (
			Connection connection =
					DBConnection.getConnection();

			PreparedStatement pstmt =
					connection.prepareStatement(
							UPDATE_USER_QUERY)
		) {

			pstmt.setString(1, user.getUserName());
			pstmt.setString(2, user.getEmail());
			pstmt.setString(3, user.getPassword());
			pstmt.setString(4, user.getAddress());
			pstmt.setInt(5, user.getUserId());

			pstmt.executeUpdate();

		}
		catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public boolean updateLastLogin(int userId) {

		String query =
				"UPDATE `user` "
				+ "SET lastLoginDate = ? "
				+ "WHERE userId = ?";

		try (
			Connection connection =
					DBConnection.getConnection();

			PreparedStatement pstmt =
					connection.prepareStatement(query)
		) {

			pstmt.setTimestamp(
					1,
					new Timestamp(
							System.currentTimeMillis())
			);

			pstmt.setInt(2, userId);

			return pstmt.executeUpdate() > 0;

		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}
	@Override
	public void deleteUser(int userId) {

		try (
			Connection connection =
					DBConnection.getConnection();

			PreparedStatement pstmt =
					connection.prepareStatement(
							DELETE_USER_QUERY)
		) {

			pstmt.setInt(1, userId);
			pstmt.executeUpdate();

		}
		catch (SQLException e) {
			e.printStackTrace();
		}
	}

	private User mapUser(ResultSet rs)
			throws SQLException {

		User user = new User();

		user.setUserId(
				rs.getInt("userId"));

		user.setUserName(
				rs.getString("userName"));

		user.setEmail(
				rs.getString("email"));

		user.setPassword(
				rs.getString("password"));

		user.setAddress(
				rs.getString("address"));

		user.setRole(
				rs.getString("role"));

		user.setCreateDate(
				rs.getTimestamp("createdDate"));

		user.setLoginLastDate(
				rs.getTimestamp("lastLoginDate"));

		return user;
	}
}
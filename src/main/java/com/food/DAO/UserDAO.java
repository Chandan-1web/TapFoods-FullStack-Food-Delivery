package com.food.DAO;

import java.util.List;

import com.food.Model.User;

public interface UserDAO {

	int addUser(User user);

	User getUser(int userId);

	User getUserByUsername(String username);

	User getUserByEmail(String email);

	List<User> getAllUser();

	boolean updateProfile(
			int userId,
			String userName,
			String email,
			String address);

	boolean updatePassword(
			int userId,
			String encryptedPassword);
	
	boolean updateLastLogin(int userId);

	void updateUser(User user);

	void deleteUser(int userId);
}
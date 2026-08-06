package com.food.servlets;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.food.DAOImpl.UserDAOImpl;
import com.food.Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(
			HttpServletRequest request,
			HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session =
				request.getSession(false);

		if (session == null) {
			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");
			return;
		}

		User loggedInUser =
				(User) session.getAttribute("user");

		if (loggedInUser == null) {
			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");
			return;
		}

		String currentPassword =
				request.getParameter("currentPassword");

		String newPassword =
				request.getParameter("newPassword");

		String confirmPassword =
				request.getParameter("confirmPassword");

		if (currentPassword == null
				|| currentPassword.trim().isEmpty()
				|| newPassword == null
				|| newPassword.trim().isEmpty()
				|| confirmPassword == null
				|| confirmPassword.trim().isEmpty()) {

			session.setAttribute(
					"passwordError",
					"Please fill all password fields.");

			response.sendRedirect(
					request.getContextPath()
					+ "/ProfileServlet");

			return;
		}

		if (newPassword.length() < 6) {

			session.setAttribute(
					"passwordError",
					"New password must contain at least 6 characters.");

			response.sendRedirect(
					request.getContextPath()
					+ "/ProfileServlet");

			return;
		}

		if (!newPassword.equals(confirmPassword)) {

			session.setAttribute(
					"passwordError",
					"New password and confirm password do not match.");

			response.sendRedirect(
					request.getContextPath()
					+ "/ProfileServlet");

			return;
		}

		UserDAOImpl userDAO =
				new UserDAOImpl();

		User databaseUser =
				userDAO.getUser(
						loggedInUser.getUserId());

		if (databaseUser == null) {

			session.setAttribute(
					"passwordError",
					"User account could not be found.");

			response.sendRedirect(
					request.getContextPath()
					+ "/ProfileServlet");

			return;
		}

		boolean currentPasswordMatched;

		try {

			currentPasswordMatched =
					BCrypt.checkpw(
							currentPassword,
							databaseUser.getPassword());

		}
		catch (IllegalArgumentException exception) {

			currentPasswordMatched = false;
		}

		if (!currentPasswordMatched) {

			session.setAttribute(
					"passwordError",
					"Current password is incorrect.");

			response.sendRedirect(
					request.getContextPath()
					+ "/ProfileServlet");

			return;
		}

		if (BCrypt.checkpw(
				newPassword,
				databaseUser.getPassword())) {

			session.setAttribute(
					"passwordError",
					"New password cannot be the same as the current password.");

			response.sendRedirect(
					request.getContextPath()
					+ "/ProfileServlet");

			return;
		}

		String encryptedPassword =
				BCrypt.hashpw(
						newPassword,
						BCrypt.gensalt());

		boolean updated =
				userDAO.updatePassword(
						loggedInUser.getUserId(),
						encryptedPassword);

		if (updated) {

			User latestUser =
					userDAO.getUser(
							loggedInUser.getUserId());

			session.setAttribute(
					"user",
					latestUser);

			session.setAttribute(
					"passwordMessage",
					"Password updated successfully.");

		}
		else {

			session.setAttribute(
					"passwordError",
					"Password could not be updated.");
		}

		response.sendRedirect(
				request.getContextPath()
				+ "/ProfileServlet");
	}
}
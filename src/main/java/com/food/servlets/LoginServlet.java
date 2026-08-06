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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(
			HttpServletRequest request,
			HttpServletResponse response)
			throws ServletException, IOException {

		String email = request.getParameter("email");
		String password = request.getParameter("password");

		HttpSession session = request.getSession(true);

		if (email == null
				|| email.trim().isEmpty()
				|| password == null
				|| password.trim().isEmpty()) {

			session.setAttribute(
					"loginError",
					"Please enter your email and password.");

			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");

			return;
		}

		email = email.trim();

		UserDAOImpl userDAO = new UserDAOImpl();

		User user = userDAO.getUserByEmail(email);

		if (user == null) {

			session.setAttribute(
					"loginError",
					"Incorrect email or password.");

			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");

			return;
		}

		String databasePassword = user.getPassword();

		if (databasePassword == null
				|| databasePassword.trim().isEmpty()) {

			session.setAttribute(
					"loginError",
					"Unable to sign in. Please contact support.");

			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");

			return;
		}

		boolean passwordMatched = false;

		try {

			passwordMatched =
					BCrypt.checkpw(
							password,
							databasePassword);

		}
		catch (IllegalArgumentException exception) {

			session.setAttribute(
					"loginError",
					"Unable to verify your password.");

			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");

			return;
		}

		if (!passwordMatched) {

			session.setAttribute(
					"loginError",
					"Incorrect email or password.");

			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");

			return;
		}

		boolean loginTimeUpdated =
				userDAO.updateLastLogin(
						user.getUserId());

		if (!loginTimeUpdated) {

			session.setAttribute(
					"loginError",
					"Unable to update login information.");

			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");

			return;
		}

		User updatedUser =
				userDAO.getUser(
						user.getUserId());

		if (updatedUser == null) {

			session.setAttribute(
					"loginError",
					"Unable to load your account.");

			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");

			return;
		}

		session.setAttribute(
				"user",
				updatedUser);

		session.setAttribute(
				"email",
				updatedUser.getEmail());

		session.setAttribute(
				"userId",
				updatedUser.getUserId());

		session.setAttribute(
				"userName",
				updatedUser.getUserName());

		session.removeAttribute("loginError");

		response.sendRedirect(
				request.getContextPath()
				+ "/restaurant");
	}
}
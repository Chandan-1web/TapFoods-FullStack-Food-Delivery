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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(
			HttpServletRequest request,
			HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		HttpSession session = request.getSession(true);

		String userName = request.getParameter("UserName");
		String email = request.getParameter("emailID");
		String password = request.getParameter("password");
		String address = request.getParameter("address");

		if (userName != null) {
			userName = userName.trim();
		}

		if (email != null) {
			email = email.trim().toLowerCase();
		}

		if (address != null) {
			address = address.trim();
		}

		/*
		 * Preserve entered values when validation fails.
		 */
		session.setAttribute("oldUserName", userName);
		session.setAttribute("oldEmail", email);
		session.setAttribute("oldAddress", address);

		/*
		 * Server-side required-field validation.
		 */
		if (userName == null
				|| userName.isEmpty()
				|| email == null
				|| email.isEmpty()
				|| password == null
				|| password.isEmpty()
				|| address == null
				|| address.isEmpty()) {

			session.setAttribute(
					"registerError",
					"Please fill all registration fields.");

			response.sendRedirect(
					request.getContextPath()
					+ "/Register.jsp");

			return;
		}

		if (password.length() < 6) {

			session.setAttribute(
					"registerError",
					"Password must contain at least 6 characters.");

			response.sendRedirect(
					request.getContextPath()
					+ "/Register.jsp");

			return;
		}

		UserDAOImpl userDAO = new UserDAOImpl();

		/*
		 * Prevent duplicate email registration.
		 */
		User existingUser = userDAO.getUserByEmail(email);

		if (existingUser != null) {

			session.setAttribute(
					"registerError",
					"Email is already registered. Please sign in.");

			response.sendRedirect(
					request.getContextPath()
					+ "/Register.jsp");

			return;
		}

		String encryptedPassword =
				BCrypt.hashpw(
						password,
						BCrypt.gensalt(12));

		/*
		 * Public registration must create CUSTOMER accounts only.
		 * Admin accounts should be created securely by the application owner.
		 */
		String role = request.getParameter("role");

		if (role == null || role.trim().isEmpty()) {
		    role = "CUSTOMER";
		}

		User newUser = new User(
		        userName,
		        email,
		        encryptedPassword,
		        address,
		        role.toUpperCase());

		int rowsInserted = userDAO.addUser(newUser);

		if (rowsInserted == 1) {

			session.removeAttribute("oldUserName");
			session.removeAttribute("oldEmail");
			session.removeAttribute("oldAddress");
			session.removeAttribute("registerError");

			session.setAttribute(
					"loginMessage",
					"Account created successfully. Please sign in.");

			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");

			return;
		}

		session.setAttribute(
				"registerError",
				"Account could not be created. Please try again.");

		response.sendRedirect(
				request.getContextPath()
				+ "/Register.jsp");
	}
}
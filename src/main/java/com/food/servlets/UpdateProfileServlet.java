package com.food.servlets;

import java.io.IOException;

import com.food.DAOImpl.UserDAOImpl;
import com.food.Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

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

		String userName =
				request.getParameter("userName");

		String email =
				request.getParameter("email");

		String address =
				request.getParameter("address");

		if (userName == null
				|| userName.trim().isEmpty()
				|| email == null
				|| email.trim().isEmpty()
				|| address == null
				|| address.trim().isEmpty()) {

			session.setAttribute(
					"profileError",
					"Please fill all profile fields.");

			response.sendRedirect(
					request.getContextPath()
					+ "/ProfileServlet");

			return;
		}

		UserDAOImpl userDAO =
				new UserDAOImpl();

		User existingUser =
				userDAO.getUserByEmail(
						email.trim());

		if (existingUser != null
				&& existingUser.getUserId()
				!= loggedInUser.getUserId()) {

			session.setAttribute(
					"profileError",
					"This email is already registered.");

			response.sendRedirect(
					request.getContextPath()
					+ "/ProfileServlet");

			return;
		}

		boolean updated =
				userDAO.updateProfile(
						loggedInUser.getUserId(),
						userName.trim(),
						email.trim(),
						address.trim());

		if (updated) {

			User latestUser =
					userDAO.getUser(
							loggedInUser.getUserId());

			session.setAttribute(
					"user",
					latestUser);

			session.setAttribute(
					"email",
					latestUser.getEmail());

			session.setAttribute(
					"profileMessage",
					"Profile updated successfully.");

		}
		else {

			session.setAttribute(
					"profileError",
					"Profile could not be updated.");
		}

		response.sendRedirect(
				request.getContextPath()
				+ "/ProfileServlet");
	}
}
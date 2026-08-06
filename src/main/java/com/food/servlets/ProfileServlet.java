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

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(
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

		User sessionUser =
				(User) session.getAttribute("user");

		if (sessionUser == null) {

			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp");

			return;
		}

		UserDAOImpl userDAO =
				new UserDAOImpl();

		User latestUser =
				userDAO.getUser(
						sessionUser.getUserId());

		if (latestUser == null) {

			session.invalidate();

			response.sendRedirect(
					request.getContextPath()
					+ "/Login.jsp	");

			return;
		}

		/*
		 * Update session with latest database details.
		 */
		session.setAttribute(
				"user",
				latestUser);

		session.setAttribute(
				"email",
				latestUser.getEmail());

		request.setAttribute(
				"profileUser",
				latestUser);

		request.getRequestDispatcher(
				"/Profile.jsp")
				.forward(request, response);
	}

	@Override
	protected void doPost(
			HttpServletRequest request,
			HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}
}
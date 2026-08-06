<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.food.Model.User"%>
<%@ page import="com.food.Model.Cart"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
User profileUser = (User) request.getAttribute("profileUser");

if (profileUser == null) {
	profileUser = (User) session.getAttribute("user");
}

if (profileUser == null) {
	response.sendRedirect(request.getContextPath() + "/Login.html");
	return;
}

Cart cart = (Cart) session.getAttribute("cart");

int cartCount = 0;

if (cart != null && cart.getItems() != null) {
	cartCount = cart.getItems().size();
}

String displayName =
		profileUser.getUserName() != null
			&& !profileUser.getUserName().trim().isEmpty()
				? profileUser.getUserName().trim()
				: "TapFoods User";

String initials = "TF";

String[] nameParts = displayName.split("\\s+");

if (nameParts.length == 1) {
	initials = nameParts[0]
			.substring(0, Math.min(2, nameParts[0].length()))
			.toUpperCase();
}
else {
	initials =
			(nameParts[0].substring(0, 1)
			+ nameParts[nameParts.length - 1].substring(0, 1))
			.toUpperCase();
}

String email =
		profileUser.getEmail() != null
			? profileUser.getEmail()
			: "";

String address =
		profileUser.getAddress() != null
			? profileUser.getAddress()
			: "";

String role =
		profileUser.getRole() != null
			? profileUser.getRole()
			: "CUSTOMER";

SimpleDateFormat dateFormat =
		new SimpleDateFormat("dd MMM yyyy, hh:mm a");

String createdDate =
		profileUser.getCreateDate() != null
			? dateFormat.format(profileUser.getCreateDate())
			: "Not available";

String lastLoginDate =
		profileUser.getLoginLastDate() != null
			? dateFormat.format(profileUser.getLoginLastDate())
			: "Not available";

String profileMessage =
		(String) session.getAttribute("profileMessage");

String profileError =
		(String) session.getAttribute("profileError");

String passwordMessage =
		(String) session.getAttribute("passwordMessage");

String passwordError =
		(String) session.getAttribute("passwordError");

session.removeAttribute("profileMessage");
session.removeAttribute("profileError");
session.removeAttribute("passwordMessage");
session.removeAttribute("passwordError");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
	content="width=device-width, initial-scale=1.0">

<title>TapFoods | Profile</title>

<link rel="preconnect"
	href="https://fonts.googleapis.com">

<link rel="preconnect"
	href="https://fonts.gstatic.com"
	crossorigin>

<link
	href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&display=swap"
	rel="stylesheet">

<style>

:root {
	--page: #0d0d12;
	--sidebar: #14141b;
	--panel: #181820;
	--panel-soft: #202029;
	--panel-hover: #252530;
	--line: rgba(255,255,255,.08);

	--text: #ffffff;
	--muted: #92929f;
	--muted-light: #b9b9c3;

	--orange: #f04a16;
	--orange-light: #ff6a2f;
	--orange-soft: rgba(240,74,22,.12);

	--green: #20bf63;
	--green-light: #31dc7b;
	--green-soft: rgba(32,191,99,.11);

	--red: #ff5c5c;
	--red-soft: rgba(255,92,92,.11);

	--sidebar-width: 240px;
	--header-height: 78px;

	--radius-xl: 25px;
	--radius-lg: 19px;
	--radius-md: 14px;
}

* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

html {
	scroll-behavior: smooth;
}

body {
	min-height: 100vh;
	overflow-x: hidden;
	background: var(--page);
	color: var(--text);
	font-family: "DM Sans", sans-serif;
	font-size: 16px;
	-webkit-font-smoothing: antialiased;
}

a {
	color: inherit;
	text-decoration: none;
}

button,
input,
textarea {
	font: inherit;
}

button {
	border: none;
}

.app-shell {
	min-height: 100vh;
}

.sidebar {
	position: fixed;
	top: 0;
	left: 0;
	z-index: 1000;

	width: var(--sidebar-width);
	height: 100vh;

	display: flex;
	flex-direction: column;

	overflow: hidden;

	border-right: 1px solid var(--line);

	background:
		linear-gradient(
			180deg,
			rgba(255,255,255,.018),
			transparent 55%
		),
		var(--sidebar);
}

.sidebar-top {
	flex-shrink: 0;
	padding: 22px 16px 18px;
	border-bottom: 1px solid var(--line);
}

.sidebar-scroll {
	flex: 1;
	padding: 18px 14px 24px;
	overflow-y: auto;
	overflow-x: hidden;

	scrollbar-width: thin;
	scrollbar-color: #34343f transparent;
}

.sidebar-scroll::-webkit-scrollbar {
	width: 5px;
}

.sidebar-scroll::-webkit-scrollbar-thumb {
	background: #34343f;
	border-radius: 20px;
}

.main-area {
	width: calc(100% - var(--sidebar-width));
	min-height: 100vh;
	margin-left: var(--sidebar-width);
}

.brand {
	min-height: 50px;
	padding: 0 5px;

	display: flex;
	align-items: center;
	gap: 11px;

	white-space: nowrap;
}

.brand-icon {
	width: 44px;
	height: 44px;

	display: grid;
	place-items: center;

	flex: 0 0 44px;

	border-radius: 13px;

	background:
		linear-gradient(
			135deg,
			var(--orange),
			var(--orange-light)
		);

	box-shadow:
		0 11px 26px
		rgba(240,74,22,.25);

	font-size: 20px;
}

.brand-copy {
	display: flex;
	flex-direction: column;
	gap: 1px;
}

.brand-name {
	font-size: 21px;
	font-weight: 800;
	letter-spacing: -.6px;
}

.brand-name span {
	color: var(--orange-light);
}

.brand-caption {
	color: var(--muted);
	font-size: 10px;
	font-weight: 700;
	letter-spacing: 1.1px;
	text-transform: uppercase;
}

.sidebar-label {
	margin: 0 10px 9px;
	color: #70707d;
	font-size: 11px;
	font-weight: 800;
	letter-spacing: 1.3px;
	text-transform: uppercase;
}

.sidebar-menu {
	display: grid;
	gap: 6px;
}

.sidebar-link {
	min-height: 47px;
	padding: 0 12px;

	display: flex;
	align-items: center;
	gap: 12px;

	border-radius: 14px;

	color: var(--muted-light);

	font-size: 14px;
	font-weight: 700;

	transition: .22s;
}

.sidebar-link:hover {
	background: var(--panel-soft);
	color: #fff;
	transform: translateX(3px);
}

.sidebar-link.active {
	background:
		linear-gradient(
			135deg,
			var(--orange),
			var(--orange-light)
		);

	color: #fff;

	box-shadow:
		0 12px 27px
		rgba(240,74,22,.21);
}

.sidebar-icon {
	width: 25px;
	display: grid;
	place-items: center;
	font-size: 18px;
}

.sidebar-count {
	margin-left: auto;

	min-width: 24px;
	height: 24px;
	padding: 0 7px;

	display: inline-flex;
	align-items: center;
	justify-content: center;

	border-radius: 999px;

	background: rgba(255,255,255,.11);

	font-size: 11px;
	font-weight: 800;
}

.sidebar-divider {
	height: 1px;
	margin: 17px 5px;
	background: var(--line);
}

.help-card {
	margin-top: 22px;
	padding: 16px;

	border: 1px solid rgba(32,191,99,.14);
	border-radius: 17px;

	background:
		linear-gradient(
			135deg,
			rgba(32,191,99,.085),
			rgba(32,191,99,.018)
		);
}

.help-icon {
	width: 37px;
	height: 37px;

	display: grid;
	place-items: center;

	border-radius: 11px;

	background: var(--green-soft);
	color: var(--green);
}

.help-card h4 {
	margin-top: 10px;
	font-size: 15px;
}

.help-card p {
	margin-top: 5px;
	color: var(--muted);
	font-size: 12px;
	line-height: 1.55;
}

.help-card a {
	margin-top: 10px;
	display: inline-flex;
	color: var(--green);
	font-size: 12px;
	font-weight: 800;
}

.top-header {
	position: sticky;
	top: 0;
	z-index: 900;

	min-height: var(--header-height);
	padding: 12px 24px;

	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 18px;

	border-bottom: 1px solid var(--line);

	background: rgba(13,13,18,.93);
	backdrop-filter: blur(16px);
}

.header-left,
.header-actions {
	display: flex;
	align-items: center;
	gap: 11px;
}

.back-link {
	min-height: 43px;
	padding: 0 15px;

	display: inline-flex;
	align-items: center;
	gap: 8px;

	border: 1px solid var(--line);
	border-radius: 13px;

	background: var(--panel);
	color: var(--muted-light);

	font-size: 13px;
	font-weight: 800;
}

.header-title {
	display: grid;
	gap: 2px;
}

.header-title small {
	color: var(--muted);
	font-size: 10px;
	font-weight: 800;
	letter-spacing: 1px;
	text-transform: uppercase;
}

.header-title strong {
	font-size: 14px;
}

.header-button {
	width: 46px;
	height: 46px;

	display: grid;
	place-items: center;

	border: 1px solid var(--line);
	border-radius: 13px;

	background: var(--panel);
	color: #fff;

	font-size: 17px;
}

.profile-chip {
	min-height: 47px;
	padding: 5px 11px 5px 6px;

	display: flex;
	align-items: center;
	gap: 9px;

	border: 1px solid var(--line);
	border-radius: 14px;

	background: var(--panel);
}

.profile-avatar-small {
	width: 37px;
	height: 37px;

	display: grid;
	place-items: center;

	border-radius: 11px;

	background:
		linear-gradient(
			135deg,
			var(--green),
			var(--green-light)
		);

	color: #07140c;

	font-size: 13px;
	font-weight: 900;
}

.profile-copy {
	display: grid;
	gap: 2px;
}

.profile-copy strong {
	font-size: 13px;
}

.profile-copy small {
	color: var(--muted);
	font-size: 10px;
}

.page-content {
	width: 100%;
	max-width: 1480px;

	margin: 0 auto;
	padding: 20px 28px 60px;
}

.profile-heading {
	margin-bottom: 22px;

	display: flex;
	align-items: flex-end;
	justify-content: space-between;
	gap: 18px;
}

.section-kicker {
	margin-bottom: 6px;
	color: var(--orange-light);
	font-size: 11px;
	font-weight: 800;
	letter-spacing: 1.3px;
	text-transform: uppercase;
}

.profile-heading h1 {
	font-size: clamp(2.1rem,3vw,3rem);
	letter-spacing: -1.4px;
}

.profile-heading p {
	margin-top: 7px;
	color: var(--muted);
	font-size: 14px;
	line-height: 1.6;
}

.role-badge {
	min-height: 40px;
	padding: 0 15px;

	display: inline-flex;
	align-items: center;
	gap: 8px;

	border: 1px solid rgba(32,191,99,.15);
	border-radius: 999px;

	background: var(--green-soft);
	color: var(--green);

	font-size: 12px;
	font-weight: 800;
}

.message {
	margin-bottom: 18px;
	padding: 14px 16px;

	border-radius: 13px;

	font-size: 13px;
	font-weight: 700;
}

.message.success {
	border: 1px solid rgba(32,191,99,.18);
	background: rgba(32,191,99,.10);
	color: var(--green-light);
}

.message.error {
	border: 1px solid rgba(255,92,92,.18);
	background: rgba(255,92,92,.10);
	color: #ff8b8b;
}

.profile-grid {
	display: grid;
	grid-template-columns: 340px minmax(0,1fr);
	gap: 24px;
	align-items: start;
}

.profile-summary-card,
.profile-form-card {
	border: 1px solid var(--line);
	border-radius: var(--radius-xl);

	background:
		linear-gradient(
			180deg,
			rgba(255,255,255,.02),
			transparent
		),
		var(--panel);

	box-shadow:
		0 14px 34px
		rgba(0,0,0,.23);
}

.profile-summary-card {
	position: sticky;
	top: calc(var(--header-height) + 20px);

	padding: 28px;
	text-align: center;
}

.profile-avatar-large {
	width: 112px;
	height: 112px;

	margin: auto;

	display: grid;
	place-items: center;

	border-radius: 31px;

	background:
		linear-gradient(
			135deg,
			var(--orange),
			var(--orange-light)
		);

	color: #fff;

	font-size: 38px;
	font-weight: 900;

	box-shadow:
		0 18px 36px
		rgba(240,74,22,.24);
}

.profile-summary-card h2 {
	margin-top: 20px;
	font-size: 27px;
	letter-spacing: -.8px;
}

.profile-summary-card > p {
	margin-top: 6px;
	color: var(--muted);
	font-size: 13px;
}

.profile-role {
	margin-top: 15px;
	padding: 8px 13px;

	display: inline-flex;
	align-items: center;
	justify-content: center;

	border-radius: 999px;

	background: var(--orange-soft);
	color: var(--orange-light);

	font-size: 10px;
	font-weight: 900;
	letter-spacing: .8px;
	text-transform: uppercase;
}

.profile-meta {
	margin-top: 24px;
	display: grid;
	gap: 12px;
	text-align: left;
}

.meta-row {
	padding: 13px 14px;

	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	gap: 16px;

	border: 1px solid var(--line);
	border-radius: 13px;

	background: var(--panel-soft);
}

.meta-row span:first-child {
	color: var(--muted);
	font-size: 11px;
	font-weight: 700;
}

.meta-row span:last-child {
	max-width: 62%;
	text-align: right;
	color: #fff;
	font-size: 11px;
	font-weight: 800;
	line-height: 1.5;
}

.logout-button {
	width: 100%;
	min-height: 48px;

	margin-top: 20px;

	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;

	border-radius: 13px;

	background: var(--red-soft);
	color: #ff8b8b;

	font-size: 12px;
	font-weight: 900;
}

.forms-column {
	display: grid;
	gap: 22px;
}

.profile-form-card {
	padding: 25px;
}

.card-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 15px;

	padding-bottom: 18px;
	border-bottom: 1px solid var(--line);
}

.card-header-copy {
	display: grid;
	gap: 5px;
}

.card-header-copy h2 {
	font-size: 23px;
	letter-spacing: -.6px;
}

.card-header-copy p {
	color: var(--muted);
	font-size: 11px;
	line-height: 1.5;
}

.card-icon {
	width: 46px;
	height: 46px;

	display: grid;
	place-items: center;

	border-radius: 14px;

	background: var(--orange-soft);
	color: var(--orange-light);

	font-size: 20px;
}

.form-grid {
	margin-top: 21px;
	display: grid;
	gap: 17px;
}

.form-row {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 15px;
}

.form-group {
	display: grid;
	gap: 8px;
}

.form-group label {
	font-size: 12px;
	font-weight: 800;
}

.form-group input,
.form-group textarea {
	width: 100%;

	border: 1px solid var(--line);
	outline: none;
	border-radius: 13px;

	background: var(--panel-soft);
	color: #fff;

	font-size: 13px;
}

.form-group input {
	height: 49px;
	padding: 0 15px;
}

.form-group textarea {
	min-height: 115px;
	padding: 14px 15px;
	resize: vertical;
}

.form-group input:focus,
.form-group textarea:focus {
	border-color: var(--orange);
	box-shadow: 0 0 0 4px rgba(240,74,22,.10);
}

.form-group input[readonly] {
	color: var(--muted-light);
	cursor: not-allowed;
}

.submit-button {
	min-height: 50px;
	padding: 0 20px;

	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 8px;

	border-radius: 13px;

	background:
		linear-gradient(
			135deg,
			var(--green),
			var(--green-light)
		);

	color: #07140c;

	font-size: 12px;
	font-weight: 900;

	cursor: pointer;

	box-shadow:
		0 13px 28px
		rgba(32,191,99,.20);
}

.password-button {
	background:
		linear-gradient(
			135deg,
			var(--orange),
			var(--orange-light)
		);

	color: #fff;

	box-shadow:
		0 13px 28px
		rgba(240,74,22,.20);
}

.footer {
	margin-top: 50px;
	padding-top: 28px;
	border-top: 1px solid var(--line);
}

.footer-main {
	padding-bottom: 28px;

	display: grid;
	grid-template-columns: 1.3fr repeat(3,.7fr);
	gap: 38px;
}

.footer-brand p {
	max-width: 430px;
	margin-top: 13px;
	color: var(--muted);
	font-size: 13px;
	line-height: 1.72;
}

.footer-column {
	display: grid;
	align-content: start;
	gap: 10px;
}

.footer-column h4 {
	font-size: 14px;
}

.footer-column a,
.footer-column span {
	color: var(--muted);
	font-size: 12px;
}

.footer-bottom {
	min-height: 62px;

	display: flex;
	align-items: center;

	border-top: 1px solid var(--line);

	color: #70707b;
	font-size: 11px;
}

@media (max-width: 1050px) {
	.profile-grid {
		grid-template-columns: 1fr;
	}

	.profile-summary-card {
		position: static;
	}
}

@media (max-width: 900px) {
	:root {
		--sidebar-width: 0px;
	}

	.sidebar {
		display: none;
	}

	.main-area {
		width: 100%;
		margin-left: 0;
	}
}

@media (max-width: 650px) {
	.top-header {
		padding: 10px 13px;
	}

	.header-title,
	.profile-copy {
		display: none;
	}

	.page-content {
		padding: 14px 13px 50px;
	}

	.profile-heading {
		align-items: flex-start;
		flex-direction: column;
	}

	.profile-form-card,
	.profile-summary-card {
		padding: 19px;
	}

	.form-row {
		grid-template-columns: 1fr;
	}

	.footer-main {
		grid-template-columns: 1fr 1fr;
	}

	.footer-brand {
		grid-column: 1 / -1;
	}
}

</style>

</head>

<body>

<div class="app-shell">

	<aside class="sidebar">

		<div class="sidebar-top">

			<a
				href="restaurant"
				class="brand">

				<span class="brand-icon">
					🍴
				</span>

				<span class="brand-copy">

					<span class="brand-name">
						Tap<span>Foods</span>
					</span>

					<span class="brand-caption">
						Food delivery
					</span>

				</span>

			</a>

		</div>

		<div class="sidebar-scroll">

			<p class="sidebar-label">
				Main menu
			</p>

			<nav class="sidebar-menu">

				<a
					href="restaurant"
					class="sidebar-link">

					<span class="sidebar-icon">
						⌂
					</span>

					<span>
						Home
					</span>

				</a>

				<a
					href="restaurant#restaurants"
					class="sidebar-link">

					<span class="sidebar-icon">
						🍽
					</span>

					<span>
						Restaurants
					</span>

				</a>

				<a
					href="Cart.jsp"
					class="sidebar-link">

					<span class="sidebar-icon">
						🛒
					</span>

					<span>
						My Cart
					</span>

					<span class="sidebar-count">
						<%=cartCount%>
					</span>

				</a>

				<a
					href="<%=request.getContextPath()%>/MyOrdersServlet"
					class="sidebar-link">

					<span class="sidebar-icon">
						📦
					</span>

					<span>
						My Orders
					</span>

				</a>

			</nav>

			<div class="sidebar-divider"></div>

			<p class="sidebar-label">
				Account
			</p>

			<nav class="sidebar-menu">

				<a
					href="<%=request.getContextPath()%>/ProfileServlet"
					class="sidebar-link active">

					<span class="sidebar-icon">
						👤
					</span>

					<span>
						Profile
					</span>

				</a>

				<a
					href="<%=request.getContextPath()%>/LogoutServlet"
					class="sidebar-link">

					<span class="sidebar-icon">
						⇥
					</span>

					<span>
						Log Out
					</span>

				</a>

			</nav>

			<div class="help-card">

				<div class="help-icon">
					?
				</div>

				<h4>
					Need assistance?
				</h4>

				<p>
					Our support team is ready to help with your account.
				</p>

				<a href="#">
					Contact support →
				</a>

			</div>

		</div>

	</aside>

	<div class="main-area">

		<header class="top-header">

			<div class="header-left">

				<a
					href="restaurant"
					class="back-link">

					← Back to Home

				</a>

				<div class="header-title">

					<small>
						Account settings
					</small>

					<strong>
						Manage your profile
					</strong>

				</div>

			</div>

			<div class="header-actions">

				<a
					href="Cart.jsp"
					class="header-button">

					🛒

				</a>

				<div class="profile-chip">

					<span class="profile-avatar-small">
						<%=initials%>
					</span>

					<span class="profile-copy">

						<strong>
							<%=displayName%>
						</strong>

						<small>
							Customer account
						</small>

					</span>

				</div>

			</div>

		</header>

		<main class="page-content">

			<section class="profile-heading">

				<div>

					<p class="section-kicker">
						Customer profile
					</p>

					<h1>
						My Profile
					</h1>

					<p>
						Update your account details and keep your profile secure.
					</p>

				</div>

				<div class="role-badge">

					<span>
						✓
					</span>

					<%=role%>

				</div>

			</section>

			<%
			if (profileMessage != null) {
			%>

			<div class="message success">
				<%=profileMessage%>
			</div>

			<%
			}

			if (profileError != null) {
			%>

			<div class="message error">
				<%=profileError%>
			</div>

			<%
			}

			if (passwordMessage != null) {
			%>

			<div class="message success">
				<%=passwordMessage%>
			</div>

			<%
			}

			if (passwordError != null) {
			%>

			<div class="message error">
				<%=passwordError%>
			</div>

			<%
			}
			%>

			<section class="profile-grid">

				<aside class="profile-summary-card">

					<div class="profile-avatar-large">
						<%=initials%>
					</div>

					<h2>
						<%=displayName%>
					</h2>

					<p>
						<%=email%>
					</p>

					<div class="profile-role">
						<%=role%>
					</div>

					<div class="profile-meta">

						<div class="meta-row">

							<span>
								User ID
							</span>

							<span>
								#<%=profileUser.getUserId()%>
							</span>

						</div>

						<div class="meta-row">

							<span>
								Account Created
							</span>

							<span>
								<%=createdDate%>
							</span>

						</div>

						<div class="meta-row">

							<span>
								Last Login
							</span>

							<span>
								<%=lastLoginDate%>
							</span>

						</div>

					</div>

					<a
						href="<%=request.getContextPath()%>/LogoutServlet"
						class="logout-button">

						⇥ Log Out

					</a>

				</aside>

				<div class="forms-column">

					<section class="profile-form-card">

						<div class="card-header">

							<div class="card-header-copy">

								<h2>
									Edit Profile
								</h2>

								<p>
									Update your name, email and delivery address.
								</p>

							</div>

							<div class="card-icon">
								✎
							</div>

						</div>

						<form
    action="<%=request.getContextPath()%>/UpdateProfileServlet"
    method="post">

							<div class="form-grid">

								<div class="form-row">

									<div class="form-group">

										<label for="userName">
											Full Name
										</label>

										<input
											id="userName"
											type="text"
											name="userName"
											value="<%=displayName%>"
											required>

									</div>

									<div class="form-group">

										<label for="email">
											Email Address
										</label>

										<input
											id="email"
											type="email"
											name="email"
											value="<%=email%>"
											required>

									</div>

								</div>

								<div class="form-group">

									<label for="address">
										Delivery Address
									</label>

									<textarea
										id="address"
										name="address"
										placeholder="Enter your complete address"
										required><%=address%></textarea>

								</div>

								<div class="form-row">

									<div class="form-group">

										<label for="role">
											Account Role
										</label>

										<input
											id="role"
											type="text"
											value="<%=role%>"
											readonly>

									</div>

									<div class="form-group">

										<label for="userId">
											User ID
										</label>

										<input
											id="userId"
											type="text"
											value="#<%=profileUser.getUserId()%>"
											readonly>

									</div>

								</div>

								<button
									type="submit"
									class="submit-button">

									Save Profile Changes

									<span>
										→
									</span>

								</button>

							</div>

						</form>

					</section>

					<section class="profile-form-card">

						<div class="card-header">

							<div class="card-header-copy">

								<h2>
									Change Password
								</h2>

								<p>
									Use a strong password to protect your TapFoods account.
								</p>

							</div>

							<div class="card-icon">
								🔒
							</div>

						</div>

						<form
							action="<%=request.getContextPath()%>/ChangePasswordServlet"
							method="post">

							<div class="form-grid">

								<div class="form-group">

									<label for="currentPassword">
										Current Password
									</label>

									<input
										id="currentPassword"
										type="password"
										name="currentPassword"
										placeholder="Enter current password"
										required>

								</div>

								<div class="form-row">

									<div class="form-group">

										<label for="newPassword">
											New Password
										</label>

										<input
											id="newPassword"
											type="password"
											name="newPassword"
											placeholder="Enter new password"
											minlength="6"
											required>

									</div>

									<div class="form-group">

										<label for="confirmPassword">
											Confirm Password
										</label>

										<input
											id="confirmPassword"
											type="password"
											name="confirmPassword"
											placeholder="Confirm new password"
											minlength="6"
											required>

									</div>

								</div>

								<button
									type="submit"
									class="submit-button password-button">

									Update Password

									<span>
										→
									</span>

								</button>

							</div>

						</form>

					</section>

				</div>

			</section>

			<footer class="footer">

				<div class="footer-main">

					<div class="footer-brand">

						<a
							href="restaurant"
							class="brand">

							<span class="brand-icon">
								🍴
							</span>

							<span class="brand-copy">

								<span class="brand-name">
									Tap<span>Foods</span>
								</span>

								<span class="brand-caption">
									Food delivery
								</span>

							</span>

						</a>

						<p>
							Discover trusted restaurants, delicious meals and a smooth
							food-ordering experience designed around your cravings.
						</p>

					</div>

					<div class="footer-column">

						<h4>
							Explore
						</h4>

						<a href="restaurant">
							Home
						</a>

						<a href="restaurant#restaurants">
							Restaurants
						</a>

						<a href="Cart.jsp">
							My Cart
						</a>

						<a href="<%=request.getContextPath()%>/MyOrdersServlet">
							My Orders
						</a>

					</div>

					<div class="footer-column">

						<h4>
							Account
						</h4>

						<a href="<%=request.getContextPath()%>/ProfileServlet">
							Profile
						</a>

						<a href="<%=request.getContextPath()%>/LogoutServlet">
							Log Out
						</a>

					</div>

					<div class="footer-column">

						<h4>
							Contact
						</h4>

						<span>
							Bengaluru, Karnataka
						</span>

						<span>
							+91 9876543210
						</span>

						<span>
							support@tapfoods.com
						</span>

					</div>

				</div>

				<div class="footer-bottom">
					© 2026 TapFoods. All rights reserved.
				</div>

			</footer>

		</main>

	</div>

</div>

<script>

const passwordForm =
	document.querySelector(
		'form[action$="ChangePasswordServlet"]'
	);

if (passwordForm) {

	passwordForm.addEventListener(
		"submit",
		function(event) {

			const newPassword =
				document.getElementById(
					"newPassword"
				).value;

			const confirmPassword =
				document.getElementById(
					"confirmPassword"
				).value;

			if (newPassword !== confirmPassword) {

				event.preventDefault();

				alert(
					"New password and confirm password do not match."
				);
			}
		}
	);
}

</script>

</body>

</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
String registerError = (String) session.getAttribute("registerError");
String oldUserName = (String) session.getAttribute("oldUserName");
String oldEmail = (String) session.getAttribute("oldEmail");
String oldAddress = (String) session.getAttribute("oldAddress");

session.removeAttribute("registerError");
session.removeAttribute("oldUserName");
session.removeAttribute("oldEmail");
session.removeAttribute("oldAddress");

if (oldUserName == null) oldUserName = "";
if (oldEmail == null) oldEmail = "";
if (oldAddress == null) oldAddress = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>TapFoods | Create Account</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&display=swap"
	rel="stylesheet">

<style>
:root {
	--page: #0d0d12;
	--panel: #17171f;
	--panel-soft: #202029;
	--panel-hover: #252530;
	--line: rgba(255, 255, 255, 0.08);
	--text: #ffffff;
	--muted: #92929f;
	--orange: #f04a16;
	--orange-light: #ff6a2f;
	--green: #20bf63;
	--green-light: #32dc7c;
	--danger: #ff5b5b;
}

* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

html {
	width: 100%;
	min-height: 100%;
	scroll-behavior: smooth;
}

body {
	width: 100%;
	min-height: 100vh;
	margin: 0;
	overflow: hidden;
	color: var(--text);
	background: var(--page);
	font-family: "DM Sans", sans-serif;
	-webkit-font-smoothing: antialiased;
}

button,
input,
textarea,
select {
	font: inherit;
}

a {
	color: inherit;
	text-decoration: none;
}

/* =========================
   FULL PAGE LAYOUT
========================= */

.register-shell {
	width: 100vw;
	height: 100vh;
	display: grid;
	grid-template-columns: 48% 52%;
	overflow: hidden;
	background: var(--panel);
}

/* =========================
   LEFT VISUAL PANEL
========================= */

.visual-panel {
	position: relative;
	width: 100%;
	height: 100vh;
	padding: 42px 52px;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
	overflow: hidden;
	background:
		linear-gradient(
			180deg,
			rgba(8, 8, 12, 0.04),
			rgba(8, 8, 12, 0.92)
		),
		url("https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1600&q=90")
		center/cover no-repeat;
}

.visual-panel::before {
	content: "";
	position: absolute;
	inset: 0;
	background:
		linear-gradient(
			125deg,
			rgba(240, 74, 22, 0.48),
			transparent 48%
		),
		linear-gradient(
			0deg,
			rgba(13, 13, 18, 0.96),
			transparent 67%
		);
	pointer-events: none;
}

.brand,
.visual-content {
	position: relative;
	z-index: 2;
}

.brand {
	display: inline-flex;
	align-items: center;
	gap: 13px;
	width: max-content;
}

.brand-icon {
	width: 52px;
	height: 52px;
	display: grid;
	place-items: center;
	border-radius: 16px;
	background: #ffffff;
	color: var(--orange);
	font-size: 24px;
	box-shadow: 0 12px 30px rgba(0, 0, 0, 0.24);
}

.brand-name {
	font-size: 25px;
	font-weight: 800;
	letter-spacing: -0.8px;
}

.brand-name span {
	color: var(--orange-light);
}

.visual-content {
	width: 100%;
	max-width: 650px;
	padding-bottom: 8px;
}

.tag {
	width: max-content;
	margin-bottom: 18px;
	padding: 10px 15px;
	display: inline-flex;
	align-items: center;
	gap: 9px;
	border: 1px solid rgba(255, 255, 255, 0.15);
	border-radius: 999px;
	background: rgba(255, 255, 255, 0.09);
	backdrop-filter: blur(10px);
	font-size: 13px;
	font-weight: 700;
}

.tag-dot {
	width: 9px;
	height: 9px;
	border-radius: 50%;
	background: var(--green);
	box-shadow: 0 0 0 5px rgba(32, 191, 99, 0.14);
}

.visual-content h1 {
	max-width: 650px;
	font-size: clamp(3rem, 5vw, 5.45rem);
	line-height: 0.98;
	letter-spacing: -4px;
}

.visual-content h1 span {
	color: var(--orange-light);
}

.visual-content p {
	max-width: 590px;
	margin-top: 22px;
	color: rgba(255, 255, 255, 0.74);
	font-size: 16px;
	line-height: 1.8;
}

.features {
	margin-top: 26px;
	display: flex;
	gap: 12px;
	flex-wrap: wrap;
}

.feature {
	padding: 11px 14px;
	border: 1px solid rgba(255, 255, 255, 0.12);
	border-radius: 12px;
	background: rgba(23, 23, 31, 0.58);
	backdrop-filter: blur(10px);
	color: rgba(255, 255, 255, 0.88);
	font-size: 13px;
	font-weight: 700;
}

/* =========================
   RIGHT FORM PANEL
========================= */

.form-panel {
	width: 100%;
	height: 100vh;
	padding: 24px 6%;
	display: flex;
	align-items: center;
	justify-content: center;
	overflow-y: auto;
	background:
		linear-gradient(
			180deg,
			rgba(255, 255, 255, 0.015),
			transparent
		),
		var(--panel);
}

.form-wrapper {
	width: 100%;
	max-width: 620px;
}

.mobile-brand {
	display: none;
}

.form-header {
	margin-bottom: 23px;
}

.small-title {
	margin-bottom: 9px;
	color: var(--green);
	font-size: 12px;
	font-weight: 800;
	letter-spacing: 1.7px;
	text-transform: uppercase;
}

.form-header h2 {
	font-size: clamp(2.3rem, 4vw, 3.25rem);
	line-height: 1.05;
	letter-spacing: -1.8px;
}

.form-header p {
	margin-top: 11px;
	color: var(--muted);
	font-size: 14px;
	line-height: 1.65;
}

/* =========================
   FORM GRID
========================= */

.form-row {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 15px;
}

.form-group {
	margin-bottom: 14px;
}

.form-group label {
	margin-bottom: 8px;
	display: block;
	color: #ececf1;
	font-size: 13px;
	font-weight: 700;
}

.input-box {
	position: relative;
}

.input-icon {
	position: absolute;
	left: 16px;
	top: 50%;
	z-index: 2;
	transform: translateY(-50%);
	color: #767682;
	font-size: 17px;
	pointer-events: none;
}

.input-box input,
.input-box textarea,
.input-box select {
	width: 100%;
	border: 1px solid var(--line);
	outline: none;
	border-radius: 14px;
	background: var(--panel-soft);
	color: var(--text);
	font-size: 14px;
	transition:
		border-color 0.25s ease,
		box-shadow 0.25s ease,
		transform 0.25s ease,
		background 0.25s ease;
}

.input-box input,
.input-box select {
	height: 54px;
	padding: 0 48px;
}

.input-box textarea {
	height: 78px;
	padding: 15px 16px 15px 48px;
	resize: none;
	line-height: 1.5;
}

.input-box input::placeholder,
.input-box textarea::placeholder {
	color: #6f6f7c;
}

.input-box input:focus,
.input-box textarea:focus,
.input-box select:focus {
	border-color: var(--orange);
	background: var(--panel-hover);
	box-shadow: 0 0 0 4px rgba(240, 74, 22, 0.13);
	transform: translateY(-1px);
}

.input-box select {
	appearance: none;
	cursor: pointer;
	padding-right: 48px;
	background-image:
		linear-gradient(45deg, transparent 50%, #8e8e99 50%),
		linear-gradient(135deg, #8e8e99 50%, transparent 50%);
	background-position:
		calc(100% - 21px) 23px,
		calc(100% - 15px) 23px;
	background-size: 6px 6px, 6px 6px;
	background-repeat: no-repeat;
}

.input-box select option {
	color: #ffffff;
	background: var(--panel-soft);
}

.password-toggle {
	position: absolute;
	right: 16px;
	top: 50%;
	z-index: 3;
	transform: translateY(-50%);
	border: none;
	background: transparent;
	color: #858591;
	cursor: pointer;
	font-size: 16px;
}

.password-toggle:hover {
	color: var(--orange-light);
}

/* =========================
   ROLE OPTIONS
========================= */

.role-options {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 12px;
}

.role-option input {
	display: none;
}

.role-card {
	min-height: 66px;
	padding: 12px 14px;
	display: flex;
	align-items: center;
	gap: 12px;
	border: 1px solid var(--line);
	border-radius: 14px;
	background: var(--panel-soft);
	cursor: pointer;
	transition:
		border-color 0.25s ease,
		background 0.25s ease,
		transform 0.25s ease;
}

.role-card:hover {
	transform: translateY(-2px);
	background: var(--panel-hover);
}

.role-icon {
	width: 39px;
	height: 39px;
	display: grid;
	place-items: center;
	flex-shrink: 0;
	border-radius: 11px;
	background: rgba(255, 255, 255, 0.06);
	font-size: 18px;
}

.role-copy {
	display: grid;
	gap: 2px;
}

.role-title {
	color: #ffffff;
	font-size: 13px;
	font-weight: 800;
}

.role-description {
	color: var(--muted);
	font-size: 10px;
}

.role-option input:checked + .role-card {
	border-color: var(--green);
	background: rgba(32, 191, 99, 0.08);
	box-shadow: 0 0 0 3px rgba(32, 191, 99, 0.08);
}

.role-option input:checked + .role-card .role-icon {
	color: var(--green);
	background: rgba(32, 191, 99, 0.13);
}

/* =========================
   CREATE BUTTON
========================= */

.create-button {
	width: 100%;
	height: 55px;
	margin-top: 8px;
	border: none;
	border-radius: 14px;
	background: linear-gradient(
		135deg,
		var(--orange),
		var(--orange-light)
	);
	color: #ffffff;
	font-size: 15px;
	font-weight: 800;
	cursor: pointer;
	box-shadow: 0 15px 32px rgba(240, 74, 22, 0.24);
	transition:
		transform 0.25s ease,
		box-shadow 0.25s ease,
		filter 0.25s ease;
}

.create-button:hover {
	transform: translateY(-3px);
	box-shadow: 0 20px 38px rgba(240, 74, 22, 0.34);
	filter: brightness(1.04);
}

.create-button:active {
	transform: translateY(-1px);
}

/* =========================
   LOGIN LINK
========================= */

.login-text {
	margin-top: 18px;
	text-align: center;
	color: var(--muted);
	font-size: 13px;
}

.login-text a {
	margin-left: 4px;
	color: var(--green);
	font-weight: 800;
}

.login-text a:hover {
	color: var(--green-light);
}

.secure-note {
	margin-top: 17px;
	padding: 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	border: 1px solid rgba(32, 191, 99, 0.13);
	border-radius: 12px;
	background: rgba(32, 191, 99, 0.06);
	color: #9ca0a9;
	font-size: 11px;
}

.secure-note span {
	color: var(--green);
	font-size: 15px;
}

/* =========================
   REGISTER MESSAGE
========================= */

.register-message {
	margin-bottom: 17px;
	padding: 13px 15px;
	display: flex;
	align-items: center;
	gap: 9px;
	border: 1px solid rgba(255, 91, 91, 0.24);
	border-radius: 13px;
	background: rgba(255, 91, 91, 0.10);
	color: #ff8b8b;
	font-size: 13px;
	font-weight: 700;
	line-height: 1.5;
}

/* =========================
   TABLET
========================= */

@media (max-width: 1000px) {
	body {
		overflow-y: auto;
	}

	.register-shell {
		width: 100%;
		height: auto;
		min-height: 100vh;
		grid-template-columns: 1fr;
	}

	.visual-panel {
		width: 100%;
		height: 360px;
		min-height: 360px;
		padding: 30px;
	}

	.visual-content h1 {
		font-size: 3.25rem;
		letter-spacing: -2.5px;
	}

	.visual-content p,
	.features {
		display: none;
	}

	.form-panel {
		width: 100%;
		height: auto;
		min-height: calc(100vh - 360px);
		padding: 42px 30px;
	}

	.form-wrapper {
		max-width: 680px;
	}
}

/* =========================
   MOBILE
========================= */

@media (max-width: 620px) {
	body {
		display: block;
		overflow-y: auto;
	}

	.register-shell {
		display: block;
		min-height: 100vh;
	}

	.visual-panel {
		height: 245px;
		min-height: 245px;
		padding: 22px;
	}

	.brand {
		display: none;
	}

	.visual-content h1 {
		max-width: 430px;
		font-size: 2.45rem;
		line-height: 1.02;
		letter-spacing: -2px;
	}

	.tag {
		margin-bottom: 13px;
		padding: 8px 12px;
		font-size: 11px;
	}

	.form-panel {
		min-height: calc(100vh - 245px);
		padding: 30px 20px 40px;
		align-items: flex-start;
	}

	.mobile-brand {
		margin-bottom: 24px;
		display: flex;
		align-items: center;
		gap: 8px;
		font-size: 21px;
		font-weight: 800;
	}

	.mobile-brand span {
		color: var(--orange-light);
	}

	.form-row,
	.role-options {
		grid-template-columns: 1fr;
	}

	.input-box textarea {
		height: 90px;
	}
}

/* =========================
   SHORT LAPTOP HEIGHT
========================= */

@media (min-width: 1001px) and (max-height: 780px) {
	.visual-panel {
		padding: 30px 42px;
	}

	.visual-content h1 {
		font-size: clamp(2.8rem, 4.4vw, 4.65rem);
	}

	.visual-content p {
		margin-top: 15px;
		line-height: 1.6;
	}

	.features {
		margin-top: 17px;
	}

	.form-panel {
		padding-top: 16px;
		padding-bottom: 16px;
	}

	.form-header {
		margin-bottom: 17px;
	}

	.form-group {
		margin-bottom: 10px;
	}

	.input-box input,
	.input-box select {
		height: 49px;
	}

	.input-box textarea {
		height: 66px;
	}

	.role-card {
		min-height: 58px;
		padding-top: 9px;
		padding-bottom: 9px;
	}

	.create-button {
		height: 50px;
	}

	.login-text {
		margin-top: 13px;
	}

	.secure-note {
		margin-top: 12px;
	}
}
</style>
</head>

<body>

	<main class="register-shell">

		<section class="visual-panel">

			<a href="#" class="brand">
				<span class="brand-icon">🍴</span>
				<span class="brand-name">Tap<span>Foods</span></span>
			</a>

			<div class="visual-content">

				<div class="tag">
					<span class="tag-dot"></span>
					Join the TapFoods community
				</div>

				<h1>
					Great food starts with <span>one account.</span>
				</h1>

				<p>
					Create your TapFoods account to explore restaurants, save your
					delivery details and enjoy a faster, smoother ordering experience.
				</p>

				<div class="features">
					<span class="feature">🍽 Discover restaurants</span>
					<span class="feature">🛒 Quick ordering</span>
					<span class="feature">🚚 Fast delivery</span>
				</div>

			</div>

		</section>

		<section class="form-panel">

			<div class="form-wrapper">

				<div class="mobile-brand">
					Tap<span>Foods</span>
				</div>

				<div class="form-header">
					<p class="small-title">Create your account</p>
					<h2>Sign up</h2>
					<p>Enter your details to begin your TapFoods experience.</p>
				</div>

				<%
				if (registerError != null && !registerError.trim().isEmpty()) {
				%>
				<div class="register-message">
					<span>⚠</span>
					<span><%=registerError%></span>
				</div>
				<%
				}
				%>

				<form action="<%=request.getContextPath()%>/register" method="post">

					<div class="form-row">

						<div class="form-group">
							<label for="username">Username</label>

							<div class="input-box">
								<span class="input-icon">👤</span>

								<input
									type="text"
									id="username"
									name="UserName"
									value="<%=oldUserName%>"
									placeholder="Enter username"
									autocomplete="username"
									required>
							</div>
						</div>

						<div class="form-group">
							<label for="email">Email ID</label>

							<div class="input-box">
								<span class="input-icon">✉</span>

								<input
									type="email"
									id="email"
									name="emailID"
									value="<%=oldEmail%>"
									placeholder="Enter email address"
									autocomplete="email"
									required>
							</div>
						</div>

					</div>

					<div class="form-group">
						<label for="password">Password</label>

						<div class="input-box">
							<span class="input-icon">🔒</span>

							<input
								type="password"
								id="password"
								name="password"
								placeholder="Create a secure password"
								autocomplete="new-password"
								required>

							<button
								type="button"
								class="password-toggle"
								id="passwordToggle"
								aria-label="Show or hide password">
								◉
							</button>
						</div>
					</div>

					<div class="form-group">
						<label for="address">Delivery Address</label>

						<div class="input-box">
							<span class="input-icon">⌖</span>

							<textarea
								id="address"
								name="address"
								placeholder="Enter your complete address"
								required><%=oldAddress%></textarea>
						</div>
					</div>

					<div class="form-group">
	<label>Select Role</label>

	<div class="role-options">

		<div class="role-option">
			<input
				type="radio"
				id="customerRole"
				name="role"
				value="CUSTOMER"
				checked>

			<label for="customerRole" class="role-card">
				<span class="role-icon">🛍</span>

				<span class="role-copy">
					<span class="role-title">Customer</span>
					<span class="role-description">
						Order food from restaurants
					</span>
				</span>
			</label>
		</div>

		<div class="role-option">
			<input
				type="radio"
				id="adminRole"
				name="role"
				value="ADMIN">

			<label for="adminRole" class="role-card">
				<span class="role-icon">⚙</span>

				<span class="role-copy">
					<span class="role-title">Admin</span>
					<span class="role-description">
						Manage restaurants, menus and orders
					</span>
				</span>
			</label>
		</div>

	</div>
</div>

					<button type="submit" class="create-button">
						Create Account
					</button>

					<p class="login-text">
						Already have an account?
						<a href="<%=request.getContextPath()%>/Login.jsp">Sign in</a>
					</p>

					<div class="secure-note">
						<span>✓</span>
						Your personal information is securely protected
					</div>

				</form>

			</div>

		</section>

	</main>

	<script>
		const passwordInput = document.getElementById("password");
		const passwordToggle = document.getElementById("passwordToggle");

		passwordToggle.addEventListener("click", function () {
			const isPassword = passwordInput.type === "password";

			passwordInput.type = isPassword ? "text" : "password";
			passwordToggle.textContent = isPassword ? "◎" : "◉";
		});
	</script>

</body>
</html>
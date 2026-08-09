<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
String loginError = (String) session.getAttribute("loginError");
String loginMessage = (String) session.getAttribute("loginMessage");
session.removeAttribute("loginError");
session.removeAttribute("loginMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>TapFoods | Sign In</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&display=swap"
	rel="stylesheet">

<style>
:root {
	--page: #0d0d12;
	--panel: #17171f;
	--panel-soft: #202029;
	--line: rgba(255, 255, 255, 0.08);
	--text: #ffffff;
	--muted: #92929f;
	--orange: #f04a16;
	--orange-light: #ff6a2f;
	--green: #20bf63;
	--green-dark: #159447;
	--danger: #ff5b5b;
	--shadow: 0 30px 80px rgba(0, 0, 0, 0.5);
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
	padding: 0;
	display: flex;
	align-items: stretch;
	justify-content: stretch;
	overflow: hidden;
	color: var(--text);
	background: var(--page);
	font-family: "DM Sans", sans-serif;
	-webkit-font-smoothing: antialiased;
}

button,
input {
	font: inherit;
}

a {
	color: inherit;
	text-decoration: none;
}

/* =========================
   COMPLETE PAGE LAYOUT
========================= */

.login-shell {
	width: 100vw;
	height: 100vh;
	max-width: none;
	min-height: 100vh;
	display: grid;
	grid-template-columns: 52% 48%;
	overflow: hidden;
	border: none;
	border-radius: 0;
	background: var(--panel);
	box-shadow: none;
}

/* =========================
   LEFT VISUAL SECTION
========================= */

.visual-panel {
	position: relative;
	width: 100%;
	height: 100vh;
	min-height: 100vh;
	padding: 42px 52px;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
	overflow: hidden;
	background:
		linear-gradient(
			180deg,
			rgba(8, 8, 12, 0.03),
			rgba(8, 8, 12, 0.9)
		),
		url("https://images.unsplash.com/photo-1543353071-10c8ba85a904?auto=format&fit=crop&w=1600&q=90")
		center/cover no-repeat;
}

.visual-panel::before {
	content: "";
	position: absolute;
	inset: 0;
	background:
		linear-gradient(
			120deg,
			rgba(240, 74, 22, 0.4),
			transparent 48%
		),
		linear-gradient(
			0deg,
			rgba(13, 13, 18, 0.95),
			transparent 66%
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
	max-width: 680px;
	padding-bottom: 10px;
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
	max-width: 680px;
	font-size: clamp(3rem, 5.2vw, 5.6rem);
	line-height: 0.98;
	letter-spacing: -4px;
}

.visual-content h1 span {
	color: var(--orange-light);
}

.visual-content p {
	max-width: 610px;
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
   RIGHT FORM SECTION
========================= */

.form-panel {
	width: 100%;
	height: 100vh;
	min-height: 100vh;
	padding: 28px 7%;
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
	max-width: 520px;
}

.mobile-brand {
	display: none;
}

.form-header {
	margin-bottom: 30px;
}

.small-title {
	margin-bottom: 10px;
	color: #a9a9bb;
	font-size: 13px;
	font-weight: 800;
	letter-spacing: 1.6px;
	text-transform: uppercase;
}

.form-header h2 {
	font-size: clamp(2.5rem, 4vw, 3.4rem);
	letter-spacing: -1.8px;
	line-height: 1.05;
}

.form-header p {
	margin-top: 13px;
	color: var(--muted);
	font-size: 15px;
	line-height: 1.7;
}

/* =========================
   FORM FIELDS
========================= */

.form-group {
	margin-bottom: 18px;
}

.form-group label {
	margin-bottom: 9px;
	display: block;
	color: #ececf1;
	font-size: 14px;
	font-weight: 700;
}

.input-box {
	position: relative;
}

.input-icon {
	position: absolute;
	left: 17px;
	top: 50%;
	z-index: 2;
	transform: translateY(-50%);
	color: #747481;
	font-size: 18px;
	pointer-events: none;
}

.input-box input {
	width: 100%;
	height: 58px;
	padding: 0 52px;
	border: 1px solid var(--line);
	outline: none;
	border-radius: 15px;
	background: var(--panel-soft);
	color: var(--text);
	font-size: 15px;
	transition:
		border-color 0.25s ease,
		box-shadow 0.25s ease,
		transform 0.25s ease,
		background 0.25s ease;
}

.input-box input::placeholder {
	color: #6f6f7c;
}

.input-box input:focus {
	border-color: var(--orange);
	background: #24242e;
	box-shadow: 0 0 0 4px rgba(240, 74, 22, 0.13);
	transform: translateY(-1px);
}

.password-toggle {
	position: absolute;
	right: 17px;
	top: 50%;
	z-index: 3;
	transform: translateY(-50%);
	border: none;
	outline: none;
	background: transparent;
	color: #858591;
	cursor: pointer;
	font-size: 17px;
}

.password-toggle:hover {
	color: var(--orange-light);
}

/* =========================
   REMEMBER + FORGOT
========================= */

.form-options {
	margin: 3px 0 24px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 16px;
}

.remember {
	display: inline-flex;
	align-items: center;
	gap: 9px;
	color: var(--muted);
	font-size: 13px;
	cursor: pointer;
}

.remember input {
	width: 17px;
	height: 17px;
	accent-color: var(--green);
	cursor: pointer;
}

.forgot-link {
	color: var(--orange-light);
	font-size: 13px;
	font-weight: 700;
}

.forgot-link:hover {
	text-decoration: underline;
}

/* =========================
   SIGN IN BUTTON
========================= */

.signin-button {
	width: 100%;
	height: 58px;
	border: none;
	border-radius: 15px;
	background: linear-gradient(
		135deg,
		var(--orange),
		var(--orange-light)
	);
	color: #ffffff;
	font-size: 16px;
	font-weight: 800;
	cursor: pointer;
	box-shadow: 0 15px 32px rgba(240, 74, 22, 0.24);
	transition:
		transform 0.25s ease,
		box-shadow 0.25s ease,
		filter 0.25s ease;
}

.signin-button:hover {
	transform: translateY(-3px);
	box-shadow: 0 20px 38px rgba(240, 74, 22, 0.34);
	filter: brightness(1.04);
}

.signin-button:active {
	transform: translateY(-1px);
}

/* =========================
   DIVIDER + SIGN UP
========================= */

.divider {
	margin: 25px 0;
	display: flex;
	align-items: center;
	gap: 14px;
	color: #6d6d78;
	font-size: 12px;
	font-weight: 700;
	text-transform: uppercase;
	letter-spacing: 1px;
}

.divider::before,
.divider::after {
	content: "";
	height: 1px;
	flex: 1;
	background: var(--line);
}

.signup-text {
	text-align: center;
	color: var(--muted);
	font-size: 14px;
}

.signup-text a {
	margin-left: 4px;
	color: var(--green);
	font-weight: 800;
}

.signup-text a:hover {
	color: #31dc7b;
}

/* =========================
   SECURE NOTE
========================= */

.secure-note {
	margin-top: 26px;
	padding: 14px;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 9px;
	border: 1px solid rgba(32, 191, 99, 0.13);
	border-radius: 13px;
	background: rgba(32, 191, 99, 0.06);
	color: #9ca0a9;
	font-size: 12px;
}

.secure-note span {
	color: var(--green);
	font-size: 16px;
}

/* =========================
   LOGIN MESSAGES
========================= */

.login-message {
	margin-bottom: 18px;
	padding: 13px 15px;
	display: flex;
	align-items: center;
	gap: 9px;
	border-radius: 13px;
	font-size: 13px;
	font-weight: 700;
	line-height: 1.5;
}

.login-message.error {
	border: 1px solid rgba(255, 91, 91, 0.24);
	background: rgba(255, 91, 91, 0.10);
	color: #ff8b8b;
}

.login-message.success {
	border: 1px solid rgba(32, 191, 99, 0.20);
	background: rgba(32, 191, 99, 0.09);
	color: #31dc7b;
}

/* =========================
   TABLET VIEW
========================= */

@media (max-width: 1000px) {
	body {
		overflow-y: auto;
	}

	.login-shell {
		width: 100%;
		height: auto;
		min-height: 100vh;
		grid-template-columns: 1fr;
	}

	.visual-panel {
		width: 100%;
		height: 370px;
		min-height: 370px;
		padding: 30px;
	}

	.visual-content {
		max-width: 590px;
	}

	.visual-content h1 {
		font-size: 3.3rem;
		letter-spacing: -2.5px;
	}

	.visual-content p,
	.features {
		display: none;
	}

	.form-panel {
		width: 100%;
		height: auto;
		min-height: calc(100vh - 370px);
		padding: 44px 32px;
	}

	.form-wrapper {
		max-width: 560px;
	}
}

/*=========================
   MOBILE VIEW
=========================*/

@media (max-width: 560px) {
	body {
		display: block;
		overflow-y: auto;
	}

	.login-shell {
		width: 100%;
		min-height: 100vh;
		display: block;
	}

	.visual-panel {
		width: 100%;
		height: 250px;
		min-height: 250px;
		padding: 22px;
	}

	.brand {
		display: none;
	}

	.visual-content {
		max-width: 100%;
	}

	.visual-content h1 {
		max-width: 390px;
		font-size: 2.45rem;
		line-height: 1.03;
		letter-spacing: -2px;
	}

	.tag {
		margin-bottom: 13px;
		padding: 8px 12px;
		font-size: 11px;
	}

	.form-panel {
		width: 100%;
		height: auto;
		min-height: calc(100vh - 250px);
		padding: 30px 20px 40px;
		align-items: flex-start;
	}

	.form-wrapper {
		max-width: 100%;
	}

	.mobile-brand {
		margin-bottom: 25px;
		display: flex;
		align-items: center;
		gap: 8px;
		font-size: 21px;
		font-weight: 800;
	}

	.mobile-brand span {
		color: var(--orange-light);
	}

	.form-header {
		margin-bottom: 27px;
	}

	.form-header h2 {
		font-size: 2.4rem;
	}

	.form-options {
		align-items: flex-start;
		flex-direction: column;
		gap: 12px;
	}

	.input-box input,
	.signin-button {
		height: 55px;
	}

	.input-box input {
		padding-left: 48px;
		padding-right: 48px;
	}
}

/* =========================
   SHORT LAPTOP HEIGHT
========================= */

@media (min-width: 1001px) and (max-height: 760px) {
	.visual-panel {
		padding: 30px 42px;
	}

	.visual-content h1 {
		font-size: clamp(2.9rem, 4.5vw, 4.8rem);
	}

	.visual-content p {
		margin-top: 15px;
		line-height: 1.6;
	}

	.features {
		margin-top: 18px;
	}

	.form-panel {
		padding-top: 20px;
		padding-bottom: 20px;
	}

	.form-header {
		margin-bottom: 22px;
	}

	.form-group {
		margin-bottom: 14px;
	}

	.form-options {
		margin-bottom: 18px;
	}

	.divider {
		margin: 19px 0;
	}

	.secure-note {
		margin-top: 18px;
	}
}
</style>
</head>

<body>

	<main class="login-shell">

		<section class="visual-panel">

			<a href="#" class="brand">
				<span class="brand-icon">🍴</span>
				<span class="brand-name">Tap<span>Foods</span></span>
			</a>

			<div class="visual-content">

				<div class="tag">
					<span class="tag-dot"></span>
					Fast and fresh delivery
				</div>

				<h1>
					Your favourite food, <span>one login away.</span>
				</h1>

				<p>
					Sign in to explore popular restaurants, discover delicious meals,
					manage your cart and enjoy a smooth ordering experience.
				</p>

				<div class="features">
					<span class="feature">⚡ Fast delivery</span>
					<span class="feature">🥗 Quality food</span>
					<span class="feature">🔒 Secure ordering</span>
				</div>

			</div>

		</section>

		<section class="form-panel">

			<div class="form-wrapper">

				<div class="mobile-brand">
					Tap<span>Foods</span>
				</div>

				<div class="form-header">
					<p class="small-title">Welcome back</p>
					<h2>Sign in</h2>
					<p>Enter your account details to continue to TapFoods.</p>
				</div>

				<%
				if (loginError != null && !loginError.trim().isEmpty()) {
				%>
				<div class="login-message error">
					<span>⚠</span>
					<span><%=loginError%></span>
				</div>
				<%
				}

				if (loginMessage != null && !loginMessage.trim().isEmpty()) {
				%>
				<div class="login-message success">
					<span>✓</span>
					<span><%=loginMessage%></span>
				</div>
				<%
				}
				%>

				<form action="<%=request.getContextPath()%>/login" method="post">

					<div class="form-group">
						<label for="email">Email ID</label>

						<div class="input-box">
							<span class="input-icon">✉</span>

							<input
								type="email"
								id="email"
								name="email"
								placeholder="Enter your email address"
								autocomplete="email"
								required>
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
								placeholder="Enter your password"
								autocomplete="current-password"
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

					<div class="form-options">

						<label class="remember">
							<input type="checkbox" name="rememberMe">
							Remember me
						</label>

						<a href="#" class="forgot-link">Forgot password?</a>

					</div>

					<button type="submit" class="signin-button">
						Sign In
					</button>

					<div class="divider">New to TapFoods?</div>

					<p class="signup-text">
				    	Don't have an account?
						<a href="Register.jsp">Create account</a>
					</p>

					<div class="secure-note">
						<span>✓</span>
						Your login information is securely protected
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
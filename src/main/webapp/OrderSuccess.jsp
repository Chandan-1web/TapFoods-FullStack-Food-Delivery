<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.food.Model.Order"%>
<%@ page import="com.food.Model.Cart"%>
<%@ page import="com.food.Model.CartItem"%>
<%@ page import="java.util.Map"%>

<%
Order lastOrder = (Order) session.getAttribute("lastOrder");
Integer lastOrderId = (Integer) session.getAttribute("lastOrderId");
String customerName = (String) session.getAttribute("orderCustomerName");
String deliveryAddress = (String) session.getAttribute("orderDeliveryAddress");
String phone = (String) session.getAttribute("orderPhone");
String paymentMode = (String) session.getAttribute("orderPaymentMode");
Double orderGrandTotal = (Double) session.getAttribute("orderGrandTotal");
Cart completedOrderCart = (Cart) session.getAttribute("completedOrderCart");

if (lastOrderId == null && lastOrder != null) {
	lastOrderId = lastOrder.getOrderID();
}

if (paymentMode == null && lastOrder != null) {
	paymentMode = lastOrder.getPaymentMethod();
}

if (orderGrandTotal == null && lastOrder != null) {
	orderGrandTotal = lastOrder.getTotalAmount();
}

if (customerName == null || customerName.trim().isEmpty()) {
	customerName = "Customer";
}

if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
	deliveryAddress = "Delivery address not available";
}

if (phone == null || phone.trim().isEmpty()) {
	phone = "Not provided";
}

if (paymentMode == null || paymentMode.trim().isEmpty()) {
	paymentMode = "Not available";
}

if (orderGrandTotal == null) {
	orderGrandTotal = 0.0;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>TapFoods | Order Success</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
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
	--line: rgba(255, 255, 255, .08);
	--text: #ffffff;
	--muted: #92929f;
	--muted-light: #b9b9c3;
	--orange: #f04a16;
	--orange-light: #ff6a2f;
	--orange-soft: rgba(240, 74, 22, .12);
	--green: #20bf63;
	--green-light: #31dc7b;
	--green-soft: rgba(32, 191, 99, .11);
	--sidebar-width: 240px;
	--header-height: 78px;
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
}

a {
	color: inherit;
	text-decoration: none;
}

button {
	font: inherit;
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
	background: var(--sidebar);
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

.brand {
	display: flex;
	align-items: center;
	gap: 11px;
	min-height: 50px;
	padding: 0 5px;
	white-space: nowrap;
}

.brand-icon {
	width: 44px;
	height: 44px;
	display: grid;
	place-items: center;
	flex: 0 0 44px;
	border-radius: 13px;
	background: linear-gradient(135deg, var(--orange), var(--orange-light));
	box-shadow: 0 11px 26px rgba(240, 74, 22, .25);
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
	background: linear-gradient(135deg, var(--orange), var(--orange-light));
	color: #fff;
	box-shadow: 0 12px 27px rgba(240, 74, 22, .21);
}

.sidebar-icon {
	width: 25px;
	display: grid;
	place-items: center;
	font-size: 18px;
}

.sidebar-divider {
	height: 1px;
	margin: 17px 5px;
	background: var(--line);
}

.help-card {
	margin-top: 22px;
	padding: 16px;
	border: 1px solid rgba(32, 191, 99, .14);
	border-radius: 17px;
	background: linear-gradient(135deg, rgba(32, 191, 99, .085),
		rgba(32, 191, 99, .018));
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

.main-area {
	width: calc(100% - var(--sidebar-width));
	min-height: 100vh;
	margin-left: var(--sidebar-width);
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
	background: rgba(13, 13, 18, .93);
	backdrop-filter: blur(16px);
}

.header-left, .header-actions {
	display: flex;
	align-items: center;
	gap: 11px;
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
	position: relative;
	width: 46px;
	height: 46px;
	display: grid;
	place-items: center;
	border: 1px solid var(--line);
	border-radius: 13px;
	background: var(--panel);
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

.profile-avatar {
	width: 37px;
	height: 37px;
	display: grid;
	place-items: center;
	border-radius: 11px;
	background: linear-gradient(135deg, var(--green), var(--green-light));
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
	max-width: 1320px;
	margin: 0 auto;
	padding: 24px 28px 60px;
}

.success-card {
	position: relative;
	overflow: hidden;
	padding: 38px;
	border: 1px solid var(--line);
	border-radius: 26px;
	background: linear-gradient(180deg, rgba(255, 255, 255, .02),
		transparent), var(--panel);
	box-shadow: 0 18px 44px rgba(0, 0, 0, .28);
}

.success-card::before {
	content: "";
	position: absolute;
	top: -150px;
	right: -120px;
	width: 320px;
	height: 320px;
	border-radius: 50%;
	background: rgba(32, 191, 99, .06);
}

.success-top {
	position: relative;
	z-index: 2;
	display: grid;
	place-items: center;
	text-align: center;
}

.success-icon {
	width: 96px;
	height: 96px;
	display: grid;
	place-items: center;
	border-radius: 28px;
	background: linear-gradient(135deg, var(--green), var(--green-light));
	color: #07140c;
	font-size: 48px;
	font-weight: 900;
	box-shadow: 0 18px 36px rgba(32, 191, 99, .24);
	animation: popIn .55s ease;
}

.success-top h1 {
	margin-top: 22px;
	font-size: clamp(2.2rem, 4vw, 3.8rem);
	letter-spacing: -1.8px;
}

.success-top p {
	max-width: 680px;
	margin-top: 10px;
	color: var(--muted);
	font-size: 15px;
	line-height: 1.7;
}

.order-pill {
	margin-top: 18px;
	min-height: 42px;
	padding: 0 16px;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	border: 1px solid rgba(240, 74, 22, .16);
	border-radius: 999px;
	background: var(--orange-soft);
	color: var(--orange-light);
	font-size: 13px;
	font-weight: 800;
}

.success-grid {
	position: relative;
	z-index: 2;
	margin-top: 30px;
	display: grid;
	grid-template-columns: 1.1fr .9fr;
	gap: 22px;
	align-items: start;
}

.info-card {
	padding: 22px;
	border: 1px solid var(--line);
	border-radius: 18px;
	background: var(--panel-soft);
}

.info-card h2 {
	font-size: 20px;
	letter-spacing: -.5px;
}

.info-list {
	margin-top: 18px;
	display: grid;
	gap: 14px;
}

.info-row {
	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	gap: 18px;
}

.info-row span:first-child {
	color: var(--muted);
	font-size: 12px;
	font-weight: 700;
}

.info-row span:last-child {
	max-width: 62%;
	text-align: right;
	color: #fff;
	font-size: 13px;
	font-weight: 700;
	line-height: 1.5;
}

.order-items {
	margin-top: 18px;
	display: grid;
	gap: 12px;
}

.order-item {
	padding-bottom: 12px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 14px;
	border-bottom: 1px solid var(--line);
}

.order-item:last-child {
	border-bottom: none;
	padding-bottom: 0;
}

.order-item-copy h3 {
	font-size: 14px;
}

.order-item-copy p {
	margin-top: 4px;
	color: var(--muted);
	font-size: 11px;
}

.order-item strong {
	color: var(--orange-light);
	font-size: 13px;
}

.delivery-card {
	margin-top: 18px;
	padding: 18px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 18px;
	border: 1px solid rgba(32, 191, 99, .14);
	border-radius: 16px;
	background: var(--green-soft);
}

.delivery-card div {
	display: grid;
	gap: 3px;
}

.delivery-card small {
	color: var(--muted);
	font-size: 10px;
	font-weight: 700;
	letter-spacing: .8px;
	text-transform: uppercase;
}

.delivery-card strong {
	color: var(--green);
	font-size: 18px;
}

.total-box {
	margin-top: 18px;
	padding-top: 18px;
	display: flex;
	align-items: flex-end;
	justify-content: space-between;
	gap: 18px;
	border-top: 1px solid var(--line);
}

.total-copy {
	display: grid;
	gap: 3px;
}

.total-copy small {
	color: var(--muted);
	font-size: 10px;
	font-weight: 700;
	letter-spacing: .8px;
	text-transform: uppercase;
}

.total-copy span {
	color: var(--muted-light);
	font-size: 10px;
}

.total-box strong {
	color: var(--orange-light);
	font-size: 30px;
	font-weight: 900;
}

.actions {
	position: relative;
	z-index: 2;
	margin-top: 28px;
	display: flex;
	justify-content: center;
	gap: 12px;
	flex-wrap: wrap;
}

.primary-button, .secondary-button {
	min-height: 50px;
	padding: 0 20px;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	border-radius: 14px;
	font-size: 13px;
	font-weight: 900;
	transition: .22s;
}

.primary-button {
	background: linear-gradient(135deg, var(--green), var(--green-light));
	color: #07140c;
	box-shadow: 0 13px 28px rgba(32, 191, 99, .20);
}

.secondary-button {
	border: 1px solid var(--line);
	background: var(--panel-soft);
	color: var(--muted-light);
}

.primary-button:hover, .secondary-button:hover {
	transform: translateY(-3px);
}

.footer {
	margin-top: 50px;
	padding-top: 28px;
	border-top: 1px solid var(--line);
}

.footer-main {
	padding-bottom: 28px;
	display: grid;
	grid-template-columns: 1.3fr repeat(3, .7fr);
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

.footer-column a, .footer-column span {
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

.confetti {
	position: fixed;
	top: -20px;
	width: 10px;
	height: 16px;
	opacity: .95;
	z-index: 2000;
	animation: fall linear forwards;
}

@keyframes popIn {
	from {
		transform: scale(.6);
		opacity: 0;
	}
	to {
		transform: scale(1);
		opacity: 1;
	}
}

@keyframes fall {
	to {
		transform: translateY(110vh) rotate(720deg);
		opacity: 0;
	}
}

@media ( max-width : 900px) {
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
	.success-grid {
		grid-template-columns: 1fr;
	}
}

@media ( max-width : 620px) {
	.top-header {
		padding: 10px 13px;
	}
	.profile-copy {
		display: none;
	}
	.page-content {
		padding: 14px 13px 50px;
	}
	.success-card {
		padding: 24px 18px;
	}
	.success-top h1 {
		font-size: 2.3rem;
	}
	.info-row {
		flex-direction: column;
		gap: 5px;
	}
	.info-row span:last-child {
		max-width: 100%;
		text-align: left;
	}
	.footer-main {
		grid-template-columns: 1fr 1fr;
	}
	.footer-brand {
		grid-column: 1/-1;
	}
}
</style>
</head>

<body>

	<div class="app-shell">

		<aside class="sidebar">

			<div class="sidebar-top">
				<a href="restaurant" class="brand"> <span class="brand-icon">🍴</span>

					<span class="brand-copy"> <span class="brand-name">
							Tap<span>Foods</span>
					</span> <span class="brand-caption"> Food delivery </span>
				</span>
				</a>
			</div>

			<div class="sidebar-scroll">

				<p class="sidebar-label">Main menu</p>

				<nav class="sidebar-menu">
					<a href="restaurant" class="sidebar-link"> <span
						class="sidebar-icon">⌂</span> <span>Home</span>
					</a> <a href="restaurant#restaurants" class="sidebar-link"> <span
						class="sidebar-icon">🍽</span> <span>Restaurants</span>
					</a> <a href="Cart.jsp" class="sidebar-link"> <span
						class="sidebar-icon">🛒</span> <span>My Cart</span>
					</a> <a href="#" class="sidebar-link active"> <span
						class="sidebar-icon">✓</span> <span>Order Success</span>
					</a> <a href="#" class="sidebar-link"> <span class="sidebar-icon">📦</span>
						<span>My Orders</span>
					</a>
				</nav>

				<div class="sidebar-divider"></div>

				<div class="help-card">
					<div class="help-icon">?</div>
					<h4>Need assistance?</h4>
					<p>Our support team is ready to help with your food orders.</p>
					<a href="#">Contact support →</a>
				</div>

			</div>

		</aside>

		<div class="main-area">

			<%
String profileInitials = "TF";

if (customerName != null && !customerName.trim().isEmpty()) {

	String[] nameParts = customerName.trim().split("\\s+");

	if (nameParts.length == 1) {

		profileInitials = nameParts[0]
				.substring(0, Math.min(2, nameParts[0].length()))
				.toUpperCase();

	} else {

		profileInitials =
				(nameParts[0].substring(0, 1)
				+ nameParts[nameParts.length - 1].substring(0, 1))
				.toUpperCase();
	}
}
%>

<header class="top-header">

	<div class="header-left">

		<div class="header-title">

			<small>Order completed</small>

			<strong>
				Your meal is being prepared
			</strong>

		</div>

	</div>

	<div class="header-actions">

		<a href="restaurant" class="header-button">
			⌂
		</a>

		<div class="profile-chip">

			<span class="profile-avatar">
				<%=profileInitials%>
			</span>

			<span class="profile-copy">

				<strong>
					<%=customerName%>
				</strong>

				<small>
					Customer account
				</small>

			</span>

		</div>

	</div>

</header>
			<main class="page-content">

				<section class="success-card">

					<div class="success-top">

						<div class="success-icon">✓</div>

						<h1>Order Placed Successfully!</h1>

						<p>
							Thank you, <strong><%=customerName%></strong>. Your order has
							been confirmed and is now being prepared.
						</p>

						<div class="order-pill">
							Order ID: #<%=lastOrderId != null ? lastOrderId : 0%>
						</div>

					</div>

					<div class="success-grid">

						<div class="info-card">

							<h2>Delivery Details</h2>

							<div class="info-list">

								<div class="info-row">
									<span>Customer</span> <span><%=customerName%></span>
								</div>

								<div class="info-row">
									<span>Phone</span> <span><%=phone%></span>
								</div>

								<div class="info-row">
									<span>Delivery Address</span> <span><%=deliveryAddress%></span>
								</div>

								<div class="info-row">
									<span>Payment Method</span> <span><%=paymentMode%></span>
								</div>

								<div class="info-row">
									<span>Order Status</span> <span style="color: #31dc7b;">
										<%=lastOrder != null ? lastOrder.getStatus() : "Pending"%>
									</span>
								</div>

							</div>

							<div class="delivery-card">

								<div>
									<small>Estimated Delivery</small> <strong>30–40
										minutes</strong>
								</div>

								<span style="font-size: 28px;">🛵</span>

							</div>

						</div>

						<div class="info-card">

							<h2>Ordered Items</h2>

							<div class="order-items">

								<%
							if (completedOrderCart != null &&
								completedOrderCart.getItems() != null &&
								!completedOrderCart.getItems().isEmpty()) {

								for (Map.Entry<Integer, CartItem> entry :
									completedOrderCart.getItems().entrySet()) {

									CartItem item = entry.getValue();
							%>

								<div class="order-item">

									<div class="order-item-copy">
										<h3><%=item.getName()%></h3>

										<p>
											Quantity:
											<%=item.getQty()%>
											&nbsp;•&nbsp; ₹<%=String.format("%.2f", item.getPrice())%>
											each
										</p>
									</div>

									<strong> ₹<%=String.format("%.2f", item.getTotalPrice())%>
									</strong>

								</div>

								<%
								}
							}
							else {
							%>

								<div class="order-item">
									<div class="order-item-copy">
										<h3>Order items saved</h3>
										<p>Your order details are available in My Orders.</p>
									</div>
								</div>

								<%
							}
							%>

							</div>

							<div class="total-box">

								<div class="total-copy">
									<small>Grand Total</small> <span>Inclusive of all
										charges</span>
								</div>

								<strong> ₹<%=String.format("%.2f", orderGrandTotal)%>
								</strong>

							</div>

						</div>

					</div>

					<div class="actions">

						<a href="restaurant" class="primary-button"> Continue Shopping
							<span>→</span>
						</a> <a href="<%=request.getContextPath()%>/MyOrdersServlet"
							class="secondary-button"> View My Orders </a>
					</div>

				</section>

				<footer class="footer">

					<div class="footer-main">

						<div class="footer-brand">
							<a href="restaurant" class="brand"> <span class="brand-icon">🍴</span>

								<span class="brand-copy"> <span class="brand-name">
										Tap<span>Foods</span>
								</span> <span class="brand-caption"> Food delivery </span>
							</span>
							</a>

							<p>Discover trusted restaurants, delicious meals and a smooth
								food-ordering experience designed around your cravings.</p>
						</div>

						<div class="footer-column">
							<h4>Explore</h4>
							<a href="restaurant">Home</a> <a href="restaurant#restaurants">Restaurants</a>
							<a href="Cart.jsp">My Cart</a> <a href="#">My Orders</a>
						</div>

						<div class="footer-column">
							<h4>Account</h4>
							<a href="#">Profile</a> <a href="Login.html">Sign In</a> <a
								href="Register.html">Create Account</a> <a href="#">Log Out</a>
						</div>

						<div class="footer-column">
							<h4>Contact</h4>
							<span>Bengaluru, Karnataka</span> <span>+91 9876543210</span> <span>support@tapfoods.com</span>
						</div>

					</div>

					<div class="footer-bottom">© 2026 TapFoods. All rights
						reserved.</div>

				</footer>

			</main>

		</div>

	</div>

	<script>
(function createConfetti() {

	const colors = [
		"#f04a16",
		"#ff6a2f",
		"#20bf63",
		"#31dc7b",
		"#ffc341",
		"#ffffff"
	];

	for (let index = 0; index < 80; index++) {

		const piece =
			document.createElement("div");

		piece.className =
			"confetti";

		piece.style.left =
			Math.random() * 100 + "vw";

		piece.style.background =
			colors[
				Math.floor(
					Math.random() * colors.length
				)
			];

		piece.style.animationDuration =
			2.5 + Math.random() * 2.5 + "s";

		piece.style.animationDelay =
			Math.random() * 1.2 + "s";

		piece.style.transform =
			"rotate(" +
			Math.random() * 360 +
			"deg)";

		document.body.appendChild(piece);

		setTimeout(function() {
			piece.remove();
		}, 6000);
	}
})();
</script>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.food.Model.Cart,
	        com.food.Model.CartItem,
	        com.food.Model.Menu,
	        com.food.Model.User,
	        com.food.DAOImpl.MenuDAOImpl,
	        java.util.Map"%>
<%
Cart cart = (Cart) session.getAttribute("cart");
Integer r = (Integer) session.getAttribute("restaurantId");
int restaurantId = r != null ? r : 0;
int cartCount = (cart != null && cart.getItems() != null) ? cart.getItems().size() : 0;
double subtotal = 0.0;
MenuDAOImpl menuDAO = new MenuDAOImpl();

User loggedInUser = (User) session.getAttribute("user");

if (loggedInUser == null) {
	response.sendRedirect(request.getContextPath() + "/Login.html");
	return;
}

String displayName = "TapFoods User";
String initials = "TF";
String userAddress = "";

if (loggedInUser != null) {

	if (loggedInUser.getUserName() != null
			&& !loggedInUser.getUserName().trim().isEmpty()) {

		displayName = loggedInUser.getUserName().trim();

		String[] nameParts = displayName.split("\\s+");

		if (nameParts.length == 1) {

			initials = nameParts[0]
					.substring(0, Math.min(2, nameParts[0].length()))
					.toUpperCase();

		} else {

			initials =
					(nameParts[0].substring(0, 1)
					+ nameParts[nameParts.length - 1].substring(0, 1))
					.toUpperCase();
		}
	}

	if (loggedInUser.getAddress() != null) {
		userAddress = loggedInUser.getAddress();
	}
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>TapFoods | Checkout</title>
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
	--soft: #202029;
	--hover: #252530;
	--line: rgba(255, 255, 255, .08);
	--text: #fff;
	--muted: #92929f;
	--orange: #f04a16;
	--orange2: #ff6a2f;
	--green: #20bf63;
	--green2: #31dc7b;
	--sidebar-width: 240px;
	--header-height: 78px
}

* {
	margin: 0;
	padding: 0;
	box-sizing: border-box
}

html {
	scroll-behavior: smooth
}

body {
	min-height: 100vh;
	overflow-x: hidden;
	background: var(--page);
	color: var(--text);
	font-family: "DM Sans", sans-serif
}

a {
	color: inherit;
	text-decoration: none
}

button, input, textarea {
	font: inherit
}

button {
	border: 0
}

img {
	display: block;
	max-width: 100%
}

.sidebar {
	position: fixed;
	inset: 0 auto 0 0;
	z-index: 1000;
	width: var(--sidebar-width);
	height: 100vh;
	display: flex;
	flex-direction: column;
	overflow: hidden;
	border-right: 1px solid var(--line);
	background: var(--sidebar)
}

.sidebar-top {
	flex-shrink: 0;
	padding: 22px 16px 18px;
	border-bottom: 1px solid var(--line)
}

.sidebar-scroll {
	flex: 1;
	padding: 18px 14px 24px;
	overflow-y: auto;
	overflow-x: hidden;
	scrollbar-width: thin;
	scrollbar-color: #34343f transparent
}

.brand {
	display: flex;
	align-items: center;
	gap: 11px;
	min-height: 50px;
	padding: 0 5px;
	white-space: nowrap
}

.brand-icon {
	width: 44px;
	height: 44px;
	display: grid;
	place-items: center;
	flex: 0 0 44px;
	border-radius: 13px;
	background: linear-gradient(135deg, var(--orange), var(--orange2));
	box-shadow: 0 11px 26px rgba(240, 74, 22, .25);
	font-size: 20px
}

.brand-copy {
	display: flex;
	flex-direction: column;
	gap: 1px
}

.brand-name {
	font-size: 21px;
	font-weight: 800;
	letter-spacing: -.6px
}

.brand-name span {
	color: var(--orange2)
}

.brand-caption {
	color: var(--muted);
	font-size: 10px;
	font-weight: 700;
	letter-spacing: 1.1px;
	text-transform: uppercase
}

.sidebar-label {
	margin: 0 10px 9px;
	color: #70707d;
	font-size: 11px;
	font-weight: 800;
	letter-spacing: 1.3px;
	text-transform: uppercase
}

.sidebar-menu {
	display: grid;
	gap: 6px
}

.sidebar-link {
	min-height: 47px;
	padding: 0 12px;
	display: flex;
	align-items: center;
	gap: 12px;
	border-radius: 14px;
	color: #b9b9c3;
	font-size: 14px;
	font-weight: 700;
	transition: .22s
}

.sidebar-link:hover {
	background: var(--soft);
	color: #fff;
	transform: translateX(3px)
}

.sidebar-link.active {
	background: linear-gradient(135deg, var(--orange), var(--orange2));
	color: #fff;
	box-shadow: 0 12px 27px rgba(240, 74, 22, .21)
}

.sidebar-icon {
	width: 25px;
	display: grid;
	place-items: center;
	font-size: 18px
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
	background: rgba(255, 255, 255, .11);
	font-size: 11px;
	font-weight: 800
}

.sidebar-divider {
	height: 1px;
	margin: 17px 5px;
	background: var(--line)
}

.help-card {
	margin-top: 22px;
	padding: 16px;
	border: 1px solid rgba(32, 191, 99, .14);
	border-radius: 17px;
	background: linear-gradient(135deg, rgba(32, 191, 99, .085),
		rgba(32, 191, 99, .018))
}

.help-icon {
	width: 37px;
	height: 37px;
	display: grid;
	place-items: center;
	border-radius: 11px;
	background: rgba(32, 191, 99, .11);
	color: var(--green)
}

.help-card h4 {
	margin-top: 10px;
	font-size: 15px
}

.help-card p {
	margin-top: 5px;
	color: var(--muted);
	font-size: 12px;
	line-height: 1.55
}

.help-card a {
	margin-top: 10px;
	display: inline-flex;
	color: var(--green);
	font-size: 12px;
	font-weight: 800
}

.main-area {
	width: calc(100% - var(--sidebar-width));
	min-height: 100vh;
	margin-left: var(--sidebar-width)
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
	backdrop-filter: blur(16px)
}

.header-left, .header-actions {
	display: flex;
	align-items: center;
	gap: 11px
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
	color: #b9b9c3;
	font-size: 13px;
	font-weight: 800
}

.header-title {
	display: grid;
	gap: 2px
}

.header-title small {
	color: var(--muted);
	font-size: 10px;
	font-weight: 800;
	letter-spacing: 1px;
	text-transform: uppercase
}

.header-title strong {
	font-size: 14px
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
	font-size: 17px
}

.notification-dot {
	position: absolute;
	top: 8px;
	right: 8px;
	width: 7px;
	height: 7px;
	border: 2px solid var(--panel);
	border-radius: 50%;
	background: var(--orange)
}

.profile-chip {
	min-height: 47px;
	padding: 5px 11px 5px 6px;
	display: flex;
	align-items: center;
	gap: 9px;
	border: 1px solid var(--line);
	border-radius: 14px;
	background: var(--panel)
}

.profile-avatar {
	width: 37px;
	height: 37px;
	display: grid;
	place-items: center;
	border-radius: 11px;
	background: linear-gradient(135deg, var(--green), var(--green2));
	color: #07140c;
	font-size: 13px;
	font-weight: 900
}

.profile-copy {
	display: grid;
	gap: 2px
}

.profile-copy strong {
	font-size: 13px
}

.profile-copy small {
	color: var(--muted);
	font-size: 10px
}

.page-content {
	width: 100%;
	max-width: 1480px;
	margin: 0 auto;
	padding: 18px 28px 60px
}

.heading {
	margin-bottom: 20px;
	display: flex;
	align-items: flex-end;
	justify-content: space-between;
	gap: 20px
}

.kicker {
	margin-bottom: 6px;
	color: var(--orange2);
	font-size: 11px;
	font-weight: 800;
	letter-spacing: 1.3px;
	text-transform: uppercase
}

.heading h1 {
	font-size: clamp(2.1rem, 3vw, 3rem);
	letter-spacing: -1.4px
}

.heading p {
	margin-top: 7px;
	color: var(--muted);
	font-size: 14px
}

.safe-badge {
	min-height: 38px;
	padding: 0 14px;
	display: inline-flex;
	align-items: center;
	gap: 7px;
	border: 1px solid rgba(32, 191, 99, .15);
	border-radius: 999px;
	background: rgba(32, 191, 99, .11);
	color: var(--green);
	font-size: 12px;
	font-weight: 800
}

.checkout-layout {
	display: grid;
	grid-template-columns: minmax(0, 1fr) 420px;
	gap: 24px;
	align-items: start
}

.card {
	padding: 24px;
	border: 1px solid var(--line);
	border-radius: 19px;
	background: linear-gradient(180deg, rgba(255, 255, 255, .02),
		transparent), var(--panel);
	box-shadow: 0 13px 30px rgba(0, 0, 0, .22)
}

.card h2 {
	font-size: 24px;
	letter-spacing: -.7px
}

.card>p {
	margin-top: 6px;
	color: var(--muted);
	font-size: 12px;
	line-height: 1.5
}

.form-grid {
	margin-top: 22px;
	display: grid;
	gap: 18px
}

.form-group {
	display: grid;
	gap: 8px
}

.form-group label, .payment-title {
	font-size: 13px;
	font-weight: 700
}

.form-group input, .form-group textarea {
	width: 100%;
	border: 1px solid var(--line);
	outline: none;
	border-radius: 13px;
	background: var(--soft);
	color: #fff;
	font-size: 14px
}

.form-group input {
	height: 49px;
	padding: 0 15px
}

.form-group textarea {
	min-height: 120px;
	padding: 14px 15px;
	resize: vertical
}

.form-group input:focus, .form-group textarea:focus {
	border-color: var(--orange);
	box-shadow: 0 0 0 4px rgba(240, 74, 22, .10)
}

.payment-grid {
	margin-top: 12px;
	display: grid;
	grid-template-columns: repeat(3, minmax(0, 1fr));
	gap: 12px
}

.payment-option input {
	display: none
}

.payment-option label {
	min-height: 92px;
	padding: 14px;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	gap: 8px;
	border: 1px solid var(--line);
	border-radius: 14px;
	background: var(--soft);
	color: #b9b9c3;
	cursor: pointer;
	text-align: center;
	font-size: 12px;
	font-weight: 800;
	transition: .22s
}

.payment-option label span {
	font-size: 22px
}

.payment-option input:checked+label {
	border-color: var(--orange);
	background: rgba(240, 74, 22, .12);
	color: #fff;
	transform: translateY(-2px)
}

.summary-card {
	position: sticky;
	top: calc(var(--header-height)+ 18px)
}

.summary-items {
	margin-top: 19px;
	display: grid;
	gap: 12px;
	max-height: 360px;
	overflow-y: auto;
	padding-right: 3px
}

.summary-item {
	padding-bottom: 12px;
	display: grid;
	grid-template-columns: 68px minmax(0, 1fr) auto;
	gap: 12px;
	align-items: center;
	border-bottom: 1px solid var(--line)
}

.summary-item img {
	width: 68px;
	height: 68px;
	border-radius: 12px;
	object-fit: cover
}

.summary-item-info h3 {
	font-size: 14px
}

.summary-item-info p {
	margin-top: 5px;
	color: var(--muted);
	font-size: 11px
}

.summary-item-price {
	color: var(--orange2);
	font-size: 13px;
	font-weight: 800
}

.summary-list {
	padding: 18px 0;
	display: grid;
	gap: 14px
}

.summary-row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	color: #b9b9c3;
	font-size: 13px
}

.summary-row span:last-child {
	color: #fff;
	font-weight: 700
}

.delivery-row span:last-child {
	color: var(--green)
}

.summary-divider {
	height: 1px;
	background: var(--line)
}

.grand-total {
	padding-top: 18px;
	display: flex;
	align-items: flex-end;
	justify-content: space-between
}

.grand-total-copy {
	display: grid;
	gap: 3px
}

.grand-total-copy small {
	color: var(--muted);
	font-size: 10px;
	font-weight: 700;
	letter-spacing: .8px;
	text-transform: uppercase
}

.grand-total-copy span {
	color: #b9b9c3;
	font-size: 10px
}

.grand-total strong {
	color: var(--orange2);
	font-size: 28px;
	font-weight: 900
}

.place-order {
	width: 100%;
	min-height: 52px;
	margin-top: 22px;
	border-radius: 14px;
	background: linear-gradient(135deg, var(--green), var(--green2));
	color: #07140c;
	font-size: 13px;
	font-weight: 900;
	cursor: pointer;
	box-shadow: 0 13px 28px rgba(32, 191, 99, .20)
}

.secure-note {
	margin-top: 14px;
	padding: 11px;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	border: 1px solid rgba(32, 191, 99, .12);
	border-radius: 12px;
	background: rgba(32, 191, 99, .055);
	color: var(--muted);
	font-size: 10px
}

.empty-state {
	padding: 52px 24px;
	text-align: center
}

.empty-icon {
	width: 70px;
	height: 70px;
	margin: auto;
	display: grid;
	place-items: center;
	border-radius: 20px;
	background: rgba(240, 74, 22, .12);
	color: var(--orange2);
	font-size: 30px
}

.empty-state h2 {
	margin-top: 18px
}

.empty-state p {
	margin-top: 8px;
	color: var(--muted)
}

.browse-button {
	min-height: 46px;
	margin-top: 20px;
	padding: 0 18px;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	border-radius: 13px;
	background: linear-gradient(135deg, var(--orange), var(--orange2));
	font-size: 12px;
	font-weight: 800
}

.footer {
	margin-top: 50px;
	padding-top: 28px;
	border-top: 1px solid var(--line)
}

.footer-main {
	padding-bottom: 28px;
	display: grid;
	grid-template-columns: 1.3fr repeat(3, .7fr);
	gap: 38px
}

.footer-brand p {
	max-width: 430px;
	margin-top: 13px;
	color: var(--muted);
	font-size: 13px;
	line-height: 1.72
}

.footer-column {
	display: grid;
	align-content: start;
	gap: 10px
}

.footer-column h4 {
	font-size: 14px
}

.footer-column a, .footer-column span {
	color: var(--muted);
	font-size: 12px
}

.footer-bottom {
	min-height: 62px;
	display: flex;
	align-items: center;
	border-top: 1px solid var(--line);
	color: #70707b;
	font-size: 11px
}

@media ( max-width :1120px) {
	:root {
		--sidebar-width: 220px
	}
	.checkout-layout {
		grid-template-columns: minmax(0, 1fr) 360px
	}
	.payment-grid {
		grid-template-columns: 1fr
	}
	.footer-main {
		grid-template-columns: 1.2fr repeat(2, .8fr)
	}
	.footer-column:last-child {
		display: none
	}
}

@media ( max-width :920px) {
	:root {
		--sidebar-width: 0px
	}
	.sidebar {
		display: none
	}
	.main-area {
		width: 100%;
		margin-left: 0
	}
	.checkout-layout {
		grid-template-columns: 1fr
	}
	.summary-card {
		position: static
	}
}

@media ( max-width :620px) {
	.top-header {
		padding: 10px 13px
	}
	.header-title, .profile-copy {
		display: none
	}
	.page-content {
		padding: 14px 13px 50px
	}
	.heading {
		align-items: flex-start;
		flex-direction: column
	}
	.card {
		padding: 18px
	}
	.summary-item {
		grid-template-columns: 58px minmax(0, 1fr) auto
	}
	.summary-item img {
		width: 58px;
		height: 58px
	}
	.footer-main {
		grid-template-columns: 1fr 1fr
	}
	.footer-brand {
		grid-column: 1/-1
	}
}
</style>
</head>
<body>
	<div class="app-shell">
		<aside class="sidebar">
			<div class="sidebar-top">
				<a href="restaurant" class="brand"><span class="brand-icon">🍴</span><span
					class="brand-copy"><span class="brand-name">Tap<span>Foods</span></span><span
						class="brand-caption">Food delivery</span></span></a>
			</div>
			<div class="sidebar-scroll">
				<p class="sidebar-label">Main menu</p>
				<nav class="sidebar-menu">
					<a href="restaurant" class="sidebar-link"><span
						class="sidebar-icon">⌂</span><span>Home</span></a> <a
						href="restaurant#restaurants" class="sidebar-link"><span
						class="sidebar-icon">🍽</span><span>Restaurants</span></a> <a
						href="Cart.jsp" class="sidebar-link"><span
						class="sidebar-icon">🛒</span><span>My Cart</span><span
						class="sidebar-count"><%=cartCount%></span></a> <a href="<%=request.getContextPath()%>/MyOrdersServlet"
						class="sidebar-link"><span class="sidebar-icon">📦</span><span>My
							Orders</span></a>
				</nav>
				<div class="sidebar-divider"></div>
				<p class="sidebar-label">Checkout</p>
				<nav class="sidebar-menu">
					<a href="#" class="sidebar-link active"><span
						class="sidebar-icon">💳</span><span>Checkout</span></a> <a href="#"
						class="sidebar-link"><span class="sidebar-icon">👤</span><span>Profile</span></a>
				</nav>
				<div class="help-card">
					<div class="help-icon">?</div>
					<h4>Need assistance?</h4>
					<p>Our support team is ready to help with your food orders.</p>
					<a href="#">Contact support →</a>
				</div>
			</div>
		</aside>

		<div class="main-area">
			<header class="top-header">
				<div class="header-left">
					<a href="Cart.jsp" class="back-link">← Back to Cart</a>
					<div class="header-title">
						<small>Checkout</small><strong>Confirm your order</strong>
					</div>
				</div>
				<div class="header-actions">
					<a href="Cart.jsp" class="header-button">🛒</a>
					<button class="header-button">
						🔔<span class="notification-dot"></span>
					</button>
					<div class="profile-chip">

						<span class="profile-avatar"> <%=initials%>
						</span> <span class="profile-copy"> <strong> <%=displayName%>
						</strong> <small> Customer account </small>

						</span>

					</div>
				</div>
			</header>

			<main class="page-content">
				<div class="heading">
					<div>
						<p class="kicker">Secure checkout</p>
						<h1>Complete your order</h1>
						<p>Enter delivery details and review your cart before placing
							the order.</p>
					</div>
					<div class="safe-badge">✓ Protected checkout</div>
				</div>

				<%
				if (cart != null && cart.getItems() != null && !cart.getItems().isEmpty()) {
				%>
				<form action="<%=request.getContextPath()%>/CheckOutServlet"
					method="post">
					<div class="checkout-layout">
						<section class="card">
							<h2>Delivery Information</h2>
							<p>Provide the details where your order should be delivered.</p>
							<div class="form-grid">
								<div class="form-group">
									<label for="customerName">Full Name</label><input
										id="customerName" type="text" name="customerName"
										value="<%=loggedInUser != null && loggedInUser.getUserName() != null ? loggedInUser.getUserName() : ""%>"
										placeholder="Enter your full name" required>
								</div>
								<div class="form-group">
									<label for="address">Delivery Address</label>
									<textarea id="address" name="address"
										placeholder="Enter complete delivery address" required><%=userAddress%></textarea>
								</div>
								<div class="form-group">
									<label for="phone">Phone Number</label><input id="phone"
										type="tel" name="phone" placeholder="Enter phone number"
										required>
								</div>
								<div>
									<p class="payment-title">Payment Mode</p>
									<div class="payment-grid">
										<div class="payment-option">
											<input type="radio" id="upi" name="paymentMode" value="UPI"
												checked><label for="upi"><span>📱</span>UPI</label>
										</div>
										<div class="payment-option">
											<input type="radio" id="cod" name="paymentMode" value="COD"><label
												for="cod"><span>💵</span>Cash on Delivery</label>
										</div>
										<div class="payment-option">
											<input type="radio" id="card" name="paymentMode" value="CARD"><label
												for="card"><span>💳</span>Card Payment</label>
										</div>
									</div>
								</div>
							</div>
						</section>

						<aside class="card summary-card">
							<h2>Order Summary</h2>
							<p>Review your selected items and final amount.</p>
							<div class="summary-items">
								<%
for(Map.Entry<Integer,CartItem> entry:cart.getItems().entrySet()){
CartItem item=entry.getValue();
Menu menu=menuDAO.getMenuById(item.getMenuId());
String imagePath=(menu!=null&&menu.getImagePath()!=null&&!menu.getImagePath().trim().isEmpty())?menu.getImagePath():"https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80";
double itemTotal=item.getTotalPrice();
subtotal+=itemTotal;
%>
								<div class="summary-item">
									<img src="<%=imagePath%>" alt="<%=item.getName()%>">
									<div class="summary-item-info">
										<h3><%=item.getName()%></h3>
										<p>
											Qty:
											<%=item.getQty()%>
											• ₹<%=String.format("%.2f",item.getPrice())%></p>
									</div>
									<div class="summary-item-price">
										₹<%=String.format("%.2f",itemTotal)%></div>
								</div>
								<%
}
double deliveryCharge=subtotal>0?40.00:0.00;
double gst=subtotal*0.05;
double grandTotal=subtotal+deliveryCharge+gst;
session.setAttribute("grandTotal",grandTotal);
%>
							</div>
							<div class="summary-list">
								<div class="summary-row">
									<span>Subtotal</span><span>₹<%=String.format("%.2f",subtotal)%></span>
								</div>
								<div class="summary-row delivery-row">
									<span>Delivery Charges</span><span>₹<%=String.format("%.2f",deliveryCharge)%></span>
								</div>
								<div class="summary-row">
									<span>GST (5%)</span><span>₹<%=String.format("%.2f",gst)%></span>
								</div>
								<div class="summary-row">
									<span>Estimated Delivery</span><span>30–40 mins</span>
								</div>
							</div>
							<div class="summary-divider"></div>
							<div class="grand-total">
								<div class="grand-total-copy">
									<small>Grand Total</small><span>Inclusive of all taxes</span>
								</div>
								<strong>₹<%=String.format("%.2f",grandTotal)%></strong>
							</div>
							<input type="hidden" name="grandTotal" value="<%=grandTotal%>">
							<button type="submit" class="place-order">Place Order →</button>
							<div class="secure-note">✓ Your checkout information is
								securely protected</div>
						</aside>
					</div>
				</form>
				<%
}else{
%>
				<section class="card empty-state">
					<div class="empty-icon">🛒</div>
					<h2>Your cart is empty</h2>
					<p>Add some delicious food before continuing to checkout.</p>
					<a href="restaurant" class="browse-button">Browse Restaurants</a>
				</section>
				<%
}
%>

				<footer class="footer">
					<div class="footer-main">
						<div class="footer-brand">
							<a href="restaurant" class="brand"><span class="brand-icon">🍴</span><span
								class="brand-copy"><span class="brand-name">Tap<span>Foods</span></span><span
									class="brand-caption">Food delivery</span></span></a>
							<p>Discover trusted restaurants, delicious meals and a smooth
								food-ordering experience designed around your cravings.</p>
						</div>
						<div class="footer-column">
							<h4>Explore</h4>
							<a href="restaurant">Home</a><a href="restaurant#restaurants">Restaurants</a><a
								href="Cart.jsp">My Cart</a><a href="#">My Orders</a>
						</div>
						<div class="footer-column">
							<h4>Account</h4>
							<a href="#">Profile</a><a href="Login.html">Sign In</a><a
								href="Register.html">Create Account</a><a href="#">Log Out</a>
						</div>
						<div class="footer-column">
							<h4>Contact</h4>
							<span>Bengaluru, Karnataka</span><span>+91 9876543210</span><span>support@tapfoods.com</span>
						</div>
					</div>
					<div class="footer-bottom">© 2026 TapFoods. All rights
						reserved.</div>
				</footer>
			</main>
		</div>
	</div>
</body>
</html>
<%@ page language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>

<%@ page import="com.food.Model.Order"%>
<%@ page import="com.food.Model.OrderItem"%>
<%@ page import="com.food.Model.Restaurant"%>
<%@ page import="com.food.Model.Menu"%>
<%@ page import="com.food.Model.User"%>
<%@ page import="com.food.Model.Cart"%>

<%
User loggedInUser =
		(User) session.getAttribute("user");

if (loggedInUser == null) {

	response.sendRedirect(
			request.getContextPath()
			+ "/Login.jsp");

	return;
}

List<Order> orderList =
		(List<Order>) request.getAttribute("orderList");

Map<Integer, Restaurant> restaurantMap =
		(Map<Integer, Restaurant>)
		request.getAttribute("restaurantMap");

Map<Integer, List<OrderItem>> orderItemsMap =
		(Map<Integer, List<OrderItem>>)
		request.getAttribute("orderItemsMap");

Map<Integer, Menu> menuMap =
		(Map<Integer, Menu>)
		request.getAttribute("menuMap");

Cart cart =
		(Cart) session.getAttribute("cart");

int cartCount = 0;

if (cart != null &&
	cart.getItems() != null) {

	cartCount =
			cart.getItems().size();
}

int totalOrders =
		orderList != null
			? orderList.size()
			: 0;

String orderMessage =
(String) session.getAttribute("orderMessage");

String orderError =
(String) session.getAttribute("orderError");

session.removeAttribute("orderMessage");
session.removeAttribute("orderError");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
	content="width=device-width, initial-scale=1.0">

<title>TapFoods | My Orders</title>

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

	--line: rgba(255, 255, 255, 0.08);

	--text: #ffffff;
	--muted: #92929f;
	--muted-light: #b9b9c3;

	--orange: #f04a16;
	--orange-light: #ff6a2f;
	--orange-soft: rgba(240, 74, 22, 0.12);

	--green: #20bf63;
	--green-light: #31dc7b;
	--green-soft: rgba(32, 191, 99, 0.11);

	--yellow: #ffc341;
	--yellow-soft: rgba(255, 195, 65, 0.11);

	--blue: #4f8cff;
	--blue-soft: rgba(79, 140, 255, 0.11);

	--red: #ff5c5c;
	--red-soft: rgba(255, 92, 92, 0.11);

	--sidebar-width: 240px;
	--header-height: 78px;

	--radius-xl: 25px;
	--radius-lg: 19px;
	--radius-md: 14px;

}

/* =====================================================
   RESET
===================================================== */

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
input {

	font: inherit;

}

button {

	border: none;

}

img {

	display: block;
	max-width: 100%;

}

/* =====================================================
   APPLICATION LAYOUT
===================================================== */

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
			rgba(255, 255, 255, 0.018),
			transparent 55%
		),
		var(--sidebar);

}

.sidebar-top {

	flex-shrink: 0;

	padding: 22px 16px 18px;

	border-bottom: 1px solid var(--line);

	background: var(--sidebar);

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

	width:
		calc(
			100% - var(--sidebar-width)
		);

	min-height: 100vh;

	margin-left:
		var(--sidebar-width);

}

/* =====================================================
   BRAND
===================================================== */

.brand {

	width: 100%;
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

	color: #ffffff;

	font-size: 20px;

	box-shadow:
		0 11px 26px
		rgba(240, 74, 22, 0.25);

}

.brand-copy {

	min-width: 0;

	display: flex;
	flex-direction: column;

	gap: 1px;

}

.brand-name {

	display: block;

	color: #ffffff;

	font-size: 21px;
	font-weight: 800;

	line-height: 1.1;
	letter-spacing: -0.6px;

	white-space: nowrap;

}

.brand-name span {

	color: var(--orange-light);

}

.brand-caption {

	display: block;

	color: var(--muted);

	font-size: 10px;
	font-weight: 700;

	line-height: 1.2;
	letter-spacing: 1.1px;

	text-transform: uppercase;
	white-space: nowrap;

}

/* =====================================================
   SIDEBAR
===================================================== */

.sidebar-divider {

	height: 1px;

	margin: 17px 5px;

	background: var(--line);

}

.sidebar-label {

	margin: 0 10px 9px;

	color: #70707d;

	font-size: 11px;
	font-weight: 800;

	letter-spacing: 1.35px;
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

	transition:
		background 0.22s ease,
		color 0.22s ease,
		transform 0.22s ease;

}

.sidebar-link:hover {

	color: #ffffff;

	background: var(--panel-soft);

	transform: translateX(3px);

}

.sidebar-link.active {

	color: #ffffff;

	background:
		linear-gradient(
			135deg,
			var(--orange),
			var(--orange-light)
		);

	box-shadow:
		0 12px 27px
		rgba(240, 74, 22, 0.21);

}

.sidebar-icon {

	width: 25px;

	display: grid;
	place-items: center;

	font-size: 18px;

}

.sidebar-count {

	min-width: 24px;
	height: 24px;

	margin-left: auto;
	padding: 0 7px;

	display: inline-flex;
	align-items: center;
	justify-content: center;

	border-radius: 999px;

	background:
		rgba(
			255,
			255,
			255,
			0.11
		);

	font-size: 11px;
	font-weight: 800;

}

.sidebar-bottom {

	margin-top: 22px;
	padding-bottom: 7px;

}

.help-card {

	padding: 16px;

	border:
		1px solid
		rgba(32, 191, 99, 0.14);

	border-radius: 17px;

	background:
		linear-gradient(
			135deg,
			rgba(32, 191, 99, 0.085),
			rgba(32, 191, 99, 0.018)
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

	font-size: 17px;

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

/* =====================================================
   TOP HEADER
===================================================== */

.top-header {

	position: sticky;

	top: 0;

	z-index: 900;

	min-height:
		var(--header-height);

	padding: 12px 24px;

	display: flex;
	align-items: center;
	justify-content: space-between;

	gap: 18px;

	border-bottom:
		1px solid var(--line);

	background:
		rgba(
			13,
			13,
			18,
			0.93
		);

	backdrop-filter:
		blur(16px);

}

.header-left,
.header-actions {

	display: flex;
	align-items: center;

	gap: 11px;

}

.mobile-menu {

	display: none;

	width: 42px;
	height: 42px;

	border-radius: 12px;

	background: var(--panel);
	color: #ffffff;

	font-size: 18px;

	cursor: pointer;

}

.back-link {

	min-height: 43px;

	padding: 0 15px;

	display: inline-flex;
	align-items: center;

	gap: 8px;

	border:
		1px solid var(--line);

	border-radius: 13px;

	background: var(--panel);
	color: var(--muted-light);

	font-size: 13px;
	font-weight: 800;

	transition:
		transform 0.22s ease,
		background 0.22s ease,
		color 0.22s ease;

}

.back-link:hover {

	transform: translateY(-2px);

	background: var(--panel-hover);
	color: #ffffff;

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

	border:
		1px solid var(--line);

	border-radius: 13px;

	background: var(--panel);
	color: #ffffff;

	font-size: 17px;

	cursor: pointer;

	transition:
		transform 0.22s ease,
		background 0.22s ease;

}

.header-button:hover {

	transform: translateY(-2px);

	background: var(--panel-hover);

}

.notification-dot {

	position: absolute;

	top: 8px;
	right: 8px;

	width: 7px;
	height: 7px;

	border:
		2px solid var(--panel);

	border-radius: 50%;

	background: var(--orange);

}

.profile-chip {

	min-height: 47px;

	padding:
		5px 11px 5px 6px;

	display: flex;
	align-items: center;

	gap: 9px;

	border:
		1px solid var(--line);

	border-radius: 14px;

	background: var(--panel);

}

.profile-avatar {

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

/* =====================================================
   PAGE CONTENT
===================================================== */

.page-content {

	width: 100%;
	max-width: 1480px;

	margin: 0 auto;

	padding:
		18px 28px 60px;

}

/* Part 2 continues from here */

/* =====================================================
   PAGE HEADING
===================================================== */

.orders-heading {

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

.orders-heading h1 {

	font-size:
		clamp(
			2.1rem,
			3vw,
			3rem
		);

	letter-spacing: -1.4px;

}

.orders-heading p {

	margin-top: 7px;

	color: var(--muted);

	font-size: 14px;

	line-height: 1.6;

}

.orders-count-badge {

	min-height: 40px;

	padding: 0 15px;

	display: inline-flex;
	align-items: center;

	gap: 8px;

	border:
		1px solid
		rgba(32, 191, 99, 0.15);

	border-radius: 999px;

	background: var(--green-soft);
	color: var(--green);

	font-size: 12px;
	font-weight: 800;

	white-space: nowrap;

}

/* =====================================================
   ORDER STATISTICS
===================================================== */

.order-stats {

	margin-bottom: 24px;

	display: grid;

	grid-template-columns:
		repeat(
			4,
			minmax(0, 1fr)
		);

	gap: 16px;

}

.stat-card {

	min-width: 0;

	padding: 18px;

	display: flex;
	align-items: center;

	gap: 14px;

	border:
		1px solid var(--line);

	border-radius: var(--radius-lg);

	background:
		linear-gradient(
			180deg,
			rgba(255, 255, 255, 0.02),
			transparent
		),
		var(--panel);

	box-shadow:
		0 11px 27px
		rgba(0, 0, 0, 0.19);

}

.stat-icon {

	width: 46px;
	height: 46px;

	display: grid;
	place-items: center;

	flex: 0 0 46px;

	border-radius: 14px;

	font-size: 20px;

}

.stat-icon.orange {

	background: var(--orange-soft);
	color: var(--orange-light);

}

.stat-icon.green {

	background: var(--green-soft);
	color: var(--green);

}

.stat-icon.blue {

	background: var(--blue-soft);
	color: var(--blue);

}

.stat-icon.yellow {

	background: var(--yellow-soft);
	color: var(--yellow);

}

.stat-copy {

	min-width: 0;

	display: grid;

	gap: 3px;

}

.stat-copy small {

	color: var(--muted);

	font-size: 10px;
	font-weight: 800;

	letter-spacing: 0.8px;
	text-transform: uppercase;

}

.stat-copy strong {

	font-size: 23px;
	font-weight: 900;

	letter-spacing: -0.6px;

}

.stat-copy span {

	color: var(--muted-light);

	font-size: 10px;

	white-space: nowrap;

	overflow: hidden;
	text-overflow: ellipsis;

}

/* =====================================================
   FILTER TOOLBAR
===================================================== */

.orders-toolbar {

	margin-bottom: 24px;

	padding: 16px;

	display: flex;
	align-items: center;
	justify-content: space-between;

	gap: 16px;

	border:
		1px solid var(--line);

	border-radius: var(--radius-lg);

	background: var(--panel);

}

.orders-search {

	position: relative;

	width:
		min(
			460px,
			100%
		);

}

.orders-search span {

	position: absolute;

	left: 15px;
	top: 50%;

	transform:
		translateY(-50%);

	color: #747480;

	font-size: 17px;

}

.orders-search input {

	width: 100%;
	height: 48px;

	padding:
		0 16px 0 45px;

	border:
		1px solid var(--line);

	outline: none;

	border-radius: 14px;

	background: var(--panel-soft);
	color: #ffffff;

	font-size: 13px;

	transition:
		border-color 0.22s ease,
		box-shadow 0.22s ease;

}

.orders-search input::placeholder {

	color: #747480;

}

.orders-search input:focus {

	border-color: var(--orange);

	box-shadow:
		0 0 0 4px
		rgba(240, 74, 22, 0.10);

}

.filter-buttons {

	display: flex;

	gap: 9px;

	overflow-x: auto;

	scrollbar-width: none;

}

.filter-buttons::-webkit-scrollbar {

	display: none;

}

.filter-button {

	min-height: 43px;

	padding: 0 15px;

	display: inline-flex;
	align-items: center;
	justify-content: center;

	flex: 0 0 auto;

	border:
		1px solid var(--line);

	border-radius: 13px;

	background: var(--panel-soft);
	color: var(--muted-light);

	font-size: 11px;
	font-weight: 800;

	cursor: pointer;

	transition:
		background 0.22s ease,
		color 0.22s ease,
		border-color 0.22s ease,
		transform 0.22s ease;

}

.filter-button:hover {

	transform: translateY(-2px);

	background: var(--panel-hover);
	color: #ffffff;

}

.filter-button.active {

	border-color: var(--orange);

	background: var(--orange);
	color: #ffffff;

}

/* =====================================================
   ORDERS LIST
===================================================== */

.orders-list {

	display: grid;

	gap: 20px;

}

.order-card {

	min-width: 0;

	overflow: hidden;

	border:
		1px solid var(--line);

	border-radius: var(--radius-xl);

	background:
		linear-gradient(
			180deg,
			rgba(255, 255, 255, 0.02),
			transparent
		),
		var(--panel);

	box-shadow:
		0 14px 34px
		rgba(0, 0, 0, 0.23);

	transition:
		transform 0.28s ease,
		border-color 0.28s ease,
		box-shadow 0.28s ease;

}

.order-card:hover {

	transform: translateY(-4px);

	border-color:
		rgba(240, 74, 22, 0.34);

	box-shadow:
		0 21px 42px
		rgba(0, 0, 0, 0.31);

}

/* =====================================================
   ORDER HEADER
===================================================== */

.order-card-header {

	padding: 20px 22px;

	display: flex;
	align-items: center;
	justify-content: space-between;

	gap: 18px;

	border-bottom:
		1px solid var(--line);

	background:
		rgba(
			255,
			255,
			255,
			0.014
		);

}

.restaurant-summary {

	min-width: 0;

	display: flex;
	align-items: center;

	gap: 14px;

}

.restaurant-image {

	width: 62px;
	height: 62px;

	flex: 0 0 62px;

	overflow: hidden;

	border-radius: 15px;

	background: var(--panel-soft);

}

.restaurant-image img {

	width: 100%;
	height: 100%;

	object-fit: cover;

}

.restaurant-copy {

	min-width: 0;

	display: grid;

	gap: 4px;

}

.restaurant-copy h2 {

	font-size: 20px;

	letter-spacing: -0.55px;

	white-space: nowrap;

	overflow: hidden;
	text-overflow: ellipsis;

}

.restaurant-copy p {

	color: var(--muted);

	font-size: 11px;

	white-space: nowrap;

	overflow: hidden;
	text-overflow: ellipsis;

}

.restaurant-meta {

	display: flex;
	align-items: center;

	gap: 12px;

	color: var(--muted-light);

	font-size: 10px;
	font-weight: 700;

}

.restaurant-meta span {

	display: inline-flex;
	align-items: center;

	gap: 5px;

}

.order-header-right {

	display: flex;
	align-items: center;

	gap: 12px;

	flex-shrink: 0;

}

/* =====================================================
   ORDER STATUS BADGES
===================================================== */

.status-badge {

	min-height: 34px;

	padding: 0 12px;

	display: inline-flex;
	align-items: center;
	justify-content: center;

	gap: 7px;

	border-radius: 999px;

	font-size: 10px;
	font-weight: 900;

	letter-spacing: 0.7px;
	text-transform: uppercase;

}

.status-badge::before {

	content: "";

	width: 7px;
	height: 7px;

	border-radius: 50%;

}

.status-placed {

	border:
		1px solid
		rgba(79, 140, 255, 0.16);

	background: var(--blue-soft);
	color: var(--blue);

}

.status-placed::before {

	background: var(--blue);

	box-shadow:
		0 0 0 4px
		rgba(79, 140, 255, 0.12);

}

.status-preparing {

	border:
		1px solid
		rgba(255, 195, 65, 0.16);

	background: var(--yellow-soft);
	color: var(--yellow);

}

.status-preparing::before {

	background: var(--yellow);

	box-shadow:
		0 0 0 4px
		rgba(255, 195, 65, 0.12);

}

.status-delivered {

	border:
		1px solid
		rgba(32, 191, 99, 0.16);

	background: var(--green-soft);
	color: var(--green);

}

.status-delivered::before {

	background: var(--green);

	box-shadow:
		0 0 0 4px
		rgba(32, 191, 99, 0.12);

}

.status-cancelled {

	border:
		1px solid
		rgba(255, 92, 92, 0.16);

	background: var(--red-soft);
	color: var(--red);

}

.status-cancelled::before {

	background: var(--red);

	box-shadow:
		0 0 0 4px
		rgba(255, 92, 92, 0.12);

}

.order-number {

	min-height: 34px;

	padding: 0 12px;

	display: inline-flex;
	align-items: center;
	justify-content: center;

	border:
		1px solid var(--line);

	border-radius: 11px;

	background: var(--panel-soft);
	color: var(--muted-light);

	font-size: 11px;
	font-weight: 800;

}

/* =====================================================
   ORDER BODY
===================================================== */

.order-card-body {

	padding: 22px;

	display: grid;

	grid-template-columns:
		minmax(0, 1fr) 280px;

	gap: 22px;

	align-items: start;

}

.order-items-panel {

	min-width: 0;

}

.order-section-title {

	margin-bottom: 14px;

	display: flex;
	align-items: center;
	justify-content: space-between;

	gap: 14px;

}

.order-section-title h3 {

	font-size: 16px;

}

.order-section-title span {

	color: var(--muted);

	font-size: 10px;
	font-weight: 700;

}

/* =====================================================
   ORDERED ITEM ROW
===================================================== */

.ordered-items-list {

	display: grid;

	gap: 11px;

}

.ordered-item {

	padding: 11px;

	display: grid;

	grid-template-columns:
		62px minmax(0, 1fr) auto;

	align-items: center;

	gap: 12px;

	border:
		1px solid var(--line);

	border-radius: 14px;

	background: var(--panel-soft);

}

.ordered-item-image {

	width: 62px;
	height: 62px;

	overflow: hidden;

	border-radius: 12px;

	background: var(--panel-hover);

}

.ordered-item-image img {

	width: 100%;
	height: 100%;

	object-fit: cover;

}

.ordered-item-copy {

	min-width: 0;

}

.ordered-item-copy h4 {

	font-size: 14px;

	white-space: nowrap;

	overflow: hidden;
	text-overflow: ellipsis;

}

.ordered-item-copy p {

	margin-top: 5px;

	color: var(--muted);

	font-size: 10px;

	line-height: 1.5;

}

.ordered-item-price {

	color: var(--orange-light);

	font-size: 13px;
	font-weight: 900;

	white-space: nowrap;

}

/* =====================================================
   ORDER SUMMARY PANEL
===================================================== */

.order-summary-panel {

	padding: 18px;

	border:
		1px solid var(--line);

	border-radius: 17px;

	background: var(--panel-soft);

}

.order-summary-panel h3 {

	font-size: 16px;

}

.order-summary-list {

	margin-top: 16px;

	display: grid;

	gap: 13px;

}

.order-summary-row {

	display: flex;
	align-items: flex-start;
	justify-content: space-between;

	gap: 14px;

}

.order-summary-row span:first-child {

	color: var(--muted);

	font-size: 11px;
	font-weight: 700;

}

.order-summary-row span:last-child {

	max-width: 60%;

	text-align: right;

	color: #ffffff;

	font-size: 11px;
	font-weight: 800;

	line-height: 1.45;

}

.order-total {

	margin-top: 17px;
	padding-top: 17px;

	display: flex;
	align-items: flex-end;
	justify-content: space-between;

	gap: 14px;

	border-top:
		1px solid var(--line);

}

.order-total-copy {

	display: grid;

	gap: 3px;

}

.order-total-copy small {

	color: var(--muted);

	font-size: 9px;
	font-weight: 700;

	letter-spacing: 0.7px;
	text-transform: uppercase;

}

.order-total-copy span {

	color: var(--muted-light);

	font-size: 9px;

}

.order-total strong {

	color: var(--orange-light);

	font-size: 24px;
	font-weight: 900;

}

/* =====================================================
   ORDER ACTIONS
===================================================== */

.order-actions {

	margin-top: 16px;

	display: grid;

	gap: 10px;

}

.primary-order-button,
.secondary-order-button {

	min-height: 44px;

	padding: 0 15px;

	display: inline-flex;
	align-items: center;
	justify-content: center;

	gap: 8px;

	border-radius: 12px;

	font-size: 11px;
	font-weight: 900;

	transition:
		transform 0.22s ease,
		background 0.22s ease,
		box-shadow 0.22s ease;

}

.primary-order-button {

	background:
		linear-gradient(
			135deg,
			var(--green),
			var(--green-light)
		);

	color: #07140c;

	box-shadow:
		0 11px 23px
		rgba(32, 191, 99, 0.18);

}

.secondary-order-button {

	border:
		1px solid var(--line);

	background: var(--panel-hover);
	color: var(--muted-light);

}

.primary-order-button:hover,
.secondary-order-button:hover {

	transform: translateY(-2px);

}


/* =====================================================
   ORDER GROUPS
===================================================== */

.orders-group {
	margin-top: 26px;
}

.orders-group-heading {
	margin-bottom: 18px;

	display: flex;
	align-items: flex-end;
	justify-content: space-between;

	gap: 18px;
}

.orders-group-heading h2 {
	font-size: 26px;
	letter-spacing: -0.8px;
}

.orders-group-heading p {
	margin-top: 6px;

	color: var(--muted);
	font-size: 13px;
	line-height: 1.6;
}

.cancelled-orders-group {
	margin-top: 38px;
	padding-top: 28px;

	border-top: 1px solid var(--line);
}

.cancelled-kicker {
	color: var(--red);
}

.cancelled-count {
	min-height: 38px;
	padding: 0 14px;

	display: inline-flex;
	align-items: center;

	border: 1px solid rgba(255, 92, 92, 0.18);
	border-radius: 999px;

	background: var(--red-soft);
	color: var(--red);

	font-size: 11px;
	font-weight: 800;
	white-space: nowrap;
}

.cancelled-orders-group .order-card {
	border-color: rgba(255, 92, 92, 0.16);
}

.cancelled-orders-group .order-card:hover {
	border-color: rgba(255, 92, 92, 0.38);
}

/* =====================================================
   ORDER MESSAGES
===================================================== */

.order-message {
	margin-bottom: 20px;
	padding: 14px 16px;

	display: flex;
	align-items: center;
	gap: 9px;

	border-radius: 13px;

	font-size: 13px;
	font-weight: 800;
	line-height: 1.5;
}

.order-message.success {
	border: 1px solid rgba(32, 191, 99, 0.18);
	background: rgba(32, 191, 99, 0.10);
	color: var(--green-light);
}

.order-message.error {
	border: 1px solid rgba(255, 92, 92, 0.18);
	background: rgba(255, 92, 92, 0.10);
	color: #ff8b8b;
}

/* =====================================================
   CANCEL ORDER BUTTON
===================================================== */

.cancel-order-form {
	width: 100%;
}

.cancel-order-button {
	width: 100%;
	min-height: 44px;
	padding: 0 15px;

	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 8px;

	border: 1px solid rgba(255, 92, 92, 0.20);
	border-radius: 12px;

	background: var(--red-soft);
	color: #ff8585;

	font-size: 11px;
	font-weight: 900;

	cursor: pointer;

	transition:
		transform 0.22s ease,
		background 0.22s ease,
		color 0.22s ease,
		box-shadow 0.22s ease;
}

.cancel-order-button:hover {
	transform: translateY(-2px);
	background: var(--red);
	color: #ffffff;
	box-shadow: 0 10px 22px rgba(255, 92, 92, 0.20);
}

/* =====================================================
   RESPONSIVE DESIGN
===================================================== */

@media (max-width: 1200px) {

	:root {

		--sidebar-width: 220px;

	}

	.order-stats {

		grid-template-columns:
			repeat(
				2,
				minmax(0, 1fr)
			);

	}

	.order-card-body {

		grid-template-columns:
			minmax(0, 1fr) 250px;

	}

}

@media (max-width: 980px) {

	.orders-toolbar {

		align-items: stretch;
		flex-direction: column;

	}

	.orders-search {

		width: 100%;

	}

	.order-card-body {

		grid-template-columns: 1fr;

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

	.mobile-menu {

		display: grid;
		place-items: center;

	}

	.back-link {

		display: none;

	}

}

@media (max-width: 650px) {

	.orders-group-heading {
		align-items: flex-start;
		flex-direction: column;
	}


	.top-header {

		min-height: 70px;

		padding:
			10px 13px;

	}

	.header-title,
	.profile-copy {

		display: none;

	}

	.page-content {

		padding:
			14px 13px 50px;

	}

	.orders-heading {

		align-items: flex-start;
		flex-direction: column;

	}

	.order-stats {

		grid-template-columns: 1fr;

	}

	.order-card-header {

		align-items: flex-start;
		flex-direction: column;

	}

	.order-header-right {

		width: 100%;

		justify-content: space-between;

	}

	.order-card-body {

		padding: 15px;

	}

	.ordered-item {

		grid-template-columns:
			55px minmax(0, 1fr);

	}

	.ordered-item-image {

		width: 55px;
		height: 55px;

	}

	.ordered-item-price {

		grid-column: 2;

		justify-self: start;

	}

}

/* Part 3 continues from here */

</style>

</head>

<body>

<div class="app-shell">

	<!-- =====================================================
	     SIDEBAR
	===================================================== -->

	<aside class="sidebar">

		<div class="sidebar-top">

			<a href="restaurant" class="brand">

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
					class="sidebar-link active">

					<span class="sidebar-icon">
						📦
					</span>

					<span>
						My Orders
					</span>

					<span class="sidebar-count">
						<%=totalOrders%>
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
					class="sidebar-link">

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

			<div class="sidebar-bottom">

				<div class="help-card">

					<div class="help-icon">
						?
					</div>

					<h4>
						Need assistance?
					</h4>

					<p>
						Our support team is ready to help with your orders.
					</p>

					<a href="#">
						Contact support →
					</a>

				</div>

			</div>

		</div>

	</aside>

	<!-- =====================================================
	     MAIN AREA
	===================================================== -->

	<div class="main-area">

		<header class="top-header">

			<div class="header-left">

				<button
					type="button"
					class="mobile-menu">

					☰

				</button>

				<a
					href="restaurant"
					class="back-link">

					<span>
						←
					</span>

					Continue Shopping

				</a>

				<div class="header-title">

					<small>
						Order history
					</small>

					<strong>
						Track all your orders
					</strong>

				</div>

			</div>

			<div class="header-actions">

				<a
					href="Cart.jsp"
					class="header-button"
					aria-label="Open cart">

					🛒

				</a>

				<button
					type="button"
					class="header-button"
					aria-label="Notifications">

					🔔

					<span class="notification-dot"></span>

				</button>

				<a
					href="<%=request.getContextPath()%>/ProfileServlet"
					class="profile-chip">

					<span class="profile-avatar">

						<%
						String userName =
								loggedInUser.getUserName();

						String initials = "TF";

						if (userName != null &&
							!userName.trim().isEmpty()) {

							String[] nameParts =
									userName.trim().split("\\s+");

							if (nameParts.length == 1) {

								initials =
										nameParts[0]
										.substring(
											0,
											Math.min(
												2,
												nameParts[0].length()
											)
										)
										.toUpperCase();
							}
							else {

								initials =
										(
											nameParts[0].substring(0, 1)
											+
											nameParts[
												nameParts.length - 1
											].substring(0, 1)
										)
										.toUpperCase();
							}
						}
						%>

						<%=initials%>

					</span>

					<span class="profile-copy">

						<strong>
							<%=loggedInUser.getUserName()%>
						</strong>

						<small>
							Customer account
						</small>

					</span>

				</a>

			</div>

		</header>

		<main class="page-content">

			<!-- =====================================================
			     PAGE HEADING
			===================================================== -->

			<section class="orders-heading">

				<div>

					<p class="section-kicker">
						My orders
					</p>

					<h1>
						Order History
					</h1>

					<p>
						Review your previous orders, payment details and delivery status.
					</p>

				</div>

				<div class="orders-count-badge">

					<span>
						📦
					</span>

					<%=totalOrders%>
					<%=totalOrders == 1 ? "Order" : "Orders"%>

				</div>

			</section>

			<%
			if (orderMessage != null && !orderMessage.trim().isEmpty()) {
			%>

			<div class="order-message success">
				<span>✓</span>
				<span><%=orderMessage%></span>
			</div>

			<%
			}

			if (orderError != null && !orderError.trim().isEmpty()) {
			%>

			<div class="order-message error">
				<span>⚠</span>
				<span><%=orderError%></span>
			</div>

			<%
			}
			%>

			<!-- =====================================================
			     STATISTICS
			===================================================== -->

			<%
			int placedCount = 0;
			int preparingCount = 0;
			int deliveredCount = 0;
			int cancelledCount = 0;

			if (orderList != null) {

				for (Order order : orderList) {

					String status =
							order.getStatus() != null
								? order.getStatus().trim().toUpperCase()
								: "";

					if ("PLACED".equals(status)) {

						placedCount++;

					}
					else if ("PREPARING".equals(status)) {

						preparingCount++;

					}
					else if ("DELIVERED".equals(status)) {

						deliveredCount++;

					}
					else if ("CANCELLED".equals(status)) {

						cancelledCount++;
					}
				}
			}
			%>

			<section class="order-stats">

				<div class="stat-card">

					<div class="stat-icon orange">
						📦
					</div>

					<div class="stat-copy">

						<small>
							Total Orders
						</small>

						<strong>
							<%=totalOrders%>
						</strong>

						<span>
							All orders placed
						</span>

					</div>

				</div>

				<div class="stat-card">

					<div class="stat-icon blue">
						✓
					</div>

					<div class="stat-copy">

						<small>
							Placed
						</small>

						<strong>
							<%=placedCount%>
						</strong>

						<span>
							Confirmed orders
						</span>

					</div>

				</div>

				<div class="stat-card">

					<div class="stat-icon yellow">
						🍳
					</div>

					<div class="stat-copy">

						<small>
							Preparing
						</small>

						<strong>
							<%=preparingCount%>
						</strong>

						<span>
							Being prepared
						</span>

					</div>

				</div>

				<div class="stat-card">

					<div class="stat-icon green">
						🛵
					</div>

					<div class="stat-copy">

						<small>
							Delivered
						</small>

						<strong>
							<%=deliveredCount%>
						</strong>

						<span>
							Successfully delivered
						</span>

					</div>

				</div>

			</section>

			<!-- =====================================================
			     FILTER TOOLBAR
			===================================================== -->

			<section class="orders-toolbar">

				<div class="orders-search">

					<span>
						⌕
					</span>

					<input
						type="text"
						id="orderSearch"
						placeholder="Search by restaurant or order ID">

				</div>

				<div class="filter-buttons">

					<button
						type="button"
						class="filter-button active"
						data-status="ALL">

						All

					</button>

					<button
						type="button"
						class="filter-button"
						data-status="PLACED">

						Placed

					</button>

					<button
						type="button"
						class="filter-button"
						data-status="PREPARING">

						Preparing

					</button>

					<button
						type="button"
						class="filter-button"
						data-status="DELIVERED">

						Delivered

					</button>

					<button
						type="button"
						class="filter-button"
						data-status="CANCELLED">

						Cancelled

					</button>

				</div>

			</section>

			<!-- =====================================================
			     DYNAMIC ORDERS
			===================================================== -->

			<section class="orders-group" id="activeOrdersGroup">

				<div class="orders-group-heading">
					<div>
						<p class="section-kicker">Current and completed</p>
						<h2>Active Orders</h2>
						<p>Placed, preparing and delivered orders are shown here.</p>
					</div>
				</div>

				<div
					class="orders-list"
					id="activeOrdersList">

				<%
				if (orderList != null &&
					!orderList.isEmpty()) {

					for (Order order : orderList) {

						Restaurant restaurant =
								restaurantMap != null
									? restaurantMap.get(
											order.getRestaurantID()
										)
									: null;

						List<OrderItem> orderItems =
								orderItemsMap != null
									? orderItemsMap.get(
											order.getOrderID()
										)
									: null;

						String restaurantName =
								restaurant != null &&
								restaurant.getName() != null
									? restaurant.getName()
									: "TapFoods Restaurant";

						String restaurantCuisine =
								restaurant != null &&
								restaurant.getCuisineType() != null
									? restaurant.getCuisineType()
									: "Multi-cuisine";

						String restaurantImage =
								restaurant != null &&
								restaurant.getImagePath() != null &&
								!restaurant.getImagePath().trim().isEmpty()
									? restaurant.getImagePath()
									: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=900&q=85";

						String orderStatus =
								order.getStatus() != null
									? order.getStatus()
											.trim()
											.toUpperCase()
									: "PLACED";

						String statusClass =
								"status-placed";

						if ("PREPARING".equals(orderStatus)) {

							statusClass =
									"status-preparing";

						}
						else if ("DELIVERED".equals(orderStatus)) {

							statusClass =
									"status-delivered";

						}
						else if ("CANCELLED".equals(orderStatus)) {

							statusClass =
									"status-cancelled";
						}

						String orderDateText =
								order.getOrderDate() != null
									? new java.text.SimpleDateFormat(
											"dd MMM yyyy, hh:mm a"
										)
										.format(
											order.getOrderDate()
										)
									: "Date not available";

						int orderedItemsCount =
								orderItems != null
									? orderItems.size()
									: 0;

						String searchableText =
								(
									restaurantName
									+ " "
									+ order.getOrderID()
									+ " "
									+ orderStatus
								)
								.toLowerCase();
				%>

				<article
					class="order-card"
					data-status="<%=orderStatus%>"
					data-search="<%=searchableText%>">

					<div class="order-card-header">

						<div class="restaurant-summary">

							<div class="restaurant-image">

								<img
									src="<%=restaurantImage%>"
									alt="<%=restaurantName%>">

							</div>

							<div class="restaurant-copy">

								<h2>
									<%=restaurantName%>
								</h2>

								<p>
									<%=restaurantCuisine%>
								</p>

								<div class="restaurant-meta">

									<span>
										📅
										<%=orderDateText%>
									</span>

									<span>
										🍽
										<%=orderedItemsCount%>
										<%=orderedItemsCount == 1 ? "item" : "items"%>
									</span>

								</div>

							</div>

						</div>

						<div class="order-header-right">

							<span
								class="status-badge <%=statusClass%>">

								<%=orderStatus%>

							</span>

							<span class="order-number">

								#<%=order.getOrderID()%>

							</span>

						</div>

					</div>

					<div class="order-card-body">

						<div class="order-items-panel">

							<div class="order-section-title">

								<h3>
									Ordered Items
								</h3>

								<span>
									<%=orderedItemsCount%>
									<%=orderedItemsCount == 1 ? "dish" : "dishes"%>
								</span>

							</div>

							<div class="ordered-items-list">

								<%
								if (orderItems != null &&
									!orderItems.isEmpty()) {

									for (OrderItem orderItem :
											orderItems) {

										Menu menu =
												menuMap != null
													? menuMap.get(
															orderItem.getMenuID()
														)
													: null;

										String itemName =
												menu != null &&
												menu.getItemName() != null
													? menu.getItemName()
													: "Menu Item";

										String itemDescription =
												menu != null &&
												menu.getDescription() != null
													? menu.getDescription()
													: "Freshly prepared food item.";

										String itemImage =
												menu != null &&
												menu.getImagePath() != null &&
												!menu.getImagePath()
													.trim()
													.isEmpty()
													? menu.getImagePath()
													: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=700&q=80";
								%>

								<div class="ordered-item">

									<div class="ordered-item-image">

										<img
											src="<%=itemImage%>"
											alt="<%=itemName%>">

									</div>

									<div class="ordered-item-copy">

										<h4>
											<%=itemName%>
										</h4>

										<p>
											Quantity:
											<%=orderItem.getQuantity()%>
											&nbsp;•&nbsp;
											<%=itemDescription%>
										</p>

									</div>

									<div class="ordered-item-price">

										₹<%=String.format(
											"%.2f",
											orderItem.getItemTotal()
										)%>

									</div>

								</div>

								<%
									}
								}
								else {
								%>

								<div class="ordered-item">

									<div class="ordered-item-image">

										<img
											src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=700&q=80"
											alt="Order item">

									</div>

									<div class="ordered-item-copy">

										<h4>
											Order details unavailable
										</h4>

										<p>
											The order was saved, but no item details were found.
										</p>

									</div>

								</div>

								<%
								}
								%>

							</div>

						</div>

						<div class="order-summary-panel">

							<h3>
								Order Summary
							</h3>

							<div class="order-summary-list">

								<div class="order-summary-row">

									<span>
										Order ID
									</span>

									<span>
										#<%=order.getOrderID()%>
									</span>

								</div>

								<div class="order-summary-row">

									<span>
										Payment
									</span>

									<span>
										<%=order.getPaymentMethod()%>
									</span>

								</div>

								<div class="order-summary-row">

									<span>
										Status
									</span>

									<span>
										<%=orderStatus%>
									</span>

								</div>

								<div class="order-summary-row">

									<span>
										Delivery
									</span>

									<span>
										<%
										if ("DELIVERED".equals(orderStatus)) {
										%>
											Delivered
										<%
										}
										else if ("CANCELLED".equals(orderStatus)) {
										%>
											Cancelled
										<%
										}
										else {
										%>
											30–40 mins
										<%
										}
										%>
									</span>

								</div>

							</div>

							<div class="order-total">

								<div class="order-total-copy">

									<small>
										Grand Total
									</small>

									<span>
										Inclusive of charges
									</span>

								</div>

								<strong>

									₹<%=String.format(
										"%.2f",
										order.getTotalAmount()
									)%>

								</strong>

							</div>

							<div class="order-actions">

								<a
									href="restaurant"
									class="primary-order-button">

									Order Again

									<span>
										→
									</span>

								</a>

								<a
									href="#"
									class="secondary-order-button">

									View Details

								</a>

								<%
								if ("PLACED".equals(orderStatus)
										|| "PENDING".equals(orderStatus)) {
								%>

								<form
									action="<%=request.getContextPath()%>/CancelOrderServlet"
									method="post"
									class="cancel-order-form"
									onsubmit="return confirm('Are you sure you want to cancel this order?');">

									<input
										type="hidden"
										name="orderId"
										value="<%=order.getOrderID()%>">

									<button
										type="submit"
										class="cancel-order-button">

										<span>✕</span>
										Cancel Order

									</button>

								</form>

								<%
								}
								%>

							</div>

						</div>

					</div>

				</article>

				<%
					}
				}
				%>

				</div>

			</section>

			<section
				class="orders-group cancelled-orders-group"
				id="cancelledOrdersGroup">

				<div class="orders-group-heading">

					<div>
						<p class="section-kicker cancelled-kicker">Cancelled</p>
						<h2>Cancelled Orders</h2>
						<p>Orders cancelled before preparation are shown separately.</p>
					</div>

					<span
						class="cancelled-count"
						id="cancelledCount">

						0 cancelled orders

					</span>

				</div>

				<div
					class="orders-list"
					id="cancelledOrdersList">
				</div>

			</section>

			<!-- Part 4 continues from here -->
			
						<%
			if (orderList == null || orderList.isEmpty()) {
			%>

			<section class="empty-orders">

				<div class="empty-orders-icon">
					📦
				</div>

				<h2>
					No orders yet
				</h2>

				<p>
					You have not placed any orders yet. Browse restaurants,
					choose your favourite dishes and place your first order.
				</p>

				<a
					href="restaurant"
					class="empty-orders-button">

					Browse Restaurants

					<span>→</span>

				</a>

			</section>

			<%
			}
			%>

			<section
				id="filteredEmptyState"
				class="empty-orders filtered-empty"
				style="display:none;">

				<div class="empty-orders-icon">
					⌕
				</div>

				<h2>
					No matching orders
				</h2>

				<p>
					Try another search term or choose a different order status.
				</p>

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

						<a href="<%=request.getContextPath()%>/Login.jsp">
							Sign In
						</a>

						<a href="<%=request.getContextPath()%>/Register.jsp">
							Create Account
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

					<span>
						© 2026 TapFoods. All rights reserved.
					</span>

				</div>

			</footer>

		</main>

	</div>

</div>

<style>

/* =====================================================
   EMPTY ORDERS
===================================================== */

.empty-orders {

	min-height: 390px;

	padding: 55px 28px;

	display: grid;
	place-items: center;

	align-content: center;

	text-align: center;

	border:
		1px solid var(--line);

	border-radius: var(--radius-xl);

	background:
		linear-gradient(
			180deg,
			rgba(255, 255, 255, 0.018),
			transparent
		),
		var(--panel);

	box-shadow:
		0 16px 36px
		rgba(0, 0, 0, 0.24);

}

.empty-orders-icon {

	width: 88px;
	height: 88px;

	display: grid;
	place-items: center;

	border-radius: 25px;

	background: var(--orange-soft);
	color: var(--orange-light);

	font-size: 39px;

	box-shadow:
		0 16px 32px
		rgba(240, 74, 22, 0.11);

}

.empty-orders h2 {

	margin-top: 21px;

	font-size: 29px;
	font-weight: 900;

	letter-spacing: -0.9px;

}

.empty-orders p {

	max-width: 540px;

	margin-top: 10px;

	color: var(--muted);

	font-size: 13px;
	line-height: 1.7;

}

.empty-orders-button {

	min-height: 49px;

	margin-top: 22px;
	padding: 0 20px;

	display: inline-flex;
	align-items: center;
	justify-content: center;

	gap: 8px;

	border-radius: 13px;

	background:
		linear-gradient(
			135deg,
			var(--orange),
			var(--orange-light)
		);

	color: #ffffff;

	font-size: 13px;
	font-weight: 900;

	box-shadow:
		0 13px 28px
		rgba(240, 74, 22, 0.20);

	transition:
		transform 0.22s ease,
		box-shadow 0.22s ease;

}

.empty-orders-button:hover {

	transform: translateY(-3px);

	box-shadow:
		0 18px 34px
		rgba(240, 74, 22, 0.29);

}

.filtered-empty {

	margin-top: 20px;

	min-height: 320px;

}

/* =====================================================
   FOOTER
===================================================== */

.footer {

	margin-top: 50px;
	padding-top: 28px;

	border-top:
		1px solid var(--line);

}

.footer-main {

	padding-bottom: 28px;

	display: grid;

	grid-template-columns:
		1.3fr repeat(3, 0.7fr);

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

	margin-bottom: 5px;

	font-size: 14px;

}

.footer-column a,
.footer-column span {

	color: var(--muted);

	font-size: 12px;
	line-height: 1.55;

}

.footer-column a:hover {

	color: var(--orange-light);

}

.footer-bottom {

	min-height: 62px;

	display: flex;
	align-items: center;
	justify-content: space-between;

	gap: 20px;

	border-top:
		1px solid var(--line);

	color: #70707b;

	font-size: 11px;

}

@media (max-width: 1200px) {

	.footer-main {

		grid-template-columns:
			1.2fr repeat(2, 0.8fr);

	}

	.footer-column:last-child {

		display: none;

	}

}

@media (max-width: 650px) {

	.empty-orders {

		min-height: 330px;

		padding: 42px 20px;

	}

	.empty-orders h2 {

		font-size: 25px;

	}

	.footer-main {

		grid-template-columns: 1fr 1fr;

	}

	.footer-brand {

		grid-column: 1 / -1;

	}

	.footer-bottom {

		padding: 17px 0;

		align-items: flex-start;
		flex-direction: column;

	}

}

</style>

<script>

const orderSearch =
	document.getElementById("orderSearch");

const orderCards =
	Array.from(
		document.querySelectorAll(".order-card")
	);

const filterButtons =
	Array.from(
		document.querySelectorAll(".filter-button")
	);

const activeOrdersGroup =
	document.getElementById("activeOrdersGroup");

const activeOrdersList =
	document.getElementById("activeOrdersList");

const cancelledOrdersGroup =
	document.getElementById("cancelledOrdersGroup");

const cancelledOrdersList =
	document.getElementById("cancelledOrdersList");

const cancelledCount =
	document.getElementById("cancelledCount");

const filteredEmptyState =
	document.getElementById("filteredEmptyState");

let selectedStatus = "ALL";

function separateOrders() {

	let cancelledTotal = 0;

	orderCards.forEach(function(card) {

		const status =
			card.dataset.status
				? card.dataset.status.toUpperCase()
				: "";

		if (status === "CANCELLED") {

			cancelledOrdersList.appendChild(card);
			cancelledTotal++;

		}
		else {

			activeOrdersList.appendChild(card);
		}
	});

	if (cancelledCount) {

		cancelledCount.textContent =
			cancelledTotal
			+ (
				cancelledTotal === 1
					? " cancelled order"
					: " cancelled orders"
			);
	}

	if (cancelledOrdersGroup) {

		cancelledOrdersGroup.style.display =
			cancelledTotal > 0
				? "block"
				: "none";
	}
}

function filterOrders() {

	const searchValue =
		orderSearch
			? orderSearch.value.trim().toLowerCase()
			: "";

	let visibleCount = 0;
	let visibleActiveCount = 0;
	let visibleCancelledCount = 0;

	orderCards.forEach(function(card) {

		const cardSearch =
			card.dataset.search
				? card.dataset.search.toLowerCase()
				: "";

		const cardStatus =
			card.dataset.status
				? card.dataset.status.toUpperCase()
				: "";

		const matchesSearch =
			cardSearch.includes(searchValue);

		const matchesStatus =
			selectedStatus === "ALL"
			|| cardStatus === selectedStatus;

		const shouldShow =
			matchesSearch && matchesStatus;

		card.style.display =
			shouldShow ? "" : "none";

		if (shouldShow) {

			visibleCount++;

			if (cardStatus === "CANCELLED") {
				visibleCancelledCount++;
			}
			else {
				visibleActiveCount++;
			}
		}
	});

	if (activeOrdersGroup) {

		activeOrdersGroup.style.display =
			visibleActiveCount > 0
				? "block"
				: "none";
	}

	if (cancelledOrdersGroup) {

		cancelledOrdersGroup.style.display =
			visibleCancelledCount > 0
				? "block"
				: "none";
	}

	if (filteredEmptyState) {

		filteredEmptyState.style.display =
			visibleCount === 0
			&& orderCards.length > 0
				? "grid"
				: "none";
	}
}

if (orderSearch) {

	orderSearch.addEventListener(
		"input",
		filterOrders
	);
}

filterButtons.forEach(function(button) {

	button.addEventListener(
		"click",
		function() {

			filterButtons.forEach(
				function(item) {

					item.classList.remove(
						"active"
					);
				}
			);

			button.classList.add(
				"active"
			);

			selectedStatus =
				button.dataset.status
					? button.dataset.status.toUpperCase()
					: "ALL";

			filterOrders();
		}
	);
});

separateOrders();
filterOrders();

</script>

</body>

</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.food.Model.Cart"%>
<%@ page import="com.food.Model.CartItem"%>
<%@ page import="com.food.Model.Menu"%>
<%@ page import="com.food.Model.User"%>
<%@ page import="com.food.DAOImpl.MenuDAOImpl"%>
<%@ page import="java.util.Map"%>

<%
Cart cart = (Cart) session.getAttribute("cart");

Integer restaurantObject =
	(Integer) session.getAttribute("restaurantId");

int restaurantId =
	restaurantObject != null ? restaurantObject : 0;

int cartCount = 0;

if (cart != null && cart.getItems() != null) {
	cartCount = cart.getItems().size();
}

User loggedInUser = (User) session.getAttribute("user");

String displayName = "TapFoods User";
String initials = "TF";

if (loggedInUser != null
		&& loggedInUser.getUserName() != null
		&& !loggedInUser.getUserName().trim().isEmpty()) {

	displayName = loggedInUser.getUserName().trim();

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
}

double subtotal = 0.0;

MenuDAOImpl menuDAOImpl =
	new MenuDAOImpl();
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>TapFoods | My Cart</title>

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
	--red: #ff5c5c;
	--red-light: #ff7878;
	--red-soft: rgba(255, 92, 92, 0.11);
	--yellow: #ffc341;
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

button, input {
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
	background: linear-gradient(180deg, rgba(255, 255, 255, 0.018),
		transparent 55%), var(--sidebar);
}

/* Fixed logo area */
.sidebar-top {
	flex-shrink: 0;
	padding: 22px 16px 18px;
	border-bottom: 1px solid var(--line);
	background: linear-gradient(180deg, rgba(255, 255, 255, 0.018),
		transparent), var(--sidebar);
}

/* Only menu area scrolls */
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

.sidebar-scroll::-webkit-scrollbar-track {
	background: transparent;
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
	background: linear-gradient(135deg, var(--orange), var(--orange-light));
	color: #ffffff;
	font-size: 20px;
	box-shadow: 0 11px 26px rgba(240, 74, 22, 0.25);
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
   SIDEBAR MENU
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
	transition: background 0.22s ease, color 0.22s ease, transform 0.22s
		ease;
}

.sidebar-link:hover {
	color: #ffffff;
	background: var(--panel-soft);
	transform: translateX(3px);
}

.sidebar-link.active {
	color: #ffffff;
	background: linear-gradient(135deg, var(--orange), var(--orange-light));
	box-shadow: 0 12px 27px rgba(240, 74, 22, 0.21);
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
	background: rgba(255, 255, 255, 0.11);
	font-size: 11px;
	font-weight: 800;
}

.sidebar-bottom {
	margin-top: 22px;
	padding-bottom: 7px;
}

.help-card {
	padding: 16px;
	border: 1px solid rgba(32, 191, 99, 0.14);
	border-radius: 17px;
	background: linear-gradient(135deg, rgba(32, 191, 99, 0.085),
		rgba(32, 191, 99, 0.018));
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
	min-height: var(--header-height);
	padding: 12px 24px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 18px;
	border-bottom: 1px solid var(--line);
	background: rgba(13, 13, 18, 0.93);
	backdrop-filter: blur(16px);
}

.header-left, .header-actions {
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
	border: 1px solid var(--line);
	border-radius: 13px;
	background: var(--panel);
	color: var(--muted-light);
	font-size: 13px;
	font-weight: 800;
	transition: transform 0.22s ease, background 0.22s ease, color 0.22s
		ease;
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
	border: 1px solid var(--line);
	border-radius: 13px;
	background: var(--panel);
	color: #ffffff;
	font-size: 17px;
	cursor: pointer;
	transition: transform 0.22s ease, background 0.22s ease;
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
	border: 2px solid var(--panel);
	border-radius: 50%;
	background: var(--orange);
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

/* =====================================================
   PAGE CONTENT
===================================================== */
.page-content {
	padding: 18px 36px 60px;
}

/* =====================================================
   CART HERO
===================================================== */
.cart-hero {
	position: relative;
	min-height: 255px;
	padding: 35px 40px;
	display: grid;
	grid-template-columns: 1.2fr 0.8fr;
	align-items: center;
	gap: 25px;
	overflow: hidden;
	border-radius: var(--radius-xl);
	background: linear-gradient(135deg, var(--orange), var(--orange-light));
	box-shadow: 0 22px 48px rgba(240, 74, 22, 0.17);
}

.cart-hero::before {
	content: "";
	position: absolute;
	left: -95px;
	bottom: -185px;
	width: 340px;
	height: 340px;
	border-radius: 50%;
	background: rgba(255, 255, 255, 0.08);
}

.cart-hero::after {
	content: "";
	position: absolute;
	top: -180px;
	right: 22%;
	width: 340px;
	height: 340px;
	border-radius: 50%;
	background: rgba(255, 255, 255, 0.05);
}

.cart-hero-content, .cart-hero-visual {
	position: relative;
	z-index: 2;
}

.cart-hero-tag {
	width: max-content;
	margin-bottom: 14px;
	padding: 9px 13px;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	border: 1px solid rgba(255, 255, 255, 0.2);
	border-radius: 999px;
	background: rgba(255, 255, 255, 0.11);
	font-size: 12px;
	font-weight: 800;
}

.cart-hero-tag-dot {
	width: 8px;
	height: 8px;
	border-radius: 50%;
	background: var(--green-light);
	box-shadow: 0 0 0 5px rgba(49, 220, 123, 0.16);
}

.cart-hero h1 {
	max-width: 720px;
	font-size: clamp(2.8rem, 4.4vw, 4.8rem);
	line-height: 0.99;
	letter-spacing: -3.5px;
}

.cart-hero h1 span {
	color: #202029;
}

.cart-hero p {
	max-width: 620px;
	margin-top: 17px;
	color: rgba(255, 255, 255, 0.84);
	font-size: 15px;
	line-height: 1.7;
}

.cart-hero-stats {
	margin-top: 22px;
	display: flex;
	gap: 27px;
	flex-wrap: wrap;
}

.cart-hero-stat {
	display: grid;
	gap: 3px;
}

.cart-hero-stat strong {
	font-size: 20px;
}

.cart-hero-stat span {
	color: rgba(255, 255, 255, 0.74);
	font-size: 11px;
	font-weight: 700;
}

.cart-hero-visual {
	min-height: 190px;
	display: grid;
	place-items: center;
}

.cart-illustration {
	position: relative;
	width: min(230px, 85%);
	aspect-ratio: 1;
	display: grid;
	place-items: center;
	border-radius: 50%;
	background: rgba(255, 255, 255, 0.13);
	box-shadow: inset 0 0 0 19px rgba(255, 255, 255, 0.04);
}

.cart-illustration span {
	font-size: 92px;
	filter: drop-shadow(0 20px 25px rgba(0, 0, 0, 0.28));
}

/* Part 2 continues from here */

/* =====================================================
   CART PAGE LAYOUT
===================================================== */
.cart-section {
	margin-top: 0;
}

.cart-section-heading {
	margin-bottom: 21px;
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

.cart-section-heading h2 {
	font-size: clamp(2rem, 3vw, 2.75rem);
	letter-spacing: -1.2px;
}

.cart-section-heading p {
	margin-top: 7px;
	color: var(--muted);
	font-size: 14px;
}

.cart-items-count {
	color: var(--green);
	font-size: 13px;
	font-weight: 800;
}

.cart-layout {
	display: grid;
	grid-template-columns: minmax(0, 1fr) 390px;
	align-items: start;
	gap: 24px;
}

/* =====================================================
   CART ITEMS COLUMN
===================================================== */
.cart-items {
	display: grid;
	gap: 17px;
}

.cart-item {
	position: relative;
	min-width: 0;
	padding: 17px;
	display: grid;
	grid-template-columns: 165px minmax(0, 1fr);
	gap: 19px;
	overflow: hidden;
	border: 1px solid var(--line);
	border-radius: var(--radius-lg);
	background: linear-gradient(180deg, rgba(255, 255, 255, 0.018),
		transparent), var(--panel);
	box-shadow: 0 11px 27px rgba(0, 0, 0, 0.2);
	transition: transform 0.28s ease, border-color 0.28s ease, box-shadow
		0.28s ease;
}

.cart-item:hover {
	transform: translateY(-4px);
	border-color: rgba(240, 74, 22, 0.36);
	box-shadow: 0 19px 36px rgba(0, 0, 0, 0.3);
}

.cart-image-wrap {
	position: relative;
	width: 100%;
	height: 150px;
	overflow: hidden;
	border-radius: 15px;
	background: var(--panel-soft);
}

.cart-image-wrap::after {
	content: "";
	position: absolute;
	inset: 0;
	background: linear-gradient(180deg, transparent 45%, rgba(13, 13, 18, 0.62));
	pointer-events: none;
}

.cart-image {
	width: 100%;
	height: 100%;
	object-fit: cover;
	transition: transform 0.5s ease;
}

.cart-item:hover .cart-image {
	transform: scale(1.055);
}

.item-badge {
	position: absolute;
	left: 10px;
	bottom: 10px;
	z-index: 3;
	min-height: 28px;
	padding: 0 10px;
	display: inline-flex;
	align-items: center;
	gap: 6px;
	border: 1px solid rgba(255, 255, 255, 0.08);
	border-radius: 999px;
	background: rgba(18, 18, 25, 0.88);
	backdrop-filter: blur(10px);
	color: #ffffff;
	font-size: 9px;
	font-weight: 800;
	letter-spacing: 0.6px;
	text-transform: uppercase;
}

.item-badge::before {
	content: "";
	width: 7px;
	height: 7px;
	border-radius: 50%;
	background: var(--green);
	box-shadow: 0 0 0 4px rgba(32, 191, 99, 0.13);
}

/* =====================================================
   CART ITEM DETAILS
===================================================== */
.cart-item-content {
	min-width: 0;
	display: flex;
	flex-direction: column;
}

.item-top {
	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	gap: 15px;
}

.item-label {
	margin-bottom: 7px;
	color: var(--orange-light);
	font-size: 10px;
	font-weight: 800;
	letter-spacing: 1px;
	text-transform: uppercase;
}

.item-name {
	font-size: 23px;
	line-height: 1.2;
	letter-spacing: -0.65px;
}

.item-unit-price {
	flex-shrink: 0;
	color: var(--orange-light);
	font-size: 20px;
	font-weight: 800;
}

.item-description {
	max-width: 610px;
	margin-top: 9px;
	color: var(--muted);
	font-size: 12px;
	line-height: 1.6;
}

.item-actions {
	margin-top: auto;
	padding-top: 15px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 14px;
	border-top: 1px solid var(--line);
}

.item-left-actions {
	display: flex;
	align-items: center;
	gap: 13px;
}

/* =====================================================
   QUANTITY CONTROL
===================================================== */
.quantity-control {
	min-height: 42px;
	padding: 4px;
	display: inline-flex;
	align-items: center;
	gap: 3px;
	border: 1px solid var(--line);
	border-radius: 13px;
	background: var(--panel-soft);
}

.quantity-control form {
	display: inline-flex;
}

.quantity-button {
	width: 34px;
	height: 34px;
	display: grid;
	place-items: center;
	border-radius: 10px;
	background: transparent;
	color: #ffffff;
	font-size: 19px;
	font-weight: 700;
	cursor: pointer;
	transition: background 0.22s ease, color 0.22s ease, transform 0.22s
		ease;
}

.quantity-button:hover {
	background: var(--orange);
	color: #ffffff;
	transform: scale(1.04);
}

.quantity-value {
	min-width: 37px;
	text-align: center;
	color: #ffffff;
	font-size: 14px;
	font-weight: 800;
}

/* =====================================================
   REMOVE BUTTON
===================================================== */
.remove-button {
	min-height: 39px;
	padding: 0 13px;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 7px;
	border: 1px solid rgba(255, 92, 92, 0.15);
	border-radius: 11px;
	background: var(--red-soft);
	color: var(--red-light);
	font-size: 11px;
	font-weight: 800;
	cursor: pointer;
	transition: transform 0.22s ease, background 0.22s ease, color 0.22s
		ease;
}

.remove-button:hover {
	transform: translateY(-2px);
	background: var(--red);
	color: #ffffff;
}

/* =====================================================
   ITEM TOTAL
===================================================== */
.item-total {
	display: grid;
	justify-items: end;
	gap: 2px;
	flex-shrink: 0;
}

.item-total small {
	color: var(--muted);
	font-size: 9px;
	font-weight: 700;
	letter-spacing: 0.8px;
	text-transform: uppercase;
}

.item-total strong {
	color: #ffffff;
	font-size: 21px;
	font-weight: 800;
}

/* =====================================================
   ORDER SUMMARY
===================================================== */
.order-summary {
	position: sticky;
	top: calc(var(--header-height)+ 20px);
	padding: 23px;
	border: 1px solid var(--line);
	border-radius: var(--radius-lg);
	background: linear-gradient(180deg, rgba(255, 255, 255, 0.023),
		transparent), var(--panel);
	box-shadow: 0 16px 35px rgba(0, 0, 0, 0.26);
}

.summary-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 14px;
	padding-bottom: 18px;
	border-bottom: 1px solid var(--line);
}

.summary-title-copy {
	display: grid;
	gap: 4px;
}

.summary-title-copy h2 {
	font-size: 23px;
	letter-spacing: -0.7px;
}

.summary-title-copy p {
	color: var(--muted);
	font-size: 11px;
	line-height: 1.5;
}

.summary-icon {
	width: 44px;
	height: 44px;
	display: grid;
	place-items: center;
	flex: 0 0 auto;
	border-radius: 13px;
	background: var(--orange-soft);
	color: var(--orange-light);
	font-size: 20px;
}

.summary-list {
	padding: 18px 0;
	display: grid;
	gap: 15px;
}

.summary-row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 18px;
	color: var(--muted-light);
	font-size: 13px;
}

.summary-row span:last-child {
	color: #ffffff;
	font-weight: 700;
}

.delivery-row span:last-child {
	color: var(--green);
}

.summary-divider {
	height: 1px;
	margin: 1px 0 17px;
	background: var(--line);
}

.grand-total {
	display: flex;
	align-items: flex-end;
	justify-content: space-between;
	gap: 18px;
}

.grand-total-copy {
	display: grid;
	gap: 3px;
}

.grand-total-copy small {
	color: var(--muted);
	font-size: 10px;
	font-weight: 700;
	letter-spacing: 0.8px;
	text-transform: uppercase;
}

.grand-total-copy span {
	color: var(--muted-light);
	font-size: 10px;
}

.grand-total strong {
	color: var(--orange-light);
	font-size: 28px;
	font-weight: 900;
}

/* =====================================================
   SUMMARY ACTION BUTTONS
===================================================== */
.summary-actions {
	margin-top: 22px;
	display: grid;
	gap: 11px;
}

.checkout-button {
	min-height: 51px;
	padding: 0 18px;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 9px;
	border-radius: 14px;
	background: linear-gradient(135deg, var(--green), var(--green-light));
	color: #07140c;
	font-size: 13px;
	font-weight: 900;
	box-shadow: 0 13px 28px rgba(32, 191, 99, 0.2);
	transition: transform 0.22s ease, box-shadow 0.22s ease, filter 0.22s
		ease;
}

.checkout-button:hover {
	transform: translateY(-3px);
	filter: brightness(1.04);
	box-shadow: 0 18px 32px rgba(32, 191, 99, 0.28);
}

.continue-button {
	min-height: 47px;
	padding: 0 18px;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	border: 1px solid var(--line);
	border-radius: 14px;
	background: var(--panel-soft);
	color: var(--muted-light);
	font-size: 12px;
	font-weight: 800;
	transition: transform 0.22s ease, background 0.22s ease, color 0.22s
		ease;
}

.continue-button:hover {
	transform: translateY(-2px);
	background: var(--panel-hover);
	color: #ffffff;
}

.secure-note {
	margin-top: 16px;
	padding: 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	border: 1px solid rgba(32, 191, 99, 0.12);
	border-radius: 12px;
	background: rgba(32, 191, 99, 0.055);
	color: var(--muted);
	font-size: 10px;
	line-height: 1.4;
}

.secure-note span {
	color: var(--green);
	font-size: 15px;
}

/* =====================================================
   EMPTY CART
===================================================== */
.empty-cart {
	grid-column: 1/-1;
	width: min(520px, 100%);
	min-height: 430px;
	margin: 10px auto 0;
	padding: 55px 38px;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	text-align: center;
	border: 1px solid var(--line);
	border-radius: var(--radius-xl);
	background: linear-gradient(180deg, rgba(255, 255, 255, 0.018),
		transparent), var(--panel);
	box-shadow: 0 20px 50px rgba(0, 0, 0, 0.30);
}

.empty-cart-icon {
	width: 92px;
	height: 92px;
	display: grid;
	place-items: center;
	border-radius: 27px;
	background: var(--orange-soft);
	color: var(--orange-light);
	font-size: 43px;
	box-shadow: 0 16px 34px rgba(240, 74, 22, 0.1);
}

.empty-cart h2 {
	margin-top: 22px;
	font-size: 29px;
	letter-spacing: -0.9px;
}

.empty-cart p {
	max-width: 500px;
	margin-top: 9px;
	color: var(--muted);
	font-size: 13px;
	line-height: 1.65;
}

.browse-button {
	min-height: 48px;
	margin-top: 23px;
	padding: 0 20px;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	border-radius: 13px;
	background: linear-gradient(135deg, var(--orange), var(--orange-light));
	color: #ffffff;
	font-size: 13px;
	font-weight: 800;
	box-shadow: 0 13px 28px rgba(240, 74, 22, 0.2);
	transition: transform 0.22s ease, box-shadow 0.22s ease;
}

.browse-button:hover {
	transform: translateY(-3px);
	box-shadow: 0 18px 34px rgba(240, 74, 22, 0.29);
}

/* =====================================================
   FOOTER
===================================================== */
.footer {
	margin-top: 50px;
	padding-top: 28px;
	border-top: 1px solid var(--line);
}

.footer-main {
	padding-bottom: 28px;
	display: grid;
	grid-template-columns: 1.3fr repeat(3, 0.7fr);
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

.footer-column a, .footer-column span {
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
	border-top: 1px solid var(--line);
	color: #70707b;
	font-size: 11px;
}

/* =====================================================
   RESPONSIVE DESIGN
===================================================== */
@media ( max-width : 1200px) {
	:root {
		--sidebar-width: 220px;
	}
	.cart-layout {
		grid-template-columns: minmax(0, 1fr) 345px;
	}
	.cart-item {
		grid-template-columns: 140px minmax(0, 1fr);
	}
	.cart-image-wrap {
		height: 145px;
	}
	.footer-main {
		grid-template-columns: 1.2fr repeat(2, 0.8fr);
	}
	.footer-column:last-child {
		display: none;
	}
}

@media ( max-width : 1000px) {
	.cart-layout {
		grid-template-columns: 1fr;
	}
	.order-summary {
		position: static;
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
	.mobile-menu {
		display: grid;
		place-items: center;
	}
	.back-link {
		display: none;
	}
	.cart-hero {
		grid-template-columns: 1fr;
	}
	.cart-hero-visual {
		display: none;
	}
}

@media ( max-width : 680px) {
	.empty-cart {
		width: 100%;
		min-height: 380px;
		padding: 42px 22px;
	}
	.top-header {
		min-height: 70px;
		padding: 10px 13px;
	}
	.header-title {
		display: none;
	}
	.profile-copy {
		display: none;
	}
	.profile-chip {
		padding-right: 6px;
	}
	.page-content {
		padding: 16px 13px 50px;
	}
	.cart-hero {
		min-height: auto;
		padding: 28px 22px;
		border-radius: 20px;
	}
	.cart-hero h1 {
		font-size: 2.7rem;
		letter-spacing: -2.5px;
	}
	.cart-hero p {
		font-size: 14px;
	}
	.cart-section-heading {
		align-items: flex-start;
		flex-direction: column;
	}
	.cart-item {
		grid-template-columns: 1fr;
		padding: 14px;
	}
	.cart-image-wrap {
		height: 210px;
	}
	.item-top {
		align-items: flex-start;
	}
	.item-name {
		font-size: 22px;
	}
	.item-actions {
		align-items: flex-start;
		flex-direction: column;
	}
	.item-left-actions {
		width: 100%;
		justify-content: space-between;
	}
	.item-total {
		width: 100%;
		justify-items: start;
	}
	.order-summary {
		padding: 19px;
	}
	.footer-main {
		grid-template-columns: 1fr 1fr;
	}
	.footer-brand {
		grid-column: 1/-1;
	}
	.footer-bottom {
		padding: 17px 0;
		align-items: flex-start;
		flex-direction: column;
	}
}
</style>

</head>

<body>

	<!-- Part 3 starts from here -->

	<div class="app-shell">

		<!-- ===========================
	         SIDEBAR
	=========================== -->

		<aside class="sidebar">

			<div class="sidebar-top">

				<a href="restaurant" class="brand"> <span class="brand-icon">🍴</span>

					<span class="brand-copy"> <span class="brand-name">
							Tap<span>Foods</span>
					</span> <span class="brand-caption"> Food Delivery </span>

				</span>

				</a>

			</div>

			<div class="sidebar-scroll">

				<p class="sidebar-label">Main Menu</p>

				<nav class="sidebar-menu">

					<a href="restaurant" class="sidebar-link"> <span
						class="sidebar-icon">🏠</span> <span>Home</span>

					</a> <a href="restaurant" class="sidebar-link"> <span
						class="sidebar-icon">🍽</span> <span>Restaurants</span>

					</a> <a href="CartServlet" class="sidebar-link active"> <span
						class="sidebar-icon">🛒</span> <span>My Cart</span> <span
						class="sidebar-count"> <%=cartCount%>
					</span>

					</a> <a href="<%=request.getContextPath()%>/MyOrdersServlet" class="sidebar-link">
                <span class="sidebar-icon">📦</span>
                <span>My Orders</span>
            </a> <a href="<%=request.getContextPath()%>/ProfileServlet" class="sidebar-link"> <span class="sidebar-icon">👤</span>

						<span>Profile</span>

					</a>

				</nav>

				<div class="sidebar-divider"></div>

				<div class="sidebar-bottom">

					<div class="help-card">

						<div class="help-icon">?</div>

						<h4>Need Assistance?</h4>

						<p>Need help regarding your order? Our support team is always
							available.</p>

						<a href="#"> Contact Support → </a>

					</div>

				</div>

			</div>

		</aside>

		<!-- ===========================
	         MAIN CONTENT
	=========================== -->

		<div class="main-area">

			<header class="top-header">

				<div class="header-left">

					<button class="mobile-menu">☰</button>

					<a href="restaurant" class="back-link"> ← Continue Shopping </a>

					<div class="header-title">

						<small>Your Cart</small> <strong>Review before Checkout</strong>

					</div>

				</div>

				<div class="header-actions">

					<a href="CartServlet" class="header-button"> 🛒 </a>

					<button class="header-button">

						🔔 <span class="notification-dot"></span>

					</button>

					<div class="profile-chip">

						<div class="profile-avatar"><%=initials%></div>

						<div class="profile-copy">

							<strong><%=displayName%></strong>
							<small>Customer account</small>

						</div>

					</div>

				</div>

			</header>

			<main class="page-content">

				<!-- ===========================
			         HERO
			=========================== -->

				<section class="cart-section">

					<div class="cart-section-heading">

						<div>

							<p class="section-kicker">YOUR CART</p>

							<h2>Shopping Cart</h2>

							<p>Manage quantities and continue to checkout.</p>

						</div>

						<div class="cart-items-count">

							<%=cartCount%>

							Items

						</div>

					</div>

					<div class="cart-layout">

						<div class="cart-items">

							<%
					if (cart != null &&
						cart.getItems() != null &&
						!cart.getItems().isEmpty()) {

						for (Map.Entry<Integer, CartItem> entry :
							cart.getItems().entrySet()) {

							CartItem item = entry.getValue();

							double itemTotal =
								item.getTotalPrice();

							subtotal += itemTotal;

							Menu menu =
								menuDAOImpl.getMenuById(
									item.getMenuId()
								);

							String imagePath =
								(menu != null &&
								 menu.getImagePath() != null &&
								 !menu.getImagePath().trim().isEmpty())
									? menu.getImagePath()
									: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=85";
					%>

							<article class="cart-item">

								<div class="cart-image-wrap">

									<img src="<%=imagePath%>" alt="<%=item.getName()%>"
										class="cart-image"> <span class="item-badge">
										Fresh Item </span>

								</div>

								<div class="cart-item-content">

									<div class="item-top">

										<div>

											<p class="item-label">Selected Dish</p>

											<h3 class="item-name">
												<%=item.getName()%>
											</h3>

										</div>

										<div class="item-unit-price">

											₹<%=String.format(
											"%.2f",
											item.getPrice()
										)%>

										</div>

									</div>

									<p class="item-description">Freshly prepared and delivered
										hot to your doorstep with premium taste.</p>

									<div class="item-actions">

										<div class="item-left-actions">

											<div class="quantity-control">

												<form action="CartServlet" method="post">

													<input type="hidden" name="action" value="update">

													<input type="hidden" name="menuId"
														value="<%=item.getMenuId()%>"> <input
														type="hidden" name="restaurantId"
														value="<%=restaurantId%>"> <input type="hidden"
														name="quantity" value="<%=item.getQty() - 1%>">

													<button type="submit" class="quantity-button"
														aria-label="Decrease quantity">−</button>

												</form>

												<span class="quantity-value"> <%=item.getQty()%>

												</span>

												<form action="CartServlet" method="post">

													<input type="hidden" name="action" value="update">

													<input type="hidden" name="menuId"
														value="<%=item.getMenuId()%>"> <input
														type="hidden" name="restaurantId"
														value="<%=restaurantId%>"> <input type="hidden"
														name="quantity" value="<%=item.getQty() + 1%>">

													<button type="submit" class="quantity-button"
														aria-label="Increase quantity">＋</button>

												</form>

											</div>

											<form action="CartServlet" method="post">

												<input type="hidden" name="action" value="delete"> <input
													type="hidden" name="menuId" value="<%=item.getMenuId()%>">

												<input type="hidden" name="restaurantId"
													value="<%=restaurantId%>">

												<button type="submit" class="remove-button">

													<span>🗑</span> Remove

												</button>

											</form>

										</div>

										<div class="item-total">

											<small> Item Total </small> <strong> ₹<%=String.format(
												"%.2f",
												itemTotal
											)%>

											</strong>

										</div>

									</div>

								</div>

							</article>

							<%
						}

						double deliveryFee =
							subtotal > 0 ? 40.0 : 0.0;

						double gst =
							subtotal * 0.05;

						double grandTotal =
							subtotal +
							deliveryFee +
							gst;
					%>

						</div>

						<aside class="order-summary">

							<div class="summary-header">

								<div class="summary-title-copy">

									<h2>Order Summary</h2>

									<p>Review your total before checkout.</p>

								</div>

								<div class="summary-icon">🧾</div>

							</div>

							<div class="summary-list">

								<div class="summary-row">

									<span>Subtotal</span> <span> ₹<%=String.format(
										"%.2f",
										subtotal
									)%>
									</span>

								</div>

								<div class="summary-row delivery-row">

									<span>Delivery Fee</span> <span> ₹<%=String.format(
										"%.2f",
										deliveryFee
									)%>
									</span>

								</div>

								<div class="summary-row">

									<span>GST (5%)</span> <span> ₹<%=String.format(
										"%.2f",
										gst
									)%>
									</span>

								</div>

								<div class="summary-row">

									<span>Estimated Delivery</span> <span>30–40 mins</span>

								</div>

							</div>

							<div class="summary-divider"></div>

							<div class="grand-total">

								<div class="grand-total-copy">

									<small> Grand Total </small> <span> Inclusive of all
										taxes </span>

								</div>

								<strong> ₹<%=String.format(
									"%.2f",
									grandTotal
								)%>

								</strong>

							</div>

							<div class="summary-actions">

								<a href="Checkout.jsp" class="checkout-button"> Proceed to
									Checkout <span>→</span>

								</a> <a href="Menu?restaurantId=<%=restaurantId%>"
									class="continue-button"> <span>←</span> Continue Shopping

								</a>

							</div>

							<div class="secure-note">

								<span>✓</span> Secure checkout with protected payment details

							</div>

						</aside>

					</div>

				</section>

				<%
			}
			else {
			%>
			
		</div>

		<div class="empty-cart">

			<div class="empty-cart-icon">🛒</div>

			<h2>Your cart is empty</h2>

			<p>You have not added any food items yet. Explore restaurants and
				add your favourite dishes.</p>

			<a href="restaurant" class="browse-button"> Browse Restaurants <span>→</span>

			</a>

		</div>

		</section>

		<%
			}
			%>

		<footer class="footer">

			<div class="footer-main">

				<div class="footer-brand">

					<a href="restaurant" class="brand"> <span class="brand-icon">
							🍴 </span> <span class="brand-copy"> <span class="brand-name">

								Tap<span>Foods</span>

						</span> <span class="brand-caption"> Food Delivery </span>

					</span>

					</a>

					<p>Discover trusted restaurants, delicious meals and a smooth
						food-ordering experience designed around your cravings.</p>

				</div>

				<div class="footer-column">

					<h4>Explore</h4>

					<a href="restaurant"> Home </a> <a href="restaurant#restaurants">
						Restaurants </a> <a href="Cart.jsp"> My Cart </a> <a
						href="<%=request.getContextPath()%>/MyOrdersServlet"> My
						Orders </a>

				</div>

				<div class="footer-column">

					<h4>Account</h4>

					<a href="<%=request.getContextPath()%>/ProfileServlet"> Profile </a> <a href="Login.html"> Sign In </a> <a
						href="Register.html"> Create Account </a> <a href="#"> Log Out
					</a>

				</div>

				<div class="footer-column">

					<h4>Contact</h4>

					<span> Bengaluru, Karnataka </span> <span> +91 9876543210 </span> <span>
						support@tapfoods.com </span>

				</div>

			</div>

			<div class="footer-bottom">

				<span> © 2026 TapFoods. All rights reserved. </span>

			</div>

		</footer>

		</main>

	</div>

	</div>

</body>

</html>
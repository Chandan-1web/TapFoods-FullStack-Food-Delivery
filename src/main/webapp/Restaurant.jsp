<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.food.Model.Restaurant"%>
<%@ page import="com.food.Model.Cart"%>
<%@ page import="com.food.Model.User"%>

<%
List<Restaurant> allRestaurants =
	(List<Restaurant>) request.getAttribute("allRestaurants");

int restaurantCount =
	allRestaurants != null ? allRestaurants.size() : 0;

Cart cart = (Cart) session.getAttribute("cart");

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
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>TapFoods | Restaurants</title>

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
	--sidebar-width: 250px;
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

/* =====================================================
   APPLICATION LAYOUT — CORRECTED
===================================================== */
:root {
	--sidebar-width: 240px;
	--sidebar: #14141b;
	--orange: #f04a16;
	--orange-light: #ff6a2f;
	--line: rgba(255, 255, 255, 0.08);
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
	background: linear-gradient(180deg, rgba(255, 255, 255, 0.018),
		transparent 55%), var(--sidebar);
	border-right: 1px solid var(--line);
}

/* Fixed TapFoods logo area */
.sidebar-top {
	flex-shrink: 0;
	padding: 22px 16px 18px;
	background: linear-gradient(180deg, rgba(255, 255, 255, 0.018),
		transparent), var(--sidebar);
	border-bottom: 1px solid var(--line);
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

/* Main content alignment */
.main-area {
	width: calc(100% - var(--sidebar-width));
	min-height: 100vh;
	margin-left: var(--sidebar-width);
}

/* =====================================================
   TAPFOODS BRAND — RESTORE ORIGINAL DESIGN
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
	color: #92929f;
	font-size: 10px;
	font-weight: 700;
	line-height: 1.2;
	letter-spacing: 1.1px;
	text-transform: uppercase;
	white-space: nowrap;
}

/* Keep sidebar menu compact */
.sidebar-divider {
	height: 1px;
	margin: 17px 5px;
	background: var(--line);
}

.sidebar-link {
	min-height: 47px;
	padding: 0 12px;
	font-size: 14px;
}

.sidebar-divider {
	margin: 17px 5px;
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
	min-height: 49px;
	padding: 0 14px;
	display: flex;
	align-items: center;
	gap: 12px;
	border-radius: 14px;
	color: var(--muted-light);
	font-size: 15px;
	font-weight: 700;
	transition: background .22s ease, color .22s ease, transform .22s ease;
}

.sidebar-link:hover {
	color: #fff;
	background: var(--panel-soft);
	transform: translateX(3px);
}

.sidebar-link.active {
	color: #fff;
	background: linear-gradient(135deg, var(--orange), var(--orange-light));
	box-shadow: 0 12px 27px rgba(240, 74, 22, .21);
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
	background: rgba(255, 255, 255, .11);
	font-size: 11px;
	font-weight: 800;
}

.sidebar-bottom {
	margin-top: 22px;
	padding-bottom: 7px;
}

.help-card {
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
	background: rgba(13, 13, 18, .93);
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
	color: #fff;
	font-size: 18px;
	cursor: pointer;
}

.location {
	display: flex;
	align-items: center;
	gap: 10px;
}

.location-icon {
	width: 39px;
	height: 39px;
	display: grid;
	place-items: center;
	border-radius: 12px;
	background: var(--orange-soft);
	color: var(--orange-light);
	font-size: 17px;
}

.location-copy {
	display: grid;
	gap: 2px;
}

.location-copy small {
	color: var(--muted);
	font-size: 10px;
	font-weight: 800;
	letter-spacing: 1px;
	text-transform: uppercase;
}

.location-copy strong {
	font-size: 14px;
}

.header-search {
	position: relative;
	width: min(470px, 36vw);
}

.header-search span {
	position: absolute;
	left: 15px;
	top: 50%;
	transform: translateY(-50%);
	color: #747480;
	font-size: 17px;
}

.header-search input {
	width: 100%;
	height: 48px;
	padding: 0 17px 0 44px;
	border: 1px solid var(--line);
	outline: none;
	border-radius: 14px;
	background: var(--panel);
	color: #fff;
	font-size: 14px;
	transition: border-color .22s ease, box-shadow .22s ease;
}

.header-search input::placeholder {
	color: #747480;
}

.header-search input:focus {
	border-color: var(--orange);
	box-shadow: 0 0 0 4px rgba(240, 74, 22, .11);
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
	color: #fff;
	font-size: 17px;
	cursor: pointer;
	transition: transform .22s ease, background .22s ease;
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
	width: 100%;
	max-width: 1480px;
	margin: 0 auto;
	padding: 25px 28px 60px;
}

/* =====================================================
   HERO
===================================================== */
.hero {
	position: relative;
	min-height: 340px;
	padding: 36px 40px;
	display: grid;
	grid-template-columns: 1.15fr .85fr;
	align-items: center;
	gap: 28px;
	overflow: hidden;
	border-radius: var(--radius-xl);
	background: linear-gradient(135deg, var(--orange), var(--orange-light));
	box-shadow: 0 22px 48px rgba(240, 74, 22, .17);
}

.hero::before {
	content: "";
	position: absolute;
	left: -95px;
	bottom: -175px;
	width: 340px;
	height: 340px;
	border-radius: 50%;
	background: rgba(255, 255, 255, .08);
}

.hero::after {
	content: "";
	position: absolute;
	top: -180px;
	right: 21%;
	width: 340px;
	height: 340px;
	border-radius: 50%;
	background: rgba(255, 255, 255, .05);
}

.hero-content, .hero-visual {
	position: relative;
	z-index: 2;
}

.hero-tag {
	width: max-content;
	margin-bottom: 16px;
	padding: 9px 13px;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	border: 1px solid rgba(255, 255, 255, .20);
	border-radius: 999px;
	background: rgba(255, 255, 255, .11);
	font-size: 12px;
	font-weight: 800;
}

.hero-tag-dot {
	width: 8px;
	height: 8px;
	border-radius: 50%;
	background: var(--green-light);
	box-shadow: 0 0 0 5px rgba(49, 220, 123, .16);
}

.hero h1 {
	max-width: 690px;
	font-size: clamp(3.1rem, 4.8vw, 5.3rem);
	line-height: .98;
	letter-spacing: -4px;
}

.hero h1 span {
	color: #202029;
}

.hero p {
	max-width: 620px;
	margin-top: 18px;
	color: rgba(255, 255, 255, .84);
	font-size: 16px;
	line-height: 1.72;
}

.hero-actions {
	margin-top: 24px;
	display: flex;
	align-items: center;
	gap: 11px;
	flex-wrap: wrap;
}

.primary-button, .secondary-button {
	min-height: 48px;
	padding: 0 20px;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	border-radius: 13px;
	font-size: 13px;
	font-weight: 800;
	transition: transform .22s ease, box-shadow .22s ease;
}

.primary-button {
	background: #17171f;
	color: #fff;
	box-shadow: 0 13px 28px rgba(0, 0, 0, .22);
}

.secondary-button {
	border: 1px solid rgba(255, 255, 255, .26);
	background: rgba(255, 255, 255, .10);
	color: #fff;
}

.primary-button:hover, .secondary-button:hover {
	transform: translateY(-3px);
}

.hero-stats {
	margin-top: 24px;
	display: flex;
	gap: 28px;
	flex-wrap: wrap;
}

.hero-stat {
	display: grid;
	gap: 3px;
}

.hero-stat strong {
	font-size: 21px;
}

.hero-stat span {
	color: rgba(255, 255, 255, .74);
	font-size: 11px;
	font-weight: 700;
}

.hero-visual {
	min-height: 255px;
	display: grid;
	place-items: center;
}

.food-ring {
	position: relative;
	width: min(305px, 90%);
	aspect-ratio: 1;
	border-radius: 50%;
	background: rgba(255, 255, 255, .13);
	box-shadow: inset 0 0 0 21px rgba(255, 255, 255, .04);
}

.food-ring img {
	position: absolute;
	inset: 8%;
	width: 84%;
	height: 84%;
	border-radius: 50%;
	object-fit: cover;
	box-shadow: 0 23px 48px rgba(0, 0, 0, .34);
	transform: rotate(-5deg);
}

.floating-card {
	position: absolute;
	z-index: 4;
	min-width: 138px;
	padding: 12px;
	display: flex;
	align-items: center;
	gap: 9px;
	border: 1px solid rgba(255, 255, 255, .12);
	border-radius: 14px;
	background: rgba(23, 23, 31, .86);
	backdrop-filter: blur(12px);
	box-shadow: 0 15px 32px rgba(0, 0, 0, .25);
}

.floating-one {
	left: -13px;
	bottom: 31px;
}

.floating-two {
	right: -12px;
	top: 37px;
}

.floating-icon {
	width: 34px;
	height: 34px;
	display: grid;
	place-items: center;
	border-radius: 10px;
	background: var(--green-soft);
	color: var(--green);
	font-size: 15px;
}

.floating-copy {
	display: grid;
	gap: 2px;
}

.floating-copy strong {
	font-size: 11px;
}

.floating-copy span {
	color: var(--muted);
	font-size: 9px;
}

/* =====================================================
   SECTIONS
===================================================== */
.section {
	margin-top: 34px;
}

.section-heading {
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

.section-heading h2 {
	font-size: clamp(2rem, 3vw, 2.75rem);
	letter-spacing: -1.2px;
}

.section-heading p {
	margin-top: 7px;
	color: var(--muted);
	font-size: 14px;
}

.view-all {
	color: var(--green);
	font-size: 13px;
	font-weight: 800;
}

/* =====================================================
   CATEGORIES
===================================================== */
.category-strip {
	display: flex;
	gap: 11px;
	overflow-x: auto;
	padding-bottom: 5px;
	scrollbar-width: none;
}

.category-strip::-webkit-scrollbar {
	display: none;
}

.category-button {
	min-height: 45px;
	padding: 0 18px;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	flex: 0 0 auto;
	border: 1px solid var(--line);
	border-radius: 13px;
	background: var(--panel);
	color: var(--muted-light);
	font-size: 13px;
	font-weight: 800;
	cursor: pointer;
	transition: transform .22s ease, color .22s ease, background .22s ease,
		border-color .22s ease;
}

.category-button:hover {
	transform: translateY(-2px);
	color: #fff;
	background: var(--panel-hover);
}

.category-button.active {
	border-color: var(--orange);
	background: var(--orange);
	color: #fff;
}

/* =====================================================
   RESTAURANT GRID
===================================================== */
.restaurant-grid {
	width: 100%;
	display: grid;
	grid-template-columns: repeat(3, minmax(0, 1fr));
	gap: 21px;
	align-items: stretch;
}

.restaurant-card {
	min-width: 0;
	display: flex;
	flex-direction: column;
	overflow: hidden;
	border: 1px solid var(--line);
	border-radius: var(--radius-lg);
	background: linear-gradient(180deg, rgba(255, 255, 255, .018),
		transparent), var(--panel);
	box-shadow: 0 11px 27px rgba(0, 0, 0, .22);
	transition: transform .28s ease, border-color .28s ease, box-shadow .28s
		ease;
}

.restaurant-card:hover {
	transform: translateY(-6px);
	border-color: rgba(240, 74, 22, .39);
	box-shadow: 0 20px 39px rgba(0, 0, 0, .31);
}

.restaurant-media {
	position: relative;
	height: 195px;
	overflow: hidden;
	background: var(--panel-soft);
}

.restaurant-media::after {
	content: "";
	position: absolute;
	inset: 0;
	background: linear-gradient(180deg, transparent 38%, rgba(13, 13, 18, .82)
		100%);
	pointer-events: none;
}

.restaurant-media img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	transition: transform .5s ease;
}

.restaurant-card:hover .restaurant-media img {
	transform: scale(1.055);
}

.rating-badge {
	position: absolute;
	top: 12px;
	right: 12px;
	z-index: 3;
	min-height: 32px;
	padding: 0 11px;
	display: inline-flex;
	align-items: center;
	gap: 5px;
	border: 1px solid rgba(255, 255, 255, .08);
	border-radius: 10px;
	background: rgba(18, 18, 25, .88);
	backdrop-filter: blur(10px);
	font-size: 12px;
	font-weight: 800;
}

.rating-badge span {
	color: #ffc341;
}

.status-badge {
	position: absolute;
	left: 12px;
	bottom: 12px;
	z-index: 3;
	min-height: 31px;
	padding: 0 11px;
	display: inline-flex;
	align-items: center;
	gap: 7px;
	border: 1px solid rgba(255, 255, 255, .08);
	border-radius: 999px;
	background: rgba(18, 18, 25, .88);
	backdrop-filter: blur(10px);
	font-size: 10px;
	font-weight: 800;
	letter-spacing: .7px;
	text-transform: uppercase;
}

.status-badge::before {
	content: "";
	width: 7px;
	height: 7px;
	border-radius: 50%;
	background: var(--green);
	box-shadow: 0 0 0 4px rgba(32, 191, 99, .13);
}

.restaurant-content {
	padding: 19px;
	display: flex;
	flex-direction: column;
	flex: 1;
}

.restaurant-topline {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
}

.cuisine {
	color: var(--orange-light);
	font-size: 11px;
	font-weight: 800;
	letter-spacing: 1px;
	text-transform: uppercase;
}

.restaurant-topline .delivery-time {
	font-size: 11px;
	white-space: nowrap;
}

.restaurant-name {
	margin-top: 10px;
	font-size: 24px;
	line-height: 1.22;
	letter-spacing: -.65px;
}

.restaurant-location {
	min-height: 43px;
	margin-top: 11px;
	display: flex;
	align-items: flex-start;
	gap: 8px;
	color: var(--muted);
	font-size: 13px;
	line-height: 1.55;
}

.restaurant-location>span:first-child {
	color: var(--orange-light);
}

.restaurant-meta {
	margin-top: auto;
	padding-top: 17px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
	border-top: 1px solid var(--line);
}

.delivery-time {
	display: inline-flex;
	align-items: center;
	gap: 7px;
	color: var(--muted-light);
	font-size: 12px;
	font-weight: 700;
}

.menu-button {
	min-height: 41px;
	padding: 0 16px;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 7px;
	flex: 0 0 auto;
	border-radius: 11px;
	background: linear-gradient(135deg, var(--green), var(--green-light));
	color: #07140c;
	font-size: 12px;
	font-weight: 900;
	box-shadow: 0 10px 22px rgba(32, 191, 99, .18);
	transition: transform .22s ease, box-shadow .22s ease, filter .22s ease;
}

.menu-button:hover {
	transform: translateY(-2px);
	filter: brightness(1.04);
	box-shadow: 0 14px 27px rgba(32, 191, 99, .26);
}

/* =====================================================
   EMPTY STATE
===================================================== */
.empty-state {
	grid-column: 1/-1;
	padding: 48px 28px;
	text-align: center;
	border: 1px solid var(--line);
	border-radius: var(--radius-lg);
	background: var(--panel);
}

.empty-icon {
	width: 65px;
	height: 65px;
	margin: auto;
	display: grid;
	place-items: center;
	border-radius: 19px;
	background: var(--orange-soft);
	color: var(--orange-light);
	font-size: 28px;
}

.empty-state h3 {
	margin-top: 16px;
	font-size: 20px;
}

.empty-state p {
	margin-top: 7px;
	color: var(--muted);
	font-size: 13px;
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

.social-links {
	display: flex;
	gap: 8px;
}

.social-link {
	width: 34px;
	height: 34px;
	display: grid;
	place-items: center;
	border: 1px solid var(--line);
	border-radius: 10px;
	background: var(--panel);
	color: var(--muted-light);
	font-size: 12px;
}

/* =====================================================
   RESPONSIVE
===================================================== */
@media ( min-width : 1500px) {
	.restaurant-grid {
		grid-template-columns: repeat(4, minmax(0, 1fr));
	}
	.restaurant-media {
		height: 190px;
	}
}

@media ( max-width : 1200px) {
	:root {
		--sidebar-width: 220px;
	}
	.restaurant-grid {
		grid-template-columns: repeat(2, minmax(0, 1fr));
	}
	.footer-main {
		grid-template-columns: 1.2fr repeat(2, .8fr);
	}
	.footer-column:last-child {
		display: none;
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
	.location {
		display: none;
	}
	.header-search {
		width: min(390px, 48vw);
	}
	.hero {
		grid-template-columns: 1fr;
		min-height: auto;
	}
	.hero-visual {
		display: none;
	}
	.restaurant-grid {
		grid-template-columns: repeat(2, minmax(0, 1fr));
	}
}

@media ( max-width : 620px) {
	.top-header {
		min-height: 70px;
		padding: 10px 13px;
	}
	.header-search {
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
	.hero {
		min-height: auto;
		padding: 28px 22px;
		border-radius: 20px;
	}
	.hero h1 {
		font-size: 2.75rem;
		letter-spacing: -2.5px;
	}
	.hero p {
		font-size: 14px;
	}
	.hero-stats {
		gap: 20px;
	}
	.section {
		margin-top: 30px;
	}
	.section-heading {
		align-items: flex-start;
		flex-direction: column;
	}
	.section-heading h2 {
		font-size: 2.05rem;
	}
	.section-heading p {
		font-size: 13px;
	}
	.category-button {
		min-height: 43px;
		padding: 0 16px;
		font-size: 12px;
	}
	.restaurant-grid {
		grid-template-columns: 1fr;
		gap: 18px;
	}
	.restaurant-media {
		height: 220px;
	}
	.restaurant-name {
		font-size: 23px;
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

	<div class="app-shell">

		<aside class="sidebar">

			<!-- FIXED LOGO -->
			<div class="sidebar-top">

				<a href="restaurant" class="brand"> <span class="brand-icon">🍴</span>

					<span class="brand-copy"> <span class="brand-name">Tap<span>Foods</span></span>
						<span class="brand-caption">Food Delivery</span>
				</span>
				</a>

			</div>

			<!-- ONLY THIS PART SCROLLS -->
			<div class="sidebar-scroll">

				<div class="sidebar-divider"></div>

				<p class="sidebar-label">Main Menu</p>

				<nav class="sidebar-menu">

					<a href="restaurant" class="sidebar-link active"> <span
						class="sidebar-icon">⌂</span> <span>Home</span>
					</a> <a href="#restaurants" class="sidebar-link"> <span
						class="sidebar-icon">🍽</span> <span>Restaurants</span>
					</a> <a href="Cart.jsp" class="sidebar-link"> <span
						class="sidebar-icon">🛒</span> <span>My Cart</span> <span
						class="sidebar-count"><%=cartCount%></span>
					</a> <a href="<%=request.getContextPath()%>/MyOrdersServlet"
						class="sidebar-link"> <span class="sidebar-icon">📦</span> <span>My
							Orders</span>
					</a>
				</nav>

				<div class="sidebar-divider"></div>

				<p class="sidebar-label">Account</p>

				<nav class="sidebar-menu">

					<a href="<%=request.getContextPath()%>/ProfileServlet"
						class="sidebar-link"> <span class="sidebar-icon">👤</span> <span>Profile</span>
					</a> <a href="<%=request.getContextPath()%>/Login.jsp"
						class="sidebar-link"> <span class="sidebar-icon">⇥</span> <span>Sign
							In</span>
					</a> <a href="<%=request.getContextPath()%>/Register.jsp"
						class="sidebar-link"> <span class="sidebar-icon">＋</span> <span>Register</span>
					</a>

				</nav>

				<div class="sidebar-bottom">

					<div class="help-card">

						<div class="help-icon">?</div>

						<h4>Need assistance?</h4>

						<p>Our support team is ready to help with your food orders.</p>

						<a href="#">Contact support →</a>

					</div>

				</div>

			</div>

		</aside>

		<div class="main-area">

			<header class="top-header">

				<div class="header-left">
					<button class="mobile-menu" type="button">☰</button>

					<div class="location">
						<div class="location-icon">⌖</div>

						<div class="location-copy">
							<small>Delivering to</small> <strong>Bengaluru,
								Karnataka</strong>
						</div>
					</div>
				</div>

				<div class="header-actions">

					<div class="header-search">
						<span>⌕</span> <input id="restaurantSearch" type="text"
							placeholder="Search food or restaurants">
					</div>

					<a href="Cart.jsp" class="header-button" aria-label="Open cart">🛒</a>

					<button class="header-button" type="button"
						aria-label="Notifications">
						🔔 <span class="notification-dot"></span>
					</button>

					<a href="<%=request.getContextPath()%>/ProfileServlet"
						class="profile-chip"> <span class="profile-avatar"><%=initials%></span>

						<span class="profile-copy"> <strong><%=displayName%></strong>
							<small>Customer account</small>
					</span>
					</a>

				</div>

			</header>

			<main class="page-content">

				<section class="hero">

					<div class="hero-content">

						<div class="hero-tag">
							<span class="hero-tag-dot"></span> Fresh meals, delivered fast
						</div>

						<h1>
							Your favourite food, <span>delivered better.</span>
						</h1>

						<p>Discover top-rated restaurants, explore delicious cuisines
							and enjoy a smooth ordering experience from your favourite
							places.</p>

						<div class="hero-actions">
							<a href="#restaurants" class="primary-button"> Explore
								Restaurants <span>→</span>
							</a> <a href="#categories" class="secondary-button"> Browse
								Cuisines </a>
						</div>

						<div class="hero-stats">

							<div class="hero-stat">
								<strong><%= restaurantCount %>+</strong> <span>Restaurants</span>
							</div>

							<div class="hero-stat">
								<strong>30 min</strong> <span>Average delivery</span>
							</div>

							<div class="hero-stat">
								<strong>4.8 ★</strong> <span>Customer rating</span>
							</div>

						</div>

					</div>

					<div class="hero-visual">

						<div class="food-ring">

							<img
								src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1000&q=88"
								alt="Premium food collection">

							<div class="floating-card floating-one">
								<span class="floating-icon">⚡</span> <span class="floating-copy">
									<strong>Fast delivery</strong> <span>Delivered hot and
										fresh</span>
								</span>
							</div>

							<div class="floating-card floating-two">
								<span class="floating-icon">✓</span> <span class="floating-copy">
									<strong>Top quality</strong> <span>Trusted restaurants</span>
								</span>
							</div>

						</div>

					</div>

				</section>

				<section class="section" id="categories">

					<div class="section-heading">
						<div>
							<p class="section-kicker">Browse by taste</p>
							<h2>Popular cuisines</h2>
							<p>Choose a category and discover restaurants that match your
								craving.</p>
						</div>

						<a href="#restaurants" class="view-all"> View all restaurants
							→ </a>
					</div>

					<div class="category-strip">

						<button class="category-button active" type="button"
							data-category="all">
							<span>🍽</span> All
						</button>

						<button class="category-button" type="button"
							data-category="biryani">
							<span>🍛</span> Biryani
						</button>

						<button class="category-button" type="button"
							data-category="south indian">
							<span>🥞</span> South Indian
						</button>

						<button class="category-button" type="button"
							data-category="north indian">
							<span>🥘</span> North Indian
						</button>

						<button class="category-button" type="button"
							data-category="chinese">
							<span>🍜</span> Chinese
						</button>

						<button class="category-button" type="button"
							data-category="pizza">
							<span>🍕</span> Pizza
						</button>

						<button class="category-button" type="button"
							data-category="burger">
							<span>🍔</span> Burger
						</button>

						<button class="category-button" type="button" data-category="cafe">
							<span>☕</span> Café
						</button>

						<button class="category-button" type="button"
							data-category="dessert">
							<span>🍰</span> Desserts
						</button>

					</div>

				</section>

				<section class="section" id="restaurants">

					<div class="section-heading">
						<div>
							<p class="section-kicker">Restaurants near you</p>
							<h2>Popular restaurants</h2>
							<p>Explore trusted restaurants and enjoy your favourite food.</p>
						</div>

						<span class="view-all" id="restaurantCount"> <%= restaurantCount %>
							<%= restaurantCount == 1 ? "restaurant available" : "restaurants available" %>
						</span>
					</div>

					<div class="restaurant-grid" id="restaurantGrid">

						<%
					if (allRestaurants != null && !allRestaurants.isEmpty()) {

						for (Restaurant restaurant : allRestaurants) {

							String cuisineValue =
								restaurant.getCuisineType() != null
									? restaurant.getCuisineType().toLowerCase()
									: "";

							String restaurantName =
								restaurant.getName() != null
									? restaurant.getName()
									: "Restaurant";

							String restaurantImage =
								restaurant.getImagePath() != null &&
								!restaurant.getImagePath().trim().isEmpty()
									? restaurant.getImagePath()
									: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1000&q=85";
					%>

						<article class="restaurant-card"
							data-name="<%= restaurantName.toLowerCase() %>"
							data-cuisine="<%= cuisineValue %>">

							<div class="restaurant-media">

								<img src="<%= restaurantImage %>" alt="<%= restaurantName %>"
									loading="lazy">

								<div class="rating-badge">
									<span>★</span>
									<%= String.format("%.1f", restaurant.getRating()) %>
								</div>

								<div class="status-badge">Open now</div>

							</div>

							<div class="restaurant-content">

								<div class="restaurant-topline">
									<span class="cuisine"> <%= restaurant.getCuisineType() %>
									</span> <span class="delivery-time"> <span>⚡</span> Fast
										delivery
									</span>
								</div>

								<h3 class="restaurant-name">
									<%= restaurantName %>
								</h3>

								<p class="restaurant-location">
									<span>⌖</span> <span><%= restaurant.getAddress() %></span>
								</p>

								<div class="restaurant-meta">
									<span class="delivery-time"> <span>◷</span> <%= restaurant.getDeliveryTime() %>
										mins
									</span> <a
										href="Menu?restaurantId=<%= restaurant.getRestaurantID() %>"
										class="menu-button"> View Menu <span>→</span>

									</a>
								</div>

							</div>

						</article>

						<%
						}
					}
					else {
					%>

						<div class="empty-state">
							<div class="empty-icon">🍽</div>
							<h3>No restaurants available</h3>
							<p>Restaurants will appear here once they are added to the
								system.</p>
						</div>

						<%
					}
					%>

					</div>

					<div class="empty-state" id="filteredEmptyState"
						style="display: none; margin-top: 18px;">

						<div class="empty-icon">⌕</div>
						<h3>No matching restaurants</h3>
						<p>Try another search term or select a different cuisine.</p>
					</div>

				</section>

				<footer class="footer">

					<div class="footer-main">

						<div class="footer-brand">
							<a href="restaurant" class="brand"> <span class="brand-icon">🍴</span>

								<span class="brand-copy"> <span class="brand-name">Tap<span>Foods</span></span>
									<span class="brand-caption">Food delivery</span>
							</span>
							</a>

							<p>Discover trusted restaurants, delicious meals and a smooth
								food-ordering experience designed around your cravings.</p>
						</div>

						<div class="footer-column">
							<h4>Explore</h4>
							<a href="restaurant">Home</a> <a href="#restaurants">Restaurants</a>
							<a href="Cart.jsp">My Cart</a> <a
								href="<%=request.getContextPath()%>/MyOrdersServlet">My
								Orders</a>
						</div>

						<div class="footer-column">
							<h4>Account</h4>
							<a href="#">Profile</a>
							 <a href="<%=request.getContextPath()%>/Login.jsp">Sign In</a>
						     <a href="<%=request.getContextPath()%>/Register.jsp">Create Account</a>
						     <a href="#">Log Out</a>
						</div>

						<div class="footer-column">
							<h4>Contact</h4>
							<span>Bengaluru, Karnataka</span> <span>+91 8317415917</span> <span>support@tapfoods.com</span>
						</div>

					</div>

					<div class="footer-bottom">
						<span>© 2026 TapFoods. All rights reserved.</span>

						<div class="social-links">
							<a href="#" class="social-link" aria-label="Instagram">◎</a> <a
								href="#" class="social-link" aria-label="Facebook">f</a> <a
								href="#" class="social-link" aria-label="Twitter">𝕏</a> <a
								href="#" class="social-link" aria-label="LinkedIn">in</a>
						</div>
					</div>

				</footer>

			</main>

		</div>

	</div>

	<script>
	const searchInput =
		document.getElementById("restaurantSearch");

	const restaurantCards =
		Array.from(document.querySelectorAll(".restaurant-card"));

	const categoryButtons =
		Array.from(document.querySelectorAll(".category-button"));

	const filteredEmptyState =
		document.getElementById("filteredEmptyState");

	const restaurantCountElement =
		document.getElementById("restaurantCount");

	let selectedCategory = "all";

	function filterRestaurants() {

		const searchText =
			searchInput
				? searchInput.value.trim().toLowerCase()
				: "";

		let visibleCount = 0;

		restaurantCards.forEach(function(card) {

			const restaurantName =
				card.dataset.name || "";

			const cuisine =
				card.dataset.cuisine || "";

			const matchesSearch =
				restaurantName.includes(searchText) ||
				cuisine.includes(searchText);

			const matchesCategory =
				selectedCategory === "all" ||
				cuisine.includes(selectedCategory);

			const showCard =
				matchesSearch && matchesCategory;

			card.style.display =
				showCard ? "" : "none";

			if (showCard) {
				visibleCount++;
			}
		});

		if (filteredEmptyState) {
			filteredEmptyState.style.display =
				visibleCount === 0 && restaurantCards.length > 0
					? "block"
					: "none";
		}

		if (restaurantCountElement) {
			restaurantCountElement.textContent =
				visibleCount +
				(visibleCount === 1
					? " restaurant available"
					: " restaurants available");
		}
	}

	if (searchInput) {
		searchInput.addEventListener("input", filterRestaurants);
	}

	categoryButtons.forEach(function(button) {

		button.addEventListener("click", function() {

			categoryButtons.forEach(function(item) {
				item.classList.remove("active");
			});

			button.classList.add("active");

			selectedCategory =
				button.dataset.category || "all";

			filterRestaurants();
		});
	});
</script>

</body>
</html>
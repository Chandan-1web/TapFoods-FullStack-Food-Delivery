<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.food.Model.Menu"%>
<%@ page import="com.food.Model.Cart"%>
<%@ page import="com.food.Model.User"%>

<%
List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");

int menuCount = menuList != null ? menuList.size() : 0;

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

<title>TapFoods | Menu</title>

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

	--red: #ff5d5d;
	--red-soft: rgba(255, 93, 93, 0.12);

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

	background:
		linear-gradient(
			180deg,
			rgba(255, 255, 255, 0.018),
			transparent
		),
		var(--sidebar);
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
		0 11px 26px rgba(240, 74, 22, 0.25);
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
		0 12px 27px rgba(240, 74, 22, 0.21);
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

	border: 1px solid var(--line);
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
	color: #ffffff;

	font-size: 14px;

	transition:
		border-color 0.22s ease,
		box-shadow 0.22s ease;
}

.header-search input::placeholder {
	color: #747480;
}

.header-search input:focus {
	border-color: var(--orange);

	box-shadow:
		0 0 0 4px rgba(240, 74, 22, 0.11);
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
	padding: 25px 28px 60px;
}

/* =====================================================
   HERO
===================================================== */

.hero {
	position: relative;

	min-height: 315px;
	padding: 36px 40px;

	display: grid;
	grid-template-columns: 1.12fr 0.88fr;
	align-items: center;
	gap: 28px;

	overflow: hidden;

	border-radius: var(--radius-xl);

	background:
		linear-gradient(
			135deg,
			var(--orange),
			var(--orange-light)
		);

	box-shadow:
		0 22px 48px rgba(240, 74, 22, 0.17);
}

.hero::before {
	content: "";

	position: absolute;
	left: -95px;
	bottom: -175px;

	width: 340px;
	height: 340px;

	border-radius: 50%;

	background: rgba(255, 255, 255, 0.08);
}

.hero::after {
	content: "";

	position: absolute;
	top: -180px;
	right: 21%;

	width: 340px;
	height: 340px;

	border-radius: 50%;

	background: rgba(255, 255, 255, 0.05);
}

.hero-content,
.hero-visual {
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

	border: 1px solid rgba(255, 255, 255, 0.2);
	border-radius: 999px;

	background: rgba(255, 255, 255, 0.11);

	font-size: 12px;
	font-weight: 800;
}

.hero-tag-dot {
	width: 8px;
	height: 8px;

	border-radius: 50%;

	background: var(--green-light);

	box-shadow:
		0 0 0 5px rgba(49, 220, 123, 0.16);
}

.hero h1 {
	max-width: 690px;

	font-size: clamp(3rem, 4.6vw, 5.05rem);
	line-height: 0.98;
	letter-spacing: -4px;
}

.hero h1 span {
	color: #202029;
}

.hero p {
	max-width: 620px;
	margin-top: 18px;

	color: rgba(255, 255, 255, 0.84);
	font-size: 16px;
	line-height: 1.72;
}

.hero-stats {
	margin-top: 25px;

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
	color: rgba(255, 255, 255, 0.74);
	font-size: 11px;
	font-weight: 700;
}

.hero-visual {
	min-height: 235px;

	display: grid;
	place-items: center;
}

.menu-plate {
	position: relative;

	width: min(285px, 88%);
	aspect-ratio: 1;

	border-radius: 50%;

	background: rgba(255, 255, 255, 0.13);

	box-shadow:
		inset 0 0 0 21px rgba(255, 255, 255, 0.04);
}

.menu-plate img {
	position: absolute;
	inset: 8%;

	width: 84%;
	height: 84%;

	border-radius: 50%;
	object-fit: cover;

	box-shadow:
		0 23px 48px rgba(0, 0, 0, 0.34);

	transform: rotate(-5deg);
}

.hero-floating {
	position: absolute;
	z-index: 4;

	min-width: 145px;
	padding: 12px;

	display: flex;
	align-items: center;
	gap: 9px;

	border: 1px solid rgba(255, 255, 255, 0.12);
	border-radius: 14px;

	background: rgba(23, 23, 31, 0.86);
	backdrop-filter: blur(12px);

	box-shadow:
		0 15px 32px rgba(0, 0, 0, 0.25);
}

.hero-floating-one {
	left: -15px;
	bottom: 29px;
}

.hero-floating-two {
	right: -12px;
	top: 35px;
}

.hero-floating-icon {
	width: 34px;
	height: 34px;

	display: grid;
	place-items: center;

	border-radius: 10px;

	background: var(--green-soft);
	color: var(--green);

	font-size: 15px;
}

.hero-floating-copy {
	display: grid;
	gap: 2px;
}

.hero-floating-copy strong {
	font-size: 11px;
}

.hero-floating-copy span {
	color: var(--muted);
	font-size: 9px;
}

/* =====================================================
   FILTER AREA
===================================================== */

.menu-toolbar {
	margin-top: 34px;
	padding: 20px;

	display: grid;
	grid-template-columns: minmax(260px, 1fr) auto;
	align-items: center;
	gap: 18px;

	border: 1px solid var(--line);
	border-radius: var(--radius-lg);

	background:
		linear-gradient(
			180deg,
			rgba(255, 255, 255, 0.018),
			transparent
		),
		var(--panel);
}

.toolbar-search {
	position: relative;
}

.toolbar-search span {
	position: absolute;
	left: 15px;
	top: 50%;
	transform: translateY(-50%);

	color: #747480;
	font-size: 17px;
}

.toolbar-search input {
	width: 100%;
	height: 49px;
	padding: 0 17px 0 45px;

	border: 1px solid var(--line);
	outline: none;
	border-radius: 14px;

	background: var(--panel-soft);
	color: #ffffff;

	font-size: 14px;

	transition:
		border-color 0.22s ease,
		box-shadow 0.22s ease;
}

.toolbar-search input::placeholder {
	color: #747480;
}

.toolbar-search input:focus {
	border-color: var(--orange);

	box-shadow:
		0 0 0 4px rgba(240, 74, 22, 0.11);
}

.filter-strip {
	display: flex;
	gap: 10px;

	overflow-x: auto;

	scrollbar-width: none;
}

.filter-strip::-webkit-scrollbar {
	display: none;
}

.filter-button {
	min-height: 45px;
	padding: 0 17px;

	display: inline-flex;
	align-items: center;
	gap: 8px;

	flex: 0 0 auto;

	border: 1px solid var(--line);
	border-radius: 13px;

	background: var(--panel-soft);
	color: var(--muted-light);

	font-size: 12px;
	font-weight: 800;
	cursor: pointer;

	transition:
		transform 0.22s ease,
		color 0.22s ease,
		background 0.22s ease,
		border-color 0.22s ease;
}

.filter-button:hover {
	transform: translateY(-2px);
	color: #ffffff;
	background: var(--panel-hover);
}

.filter-button.active {
	border-color: var(--orange);
	background: var(--orange);
	color: #ffffff;
}

/* =====================================================
   MENU SECTION
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

.menu-count {
	color: var(--green);
	font-size: 13px;
	font-weight: 800;
}

/* =====================================================
   MENU CARDS
===================================================== */

.menu-grid {
	width: 100%;

	display: grid;
	grid-template-columns:
		repeat(3, minmax(0, 1fr));
	gap: 21px;

	align-items: stretch;
}

.menu-card {
	min-width: 0;

	display: flex;
	flex-direction: column;

	overflow: hidden;

	border: 1px solid var(--line);
	border-radius: var(--radius-lg);

	background:
		linear-gradient(
			180deg,
			rgba(255, 255, 255, 0.018),
			transparent
		),
		var(--panel);

	box-shadow:
		0 11px 27px rgba(0, 0, 0, 0.22);

	transition:
		transform 0.28s ease,
		border-color 0.28s ease,
		box-shadow 0.28s ease;
}

.menu-card:hover {
	transform: translateY(-6px);

	border-color: rgba(240, 74, 22, 0.39);

	box-shadow:
		0 20px 39px rgba(0, 0, 0, 0.31);
}

.menu-media {
	position: relative;

	height: 205px;

	overflow: hidden;

	background: var(--panel-soft);
}

.menu-media::after {
	content: "";

	position: absolute;
	inset: 0;

	background:
		linear-gradient(
			180deg,
			transparent 38%,
			rgba(13, 13, 18, 0.82) 100%
		);

	pointer-events: none;
}

.menu-media img {
	width: 100%;
	height: 100%;

	object-fit: cover;

	transition: transform 0.5s ease;
}

.menu-card:hover .menu-media img {
	transform: scale(1.055);
}

.price-badge {
	position: absolute;
	top: 12px;
	right: 12px;
	z-index: 3;

	min-height: 34px;
	padding: 0 12px;

	display: inline-flex;
	align-items: center;
	justify-content: center;

	border: 1px solid rgba(255, 255, 255, 0.08);
	border-radius: 11px;

	background: rgba(18, 18, 25, 0.9);
	backdrop-filter: blur(10px);

	color: #ffffff;
	font-size: 13px;
	font-weight: 900;
}

.availability-badge {
	position: absolute;
	left: 12px;
	bottom: 12px;
	z-index: 3;

	min-height: 31px;
	padding: 0 11px;

	display: inline-flex;
	align-items: center;
	gap: 7px;

	border: 1px solid rgba(255, 255, 255, 0.08);
	border-radius: 999px;

	background: rgba(18, 18, 25, 0.88);
	backdrop-filter: blur(10px);

	font-size: 10px;
	font-weight: 800;
	letter-spacing: 0.7px;
	text-transform: uppercase;
}

.availability-badge::before {
	content: "";

	width: 7px;
	height: 7px;

	border-radius: 50%;

	background: var(--green);

	box-shadow:
		0 0 0 4px rgba(32, 191, 99, 0.13);
}

.availability-badge.unavailable::before {
	background: var(--red);

	box-shadow:
		0 0 0 4px rgba(255, 93, 93, 0.13);
}

.menu-content {
	padding: 19px;

	display: flex;
	flex-direction: column;
	flex: 1;
}

.menu-topline {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
}

.menu-category {
	color: var(--orange-light);
	font-size: 11px;
	font-weight: 800;
	letter-spacing: 1px;
	text-transform: uppercase;
}

.menu-hot {
	display: inline-flex;
	align-items: center;
	gap: 6px;

	color: var(--muted-light);
	font-size: 11px;
	font-weight: 700;
	white-space: nowrap;
}

.menu-name {
	margin-top: 10px;

	font-size: 24px;
	line-height: 1.22;
	letter-spacing: -0.65px;
}

.menu-description {
	min-height: 65px;
	margin-top: 11px;

	color: var(--muted);
	font-size: 13px;
	line-height: 1.6;
}

.menu-footer {
	margin-top: auto;
	padding-top: 17px;

	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;

	border-top: 1px solid var(--line);
}

.menu-price {
	display: grid;
	gap: 2px;
}

.menu-price small {
	color: var(--muted);
	font-size: 10px;
	font-weight: 700;
	text-transform: uppercase;
	letter-spacing: 0.8px;
}

.menu-price strong {
	font-size: 20px;
	color: #ffffff;
}

.add-button {
	min-height: 43px;
	padding: 0 17px;

	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 8px;

	flex: 0 0 auto;

	border-radius: 12px;

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
		0 10px 22px rgba(32, 191, 99, 0.18);

	transition:
		transform 0.22s ease,
		box-shadow 0.22s ease,
		filter 0.22s ease;
}

.add-button:hover {
	transform: translateY(-2px);
	filter: brightness(1.04);

	box-shadow:
		0 14px 27px rgba(32, 191, 99, 0.26);
}

.add-button:disabled {
	cursor: not-allowed;

	background: #34343f;
	color: #888894;

	box-shadow: none;
	transform: none;
}

/* =====================================================
   EMPTY STATE
===================================================== */

.empty-state {
	grid-column: 1 / -1;

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

	border-top: 1px solid var(--line);

	color: #70707b;
	font-size: 11px;
}

/* =====================================================
   RESPONSIVE
===================================================== */

@media (min-width: 1500px) {
	.menu-grid {
		grid-template-columns:
			repeat(4, minmax(0, 1fr));
	}

	.menu-media {
		height: 195px;
	}
}

@media (max-width: 1200px) {
	:root {
		--sidebar-width: 220px;
	}

	.menu-grid {
		grid-template-columns:
			repeat(2, minmax(0, 1fr));
	}

	.menu-toolbar {
		grid-template-columns: 1fr;
	}

	.footer-main {
		grid-template-columns:
			1.2fr repeat(2, 0.8fr);
	}

	.footer-column:last-child {
		display: none;
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

	.menu-grid {
		grid-template-columns:
			repeat(2, minmax(0, 1fr));
	}
}

@media (max-width: 620px) {
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

	.menu-toolbar {
		padding: 15px;
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

	.menu-grid {
		grid-template-columns: 1fr;
		gap: 18px;
	}

	.menu-media {
		height: 225px;
	}

	.menu-name {
		font-size: 23px;
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
</head>

<body>

<div class="app-shell">

	<aside class="sidebar">

		<div class="sidebar-top">

			<a href="restaurant" class="brand">
				<span class="brand-icon">🍴</span>

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

			<p class="sidebar-label">Main menu</p>

			<nav class="sidebar-menu">

				<a href="restaurant" class="sidebar-link">
					<span class="sidebar-icon">⌂</span>
					<span>Home</span>
				</a>

				<a href="restaurant#restaurants" class="sidebar-link">
					<span class="sidebar-icon">🍽</span>
					<span>Restaurants</span>
				</a>

				<a href="#" class="sidebar-link active">
					<span class="sidebar-icon">📖</span>
					<span>Menu</span>
				</a>

				<a href="Cart.jsp" class="sidebar-link">
					<span class="sidebar-icon">🛒</span>
					<span>My Cart</span>
					<span class="sidebar-count"><%=cartCount%></span>
				</a>

				
            <a href="<%=request.getContextPath()%>/MyOrdersServlet" class="sidebar-link">
                <span class="sidebar-icon">📦</span>
                <span>My Orders</span>
            </a>

			</nav>

			<div class="sidebar-divider"></div>

			<p class="sidebar-label">Account</p>

			<nav class="sidebar-menu">

				<a href="<%=request.getContextPath()%>/ProfileServlet" class="sidebar-link">
					<span class="sidebar-icon">👤</span>
					<span>Profile</span>
				</a>

				<a href="<%=request.getContextPath()%>/Login.jsp" class="sidebar-link">
					<span class="sidebar-icon">⇥</span>
					<span>Sign In</span>
				</a>

				<a href="<%=request.getContextPath()%>/Register.jsp" class="sidebar-link">
					<span class="sidebar-icon">＋</span>
					<span>Register</span>
				</a>

			</nav>

			<div class="sidebar-bottom">

				<div class="help-card">

					<div class="help-icon">?</div>

					<h4>Need assistance?</h4>

					<p>
						Our support team is ready to help with your food orders.
					</p>

					<a href="#">Contact support →</a>

				</div>

			</div>

		</div>

	</aside>

	<div class="main-area">

		<header class="top-header">

			<div class="header-left">

				<button class="mobile-menu" type="button">☰</button>

				<a href="restaurant" class="back-link">
					<span>←</span>
					Restaurants
				</a>

			</div>

			<div class="header-actions">

				<div class="header-search">
					<span>⌕</span>

					<input
						id="headerMenuSearch"
						type="text"
						placeholder="Search menu items">
				</div>

				<a href="Cart.jsp" class="header-button" aria-label="Open cart">
					🛒
				</a>

				<button
					class="header-button"
					type="button"
					aria-label="Notifications">

					🔔

					<span class="notification-dot"></span>

				</button>

				<a href="<%=request.getContextPath()%>/ProfileServlet" class="profile-chip">

					<span class="profile-avatar"><%=initials%></span>

					<span class="profile-copy">
						<strong><%=displayName%></strong>
						<small>Customer account</small>
					</span>

				</a>

			</div>

		</header>

		<main class="page-content">

			<section class="menu-toolbar">

				<div class="toolbar-search">

					<span>⌕</span>

					<input
						id="menuSearch"
						type="text"
						placeholder="Search dishes by name, description or price">

				</div>

				<div class="filter-strip">

					<button
						type="button"
						class="filter-button active"
						data-filter="all">

						<span>🍽</span>
						All

					</button>

					<button
						type="button"
						class="filter-button"
						data-filter="biryani">

						<span>🍛</span>
						Biryani

					</button>

					<button
						type="button"
						class="filter-button"
						data-filter="dosa">

						<span>🥞</span>
						Dosa

					</button>

					<button
						type="button"
						class="filter-button"
						data-filter="rice">

						<span>🍚</span>
						Rice

					</button>

					<button
						type="button"
						class="filter-button"
						data-filter="chicken">

						<span>🍗</span>
						Chicken

					</button>

					<button
						type="button"
						class="filter-button"
						data-filter="veg">

						<span>🥗</span>
						Veg

					</button>

				</div>

			</section>

			<section class="section">

				<div class="section-heading">

					<div>

						<p class="section-kicker">
							Popular dishes
						</p>

						<h2>
							Explore the menu
						</h2>

						<p>
							Choose a dish and add it directly to your cart.
						</p>

					</div>

					<span class="menu-count" id="menuCount">
						<%=menuCount%>
						<%=menuCount == 1 ? "item available" : "items available"%>
					</span>

				</div>

				<div class="menu-grid" id="menuGrid">

					<%
					if (menuList != null && !menuList.isEmpty()) {

						for (Menu menu : menuList) {

							String itemName =
								menu.getItemName() != null
									? menu.getItemName()
									: "Menu Item";

							String description =
								menu.getDescription() != null
									? menu.getDescription()
									: "Freshly prepared and served with care.";

							String imagePath =
								menu.getImagePath() != null &&
								!menu.getImagePath().trim().isEmpty()
									? menu.getImagePath()
									: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=1000&q=85";

							String searchableText =
								(itemName + " " + description + " "
								+ String.format("%.2f", menu.getPrice()))
								.toLowerCase();
					%>

					<article
						class="menu-card"
						data-search="<%=searchableText%>">

						<div class="menu-media">

							<img
								src="<%=imagePath%>"
								alt="<%=itemName%>"
								loading="lazy">

							<div class="price-badge">
								₹<%=String.format("%.2f", menu.getPrice())%>
							</div>

							<div
								class="availability-badge <%=menu.isAvailable() ? "" : "unavailable"%>">

								<%=menu.isAvailable() ? "Available" : "Unavailable"%>

							</div>

						</div>

						<div class="menu-content">

							<div class="menu-topline">

								<span class="menu-category">
									Popular choice
								</span>

								<span class="menu-hot">
									<span>🔥</span>
									Customer favourite
								</span>

							</div>

							<h3 class="menu-name">
								<%=itemName%>
							</h3>

							<p class="menu-description">
								<%=description%>
							</p>

							<div class="menu-footer">

								<div class="menu-price">

									<small>Price</small>

									<strong>
										₹<%=String.format("%.2f", menu.getPrice())%>
									</strong>

								</div>

								<form action="<%=request.getContextPath()%>/CartServlet" method="post">

									<input
										type="hidden"
										name="menuId"
										value="<%=menu.getMenuID()%>">

									<input
										type="hidden"
										name="restaurantId"
										value="<%=menu.getRestaurantID()%>">

									<input
										type="hidden"
										name="qty"
										value="1">

									<input
										type="hidden"
										name="action"
										value="add">

									<button
										type="submit"
										class="add-button"
										<%=menu.isAvailable() ? "" : "disabled"%>>

										<span>＋</span>

										<%=menu.isAvailable() ? "Add to Cart" : "Unavailable"%>

									</button>

								</form>

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

						<h3>No menu items available</h3>

						<p>
							Menu items will appear here once they are added for this restaurant.
						</p>

					</div>

					<%
					}
					%>

				</div>

				<div
					class="empty-state"
					id="filteredEmptyState"
					style="display:none; margin-top:18px;">

					<div class="empty-icon">⌕</div>

					<h3>No matching dishes</h3>

					<p>
						Try another search term or select a different category.
					</p>

				</div>

			</section>

			<footer class="footer">

				<div class="footer-main">

					<div class="footer-brand">

						<a href="restaurant" class="brand">

							<span class="brand-icon">🍴</span>

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
						<h4>Explore</h4>
						<a href="restaurant">Home</a>
						<a href="restaurant#restaurants">Restaurants</a>
						<a href="Cart.jsp">My Cart</a>
						<a href="<%=request.getContextPath()%>/MyOrdersServlet">My Orders</a>
					</div>

					<div class="footer-column">
						<h4>Account</h4>
						<a href="<%=request.getContextPath()%>/ProfileServlet">Profile</a>
						<a href="<%=request.getContextPath()%>/Login.jsp">Sign In</a>
						<a href="<%=request.getContextPath()%>/Register.jsp">Create Account</a>
						<a href="<%=request.getContextPath()%>/LogoutServlet">Log Out</a>
					</div>

					<div class="footer-column">
						<h4>Contact</h4>
						<span>Bengaluru, Karnataka</span>
						<span>+91 8317415917</span>
						<span>support@tapfoods.com</span>
					</div>

				</div>

				<div class="footer-bottom">
					<span>© 2026 TapFoods. All rights reserved.</span>
				</div>

			</footer>

		</main>

	</div>

</div>

<script>
	const headerSearch =
		document.getElementById("headerMenuSearch");

	const menuSearch =
		document.getElementById("menuSearch");

	const menuCards =
		Array.from(document.querySelectorAll(".menu-card"));

	const filterButtons =
		Array.from(document.querySelectorAll(".filter-button"));

	const menuCountElement =
		document.getElementById("menuCount");

	const filteredEmptyState =
		document.getElementById("filteredEmptyState");

	let selectedFilter = "all";

	function getSearchValue() {

		const headerValue =
			headerSearch
				? headerSearch.value.trim().toLowerCase()
				: "";

		const toolbarValue =
			menuSearch
				? menuSearch.value.trim().toLowerCase()
				: "";

		return toolbarValue || headerValue;
	}

	function filterMenuItems() {

		const searchText = getSearchValue();

		let visibleCount = 0;

		menuCards.forEach(function(card) {

			const searchableText =
				card.dataset.search || "";

			const matchesSearch =
				searchableText.includes(searchText);

			const matchesFilter =
				selectedFilter === "all" ||
				searchableText.includes(selectedFilter);

			const showCard =
				matchesSearch && matchesFilter;

			card.style.display =
				showCard ? "" : "none";

			if (showCard) {
				visibleCount++;
			}
		});

		if (filteredEmptyState) {
			filteredEmptyState.style.display =
				visibleCount === 0 && menuCards.length > 0
					? "block"
					: "none";
		}

		if (menuCountElement) {
			menuCountElement.textContent =
				visibleCount +
				(visibleCount === 1
					? " item available"
					: " items available");
		}
	}

	if (headerSearch) {
		headerSearch.addEventListener("input", function() {

			if (menuSearch) {
				menuSearch.value = headerSearch.value;
			}

			filterMenuItems();
		});
	}

	if (menuSearch) {
		menuSearch.addEventListener("input", function() {

			if (headerSearch) {
				headerSearch.value = menuSearch.value;
			}

			filterMenuItems();
		});
	}

	filterButtons.forEach(function(button) {

		button.addEventListener("click", function() {

			filterButtons.forEach(function(item) {
				item.classList.remove("active");
			});

			button.classList.add("active");

			selectedFilter =
				button.dataset.filter || "all";

			filterMenuItems();
		});
	});
</script>

</body>
</html>
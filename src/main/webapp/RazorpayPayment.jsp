<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.food.Model.User" %>

<%
User user =
		(User) session.getAttribute("user");

String razorpayOrderId =
		(String) session.getAttribute("razorpayOrderId");

Long razorpayAmount =
		(Long) session.getAttribute("razorpayAmount");

String razorpayKeyId =
		(String) session.getAttribute("razorpayKeyId");

Double grandTotal =
		(Double) session.getAttribute("pendingGrandTotal");

String customerName =
		(String) session.getAttribute("pendingCustomerName");

String phone =
		(String) session.getAttribute("pendingPhone");

if (user == null) {

	response.sendRedirect(
			request.getContextPath()
			+ "/Login.jsp");

	return;
}

if (razorpayOrderId == null
		|| razorpayAmount == null
		|| razorpayKeyId == null
		|| grandTotal == null) {

	response.sendRedirect(
			request.getContextPath()
			+ "/Checkout.jsp");

	return;
}

if (customerName == null) {
	customerName = "";
}

if (phone == null) {
	phone = "";
}
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
	content="width=device-width, initial-scale=1.0">

<title>TapFoods | Secure Payment</title>

<style>

* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

body {

	min-height: 100vh;

	display: flex;
	align-items: center;
	justify-content: center;

	background:
		radial-gradient(
			circle at top right,
			rgba(240, 74, 22, 0.18),
			transparent 35%
		),
		#0d0d12;

	color: #ffffff;

	font-family:
		Arial,
		sans-serif;
}

.payment-card {

	width: min(92%, 520px);

	padding: 40px;

	border: 1px solid rgba(255,255,255,.08);
	border-radius: 24px;

	background: #181820;

	box-shadow:
		0 25px 70px rgba(0,0,0,.45);

	text-align: center;
}

.logo {

	width: 70px;
	height: 70px;

	margin: 0 auto 20px;

	display: grid;
	place-items: center;

	border-radius: 20px;

	background:
		linear-gradient(
			135deg,
			#f04a16,
			#ff6a2f
		);

	font-size: 30px;
}

h1 {

	font-size: 30px;

	margin-bottom: 10px;
}

.description {

	color: #92929f;

	font-size: 14px;

	line-height: 1.7;
}

.amount-box {

	margin: 28px 0;

	padding: 22px;

	border: 1px solid rgba(255,255,255,.08);
	border-radius: 16px;

	background: #202029;
}

.amount-box small {

	display: block;

	margin-bottom: 6px;

	color: #92929f;

	font-size: 11px;

	text-transform: uppercase;

	letter-spacing: 1px;
}

.amount-box strong {

	color: #ff6a2f;

	font-size: 34px;
}

.pay-button {

	width: 100%;

	min-height: 54px;

	border: 0;
	border-radius: 15px;

	background:
		linear-gradient(
			135deg,
			#20bf63,
			#31dc7b
		);

	color: #07140c;

	font-size: 14px;
	font-weight: 900;

	cursor: pointer;
}

.cancel-link {

	margin-top: 18px;

	display: inline-block;

	color: #92929f;

	font-size: 13px;
}

.secure {

	margin-top: 24px;

	color: #20bf63;

	font-size: 12px;
}

</style>

</head>

<body>

<div class="payment-card">

	<div class="logo">
		💳
	</div>

	<h1>
		Secure Online Payment
	</h1>

	<p class="description">
		Complete your TapFoods order securely using Razorpay.
	</p>

	<div class="amount-box">

		<small>
			Amount Payable
		</small>

		<strong>
			₹<%=String.format("%.2f", grandTotal)%>
		</strong>

	</div>

	<button
		type="button"
		class="pay-button"
		id="payButton">

		Pay Securely →

	</button>

	<a
		href="<%=request.getContextPath()%>/Checkout.jsp"
		class="cancel-link">

		← Cancel Payment

	</a>

	<div class="secure">
		✓ Powered by Razorpay Test Mode
	</div>

</div>


<form
	id="paymentSuccessForm"
	action="<%=request.getContextPath()%>/VerifyPaymentServlet"
	method="post"
	style="display:none;">

	<input
		type="hidden"
		name="razorpay_payment_id"
		id="razorpayPaymentId">

	<input
		type="hidden"
		name="razorpay_order_id"
		id="razorpayOrderId">

	<input
		type="hidden"
		name="razorpay_signature"
		id="razorpaySignature">

</form>


<script
	src="https://checkout.razorpay.com/v1/checkout.js">
</script>

<script>

const options = {

	key:
		"<%=razorpayKeyId%>",

	amount:
		"<%=razorpayAmount%>",

	currency:
		"INR",

	name:
		"TapFoods",

	description:
		"Food Order Payment",

	order_id:
		"<%=razorpayOrderId%>",

	handler:
		function (response) {

			document
				.getElementById(
					"razorpayPaymentId"
				)
				.value =
					response
						.razorpay_payment_id;

			document
				.getElementById(
					"razorpayOrderId"
				)
				.value =
					response
						.razorpay_order_id;

			document
				.getElementById(
					"razorpaySignature"
				)
				.value =
					response
						.razorpay_signature;

			document
				.getElementById(
					"paymentSuccessForm"
				)
				.submit();
		},

	prefill: {

		name:
			"<%=customerName.replace("\"", "\\\"")%>",

		email:
			"<%=user.getEmail() != null
				? user.getEmail().replace("\"", "\\\"")
				: ""%>",

		contact:
			"<%=phone.replace("\"", "\\\"")%>"
	},

	theme: {

		color:
			"#f04a16"
	},

	modal: {

		ondismiss:
			function () {

				console.log(
					"Razorpay payment popup closed."
				);
			}
	}
};


const razorpay =
	new Razorpay(
		options
	);


document
	.getElementById(
		"payButton"
	)
	.addEventListener(
		"click",
		function () {

			razorpay.open();
		}
	);


/*
 * Automatically open checkout
 * when this page loads.
 */
window.addEventListener(
	"load",
	function () {

		setTimeout(
			function () {

				razorpay.open();

			},
			400
		);
	}
);

</script>

</body>

</html>
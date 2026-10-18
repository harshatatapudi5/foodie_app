<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Integer orderId = (Integer) session.getAttribute("lastOrderId");
    if (orderId == null) {
        response.sendRedirect(request.getContextPath() + "/orders");
        return;
    }

    String customerName = (String) session.getAttribute("lastOrderName");
    String paymentMethod = (String) session.getAttribute("lastOrderPayment");
    Double orderTotal = (Double) session.getAttribute("lastOrderTotal");
    String deliveryAddress = (String) session.getAttribute("lastOrderAddress");

    if (customerName == null) customerName = user.getName();
    if (paymentMethod == null) paymentMethod = "Online / COD";
    if (orderTotal == null) orderTotal = 0.0;
    if (deliveryAddress == null) deliveryAddress = user.getAddress();

    request.setAttribute("activePage", "orders");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Placed Successfully — Foodie</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Dark Design System -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Foodie/css/theme-dark.css">
</head>
<body>

    <!-- Shared Dark Navbar -->
    <jsp:include page="/Foodie/includes/navbar.jsp" />

    <main class="page-container" style="max-width: 650px; margin: 40px auto 60px; padding: 0 24px;">

        <div style="background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: var(--radius-xl); padding: 40px 32px; text-align: center; box-shadow: var(--shadow-card);">

            <!-- Success Animated Circle -->
            <div style="width: 80px; height: 80px; border-radius: 50%; background: rgba(16,185,129,0.15); border: 2px solid var(--success); color: var(--success); display: flex; align-items: center; justify-content: center; font-size: 38px; margin: 0 auto 24px; box-shadow: 0 0 24px rgba(16,185,129,0.35);">
                ✓
            </div>

            <span style="font-size: 13px; font-weight: 700; color: var(--success); text-transform: uppercase; letter-spacing: 1px;">
                Order Placed Successfully!
            </span>

            <h1 style="font-size: 28px; font-weight: 800; color: #fff; margin: 10px 0 8px;">
                Thank you, <%= customerName %>!
            </h1>

            <p style="color: var(--text-secondary); font-size: 14.5px; line-height: 1.5; margin-bottom: 28px;">
                Your order <strong style="color: var(--primary);">#ORD-<%= orderId %></strong> has been received by the kitchen and will be delivered shortly.
            </p>

            <!-- Order Details Pill Box -->
            <div style="background: var(--bg-surface); border: 1px solid var(--border-subtle); border-radius: var(--radius-lg); padding: 20px; text-align: left; margin-bottom: 28px; display: flex; flex-direction: column; gap: 12px; font-size: 13.5px;">
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--text-muted);">Order Number:</span>
                    <strong style="color: #fff;">#ORD-<%= orderId %></strong>
                </div>
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--text-muted);">Amount Paid:</span>
                    <strong style="color: var(--primary);">₹<%= String.format("%.2f", orderTotal) %></strong>
                </div>
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--text-muted);">Payment Method:</span>
                    <strong style="color: #fff;"><%= paymentMethod %></strong>
                </div>
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--text-muted);">Delivery Location:</span>
                    <strong style="color: #fff; text-align: right; max-width: 280px;"><%= deliveryAddress %></strong>
                </div>
            </div>

            <!-- Action Buttons -->
            <div style="display: flex; flex-direction: column; gap: 12px;">
                <a href="<%= request.getContextPath() %>/orders?trackOrderId=<%= orderId %>" class="btn-primary" style="padding: 14px; font-size: 15px; border-radius: var(--radius-pill); font-weight: 700; display: flex; align-items: center; justify-content: center; gap: 8px;">
                    <span>Live Order Tracking</span>
                    <span>🛵</span>
                </a>

                <div style="display: flex; gap: 12px;">
                    <a href="<%= request.getContextPath() %>/orders" class="btn-secondary" style="flex: 1; padding: 12px; font-size: 13.5px; border-radius: var(--radius-pill); text-align: center;">
                        My Order History
                    </a>
                    <a href="<%= request.getContextPath() %>/restaurant" class="btn-secondary" style="flex: 1; padding: 12px; font-size: 13.5px; border-radius: var(--radius-pill); text-align: center;">
                        Browse More Food
                    </a>
                </div>
            </div>

        </div>

    </main>

    <!-- Shared Dark Footer -->
    <jsp:include page="/Foodie/includes/footer.jsp" />

</body>
</html>

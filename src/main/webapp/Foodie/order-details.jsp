<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.tap.model.OrdersDetails" %>
<%@ page import="com.tap.model.OrderItem" %>
<%@ page import="com.tap.model.MenuData" %>
<%@ page import="com.tap.model.ResDetails" %>
<%@ page import="com.tap.model.User" %>

<%
    User user = (User) session.getAttribute("user");
    OrdersDetails order = (OrdersDetails) request.getAttribute("order");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (order == null) {
        response.sendRedirect(request.getContextPath() + "/orders");
        return;
    }

    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
    Map<Integer, MenuData> menuMap = (Map<Integer, MenuData>) request.getAttribute("menuMap");
    ResDetails restaurant = (ResDetails) request.getAttribute("restaurant");

    String resName = (restaurant != null && restaurant.getResName() != null) ? restaurant.getResName() : "Partner Restaurant";
    String resAddress = (restaurant != null && restaurant.getAddress() != null) ? restaurant.getAddress() : "Hyderabad";

    String dateStr = "Recent";
    if (order.getOrder_date() != null) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
            dateStr = sdf.format(order.getOrder_date());
        } catch (Exception ignored) {}
    }

    request.setAttribute("activePage", "orders");
    request.setAttribute("backUrl", request.getContextPath() + "/orders");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Receipt #<%= order.getOders_id() %> — Foodie</title>
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

    <main class="page-container" style="max-width: 850px; margin: 28px auto; padding: 0 24px;">

        <div style="margin-bottom: 20px;">
            <a href="<%= request.getContextPath() %>/orders" class="btn-secondary" style="font-size: 13px; padding: 6px 16px; border-radius: var(--radius-pill); display: inline-flex; align-items: center; gap: 8px;">
                ← Back to All Orders
            </a>
        </div>

        <div style="background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: var(--radius-xl); padding: 32px;">

            <!-- Header -->
            <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 16px; border-bottom: 1px solid var(--border-subtle); padding-bottom: 24px; margin-bottom: 24px;">
                <div>
                    <span style="font-size: 12px; background: rgba(255,87,34,0.15); color: var(--primary); padding: 4px 10px; border-radius: var(--radius-pill); font-weight: 700;">
                        Official Foodie Receipt
                    </span>
                    <h1 style="font-size: 24px; font-weight: 800; color: #fff; margin-top: 8px;">
                        Order #ORD-<%= order.getOders_id() %>
                    </h1>
                    <div style="font-size: 13px; color: var(--text-muted); margin-top: 4px;">
                        Placed on <%= dateStr %> • Status: <strong style="color: var(--success);"><%= (order.getStatus() != null) ? order.getStatus() : "Delivered" %></strong>
                    </div>
                </div>

                <div style="text-align: right;">
                    <a href="<%= request.getContextPath() %>/orders?trackOrderId=<%= order.getOders_id() %>" class="btn-primary" style="padding: 8px 18px; font-size: 13px; border-radius: var(--radius-pill); display: inline-flex; align-items: center; gap: 6px;">
                        <span>Track Order</span> <span>🛵</span>
                    </a>
                </div>
            </div>

            <!-- Restaurant Info -->
            <div style="background: var(--bg-surface); border: 1px solid var(--border-subtle); border-radius: var(--radius-lg); padding: 18px 22px; display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px;">
                <div style="display: flex; align-items: center; gap: 14px;">
                    <span style="font-size: 26px;">🏪</span>
                    <div>
                        <h3 style="font-size: 16px; font-weight: 700; color: #fff;"><%= resName %></h3>
                        <p style="font-size: 12.5px; color: var(--text-muted);"><%= resAddress %></p>
                    </div>
                </div>
                <a href="<%= request.getContextPath() %>/menu?resId=<%= order.getRes_id() %>" class="btn-secondary" style="font-size: 12.5px; padding: 6px 14px; border-radius: var(--radius-pill);">
                    View Menu
                </a>
            </div>

            <!-- Itemized Table -->
            <h3 style="font-size: 16px; font-weight: 700; color: #fff; margin-bottom: 14px;">Items Ordered</h3>
            <div style="display: flex; flex-direction: column; gap: 12px; margin-bottom: 24px;">
                <% if (orderItems != null && !orderItems.isEmpty()) {
                    for (OrderItem item : orderItems) {
                        MenuData m = (menuMap != null) ? menuMap.get(item.getM_id()) : null;
                        String itemName = (m != null && m.getItemName() != null) ? m.getItemName() : "Food Item #" + item.getM_id();
                %>
                    <div style="background: var(--bg-input); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 14px 18px; display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <div style="font-weight: 700; color: #fff; font-size: 14px;"><%= itemName %></div>
                            <div style="font-size: 12px; color: var(--text-muted);">Quantity: <%= item.getQuantity() %></div>
                        </div>
                        <div style="font-size: 15px; font-weight: 700; color: var(--primary);">
                            ₹<%= String.format("%.2f", item.getItemTotal()) %>
                        </div>
                    </div>
                <% } } %>
            </div>

            <!-- Bill Breakdown -->
            <div class="bill-rows" style="border-top: 1px solid var(--border-subtle); padding-top: 18px;">
                <div class="bill-row">
                    <span>Payment Method</span>
                    <span style="font-weight: 600; color: #fff;"><%= (order.getPayment() != null) ? order.getPayment() : "Online Payment" %></span>
                </div>
                <div class="bill-row total">
                    <span>Grand Total</span>
                    <span class="price">₹<%= String.format("%.2f", order.getTotalamount()) %></span>
                </div>
            </div>

            <!-- Print Receipt / Download Button -->
            <div style="margin-top: 24px; text-align: right;">
                <button type="button" class="btn-secondary" onclick="window.print()" style="font-size: 13px; padding: 8px 18px; border-radius: var(--radius-pill);">
                    🖨️ Print Receipt
                </button>
            </div>

        </div>

    </main>

    <!-- Shared Dark Footer -->
    <jsp:include page="/Foodie/includes/footer.jsp" />

</body>
</html>

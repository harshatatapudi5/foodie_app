<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.OrdersDetails" %>
<%@ page import="com.tap.model.OrderItem" %>
<%@ page import="com.tap.model.MenuData" %>
<%@ page import="com.tap.model.ResDetails" %>
<%@ page import="com.tap.DAOImp.OrdersDAOImpl" %>
<%@ page import="com.tap.DAOImp.OItemDAOImp" %>
<%@ page import="com.tap.DAOImp.DAOImp" %>
<%@ page import="com.tap.DAOImp.DAOImpRes" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<OrdersDetails> orders = (List<OrdersDetails>) request.getAttribute("orders");
    Map<Integer, List<OrderItem>> orderItemsMap = (Map<Integer, List<OrderItem>>) request.getAttribute("orderItemsMap");
    Map<Integer, MenuData> menuMap = (Map<Integer, MenuData>) request.getAttribute("menuMap");
    Map<Integer, ResDetails> restaurantMap = (Map<Integer, ResDetails>) request.getAttribute("restaurantMap");

    // If accessed directly without controller forward, load from DAOs safely
    if (orders == null) {
        try {
            OrdersDAOImpl orderDAO = new OrdersDAOImpl();
            orders = orderDAO.getOrdersByUser(user.getId());
        } catch (Exception ignored) {}
    }

    request.setAttribute("activePage", "orders");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders — Foodie</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Dark Design System -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Foodie/css/theme-dark.css">
    <style>
        .order-history-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 24px 28px;
            margin-bottom: 24px;
            transition: all 0.25s ease;
        }
        .order-history-card:hover {
            border-color: var(--border-medium);
            box-shadow: var(--shadow-card);
            transform: translateY(-2px);
        }
        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: var(--radius-pill);
            font-size: 12px;
            font-weight: 700;
        }
        .status-pill.delivered {
            background: rgba(16,185,129,0.15);
            color: var(--success);
            border: 1px solid var(--success);
        }
        .status-pill.on-way, .status-pill.pending, .status-pill.processing {
            background: rgba(255,87,34,0.15);
            color: var(--primary);
            border: 1px solid var(--primary);
        }
        .status-pill.cancelled {
            background: rgba(239,68,68,0.15);
            color: var(--danger);
            border: 1px solid var(--danger);
        }
    </style>
</head>
<body>

    <!-- Shared Dark Navbar -->
    <jsp:include page="/Foodie/includes/navbar.jsp" />

    <main class="page-container" style="max-width: 1050px; margin: 28px auto; padding: 0 24px;">

        <!-- Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; flex-wrap: wrap; gap: 16px;">
            <div>
                <h1 style="font-size: 28px; font-weight: 800; color: #fff; margin-bottom: 4px;">
                    📦 My Order History
                </h1>
                <p style="color: var(--text-secondary); font-size: 14px;">
                    Track ongoing orders and review your previous delicious meals
                </p>
            </div>

            <a href="<%= request.getContextPath() %>/restaurant" class="btn-primary" style="padding: 10px 22px; font-size: 13.5px; border-radius: var(--radius-pill);">
                + Order Something New
            </a>
        </div>

        <% if (orders == null || orders.isEmpty()) { %>
            <!-- Empty State -->
            <div class="empty-state-view" style="background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: var(--radius-xl); margin: 40px auto;">
                <span class="empty-state-icon">🍽️</span>
                <h2 class="empty-state-title">No Orders Placed Yet</h2>
                <p class="empty-state-text">
                    Hungry? Browse from our top-rated restaurants, select your favorite dishes, and have them delivered to your doorstep in minutes!
                </p>
                <a href="<%= request.getContextPath() %>/restaurant" class="btn-primary" style="padding: 12px 28px; font-size: 14px; border-radius: var(--radius-pill);">
                    Browse Restaurants Now →
                </a>
            </div>
        <% } else { %>
            <!-- Orders List -->
            <div>
                <%
                    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

                    for (OrdersDetails o : orders) {
                        int orderId = o.getOders_id();
                        String statusStr = (o.getStatus() != null) ? o.getStatus() : "Processing";
                        String statusLower = statusStr.toLowerCase();

                        String statusClass = "delivered";
                        if (statusLower.contains("cancel")) {
                            statusClass = "cancelled";
                        } else if (statusLower.contains("pend") || statusLower.contains("process") || statusLower.contains("way")) {
                            statusClass = "on-way";
                        }

                        ResDetails res = (restaurantMap != null) ? restaurantMap.get(o.getRes_id()) : null;
                        String restaurantName = (res != null && res.getResName() != null) ? res.getResName() : "Partner Restaurant #" + o.getRes_id();
                        String resAddress = (res != null && res.getAddress() != null) ? res.getAddress() : "Hyderabad";

                        List<OrderItem> items = (orderItemsMap != null) ? orderItemsMap.get(orderId) : null;

                        String dateStr = "Recent";
                        if (o.getOrder_date() != null) {
                            try {
                                dateStr = sdf.format(o.getOrder_date());
                            } catch (Exception ignored) {}
                        }
                %>
                    <div class="order-history-card">
                        <!-- Top Bar of Order Card -->
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 14px; border-bottom: 1px solid var(--border-subtle); padding-bottom: 16px; margin-bottom: 16px;">
                            <div style="display: flex; align-items: center; gap: 14px;">
                                <div style="width: 48px; height: 48px; border-radius: var(--radius-md); background: rgba(255,87,34,0.12); display: flex; align-items: center; justify-content: center; font-size: 24px; color: var(--primary);">
                                    🏪
                                </div>
                                <div>
                                    <h3 style="font-size: 18px; font-weight: 700; color: #fff; margin-bottom: 2px;"><%= restaurantName %></h3>
                                    <div style="font-size: 12.5px; color: var(--text-muted);">
                                        📍 <%= resAddress %> • Ordered on <%= dateStr %>
                                    </div>
                                </div>
                            </div>

                            <div style="display: flex; align-items: center; gap: 12px;">
                                <span class="status-pill <%= statusClass %>">
                                    ● <%= statusStr %>
                                </span>
                                <span style="font-size: 13px; color: var(--text-muted); font-weight: 600;">
                                    #ORD-<%= orderId %>
                                </span>
                            </div>
                        </div>

                        <!-- Items Summary -->
                        <div style="margin-bottom: 18px;">
                            <% if (items != null && !items.isEmpty()) { %>
                                <div style="display: flex; flex-direction: column; gap: 8px;">
                                    <%
                                        for (OrderItem item : items) {
                                            MenuData menu = (menuMap != null) ? menuMap.get(item.getM_id()) : null;
                                            String itemName = (menu != null && menu.getItemName() != null) ? menu.getItemName() : "Delicious Dish";
                                    %>
                                        <div style="display: flex; justify-content: space-between; font-size: 13.5px; color: var(--text-secondary);">
                                            <span>
                                                <strong style="color: var(--primary);"><%= item.getQuantity() %> ×</strong> <%= itemName %>
                                            </span>
                                            <span style="font-weight: 600; color: #fff;">
                                                ₹<%= String.format("%.2f", item.getItemTotal()) %>
                                            </span>
                                        </div>
                                    <% } %>
                                </div>
                            <% } else { %>
                                <div style="font-size: 13px; color: var(--text-muted);">
                                    Order placed with <%= restaurantName %>
                                </div>
                            <% } %>
                        </div>

                        <!-- Bottom Summary & Actions -->
                        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 14px; border-top: 1px solid var(--border-subtle); padding-top: 14px;">
                            <div>
                                <span style="font-size: 13px; color: var(--text-muted);">Total Paid: </span>
                                <span style="font-size: 18px; font-weight: 800; color: var(--primary);">
                                    ₹<%= String.format("%.2f", o.getTotalamount()) %>
                                </span>
                                <span style="font-size: 12px; color: var(--text-muted); margin-left: 8px;">
                                    (<%= (o.getPayment() != null) ? o.getPayment() : "Online" %>)
                                </span>
                            </div>

                            <div style="display: flex; gap: 10px; align-items: center;">
                                <a href="<%= request.getContextPath() %>/orders?trackOrderId=<%= orderId %>" class="btn-primary" style="padding: 8px 18px; font-size: 13px; border-radius: var(--radius-pill); display: flex; align-items: center; gap: 6px;">
                                    <span>Live Tracking</span>
                                    <span>🛵</span>
                                </a>

                                <a href="<%= request.getContextPath() %>/menu?resId=<%= o.getRes_id() %>" class="btn-secondary" style="padding: 8px 16px; font-size: 13px; border-radius: var(--radius-pill);">
                                    Reorder 🔄
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>

    </main>

    <!-- Shared Dark Footer -->
    <jsp:include page="/Foodie/includes/footer.jsp" />

</body>
</html>
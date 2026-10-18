<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.OrdersDetails" %>
<%@ page import="com.tap.model.OrderItem" %>
<%@ page import="com.tap.model.ResDetails" %>
<%@ page import="com.tap.DAOImp.DAOImpRes" %>
<%@ page import="com.tap.DAOImp.OItemDAOImp" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    OrdersDetails order = (OrdersDetails) request.getAttribute("order");
    if (order == null) {
        String trackId = request.getParameter("trackOrderId");
        if (trackId == null) trackId = request.getParameter("orderId");
        if (trackId == null && session.getAttribute("lastOrderId") != null) {
            trackId = String.valueOf(session.getAttribute("lastOrderId"));
        }
        if (trackId != null && !trackId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders?trackOrderId=" + trackId.trim());
            return;
        } else {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
    }

    ResDetails restaurant = null;
    if (order.getRes_id() > 0) {
        try {
            DAOImpRes resDAO = new DAOImpRes();
            restaurant = resDAO.getRes(order.getRes_id());
        } catch (Exception ignored) {}
    }
    String resName = (restaurant != null && restaurant.getResName() != null) ? restaurant.getResName() : "Partner Restaurant";
    String resAddress = (restaurant != null && restaurant.getAddress() != null) ? restaurant.getAddress() : "Madhapur, Hyderabad";

    // Delivery address from session or user
    String delAddress = (String) session.getAttribute("lastOrderAddress");
    if (delAddress == null || delAddress.trim().isEmpty()) {
        delAddress = (user.getAddress() != null) ? user.getAddress() : "Hitech City, Hyderabad";
    }

    String orderDateFormatted = "Just now";
    if (order.getOrder_date() != null) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
            orderDateFormatted = sdf.format(order.getOrder_date());
        } catch (Exception ignored) {}
    }

    String status = (order.getStatus() != null) ? order.getStatus() : "Processing";

    request.setAttribute("activePage", "orders");
    request.setAttribute("backUrl", request.getContextPath() + "/orders");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Live Order Tracking #<%= order.getOders_id() %> — Foodie</title>
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

    <main class="page-container" style="max-width: 960px; margin: 24px auto; padding: 0 24px;">

        <!-- Back to Orders link -->
        <div style="margin-bottom: 20px;">
            <a href="<%= request.getContextPath() %>/orders" class="btn-secondary" style="font-size: 13px; padding: 6px 16px; border-radius: var(--radius-pill); display: inline-flex; align-items: center; gap: 8px;">
                ← Back to Order History
            </a>
        </div>

        <div class="tracking-hero-card">

            <!-- Top Header & Status -->
            <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 16px; border-bottom: 1px solid var(--border-subtle); padding-bottom: 20px;">
                <div>
                    <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 6px;">
                        <span style="font-size: 13px; background: rgba(16,185,129,0.15); color: var(--success); border: 1px solid var(--success); padding: 4px 10px; border-radius: var(--radius-pill); font-weight: 700;">
                            ● LIVE TRACKING
                        </span>
                        <span style="font-size: 13px; color: var(--text-muted);">Order #<%= order.getOders_id() %></span>
                    </div>

                    <h1 style="font-size: 26px; font-weight: 800; color: #fff; margin-bottom: 4px;">
                        Your food is on the way! 🛵
                    </h1>
                    <p style="color: var(--text-secondary); font-size: 14px;">
                        Estimated arrival: <strong style="color: var(--primary);">18 – 24 mins</strong> • Placed on <%= orderDateFormatted %>
                    </p>
                </div>

                <div style="text-align: right;">
                    <div style="font-size: 12px; color: var(--text-muted);">Total Amount</div>
                    <div style="font-size: 22px; font-weight: 800; color: var(--primary);">₹<%= String.format("%.2f", order.getTotalamount()) %></div>
                    <span style="font-size: 11px; background: var(--bg-surface); padding: 3px 8px; border-radius: var(--radius-pill); color: var(--text-muted); border: 1px solid var(--border-subtle);">
                        <%= (order.getPayment() != null) ? order.getPayment() : "Paid" %>
                    </span>
                </div>
            </div>

            <!-- Simulated Interactive Map Visualization -->
            <div class="tracking-map-simulation">
                <!-- SVG Route Line -->
                <svg class="map-route-svg" viewBox="0 0 600 80" preserveAspectRatio="none">
                    <defs>
                        <linearGradient id="routeGradient" x1="0%" y1="0%" x2="100%" y2="0%">
                            <stop offset="0%" stop-color="#10B981" />
                            <stop offset="60%" stop-color="#FF5722" />
                            <stop offset="100%" stop-color="#3B82F6" />
                        </linearGradient>
                    </defs>
                    <path d="M 50 40 Q 250 10, 400 45 T 550 40" fill="none" stroke="rgba(255,255,255,0.15)" stroke-width="8" stroke-linecap="round" />
                    <path d="M 50 40 Q 250 10, 400 45 T 550 40" fill="none" stroke="url(#routeGradient)" stroke-width="5" stroke-linecap="round" stroke-dasharray="8 6" />
                </svg>

                <!-- Restaurant Node (Left) -->
                <div style="position: absolute; left: 10%; top: 50%; transform: translateY(-50%); display: flex; flex-direction: column; align-items: center; z-index: 5;">
                    <div style="width: 44px; height: 44px; border-radius: 50%; background: #1E293B; border: 2px solid var(--success); display: flex; align-items: center; justify-content: center; font-size: 20px; box-shadow: 0 4px 14px rgba(16,185,129,0.3);">
                        🏪
                    </div>
                    <span style="font-size: 11.5px; font-weight: 700; color: #fff; margin-top: 6px; background: rgba(0,0,0,0.6); padding: 2px 8px; border-radius: var(--radius-pill);"><%= resName %></span>
                </div>

                <!-- Live Scooter Node (Middle) -->
                <div class="map-scooter-node" title="Delivery Partner Ramesh on the move!">
                    🛵
                </div>

                <!-- Destination House Node (Right) -->
                <div style="position: absolute; right: 10%; top: 50%; transform: translateY(-50%); display: flex; flex-direction: column; align-items: center; z-index: 5;">
                    <div style="width: 44px; height: 44px; border-radius: 50%; background: #1E293B; border: 2px solid #3B82F6; display: flex; align-items: center; justify-content: center; font-size: 20px; box-shadow: 0 4px 14px rgba(59,130,246,0.3);">
                        🏠
                    </div>
                    <span style="font-size: 11.5px; font-weight: 700; color: #fff; margin-top: 6px; background: rgba(0,0,0,0.6); padding: 2px 8px; border-radius: var(--radius-pill);">Your Home</span>
                </div>
            </div>

            <!-- 4-Step Order Status Timeline -->
            <div class="tracking-timeline">
                <div class="tracking-step done">
                    <div class="tracking-step-dot">✓</div>
                    <div class="tracking-step-name">Order Placed</div>
                    <div class="tracking-step-time">Confirmed</div>
                </div>

                <div class="tracking-step done">
                    <div class="tracking-step-dot">✓</div>
                    <div class="tracking-step-name">Preparing Food</div>
                    <div class="tracking-step-time">Kitchen at work</div>
                </div>

                <div class="tracking-step active">
                    <div class="tracking-step-dot">🛵</div>
                    <div class="tracking-step-name" style="color: var(--primary);">On the Way</div>
                    <div class="tracking-step-time" style="color: var(--primary);">Out for delivery</div>
                </div>

                <div class="tracking-step">
                    <div class="tracking-step-dot">🏠</div>
                    <div class="tracking-step-name">Delivered</div>
                    <div class="tracking-step-time">Estimated ~20m</div>
                </div>
            </div>

            <!-- Delivery Partner Card -->
            <div class="delivery-driver-card">
                <div class="driver-info">
                    <div class="driver-avatar">
                        👨‍🦱
                    </div>
                    <div>
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <h3 style="font-size: 16px; font-weight: 700; color: #fff;">Ramesh Kumar</h3>
                            <span style="font-size: 12px; background: var(--warning-bg); color: var(--warning); padding: 2px 6px; border-radius: var(--radius-pill); font-weight: 700;">
                                ★ 4.9 (850+ deliveries)
                            </span>
                        </div>
                        <div style="font-size: 12.5px; color: var(--text-muted); margin-top: 2px;">
                            Your Foodie Delivery Specialist • Electric Scooter (TS 09 EZ 4412)
                        </div>
                    </div>
                </div>

                <div style="display: flex; gap: 10px;">
                    <a href="tel:+919876543210" class="btn-secondary" style="padding: 8px 16px; font-size: 13px; border-radius: var(--radius-pill); display: inline-flex; align-items: center; gap: 6px;">
                        📞 Call Partner
                    </a>
                    <button type="button" class="btn-secondary" style="padding: 8px 16px; font-size: 13px; border-radius: var(--radius-pill); display: inline-flex; align-items: center; gap: 6px;" onclick="alert('Ramesh: Hello! I have picked up your order from ' + '<%= resName %>' + ' and am driving to your location safely.');">
                        💬 Chat
                    </button>
                </div>
            </div>

            <!-- Delivery Location & Support Section -->
            <div style="margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--border-subtle); display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div>
                    <h4 style="font-size: 13px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; margin-bottom: 6px;">Delivery Address</h4>
                    <p style="font-size: 14px; color: #fff; line-height: 1.4;">
                        📍 <%= delAddress %>
                    </p>
                </div>

                <div style="display: flex; justify-content: flex-end; align-items: center; gap: 14px;">
                    <button type="button" class="btn-secondary" style="font-size: 13px; padding: 8px 16px; border-radius: var(--radius-pill);" onclick="alert('Our 24x7 Support team is here to assist with Order #' + '<%= order.getOders_id() %>');">
                        Need Help?
                    </button>
                    <a href="<%= request.getContextPath() %>/orders" class="btn-primary" style="font-size: 13px; padding: 8px 18px; border-radius: var(--radius-pill);">
                        View All Orders →
                    </a>
                </div>
            </div>

        </div>

    </main>

    <!-- Shared Dark Footer -->
    <jsp:include page="/Foodie/includes/footer.jsp" />

</body>
</html>
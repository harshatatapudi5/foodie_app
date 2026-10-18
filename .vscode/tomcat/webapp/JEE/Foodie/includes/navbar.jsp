<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Cart" %>
<%
    User navUser = (User) session.getAttribute("user");
    Cart navCart = (Cart) session.getAttribute("cart");
    int navCartCount = (navCart != null) ? navCart.getTotalQuantity() : 0;
    String navActivePage = (String) request.getAttribute("activePage");
    if (navActivePage == null) navActivePage = "";
    String backUrl = (String) request.getAttribute("backUrl");

    String navLocation = "Hyderabad, Telangana";
    if (navUser != null && navUser.getAddress() != null && !navUser.getAddress().trim().isEmpty()) {
        navLocation = navUser.getAddress().trim();
    }
%>

<header class="site-header">
    <div class="nav-container">
        <!-- Brand & Optional Back Button -->
        <div style="display: flex; align-items: center; gap: 14px;">
            <% if (backUrl != null && !backUrl.isEmpty()) { %>
                <a href="<%= backUrl %>" class="icon-btn" title="Go Back" aria-label="Go Back">
                    <span style="font-size: 18px;">←</span>
                </a>
            <% } %>
            <a href="<%= request.getContextPath() %>/index.jsp" class="brand-logo" aria-label="Foodie Home">
                <span class="brand-logo-icon">🍴</span>
                <span>Food<strong>ie</strong></span>
            </a>
        </div>

        <!-- Navigation Links (Desktop) -->
        <ul class="nav-menu" id="globalNavMenu">
            <li>
                <a href="<%= request.getContextPath() %>/index.jsp" class="nav-link <%= "home".equals(navActivePage) ? "active" : "" %>">
                    Home
                </a>
            </li>
            <li>
                <a href="<%= request.getContextPath() %>/restaurant" class="nav-link <%= "restaurants".equals(navActivePage) ? "active" : "" %>">
                    Restaurants
                </a>
            </li>
            <li>
                <a href="<%= request.getContextPath() %>/index.jsp#offers" class="nav-link <%= "offers".equals(navActivePage) ? "active" : "" %>">
                    Offers
                </a>
            </li>
            <li>
                <a href="<%= request.getContextPath() %>/index.jsp#about" class="nav-link <%= "about".equals(navActivePage) ? "active" : "" %>">
                    About
                </a>
            </li>
        </ul>

        <!-- Right Actions -->
        <div class="nav-right">
            <!-- Location Picker -->
            <div class="location-picker" id="locationPickerBtn" title="Delivery Location: <%= navLocation %>">
                <span class="loc-icon">📍</span>
                <span id="currentLocationText" style="max-width: 140px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= navLocation %></span>
                <span style="font-size: 10px; color: var(--text-muted);">▼</span>
            </div>

            <!-- Search Button -->
            <a href="<%= request.getContextPath() %>/restaurant" class="icon-btn" title="Search restaurants or food" aria-label="Search">
                🔍
            </a>

            <!-- Notification Bell (clean, no fake counts) -->
            <button type="button" class="icon-btn" id="navNotificationBtn" title="Notifications" aria-label="Notifications" onclick="alert('You are all caught up! No unread notifications.');">
                🔔
            </button>

            <!-- Cart Pill with REAL Cart Count -->
            <a href="<%= request.getContextPath() %>/cart" class="cart-pill-btn" aria-label="Cart (<%= navCartCount %> items)">
                <span>🛒</span>
                <span id="navCartTotalCount"><%= navCartCount %></span>
            </a>

            <!-- User Avatar / Login -->
            <% if (navUser != null) { 
                String uName = (navUser.getName() != null && !navUser.getName().isEmpty()) ? navUser.getName() : "User";
                String uInitial = uName.substring(0, 1).toUpperCase();
            %>
                <div style="position: relative;">
                    <a href="<%= request.getContextPath() %>/profile" class="user-avatar-btn" title="My Profile (<%= uName %>)">
                        <span class="user-avatar-initial">
                            <%= uInitial %>
                        </span>
                    </a>
                </div>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn-primary" style="padding: 9px 20px; font-size: 13.5px;">
                    Sign In
                </a>
            <% } %>

            <!-- Mobile Hamburger Toggle Button -->
            <button type="button" class="icon-btn mobile-menu-toggle" onclick="toggleGlobalMobileNav()" aria-label="Toggle Menu" style="display: none;">
                ☰
            </button>
        </div>
    </div>
</header>

<script>
    function toggleGlobalMobileNav() {
        const menu = document.getElementById('globalNavMenu');
        if (menu) {
            menu.classList.toggle('mobile-open');
        }
    }
</script>

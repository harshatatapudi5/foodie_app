<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.OrdersDetails" %>
<%@ page import="com.tap.DAOImp.OrdersDAOImpl" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Integer totalOrders = (Integer) request.getAttribute("totalOrders");
    Double totalSpent = (Double) request.getAttribute("totalSpent");
    List<OrdersDetails> orders = (List<OrdersDetails>) request.getAttribute("orders");

    if (totalOrders == null) {
        try {
            OrdersDAOImpl orderDAO = new OrdersDAOImpl();
            orders = orderDAO.getOrdersByUser(user.getId());
            totalOrders = (orders != null) ? orders.size() : 0;
            totalSpent = 0.0;
            if (orders != null) {
                for (OrdersDetails o : orders) {
                    totalSpent += o.getTotalamount();
                }
            }
        } catch (Exception ignored) {
            totalOrders = 0;
            totalSpent = 0.0;
        }
    }

    String profileMessage = (String) session.getAttribute("profileMessage");
    if (profileMessage != null) {
        session.removeAttribute("profileMessage");
    }

    String userName = (user.getName() != null && !user.getName().trim().isEmpty()) ? user.getName() : "Foodie Gourmet";
    String userEmail = (user.getEmail() != null) ? user.getEmail() : "user@foodie.com";
    String userAddress = (user.getAddress() != null && !user.getAddress().trim().isEmpty()) ? user.getAddress() : "Hitech City, Hyderabad, Telangana";
    String initial = userName.substring(0, 1).toUpperCase();

    request.setAttribute("activePage", "profile");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= userName %> — My Profile | Foodie</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Dark Design System -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Foodie/css/theme-dark.css">
    <style>
        .profile-tab-content {
            display: none;
        }
        .profile-tab-content.active {
            display: block;
        }
        .profile-tab-pill {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-pill);
            padding: 10px 20px;
            font-size: 13.5px;
            font-weight: 700;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .profile-tab-pill:hover {
            color: #fff;
            border-color: var(--border-medium);
        }
        .profile-tab-pill.active {
            background: var(--primary-gradient);
            color: #fff;
            border-color: transparent;
            box-shadow: var(--primary-glow-sm);
        }
    </style>
</head>
<body>

    <!-- Shared Dark Navbar -->
    <jsp:include page="/Foodie/includes/navbar.jsp" />

    <main class="page-container" style="max-width: 1050px; margin: 28px auto; padding: 0 24px;">

        <!-- Success Alert Message -->
        <% if (profileMessage != null && !profileMessage.isEmpty()) { %>
            <div style="background: rgba(16,185,129,0.15); border: 1px solid var(--success); color: #fff; padding: 14px 20px; border-radius: var(--radius-md); margin-bottom: 24px; display: flex; align-items: center; gap: 10px; font-size: 14px;">
                <span>✅</span>
                <span><%= profileMessage %></span>
            </div>
        <% } %>

        <div class="profile-dashboard">

            <!-- Profile Header Card -->
            <div class="profile-header-card">
                <div style="display: flex; align-items: center; gap: 24px; flex-wrap: wrap;">
                    <div class="profile-avatar-circle">
                        <%= initial %>
                    </div>
                    <div>
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 4px;">
                            <h1 style="font-size: 26px; font-weight: 800; color: #fff;"><%= userName %></h1>
                            <span style="font-size: 12px; background: rgba(16,185,129,0.15); color: var(--success); border: 1px solid var(--success); padding: 3px 8px; border-radius: var(--radius-pill); font-weight: 700;">
                                Verified Member
                            </span>
                        </div>
                        <div style="font-size: 13.5px; color: var(--text-muted); margin-bottom: 8px;">
                            📧 <%= userEmail %> • 📍 <%= userAddress %>
                        </div>
                        <div style="font-size: 12px; color: var(--primary); font-weight: 600;">
                            🌟 Foodie Super Club Member • Free delivery on orders over ₹199
                        </div>
                    </div>
                </div>

                <div style="display: flex; gap: 12px;">
                    <button type="button" class="btn-primary" style="padding: 10px 20px; font-size: 13.5px; border-radius: var(--radius-pill);" onclick="openEditModal()">
                        ✏️ Edit Profile
                    </button>
                    <a href="<%= request.getContextPath() %>/logout" class="btn-secondary" style="padding: 10px 18px; font-size: 13.5px; border-radius: var(--radius-pill); color: var(--danger); border-color: rgba(239,68,68,0.3);">
                        🚪 Logout
                    </a>
                </div>
            </div>

            <!-- Stats Counters -->
            <div class="profile-stats-grid">
                <div class="profile-stat-box">
                    <div class="profile-stat-val"><%= totalOrders %></div>
                    <div class="profile-stat-label">Total Orders Placed</div>
                </div>
                <div class="profile-stat-box">
                    <div class="profile-stat-val">₹<%= String.format("%.0f", (totalSpent != null ? totalSpent : 0.0)) %></div>
                    <div class="profile-stat-label">Total Amount Spent</div>
                </div>
                <div class="profile-stat-box">
                    <div class="profile-stat-val">340 pts</div>
                    <div class="profile-stat-label">Foodie Reward Coins</div>
                </div>
                <div class="profile-stat-box">
                    <div class="profile-stat-val">2</div>
                    <div class="profile-stat-label">Saved Delivery Addresses</div>
                </div>
            </div>

            <!-- Sub-tab Pills -->
            <div style="display: flex; gap: 12px; overflow-x: auto; padding-bottom: 4px;">
                <button type="button" class="profile-tab-pill active" onclick="switchProfileTab('tab-overview', this)">
                    🧭 Account Hub
                </button>
                <button type="button" class="profile-tab-pill" onclick="switchProfileTab('tab-addresses', this)">
                    📍 Saved Addresses
                </button>
                <button type="button" class="profile-tab-pill" onclick="switchProfileTab('tab-payments', this)">
                    💳 Payment Methods
                </button>
                <button type="button" class="profile-tab-pill" onclick="switchProfileTab('tab-offers', this)">
                    🎁 Coupons & Rewards
                </button>
            </div>

            <!-- TAB 1: ACCOUNT HUB -->
            <div id="tab-overview" class="profile-tab-content active">
                <div class="profile-menu-grid">
                    <a href="<%= request.getContextPath() %>/orders" class="profile-nav-card">
                        <div style="display: flex; align-items: center; gap: 14px;">
                            <span style="font-size: 24px;">📦</span>
                            <div>
                                <div style="font-weight: 700; color: #fff; font-size: 15px;">My Orders</div>
                                <div style="font-size: 12px; color: var(--text-muted);">View order history & live tracking</div>
                            </div>
                        </div>
                        <span style="font-size: 18px; color: var(--text-muted);">→</span>
                    </a>

                    <a href="<%= request.getContextPath() %>/restaurant" class="profile-nav-card">
                        <div style="display: flex; align-items: center; gap: 14px;">
                            <span style="font-size: 24px;">🍽️</span>
                            <div>
                                <div style="font-weight: 700; color: #fff; font-size: 15px;">Explore Restaurants</div>
                                <div style="font-size: 12px; color: var(--text-muted);">Discover top-rated cuisines nearby</div>
                            </div>
                        </div>
                        <span style="font-size: 18px; color: var(--text-muted);">→</span>
                    </a>

                    <a href="<%= request.getContextPath() %>/cart" class="profile-nav-card">
                        <div style="display: flex; align-items: center; gap: 14px;">
                            <span style="font-size: 24px;">🛒</span>
                            <div>
                                <div style="font-weight: 700; color: #fff; font-size: 15px;">Shopping Cart</div>
                                <div style="font-size: 12px; color: var(--text-muted);">Review items and checkout</div>
                            </div>
                        </div>
                        <span style="font-size: 18px; color: var(--text-muted);">→</span>
                    </a>

                    <div class="profile-nav-card" onclick="alert('Foodie 24x7 Support: call 1800-123-456 or email support@foodie.com');">
                        <div style="display: flex; align-items: center; gap: 14px;">
                            <span style="font-size: 24px;">💬</span>
                            <div>
                                <div style="font-weight: 700; color: #fff; font-size: 15px;">Help & Support</div>
                                <div style="font-size: 12px; color: var(--text-muted);">Instant 24x7 customer care</div>
                            </div>
                        </div>
                        <span style="font-size: 18px; color: var(--text-muted);">→</span>
                    </div>
                </div>
            </div>

            <!-- TAB 2: SAVED ADDRESSES -->
            <div id="tab-addresses" class="profile-tab-content">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 18px;">
                    <div style="background: var(--bg-card); border: 1.5px solid var(--border-subtle); border-radius: var(--radius-lg); padding: 22px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <span style="font-size: 20px;">🏠</span>
                                <h3 style="font-size: 16px; font-weight: 700; color: #fff;">Home (Primary)</h3>
                            </div>
                            <span style="font-size: 11px; background: rgba(16,185,129,0.15); color: var(--success); padding: 2px 8px; border-radius: var(--radius-pill); font-weight: 700;">DEFAULT</span>
                        </div>
                        <p style="font-size: 13.5px; color: var(--text-secondary); line-height: 1.5; margin-bottom: 16px;">
                            <%= userAddress %>
                        </p>
                        <button type="button" class="btn-secondary" style="font-size: 12px; padding: 6px 14px; border-radius: var(--radius-pill);" onclick="openEditModal()">
                            Edit Address
                        </button>
                    </div>

                    <div style="background: var(--bg-card); border: 1.5px solid var(--border-subtle); border-radius: var(--radius-lg); padding: 22px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <span style="font-size: 20px;">🏢</span>
                                <h3 style="font-size: 16px; font-weight: 700; color: #fff;">Work</h3>
                            </div>
                        </div>
                        <p style="font-size: 13.5px; color: var(--text-secondary); line-height: 1.5; margin-bottom: 16px;">
                            Cyber Towers, 4th Floor, HITEC City, Hyderabad, 500081
                        </p>
                        <button type="button" class="btn-secondary" style="font-size: 12px; padding: 6px 14px; border-radius: var(--radius-pill);" onclick="alert('Work address is verified.');">
                            Use this Address
                        </button>
                    </div>
                </div>
            </div>

            <!-- TAB 3: PAYMENT METHODS -->
            <div id="tab-payments" class="profile-tab-content">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 18px;">
                    <div style="background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: var(--radius-lg); padding: 20px; display: flex; align-items: center; justify-content: space-between;">
                        <div style="display: flex; align-items: center; gap: 14px;">
                            <span style="font-size: 24px;">📱</span>
                            <div>
                                <div style="font-weight: 700; color: #fff; font-size: 14px;">Google Pay UPI</div>
                                <div style="font-size: 12px; color: var(--text-muted);"><%= userEmail.split("@")[0] %>@oksbi</div>
                            </div>
                        </div>
                        <span style="color: var(--success); font-weight: 700; font-size: 12px;">✓ Linked</span>
                    </div>

                    <div style="background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: var(--radius-lg); padding: 20px; display: flex; align-items: center; justify-content: space-between;">
                        <div style="display: flex; align-items: center; gap: 14px;">
                            <span style="font-size: 24px;">💳</span>
                            <div>
                                <div style="font-weight: 700; color: #fff; font-size: 14px;">HDFC Millennia Debit</div>
                                <div style="font-size: 12px; color: var(--text-muted);">Ending in •••• 4289</div>
                            </div>
                        </div>
                        <span style="color: var(--success); font-weight: 700; font-size: 12px;">✓ Active</span>
                    </div>
                </div>
            </div>

            <!-- TAB 4: OFFERS & REWARDS -->
            <div id="tab-offers" class="profile-tab-content">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 18px;">
                    <div style="background: linear-gradient(135deg, rgba(255,87,34,0.15) 0%, rgba(22,27,38,1) 100%); border: 1px dashed var(--primary); border-radius: var(--radius-lg); padding: 22px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                            <span style="font-size: 16px; font-weight: 800; color: var(--primary);">FOODIE50</span>
                            <button type="button" class="btn-primary" style="padding: 4px 12px; font-size: 12px;" onclick="navigator.clipboard.writeText('FOODIE50'); alert('Coupon code copied!');">Copy</button>
                        </div>
                        <p style="font-size: 13px; color: #fff; margin-bottom: 4px;">Get ₹50 OFF on all orders above ₹299</p>
                        <span style="font-size: 11px; color: var(--text-muted);">Valid on any restaurant • Expires in 14 days</span>
                    </div>

                    <div style="background: linear-gradient(135deg, rgba(16,185,129,0.15) 0%, rgba(22,27,38,1) 100%); border: 1px dashed var(--success); border-radius: var(--radius-lg); padding: 22px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                            <span style="font-size: 16px; font-weight: 800; color: var(--success);">FREEDEL</span>
                            <button type="button" class="btn-primary" style="padding: 4px 12px; font-size: 12px; background: var(--success);" onclick="navigator.clipboard.writeText('FREEDEL'); alert('Coupon code copied!');">Copy</button>
                        </div>
                        <p style="font-size: 13px; color: #fff; margin-bottom: 4px;">Free Delivery on orders above ₹199</p>
                        <span style="font-size: 11px; color: var(--text-muted);">Unlimited uses this month</span>
                    </div>
                </div>
            </div>

        </div>

    </main>

    <!-- Edit Profile Modal -->
    <div id="editProfileModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.75); backdrop-filter: blur(6px); z-index: 2000; align-items: center; justify-content: center; padding: 20px;">
        <div style="background: var(--bg-card); border: 1px solid var(--border-medium); border-radius: var(--radius-xl); padding: 32px; width: 100%; max-width: 500px; box-shadow: var(--shadow-dropdown);">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h3 style="font-size: 20px; font-weight: 800; color: #fff;">Edit Profile Details</h3>
                <button type="button" class="icon-btn" onclick="closeEditModal()" style="font-size: 18px;">✕</button>
            </div>

            <form action="<%= request.getContextPath() %>/profile" method="post">
                <div style="display: flex; flex-direction: column; gap: 16px; margin-bottom: 24px;">
                    <div>
                        <label style="display: block; font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px;">Your Full Name</label>
                        <input type="text" name="name" value="<%= userName %>" required
                               style="width: 100%; background: var(--bg-input); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 12px 16px; color: #fff; font-size: 14px; outline: none;">
                    </div>

                    <div>
                        <label style="display: block; font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px;">Email Address (Read-only)</label>
                        <input type="email" value="<%= userEmail %>" disabled
                               style="width: 100%; background: rgba(255,255,255,0.03); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 12px 16px; color: var(--text-muted); font-size: 14px; cursor: not-allowed;">
                    </div>

                    <div>
                        <label style="display: block; font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px;">Default Delivery Address</label>
                        <textarea name="address" rows="3" required
                                  style="width: 100%; background: var(--bg-input); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 12px 16px; color: #fff; font-size: 14px; outline: none; resize: vertical;"><%= userAddress %></textarea>
                    </div>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 12px;">
                    <button type="button" class="btn-secondary" onclick="closeEditModal()">Cancel</button>
                    <button type="submit" class="btn-primary" style="padding: 10px 24px; border-radius: var(--radius-pill);">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Shared Dark Footer -->
    <jsp:include page="/Foodie/includes/footer.jsp" />

    <script>
        function switchProfileTab(tabId, pill) {
            document.querySelectorAll('.profile-tab-content').forEach(c => c.classList.remove('active'));
            document.querySelectorAll('.profile-tab-pill').forEach(p => p.classList.remove('active'));
            const target = document.getElementById(tabId);
            if (target) target.classList.add('active');
            if (pill) pill.classList.add('active');
        }

        function openEditModal() {
            const modal = document.getElementById('editProfileModal');
            if (modal) modal.style.display = 'flex';
        }

        function closeEditModal() {
            const modal = document.getElementById('editProfileModal');
            if (modal) modal.style.display = 'none';
        }
    </script>
</body>
</html>


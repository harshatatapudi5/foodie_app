<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.MenuData" %>
<%@ page import="com.tap.model.ResDetails" %>
<%@ page import="com.tap.DAOImp.DAOImpRes" %>

<%
    User loggedInUser = (User) session.getAttribute("user");
    
    // Get cart from request (if forwarded from CartController) or fallback to session
    Cart cart = (Cart) request.getAttribute("cart");
    if (cart == null) {
        cart = (Cart) session.getAttribute("cart");
    }
    if (cart == null) {
        cart = new Cart();
        session.setAttribute("cart", cart);
    }

    double itemTotal = cart.getTotal();
    int totalItems = cart.getTotalQuantity();
    boolean isEmpty = cart.isEmpty();

    // Look up restaurant details if cart has items
    ResDetails cartRestaurant = null;
    if (!isEmpty && cart.getRes_id() > 0) {
        try {
            DAOImpRes resDAO = new DAOImpRes();
            cartRestaurant = resDAO.getRes(cart.getRes_id());
        } catch (Exception ignored) {}
    }

    String resName = (cartRestaurant != null && cartRestaurant.getResName() != null) 
                     ? cartRestaurant.getResName() 
                     : "Your Selected Restaurant";

    double deliveryFee = isEmpty ? 0.0 : (itemTotal >= 500 ? 0.0 : 40.0);
    double platformFee = isEmpty ? 0.0 : 5.0;
    double taxes = isEmpty ? 0.0 : Math.round(itemTotal * 0.05 * 100.0) / 100.0; // 5% GST
    double toPay = itemTotal + deliveryFee + platformFee + taxes;

    request.setAttribute("activePage", "cart");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart (<%= totalItems %>) — Foodie</title>
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

    <main class="page-container" style="max-width: 1200px; margin: 28px auto; padding: 0 24px;">

        <!-- Page Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; flex-wrap: wrap; gap: 16px;">
            <div>
                <h1 style="font-size: 28px; font-weight: 800; color: #fff; margin-bottom: 4px;">
                    🛒 Your Food Cart
                </h1>
                <p style="color: var(--text-secondary); font-size: 14px;">
                    <% if (!isEmpty) { %>
                        Ordering delicious meals from <strong style="color: var(--primary);"><%= resName %></strong>
                    <% } else { %>
                        Review items in your cart and proceed to checkout
                    <% } %>
                </p>
            </div>

            <% if (!isEmpty) { %>
                <a href="<%= request.getContextPath() %>/menu?resId=<%= cart.getRes_id() %>" class="btn-secondary" style="font-size: 13px; padding: 8px 18px; border-radius: var(--radius-pill);">
                    + Add More Items
                </a>
            <% } %>
        </div>

        <% if (isEmpty) { %>
            <!-- Clean Empty Cart State -->
            <div class="empty-state-view" style="background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: var(--radius-xl); margin: 40px auto;">
                <span class="empty-state-icon">🛒</span>
                <h2 class="empty-state-title">Your Cart is Empty</h2>
                <p class="empty-state-text">
                    Looks like you haven't added anything to your cart yet. Explore popular restaurants and handpick your favorite delicacies!
                </p>
                <div style="display: flex; justify-content: center; gap: 16px;">
                    <a href="<%= request.getContextPath() %>/restaurant" class="btn-primary" style="padding: 12px 28px; font-size: 15px;">
                        Explore Restaurants →
                    </a>
                </div>
            </div>
        <% } else { %>
            <!-- 2-Column Cart Layout -->
            <div class="cart-layout">

                <!-- Left Column: Cart Items List -->
                <div class="cart-card-group">
                    <!-- Restaurant Card Header -->
                    <div style="background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: var(--radius-lg); padding: 18px 22px; display: flex; align-items: center; justify-content: space-between;">
                        <div style="display: flex; align-items: center; gap: 14px;">
                            <div style="width: 44px; height: 44px; border-radius: 50%; background: rgba(255,87,34,0.15); display: flex; align-items: center; justify-content: center; font-size: 20px; color: var(--primary);">
                                🏪
                            </div>
                            <div>
                                <h3 style="font-size: 16px; font-weight: 700; color: #fff;"><%= resName %></h3>
                                <p style="font-size: 12.5px; color: var(--text-muted);">Standard delivery in 30-40 mins</p>
                            </div>
                        </div>
                        <span style="background: var(--success-bg); color: var(--success); border: 1px solid var(--success); font-size: 12px; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-pill);">
                            Verified Kitchen
                        </span>
                    </div>

                    <!-- Items Rows -->
                    <div style="display: flex; flex-direction: column; gap: 14px;">
                        <%
                            for (Map.Entry<Integer, CartItem> entry : cart.getItems().entrySet()) {
                                CartItem item = entry.getValue();
                                MenuData menu = item.getMenu();

                                String lowerName = (menu.getItemName() != null) ? menu.getItemName().toLowerCase() : "";
                                boolean isNonVeg = lowerName.contains("chicken") || lowerName.contains("mutton") 
                                                || lowerName.contains("fish") || lowerName.contains("egg") 
                                                || lowerName.contains("meat") || lowerName.contains("tikka");

                                // Resolve food image safely
                                String foodImage = menu.getImagePath();
                                String foodImageUrl = "";
                                if (foodImage == null || foodImage.trim().isEmpty()) {
                                    foodImageUrl = request.getContextPath() + "/Foodie/images/menu/pizza.jpg";
                                } else {
                                    foodImage = foodImage.trim();
                                    if (foodImage.startsWith("/")) foodImage = foodImage.substring(1);
                                    if (foodImage.startsWith("images/")) {
                                        foodImageUrl = request.getContextPath() + "/Foodie/" + foodImage;
                                    } else if (foodImage.contains("/")) {
                                        foodImageUrl = request.getContextPath() + "/Foodie/images/" + foodImage;
                                    } else {
                                        foodImageUrl = request.getContextPath() + "/Foodie/images/menu/" + foodImage;
                                    }
                                }
                        %>
                            <div class="cart-item-row">
                                <div class="cart-item-info">
                                    <img src="<%= foodImageUrl %>" 
                                         alt="<%= menu.getItemName() %>" 
                                         class="cart-item-thumb"
                                         onerror="this.src='<%= request.getContextPath() %>/Foodie/images/menu/pizza.jpg';">

                                    <div>
                                        <div style="display: flex; align-items: center; gap: 6px; margin-bottom: 4px;">
                                            <span class="food-type-icon <%= isNonVeg ? "non-veg" : "veg" %>"></span>
                                            <span style="font-size: 11px; font-weight: 700; color: <%= isNonVeg ? "var(--danger)" : "var(--success)" %>;">
                                                <%= isNonVeg ? "NON-VEG" : "PURE VEG" %>
                                            </span>
                                        </div>
                                        <h4 class="cart-item-name"><%= menu.getItemName() %></h4>
                                        <div class="cart-item-sub">₹<%= String.format("%.2f", menu.getPrice()) %> each</div>
                                    </div>
                                </div>

                                <div style="display: flex; align-items: center; gap: 20px;">
                                    <!-- Stepper Controls -->
                                    <div class="quantity-stepper">
                                        <form action="<%= request.getContextPath() %>/cart" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="decrease">
                                            <input type="hidden" name="menuId" value="<%= menu.getId() %>">
                                            <button type="submit" class="btn-step" title="Decrease Quantity">−</button>
                                        </form>

                                        <span class="step-value"><%= item.getQuantity() %></span>

                                        <form action="<%= request.getContextPath() %>/cart" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="increase">
                                            <input type="hidden" name="menuId" value="<%= menu.getId() %>">
                                            <button type="submit" class="btn-step" title="Increase Quantity">+</button>
                                        </form>
                                    </div>

                                    <!-- Subtotal -->
                                    <div class="cart-item-price">
                                        ₹<%= String.format("%.2f", item.getSubtotal()) %>
                                    </div>

                                    <!-- Remove Trash Button -->
                                    <form action="<%= request.getContextPath() %>/cart" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="menuId" value="<%= menu.getId() %>">
                                        <button type="submit" class="icon-btn" style="color: var(--danger); font-size: 15px;" title="Remove Item">
                                            🗑
                                        </button>
                                    </form>
                                </div>
                            </div>
                        <% } %>
                    </div>

                    <!-- Cooking / Delivery Instructions -->
                    <div style="background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: var(--radius-lg); padding: 18px 22px;">
                        <label for="cookingInstructions" style="display: block; font-size: 14px; font-weight: 700; color: #fff; margin-bottom: 8px;">
                            📝 Cooking & Delivery Notes (Optional)
                        </label>
                        <input type="text" id="cookingInstructions" placeholder="e.g. Extra spicy, no onions, leave at door..."
                               style="width: 100%; background: var(--bg-input); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 10px 14px; color: #fff; font-size: 13.5px; outline: none;">
                    </div>
                </div>

                <!-- Right Column: Bill Details & Coupons -->
                <div>
                    <div class="bill-card">
                        <h3>Bill Summary</h3>

                        <!-- Apply Coupon Box -->
                        <div class="coupon-box">
                            <input type="text" id="couponCodeInput" placeholder="Enter coupon code (e.g. FOODIE50)">
                            <button type="button" id="applyCouponBtn" onclick="applyCoupon()">Apply</button>
                        </div>
                        <div id="couponStatusMsg" style="font-size: 12px; display: none;"></div>

                        <!-- Bill Breakdown Rows -->
                        <div class="bill-rows">
                            <div class="bill-row">
                                <span>Item Total (<%= totalItems %> items)</span>
                                <span>₹<%= String.format("%.2f", itemTotal) %></span>
                            </div>

                            <div class="bill-row">
                                <span>Delivery Fee</span>
                                <span>
                                    <% if (deliveryFee == 0.0) { %>
                                        <span style="color: var(--success); font-weight: 700;">FREE</span>
                                    <% } else { %>
                                        ₹<%= String.format("%.2f", deliveryFee) %>
                                    <% } %>
                                </span>
                            </div>

                            <div class="bill-row">
                                <span>Platform Fee</span>
                                <span>₹<%= String.format("%.2f", platformFee) %></span>
                            </div>

                            <div class="bill-row">
                                <span>GST and Restaurant Taxes (5%)</span>
                                <span>₹<%= String.format("%.2f", taxes) %></span>
                            </div>

                            <div class="bill-row discount" id="discountRow" style="display: none;">
                                <span>Coupon Discount</span>
                                <span id="discountVal">-₹50.00</span>
                            </div>

                            <div class="bill-row total">
                                <span>To Pay</span>
                                <span class="price" id="finalToPay">₹<%= String.format("%.2f", toPay) %></span>
                            </div>
                        </div>

                        <!-- Free Delivery Tip -->
                        <% if (itemTotal < 500 && deliveryFee > 0) { %>
                            <div style="background: rgba(16,185,129,0.1); border: 1px dashed var(--success); border-radius: var(--radius-md); padding: 10px 14px; font-size: 12px; color: var(--success); display: flex; align-items: center; gap: 8px;">
                                <span>💡</span>
                                <span>Add items worth ₹<%= String.format("%.2f", 500.0 - itemTotal) %> more for <strong>FREE Delivery!</strong></span>
                            </div>
                        <% } %>

                        <!-- Proceed to Checkout Button -->
                        <a href="<%= request.getContextPath() %>/checkout" class="btn-primary" style="width: 100%; text-align: center; padding: 14px; font-size: 15px; border-radius: var(--radius-pill); font-weight: 700;">
                            Proceed to Checkout →
                        </a>

                        <!-- Safe & Secure Badge -->
                        <div style="display: flex; align-items: center; justify-content: center; gap: 8px; font-size: 12px; color: var(--text-muted); text-align: center;">
                            <span>🛡️</span>
                            <span>Safe, contactless delivery & secure payments</span>
                        </div>
                    </div>
                </div>

            </div>
        <% } %>

    </main>

    <!-- Shared Dark Footer -->
    <jsp:include page="/Foodie/includes/footer.jsp" />

    <script>
        let baseToPay = <%= toPay %>;
        let discountApplied = false;

        function applyCoupon() {
            const input = document.getElementById('couponCodeInput');
            const msg = document.getElementById('couponStatusMsg');
            const discountRow = document.getElementById('discountRow');
            const finalToPay = document.getElementById('finalToPay');

            if (!input || !msg) return;
            const code = input.value.trim().toUpperCase();

            if (code === 'FOODIE50' || code === 'WELCOME' || code === 'TASTY') {
                discountApplied = true;
                discountRow.style.display = 'flex';
                const discounted = Math.max(0, baseToPay - 50.0);
                finalToPay.innerText = '₹' + discounted.toFixed(2);
                msg.style.display = 'block';
                msg.style.color = 'var(--success)';
                msg.innerText = '🎉 Coupon ' + code + ' applied! ₹50.00 saved.';
            } else if (code === '') {
                msg.style.display = 'block';
                msg.style.color = 'var(--danger)';
                msg.innerText = 'Please enter a valid coupon code.';
            } else {
                msg.style.display = 'block';
                msg.style.color = 'var(--danger)';
                msg.innerText = 'Invalid coupon code. Try FOODIE50 or WELCOME.';
            }
        }
    </script>
</body>
</html>

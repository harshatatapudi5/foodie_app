<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.MenuData" %>
<%@ page import="com.tap.model.ResDetails" %>
<%@ page import="com.tap.DAOImp.DAOImpRes" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Cart cart = (Cart) request.getAttribute("cart");
    if (cart == null) {
        cart = (Cart) session.getAttribute("cart");
    }
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/cart");
        return;
    }

    double itemTotal = cart.getTotal();
    int totalItems = cart.getTotalQuantity();

    ResDetails cartRestaurant = null;
    if (cart.getRes_id() > 0) {
        try {
            DAOImpRes resDAO = new DAOImpRes();
            cartRestaurant = resDAO.getRes(cart.getRes_id());
        } catch (Exception ignored) {}
    }
    String resName = (cartRestaurant != null && cartRestaurant.getResName() != null) ? cartRestaurant.getResName() : "Selected Restaurant";

    String error = (String) request.getAttribute("error");

    String userName = (user.getName() != null) ? user.getName() : "";
    String userAddress = (user.getAddress() != null) ? user.getAddress() : "";

    request.setAttribute("activePage", "cart");
    request.setAttribute("backUrl", request.getContextPath() + "/cart");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout — Step 1 & 2: Delivery Details — Foodie</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Dark Design System -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Foodie/css/theme-dark.css">
    <style>
        .input-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .input-group label {
            font-size: 13px;
            font-weight: 600;
            color: var(--text-secondary);
        }
        .input-control {
            background: var(--bg-input);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-md);
            padding: 12px 16px;
            color: var(--text-white);
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s ease;
        }
        .input-control:focus {
            border-color: var(--primary);
        }
        .instruction-chip {
            background: var(--bg-input);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-pill);
            padding: 6px 14px;
            font-size: 12.5px;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .instruction-chip:hover, .instruction-chip.selected {
            background: rgba(255,87,34,0.15);
            border-color: var(--primary);
            color: var(--primary);
        }
    </style>
</head>
<body>

    <!-- Shared Dark Navbar -->
    <jsp:include page="/Foodie/includes/navbar.jsp" />

    <main class="page-container" style="max-width: 1100px; margin: 24px auto; padding: 0 24px;">

        <!-- 3-Step Checkout Progress Stepper -->
        <div class="checkout-stepper">
            <div class="step-item active">
                <span class="step-number">1</span>
                <span>Address</span>
            </div>
            <div class="step-line active"></div>
            <div class="step-item active">
                <span class="step-number">2</span>
                <span>Delivery</span>
            </div>
            <div class="step-line"></div>
            <div class="step-item">
                <span class="step-number">3</span>
                <span>Payment</span>
            </div>
        </div>

        <% if (error != null && !error.isEmpty()) { %>
            <div style="background: var(--danger-bg); border: 1px solid var(--danger); color: #fff; padding: 14px 20px; border-radius: var(--radius-md); margin-bottom: 24px; font-size: 14px; display: flex; align-items: center; gap: 10px;">
                <span>⚠️</span>
                <span><%= error %></span>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/payment" method="post" id="checkoutForm">
            <input type="hidden" name="fromCheckout" value="true">

            <div class="cart-layout">

                <!-- Left Column: Address & Delivery Speed -->
                <div class="cart-card-group">

                    <!-- SECTION 1: DELIVERY ADDRESS -->
                    <div style="background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: var(--radius-xl); padding: 26px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <span style="font-size: 20px;">📍</span>
                                <h2 style="font-size: 18px; font-weight: 800; color: #fff;">Delivery Address</h2>
                            </div>
                            <span style="font-size: 12px; background: rgba(255,87,34,0.15); color: var(--primary); padding: 4px 10px; border-radius: var(--radius-pill); font-weight: 700;">
                                🏠 Home Address
                            </span>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px;">
                            <div class="input-group">
                                <label for="name">Recipient Name *</label>
                                <input type="text" id="name" name="name" class="input-control" value="<%= userName %>" required placeholder="Full Name">
                            </div>

                            <div class="input-group">
                                <label for="phone">Contact Phone Number (10 Digits) *</label>
                                <input type="tel" id="phone" name="phone" class="input-control" pattern="[0-9]{10}" required placeholder="e.g. 9876543210" maxlength="10">
                            </div>
                        </div>

                        <div class="input-group" style="margin-bottom: 16px;">
                            <label for="address">Street Address, Apartment, Flat / House No. *</label>
                            <input type="text" id="address" name="address" class="input-control" value="<%= userAddress %>" required placeholder="Flat 402, Green Valley Apartments, Hitech City">
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                            <div class="input-group">
                                <label for="city">City *</label>
                                <input type="text" id="city" name="city" class="input-control" value="Hyderabad" required placeholder="City">
                            </div>

                            <div class="input-group">
                                <label for="pincode">Pincode (6 Digits) *</label>
                                <input type="text" id="pincode" name="pincode" class="input-control" pattern="[0-9]{6}" maxlength="6" value="500081" required placeholder="500081">
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 2: DELIVERY SPEED -->
                    <div style="background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: var(--radius-xl); padding: 26px;">
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 18px;">
                            <span style="font-size: 20px;">⚡</span>
                            <h2 style="font-size: 18px; font-weight: 800; color: #fff;">Choose Delivery Speed</h2>
                        </div>

                        <div class="delivery-options-grid">
                            <label class="delivery-option-card selected" id="optStandard" onclick="selectDeliveryType('standard')">
                                <input type="radio" name="deliveryType" value="standard" checked>
                                <div>
                                    <div style="font-weight: 700; color: #fff; font-size: 15px;">Standard Delivery</div>
                                    <div style="font-size: 12.5px; color: var(--text-muted); margin-top: 3px;">Arrives in 30-40 mins</div>
                                    <div style="font-size: 13px; font-weight: 700; color: var(--primary); margin-top: 6px;">₹40.00</div>
                                </div>
                            </label>

                            <label class="delivery-option-card" id="optExpress" onclick="selectDeliveryType('express')">
                                <input type="radio" name="deliveryType" value="express">
                                <div>
                                    <div style="display: flex; align-items: center; gap: 6px;">
                                        <span style="font-weight: 700; color: #fff; font-size: 15px;">Express Delivery</span>
                                        <span style="font-size: 10px; background: var(--badge-discount); color: #fff; padding: 2px 6px; border-radius: var(--radius-pill); font-weight: 700;">FAST</span>
                                    </div>
                                    <div style="font-size: 12.5px; color: var(--text-muted); margin-top: 3px;">Priority delivery in 15-25 mins</div>
                                    <div style="font-size: 13px; font-weight: 700; color: var(--primary); margin-top: 6px;">₹70.00</div>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- SECTION 3: DELIVERY INSTRUCTIONS -->
                    <div style="background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: var(--radius-xl); padding: 26px;">
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 14px;">
                            <span style="font-size: 20px;">🛎️</span>
                            <h2 style="font-size: 18px; font-weight: 800; color: #fff;">Delivery Instructions</h2>
                        </div>

                        <div style="display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 16px;">
                            <button type="button" class="instruction-chip" onclick="toggleInstruction(this, 'Avoid calling')">📵 Avoid calling</button>
                            <button type="button" class="instruction-chip" onclick="toggleInstruction(this, 'Leave at door')">🚪 Leave at door</button>
                            <button type="button" class="instruction-chip" onclick="toggleInstruction(this, 'Do not ring bell')">🔕 Do not ring bell</button>
                            <button type="button" class="instruction-chip" onclick="toggleInstruction(this, 'Pet at home')">🐾 Pet at home</button>
                        </div>

                        <div class="input-group">
                            <input type="text" id="instructionsInput" name="instructions" class="input-control" placeholder="Any specific instructions for your delivery partner...">
                        </div>
                    </div>

                </div>

                <!-- Right Column: Order Preview & Continue CTA -->
                <div>
                    <div class="bill-card">
                        <h3>Order Summary</h3>

                        <div style="background: var(--bg-surface); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 14px; display: flex; align-items: center; gap: 12px;">
                            <span style="font-size: 22px;">🏪</span>
                            <div>
                                <div style="font-weight: 700; color: #fff; font-size: 14px;"><%= resName %></div>
                                <div style="font-size: 12px; color: var(--text-muted);"><%= totalItems %> items in order</div>
                            </div>
                        </div>

                        <!-- Mini items preview -->
                        <div style="display: flex; flex-direction: column; gap: 10px; max-height: 180px; overflow-y: auto; padding-right: 4px;">
                            <%
                                for (Map.Entry<Integer, CartItem> entry : cart.getItems().entrySet()) {
                                    CartItem item = entry.getValue();
                            %>
                                <div style="display: flex; justify-content: space-between; font-size: 13px; color: var(--text-secondary);">
                                    <span><%= item.getQuantity() %> × <%= item.getMenu().getItemName() %></span>
                                    <span style="font-weight: 600; color: #fff;">₹<%= String.format("%.2f", item.getSubtotal()) %></span>
                                </div>
                            <% } %>
                        </div>

                        <!-- Price Breakdown -->
                        <div class="bill-rows" style="border-top: 1px solid var(--border-subtle); padding-top: 14px;">
                            <div class="bill-row">
                                <span>Items Subtotal</span>
                                <span>₹<%= String.format("%.2f", itemTotal) %></span>
                            </div>
                            <div class="bill-row">
                                <span>Delivery Fee</span>
                                <span id="deliveryFeeSummary">₹40.00</span>
                            </div>
                            <div class="bill-row">
                                <span>Platform Fee</span>
                                <span>₹5.00</span>
                            </div>
                            <div class="bill-row total">
                                <span>Estimated Total</span>
                                <span class="price" id="previewTotal">₹<%= String.format("%.2f", itemTotal + 45.0) %></span>
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn-primary" style="width: 100%; padding: 14px; font-size: 15px; border-radius: var(--radius-pill); font-weight: 700;">
                            Continue to Payment →
                        </button>

                        <div style="text-align: center;">
                            <a href="<%= request.getContextPath() %>/cart" style="font-size: 13px; color: var(--text-muted); text-decoration: underline;">
                                ← Back to Cart
                            </a>
                        </div>
                    </div>
                </div>

            </div>
        </form>

    </main>

    <!-- Shared Dark Footer -->
    <jsp:include page="/Foodie/includes/footer.jsp" />

    <script>
        const itemTotal = <%= itemTotal %>;

        function selectDeliveryType(type) {
            const optStd = document.getElementById('optStandard');
            const optExp = document.getElementById('optExpress');
            const feeElem = document.getElementById('deliveryFeeSummary');
            const totalElem = document.getElementById('previewTotal');

            if (type === 'express') {
                optExp.classList.add('selected');
                optStd.classList.remove('selected');
                optExp.querySelector('input').checked = true;
                feeElem.innerText = '₹70.00';
                totalElem.innerText = '₹' + (itemTotal + 75.0).toFixed(2);
            } else {
                optStd.classList.add('selected');
                optExp.classList.remove('selected');
                optStd.querySelector('input').checked = true;
                feeElem.innerText = '₹40.00';
                totalElem.innerText = '₹' + (itemTotal + 45.0).toFixed(2);
            }
        }

        function toggleInstruction(btn, text) {
            btn.classList.toggle('selected');
            const input = document.getElementById('instructionsInput');
            if (!input) return;

            let cur = input.value.split(',').map(s => s.trim()).filter(Boolean);
            if (btn.classList.contains('selected')) {
                if (!cur.includes(text)) cur.push(text);
            } else {
                cur = cur.filter(s => s !== text);
            }
            input.value = cur.join(', ');
        }
    </script>
</body>
</html>
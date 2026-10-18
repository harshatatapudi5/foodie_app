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

    Cart cart = (Cart) session.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/cart");
        return;
    }

    String deliveryType = (String) session.getAttribute("checkout_deliveryType");
    double deliveryFee = "express".equalsIgnoreCase(deliveryType) ? 70.0 : 40.0;
    double platformFee = 5.0;
    double itemTotal = cart.getTotal();
    double finalTotal = itemTotal + deliveryFee + platformFee;

    String address = (String) session.getAttribute("checkout_address");
    if (address == null || address.trim().isEmpty()) {
        address = (user.getAddress() != null) ? user.getAddress() : "Hyderabad, Telangana";
    }

    String phone = (String) session.getAttribute("checkout_phone");
    if (phone == null || phone.trim().isEmpty()) {
        phone = "+91 98765 43210";
    }

    ResDetails cartRestaurant = null;
    if (cart.getRes_id() > 0) {
        try {
            DAOImpRes resDAO = new DAOImpRes();
            cartRestaurant = resDAO.getRes(cart.getRes_id());
        } catch (Exception ignored) {}
    }
    String resName = (cartRestaurant != null && cartRestaurant.getResName() != null) ? cartRestaurant.getResName() : "Selected Restaurant";

    String error = (String) request.getAttribute("error");

    request.setAttribute("activePage", "cart");
    request.setAttribute("backUrl", request.getContextPath() + "/checkout");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment — Final Step — Foodie</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Dark Design System -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Foodie/css/theme-dark.css">
    <style>
        .pay-tab {
            background: var(--bg-card);
            border: 1.5px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            margin-bottom: 16px;
            overflow: hidden;
            transition: all 0.2s ease;
        }
        .pay-tab.active {
            border-color: var(--primary);
            box-shadow: 0 4px 18px rgba(255,87,34,0.12);
        }
        .pay-tab-header {
            padding: 18px 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            cursor: pointer;
            user-select: none;
        }
        .pay-tab-body {
            padding: 0 22px 20px;
            display: none;
            border-top: 1px solid var(--border-subtle);
            margin-top: 6px;
            padding-top: 16px;
        }
        .pay-tab.active .pay-tab-body {
            display: block;
        }
        .bank-chip {
            background: var(--bg-input);
            border: 1px solid var(--border-subtle);
            padding: 10px;
            border-radius: var(--radius-md);
            text-align: center;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-white);
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .bank-chip:hover, .bank-chip.active {
            border-color: var(--primary);
            background: rgba(255,87,34,0.1);
        }
        .upi-app-btn {
            background: var(--bg-input);
            border: 1px solid var(--border-subtle);
            padding: 12px 16px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            color: #fff;
            transition: all 0.2s ease;
        }
        .upi-app-btn:hover, .upi-app-btn.active {
            border-color: var(--primary);
            background: rgba(255,87,34,0.1);
        }
    </style>
</head>
<body>

    <!-- Shared Dark Navbar -->
    <jsp:include page="/Foodie/includes/navbar.jsp" />

    <main class="page-container" style="max-width: 1100px; margin: 24px auto; padding: 0 24px;">

        <!-- 3-Step Checkout Progress Stepper -->
        <div class="checkout-stepper">
            <div class="step-item completed">
                <span class="step-number">✓</span>
                <span>Address</span>
            </div>
            <div class="step-line active"></div>
            <div class="step-item completed">
                <span class="step-number">✓</span>
                <span>Delivery</span>
            </div>
            <div class="step-line active"></div>
            <div class="step-item active">
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

        <form action="<%= request.getContextPath() %>/payment" method="post" id="paymentForm">
            <input type="hidden" name="paymentMethod" id="selectedPaymentMethod" value="UPI">

            <div class="cart-layout">

                <!-- Left Column: Payment Options List -->
                <div>
                    <h2 style="font-size: 20px; font-weight: 800; color: #fff; margin-bottom: 18px;">
                        Select Payment Method
                    </h2>

                    <!-- 1. UPI Payment -->
                    <div class="pay-tab active" id="tabUPI">
                        <div class="pay-tab-header" onclick="selectPayTab('tabUPI', 'UPI')">
                            <div style="display: flex; align-items: center; gap: 14px;">
                                <input type="radio" name="payRadio" id="radioUPI" checked style="accent-color: var(--primary); width: 18px; height: 18px;">
                                <div>
                                    <div style="font-weight: 700; color: #fff; font-size: 15px;">UPI (Google Pay, PhonePe, Paytm)</div>
                                    <div style="font-size: 12.5px; color: var(--text-muted);">Pay directly using any UPI App or VPA ID</div>
                                </div>
                            </div>
                            <span style="font-size: 22px;">📱</span>
                        </div>
                        <div class="pay-tab-body">
                            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin-bottom: 16px;">
                                <div class="upi-app-btn active" onclick="setUpiOption('Google Pay', this)">
                                    <span>🟢</span> <span>Google Pay</span>
                                </div>
                                <div class="upi-app-btn" onclick="setUpiOption('PhonePe', this)">
                                    <span>🟣</span> <span>PhonePe</span>
                                </div>
                                <div class="upi-app-btn" onclick="setUpiOption('Paytm', this)">
                                    <span>🔵</span> <span>Paytm</span>
                                </div>
                            </div>

                            <div style="display: flex; gap: 10px;">
                                <input type="text" id="upiIdInput" placeholder="Enter UPI ID (e.g. mobile@upi, name@oksbi)"
                                       style="flex: 1; background: var(--bg-input); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 10px 14px; color: #fff; font-size: 13.5px; outline: none;">
                                <button type="button" class="btn-secondary" style="padding: 10px 18px; font-size: 13px;" onclick="verifyUpi()">
                                    Verify
                                </button>
                            </div>
                            <div id="upiVerifyMsg" style="font-size: 12px; margin-top: 6px; display: none;"></div>
                        </div>
                    </div>

                    <!-- 2. Credit / Debit Card -->
                    <div class="pay-tab" id="tabCard">
                        <div class="pay-tab-header" onclick="selectPayTab('tabCard', 'Card')">
                            <div style="display: flex; align-items: center; gap: 14px;">
                                <input type="radio" name="payRadio" id="radioCard" style="accent-color: var(--primary); width: 18px; height: 18px;">
                                <div>
                                    <div style="font-weight: 700; color: #fff; font-size: 15px;">Credit / Debit Card</div>
                                    <div style="font-size: 12.5px; color: var(--text-muted);">Visa, MasterCard, RuPay, Maestro</div>
                                </div>
                            </div>
                            <span style="font-size: 22px;">💳</span>
                        </div>
                        <div class="pay-tab-body">
                            <div style="display: flex; flex-direction: column; gap: 12px;">
                                <div>
                                    <label style="display: block; font-size: 12.5px; color: var(--text-muted); margin-bottom: 4px;">Card Number</label>
                                    <input type="text" placeholder="XXXX XXXX XXXX XXXX" maxlength="19"
                                           style="width: 100%; background: var(--bg-input); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 10px 14px; color: #fff; font-size: 13.5px; letter-spacing: 2px;">
                                </div>

                                <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 12px;">
                                    <div>
                                        <label style="display: block; font-size: 12.5px; color: var(--text-muted); margin-bottom: 4px;">Valid Thru</label>
                                        <input type="text" placeholder="MM/YY" maxlength="5"
                                               style="width: 100%; background: var(--bg-input); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 10px 14px; color: #fff; font-size: 13.5px;">
                                    </div>
                                    <div>
                                        <label style="display: block; font-size: 12.5px; color: var(--text-muted); margin-bottom: 4px;">CVV</label>
                                        <input type="password" placeholder="•••" maxlength="4"
                                               style="width: 100%; background: var(--bg-input); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 10px 14px; color: #fff; font-size: 13.5px;">
                                    </div>
                                </div>

                                <div style="font-size: 11.5px; color: var(--text-muted); display: flex; align-items: center; gap: 6px;">
                                    <span>🛡️</span>
                                    <span>Demo checkout: No real transactions or sensitive data stored.</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 3. Net Banking -->
                    <div class="pay-tab" id="tabNet">
                        <div class="pay-tab-header" onclick="selectPayTab('tabNet', 'Net Banking')">
                            <div style="display: flex; align-items: center; gap: 14px;">
                                <input type="radio" name="payRadio" id="radioNet" style="accent-color: var(--primary); width: 18px; height: 18px;">
                                <div>
                                    <div style="font-weight: 700; color: #fff; font-size: 15px;">Net Banking</div>
                                    <div style="font-size: 12.5px; color: var(--text-muted);">All major Indian banks supported</div>
                                </div>
                            </div>
                            <span style="font-size: 22px;">🏦</span>
                        </div>
                        <div class="pay-tab-body">
                            <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; margin-bottom: 12px;">
                                <div class="bank-chip active" onclick="selectBank(this)">HDFC Bank</div>
                                <div class="bank-chip" onclick="selectBank(this)">SBI Bank</div>
                                <div class="bank-chip" onclick="selectBank(this)">ICICI Bank</div>
                                <div class="bank-chip" onclick="selectBank(this)">Axis Bank</div>
                            </div>
                        </div>
                    </div>

                    <!-- 4. Cash on Delivery (COD) -->
                    <div class="pay-tab" id="tabCOD">
                        <div class="pay-tab-header" onclick="selectPayTab('tabCOD', 'Cash on Delivery')">
                            <div style="display: flex; align-items: center; gap: 14px;">
                                <input type="radio" name="payRadio" id="radioCOD" style="accent-color: var(--primary); width: 18px; height: 18px;">
                                <div>
                                    <div style="font-weight: 700; color: #fff; font-size: 15px;">Cash / QR on Delivery</div>
                                    <div style="font-size: 12.5px; color: var(--text-muted);">Pay in cash or scan QR upon delivery</div>
                                </div>
                            </div>
                            <span style="font-size: 22px;">💵</span>
                        </div>
                        <div class="pay-tab-body">
                            <p style="font-size: 13.5px; color: var(--text-secondary); line-height: 1.5;">
                                Please keep exact change ready or use any UPI QR scanner directly on your delivery executive's phone upon arrival.
                            </p>
                        </div>
                    </div>

                </div>

                <!-- Right Column: Final Payable Summary & Place Order CTA -->
                <div>
                    <div class="bill-card">
                        <h3>Payable Amount</h3>

                        <div style="text-align: center; padding: 18px 0; border-bottom: 1px solid var(--border-subtle);">
                            <div style="font-size: 36px; font-weight: 800; color: var(--primary); letter-spacing: -0.5px;">
                                ₹<%= String.format("%.2f", finalTotal) %>
                            </div>
                            <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">
                                Total inclusive of all taxes and delivery
                            </div>
                        </div>

                        <!-- Delivery preview -->
                        <div style="display: flex; flex-direction: column; gap: 8px; font-size: 13px; color: var(--text-secondary);">
                            <div style="display: flex; justify-content: space-between;">
                                <span>Delivering to:</span>
                                <strong style="color: #fff;"><%= (user.getName() != null) ? user.getName() : "Customer" %></strong>
                            </div>
                            <div style="font-size: 12px; color: var(--text-muted); line-height: 1.4;">
                                📍 <%= address %>
                            </div>
                            <div style="font-size: 12px; color: var(--text-muted);">
                                📞 <%= phone %>
                            </div>
                        </div>

                        <!-- Big CTA Button -->
                        <button type="submit" class="btn-primary" style="width: 100%; padding: 15px; font-size: 16px; border-radius: var(--radius-pill); font-weight: 800; box-shadow: var(--primary-glow);">
                            Pay ₹<%= String.format("%.2f", finalTotal) %> & Place Order →
                        </button>

                        <!-- Trust Seal -->
                        <div style="background: var(--bg-surface); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 12px; text-align: center;">
                            <div style="font-size: 13px; font-weight: 700; color: var(--success); margin-bottom: 2px;">
                                🔒 100% Safe & Secure Payments
                            </div>
                            <div style="font-size: 11px; color: var(--text-muted);">
                                Encrypted via 256-bit SSL connection
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </form>

    </main>

    <!-- Shared Dark Footer -->
    <jsp:include page="/Foodie/includes/footer.jsp" />

    <script>
        function selectPayTab(tabId, methodName) {
            document.querySelectorAll('.pay-tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('input[name="payRadio"]').forEach(r => r.checked = false);

            const tab = document.getElementById(tabId);
            if (tab) {
                tab.classList.add('active');
                const radio = tab.querySelector('input[type="radio"]');
                if (radio) radio.checked = true;
            }

            const methodInput = document.getElementById('selectedPaymentMethod');
            if (methodInput) {
                methodInput.value = methodName;
            }
        }

        function setUpiOption(appName, btn) {
            document.querySelectorAll('.upi-app-btn').forEach(b => b.classList.remove('active'));
            if (btn) btn.classList.add('active');
            const upiInput = document.getElementById('upiIdInput');
            if (upiInput) {
                upiInput.value = 'user@' + appName.toLowerCase().replace(/\s+/g, '');
            }
        }

        function verifyUpi() {
            const input = document.getElementById('upiIdInput');
            const msg = document.getElementById('upiVerifyMsg');
            if (!input || !msg) return;

            if (input.value.trim().length > 3 && input.value.includes('@')) {
                msg.style.display = 'block';
                msg.style.color = 'var(--success)';
                msg.innerText = '✅ Verified: ' + input.value.trim();
            } else {
                msg.style.display = 'block';
                msg.style.color = 'var(--danger)';
                msg.innerText = '⚠️ Please enter a valid UPI ID (e.g. 9876543210@upi)';
            }
        }

        function selectBank(chip) {
            document.querySelectorAll('.bank-chip').forEach(c => c.classList.remove('active'));
            chip.classList.add('active');
        }
    </script>
</body>
</html>


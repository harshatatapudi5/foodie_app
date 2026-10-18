<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account — Foodie</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Dark Design System -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Foodie/css/theme-dark.css">
    <style>
        .auth-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px 16px;
            background: radial-gradient(circle at 50% 10%, rgba(255, 87, 34, 0.08) 0%, transparent 60%), var(--bg-base);
        }
        .auth-box {
            width: 100%;
            max-width: 480px;
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-xl);
            padding: 36px 32px;
            box-shadow: var(--shadow-dropdown);
        }
        .auth-input {
            width: 100%;
            background: var(--bg-input);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-md);
            padding: 12px 16px;
            color: #fff;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s ease;
        }
        .auth-input:focus {
            border-color: var(--primary);
        }
    </style>
</head>
<body>

    <div class="auth-container">
        <div class="auth-box">

            <!-- Logo -->
            <div style="text-align: center; margin-bottom: 24px;">
                <a href="<%= request.getContextPath() %>/index.jsp" class="brand-logo" style="justify-content: center; margin-bottom: 8px;">
                    <span class="brand-logo-icon">🍴</span>
                    <span>Foodie</span>
                </a>
                <p style="font-size: 13.5px; color: var(--text-muted);">
                    Join Foodie and unlock delicious meals delivered to your doorstep.
                </p>
            </div>

            <!-- Error Notification -->
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div style="background: var(--danger-bg); border: 1px solid var(--danger); color: #fff; padding: 12px 16px; border-radius: var(--radius-md); margin-bottom: 20px; font-size: 13.5px; display: flex; align-items: center; gap: 8px;">
                    <span>⚠️</span>
                    <span><%= error %></span>
                </div>
            <% } %>

            <!-- Signup Form -->
            <form action="<%= request.getContextPath() %>/signup" method="post">
                <div style="display: flex; flex-direction: column; gap: 14px; margin-bottom: 24px;">
                    <div>
                        <label for="name" style="display: block; font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px;">Full Name *</label>
                        <input type="text" id="name" name="name" class="auth-input" placeholder="e.g. Rahul Sharma" required>
                    </div>

                    <div>
                        <label for="email" style="display: block; font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px;">Email Address *</label>
                        <input type="email" id="email" name="email" class="auth-input" placeholder="e.g. rahul@example.com" required>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                        <div>
                            <label for="password" style="display: block; font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px;">Password *</label>
                            <input type="password" id="password" name="password" class="auth-input" placeholder="Min 6 chars" required minlength="6">
                        </div>
                        <div>
                            <label for="confirmPassword" style="display: block; font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px;">Confirm *</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="auth-input" placeholder="Re-enter password" required minlength="6">
                        </div>
                    </div>

                    <div>
                        <label for="address" style="display: block; font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px;">Delivery Address *</label>
                        <input type="text" id="address" name="address" class="auth-input" placeholder="Flat / House No., Landmark, City" required>
                    </div>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%; padding: 14px; font-size: 15px; border-radius: var(--radius-pill); font-weight: 700; box-shadow: var(--primary-glow-sm);">
                    Create Account →
                </button>
            </form>

            <div style="margin-top: 24px; text-align: center; font-size: 13.5px; color: var(--text-secondary);">
                Already have an account?
                <a href="<%= request.getContextPath() %>/login.jsp" style="color: var(--primary); font-weight: 700;">
                    Sign In
                </a>
            </div>

            <div style="margin-top: 16px; text-align: center;">
                <a href="<%= request.getContextPath() %>/index.jsp" style="font-size: 13px; color: var(--text-muted); text-decoration: underline;">
                    ← Back to Home
                </a>
            </div>

        </div>
    </div>

</body>
</html>
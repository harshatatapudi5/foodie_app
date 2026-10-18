<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In — Foodie</title>
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
            padding: 24px 16px;
            background: radial-gradient(circle at 50% 10%, rgba(255, 87, 34, 0.08) 0%, transparent 60%), var(--bg-base);
        }
        .auth-box {
            width: 100%;
            max-width: 440px;
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
            <div style="text-align: center; margin-bottom: 28px;">
                <a href="<%= request.getContextPath() %>/index.jsp" class="brand-logo" style="justify-content: center; margin-bottom: 8px;">
                    <span class="brand-logo-icon">🍴</span>
                    <span>Foodie</span>
                </a>
                <p style="font-size: 13.5px; color: var(--text-muted);">
                    Welcome back! Sign in to order your favorite dishes.
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

            <!-- Login Form -->
            <form action="<%= request.getContextPath() %>/login" method="post">
                <div style="display: flex; flex-direction: column; gap: 16px; margin-bottom: 24px;">
                    <div>
                        <label for="email" style="display: block; font-size: 13px; font-weight: 600; color: var(--text-secondary); margin-bottom: 6px;">Email Address</label>
                        <input type="email" id="email" name="email" class="auth-input" placeholder="e.g. yourname@example.com" required>
                    </div>

                    <div>
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                            <label for="password" style="font-size: 13px; font-weight: 600; color: var(--text-secondary);">Password</label>
                            <a href="#" onclick="alert('Please contact support or re-register if password forgotten in demo mode.');" style="font-size: 12px; color: var(--primary);">Forgot?</a>
                        </div>
                        <input type="password" id="password" name="password" class="auth-input" placeholder="Enter your password" required>
                    </div>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%; padding: 14px; font-size: 15px; border-radius: var(--radius-pill); font-weight: 700; box-shadow: var(--primary-glow-sm);">
                    Sign In →
                </button>
            </form>

            <div style="margin-top: 24px; text-align: center; font-size: 13.5px; color: var(--text-secondary);">
                Don't have an account?
                <a href="<%= request.getContextPath() %>/signup.jsp" style="color: var(--primary); font-weight: 700;">
                    Create Account
                </a>
            </div>

            <div style="margin-top: 20px; text-align: center;">
                <a href="<%= request.getContextPath() %>/index.jsp" style="font-size: 13px; color: var(--text-muted); text-decoration: underline;">
                    ← Back to Home
                </a>
            </div>

        </div>
    </div>

</body>
</html>
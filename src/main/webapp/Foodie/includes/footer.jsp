<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="site-footer" id="about">
    <div class="footer-container">
        <div class="footer-grid">
            <div class="footer-brand">
                <a href="<%= request.getContextPath() %>/index.jsp" class="brand-logo">
                    <span class="brand-logo-icon">🍴</span>
                    <span>Food<strong>ie</strong></span>
                </a>
                <p>
                    Experience the finest cuisines and prompt deliveries right to your doorstep. Best restaurants, live tracking, and safe contactless delivery.
                </p>
                <div style="display: flex; gap: 12px; margin-top: 18px;">
                    <span class="icon-btn" style="cursor: pointer;" title="Mobile App">📱</span>
                    <span class="icon-btn" style="cursor: pointer;" title="Support Chat">💬</span>
                    <span class="icon-btn" style="cursor: pointer;" title="Social Media">📷</span>
                    <span class="icon-btn" style="cursor: pointer;" title="Website">🌐</span>
                </div>
            </div>

            <div class="footer-col">
                <h4>Navigation</h4>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/index.jsp">Home</a></li>
                    <li><a href="<%= request.getContextPath() %>/restaurant">Restaurants</a></li>
                    <li><a href="<%= request.getContextPath() %>/cart">My Cart</a></li>
                    <li><a href="<%= request.getContextPath() %>/orders">My Orders</a></li>
                    <li><a href="<%= request.getContextPath() %>/profile">My Profile</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>Top Cuisines</h4>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/restaurant?cuisine=Biryani">Hyderabadi Biryani</a></li>
                    <li><a href="<%= request.getContextPath() %>/restaurant?cuisine=Pizza">Italian Pizza</a></li>
                    <li><a href="<%= request.getContextPath() %>/restaurant?cuisine=Burgers">Gourmet Burgers</a></li>
                    <li><a href="<%= request.getContextPath() %>/restaurant?cuisine=Chinese">Spicy Chinese</a></li>
                    <li><a href="<%= request.getContextPath() %>/restaurant?cuisine=Desserts">Sweet Desserts</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>Contact & Help</h4>
                <ul>
                    <li><a href="mailto:support@foodie.com">support@foodie.com</a></li>
                    <li><a href="tel:+911800123456">+91 1800 123 456</a></li>
                    <li><a href="<%= request.getContextPath() %>/index.jsp#about">Help Center & FAQs</a></li>
                    <li><a href="<%= request.getContextPath() %>/index.jsp#about">Terms of Service</a></li>
                    <li><a href="<%= request.getContextPath() %>/index.jsp#about">Privacy Policy</a></li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <p>&copy; 2026 Foodie Technologies Pvt. Ltd. All rights reserved.</p>
            <p>Made with ❤️ for food lovers everywhere.</p>
        </div>
    </div>
</footer>

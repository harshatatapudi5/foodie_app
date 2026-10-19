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

<!-- ==========================================================================
     FOODIE REUSABLE AURORA GLASS DETAIL MODALS
     ========================================================================== -->

<!-- 1. Restaurant Detail Modal -->
<div class="glass-modal-overlay" id="restaurantDetailModal" aria-hidden="true" role="dialog" aria-labelledby="resModalTitle">
    <div class="glass-modal-dialog">
        <button class="glass-modal-close-btn" aria-label="Close restaurant details">✕</button>
        <div class="modal-hero-cover">
            <img id="resModalImg" src="" alt="Restaurant Cover">
            <div class="modal-hero-badge badge-discount" id="resModalBadge">Special Deal</div>
        </div>
        <div class="modal-body-content">
            <div class="modal-title-row">
                <h3 class="modal-item-title" id="resModalTitle">Restaurant Name</h3>
                <span class="badge-rating" id="resModalRating">⭐ 4.5</span>
            </div>
            <div class="modal-meta-chips">
                <span class="modal-chip" id="resModalCuisine">Multi-Cuisine</span>
                <span class="modal-chip" id="resModalTime">⏱ 30-40 mins</span>
                <span class="modal-chip" id="resModalFee">🛵 Free Delivery</span>
                <span class="modal-chip" id="resModalReviews">(500+ ratings)</span>
            </div>
            <div class="modal-meta-chips" style="margin-bottom: 14px;">
                <span class="modal-chip" id="resModalAddress" style="color: var(--text-secondary);">📍 Location</span>
            </div>
            <div class="modal-desc-box" id="resModalDesc">
                Authentic kitchen serving flavorful dishes prepared fresh daily.
            </div>
            <div class="modal-action-footer">
                <button type="button" class="btn btn-secondary" onclick="window.closeFoodieModal('restaurantDetailModal')">Close</button>
                <a href="#" class="btn btn-primary" id="resModalMenuBtn" style="flex: 1; text-align: center;">View Full Menu &amp; Order →</a>
            </div>
        </div>
    </div>
</div>

<!-- 2. Food Item Detail Modal -->
<div class="glass-modal-overlay" id="foodDetailModal" aria-hidden="true" role="dialog" aria-labelledby="foodModalTitle">
    <div class="glass-modal-dialog">
        <button class="glass-modal-close-btn" aria-label="Close food item details">✕</button>
        <div class="modal-hero-cover">
            <img id="foodModalImg" src="" alt="Food Item">
            <div class="modal-hero-badge" id="foodModalStatus">● In Stock</div>
        </div>
        <div class="modal-body-content">
            <div class="modal-title-row">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <span id="foodModalVegIcon" class="food-type-icon veg"></span>
                    <h3 class="modal-item-title" id="foodModalTitle">Dish Name</h3>
                </div>
                <span class="modal-item-price" id="foodModalPrice">₹0.00</span>
            </div>
            <div class="modal-meta-chips">
                <span class="modal-chip" id="foodModalCategory">Main Course</span>
                <span class="modal-chip" id="foodModalVegText" style="font-weight: 700;">Pure Veg</span>
                <span class="modal-chip" id="foodModalRestaurant">🍴 Kitchen</span>
            </div>
            <div class="modal-desc-box" id="foodModalDesc">
                Delicious food prepared with the freshest ingredients and culinary passion.
            </div>
            <form id="foodModalForm" method="post" action="<%= request.getContextPath() %>/cart">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="menuId" id="foodModalMenuId" value="">
                <input type="hidden" name="resId" id="foodModalResId" value="">
                <input type="hidden" name="quantity" id="foodModalQtyInput" value="1">
                <div class="modal-action-footer">
                    <div class="modal-qty-control">
                        <button type="button" class="modal-qty-btn" id="foodModalDecBtn" aria-label="Decrease quantity">−</button>
                        <span class="modal-qty-value" id="foodModalQtyVal">1</span>
                        <button type="button" class="modal-qty-btn" id="foodModalIncBtn" aria-label="Increase quantity">+</button>
                    </div>
                    <button type="submit" class="btn btn-primary" id="foodModalSubmitBtn" style="flex: 1;">
                        Add to Cart • ₹0.00
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 3. Category Detail Modal -->
<div class="glass-modal-overlay" id="categoryDetailModal" aria-hidden="true" role="dialog" aria-labelledby="catModalTitle">
    <div class="glass-modal-dialog">
        <button class="glass-modal-close-btn" aria-label="Close category details">✕</button>
        <div class="modal-hero-cover">
            <img id="catModalImg" src="" alt="Cuisine Category">
            <div class="modal-hero-badge badge-discount" id="catModalCount">50+ Options</div>
        </div>
        <div class="modal-body-content">
            <div class="modal-title-row">
                <h3 class="modal-item-title" id="catModalTitle">Cuisine</h3>
            </div>
            <div class="modal-meta-chips">
                <span class="modal-chip">⚡ Fast Delivery</span>
                <span class="modal-chip">🔥 Trending Choice</span>
            </div>
            <div class="modal-desc-box" id="catModalDesc">
                Explore authentic cuisines from top-rated restaurants near you.
            </div>
            <div style="margin-bottom: 20px;">
                <span style="font-size: 13px; font-weight: 700; color: var(--text-white); text-transform: uppercase; letter-spacing: 0.5px;">Popular Dishes:</span>
                <p id="catModalDishes" style="color: var(--text-secondary); font-size: 14px; margin-top: 6px; line-height: 1.5;"></p>
            </div>
            <div class="modal-action-footer">
                <button type="button" class="btn btn-secondary" onclick="window.closeFoodieModal('categoryDetailModal')">Close</button>
                <a href="#" class="btn btn-primary" id="catModalExploreBtn" style="flex: 1; text-align: center;">Explore Restaurants →</a>
            </div>
        </div>
    </div>
</div>

<!-- Website-Wide Animation & Glass Detail Modal Controllers -->
<script src="<%= request.getContextPath() %>/Foodie/js/animations.js"></script>
<script src="<%= request.getContextPath() %>/Foodie/js/glass-details.js"></script>

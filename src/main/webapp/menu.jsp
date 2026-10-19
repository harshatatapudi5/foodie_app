<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.MenuData" %>
<%@ page import="com.tap.model.ResDetails" %>
<%@ page import="com.tap.DAOImp.DAOImp" %>
<%@ page import="com.tap.DAOImp.DAOImpRes" %>

<%
    User loggedInUser = (User) session.getAttribute("user");
    Cart cart = (Cart) session.getAttribute("cart");
    if (cart == null) {
        cart = new Cart();
        session.setAttribute("cart", cart);
    }

    ResDetails restaurant = (ResDetails) request.getAttribute("restaurant");
    String resIdParam = request.getParameter("resId");
    int resId = 0;
    if (restaurant != null) {
        resId = restaurant.getId();
    } else if (resIdParam != null && !resIdParam.trim().isEmpty()) {
        try {
            resId = Integer.parseInt(resIdParam);
            DAOImpRes resDAO = new DAOImpRes();
            restaurant = resDAO.getRes(resId);
        } catch (Exception ignored) {}
    }

    List<MenuData> allMenu = (List<MenuData>) request.getAttribute("allMenu");
    if (allMenu == null && resId > 0) {
        try {
            DAOImp menuDAO = new DAOImp();
            allMenu = menuDAO.getMenuByRestaurant(resId);
        } catch (Exception ignored) {}
    }

    String cartMessage = (String) session.getAttribute("cartMessage");
    if (cartMessage != null) {
        session.removeAttribute("cartMessage");
    }

    request.setAttribute("activePage", "restaurants");
    request.setAttribute("backUrl", request.getContextPath() + "/restaurant");

    // Resolve restaurant image
    String resImage = (restaurant != null) ? restaurant.getImagePath() : "";
    String resImageUrl = "";
    if (resImage == null || resImage.trim().isEmpty()) {
        resImageUrl = request.getContextPath() + "/Foodie/images/restaurants/default.jpg";
    } else {
        resImage = resImage.trim();
        if (resImage.startsWith("/")) resImage = resImage.substring(1);
        if (resImage.startsWith("images/")) {
            resImageUrl = request.getContextPath() + "/Foodie/" + resImage;
        } else if (resImage.contains("/")) {
            resImageUrl = request.getContextPath() + "/Foodie/images/" + resImage;
        } else {
            resImageUrl = request.getContextPath() + "/Foodie/images/restaurants/" + resImage;
        }
    }

    String resName = (restaurant != null && restaurant.getResName() != null) ? restaurant.getResName() : "Restaurant Menu";
    String cuisine = (restaurant != null && restaurant.getCuisineType() != null) ? restaurant.getCuisineType() : "Delicious Cuisines";
    double rating = (restaurant != null) ? restaurant.getRating() : 4.5;
    String delTime = (restaurant != null && restaurant.getDelTime() != null) ? restaurant.getDelTime() : "30-40 mins";
    String address = (restaurant != null && restaurant.getAddress() != null) ? restaurant.getAddress() : "Hyderabad";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= resName %> — Foodie Menu</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Dark Design System -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Foodie/css/theme-dark.css">
    <style>
        .res-cover-banner {
            position: relative;
            height: 280px;
            border-radius: var(--radius-xl);
            overflow: hidden;
            border: 1px solid var(--border-subtle);
            margin-bottom: 28px;
            background: #121620;
        }
        .res-cover-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            filter: brightness(0.55);
        }
        .res-cover-content {
            position: absolute;
            inset: 0;
            padding: 30px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            background: linear-gradient(0deg, rgba(11,14,20,0.95) 0%, rgba(11,14,20,0.4) 60%, transparent 100%);
        }
        .res-cover-badge {
            background: rgba(16, 185, 129, 0.2);
            color: var(--success);
            border: 1px solid var(--success);
            padding: 4px 12px;
            border-radius: var(--radius-pill);
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .subtab-content {
            display: none;
        }
        .subtab-content.active {
            display: block;
        }
    </style>
</head>
<body>

    <!-- Shared Dark Header -->
    <jsp:include page="/Foodie/includes/navbar.jsp" />

    <main class="page-container" style="max-width: 1320px; margin: 24px auto; padding: 0 24px;">

        <!-- Flash Cart Message -->
        <% if (cartMessage != null && !cartMessage.isEmpty()) { %>
            <div style="background: rgba(255,87,34,0.15); border: 1px solid var(--primary); color: #fff; padding: 14px 20px; border-radius: var(--radius-md); margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <span style="font-size: 18px;">🛒</span>
                    <span style="font-size: 14px; font-weight: 600;"><%= cartMessage %></span>
                </div>
                <a href="<%= request.getContextPath() %>/cart" style="color: var(--primary); font-weight: 700; font-size: 13px; text-decoration: underline;">
                    View Cart →
                </a>
            </div>
        <% } %>

        <!-- Restaurant Cover Hero Banner -->
        <section class="res-cover-banner">
            <img src="<%= resImageUrl %>" alt="<%= resName %>" class="res-cover-img"
                 onerror="this.src='<%= request.getContextPath() %>/Foodie/images/restaurants/default.jpg';">
            
            <div class="res-cover-content">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <a href="<%= request.getContextPath() %>/restaurant" class="btn-secondary" style="padding: 6px 14px; font-size: 13px; border-radius: var(--radius-pill); background: rgba(0,0,0,0.6); backdrop-filter: blur(8px);">
                        ← Back to Restaurants
                    </a>
                    <div style="display: flex; gap: 10px;">
                        <button type="button" class="icon-btn" style="background: rgba(0,0,0,0.6); backdrop-filter: blur(8px);" onclick="navigator.clipboard.writeText(window.location.href); alert('Restaurant link copied to clipboard!');" title="Share Restaurant">
                            🔗
                        </button>
                        <button type="button" class="icon-btn" style="background: rgba(0,0,0,0.6); backdrop-filter: blur(8px);" id="btnFavRes" onclick="toggleFav(this)" title="Save to Favorites">
                            🤍
                        </button>
                    </div>
                </div>

                <div>
                    <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 10px;">
                        <span class="res-cover-badge">● Open Now</span>
                        <span style="font-size: 13px; color: var(--text-muted);">Delivery within <%= delTime %></span>
                    </div>

                    <h1 style="font-size: 32px; font-weight: 800; color: #fff; margin-bottom: 8px;">
                        <%= resName %>
                    </h1>

                    <div style="display: flex; flex-wrap: wrap; align-items: center; gap: 16px; font-size: 14px; color: var(--text-secondary);">
                        <span style="background: var(--warning-bg); color: var(--warning); padding: 4px 10px; border-radius: var(--radius-pill); font-weight: 700; display: inline-flex; align-items: center; gap: 4px;">
                            ★ <%= String.format("%.1f", rating) %> (1.2K+ ratings)
                        </span>
                        <span>•</span>
                        <span><%= cuisine %></span>
                        <span>•</span>
                        <span>📍 <%= address %></span>
                        <span>•</span>
                        <span style="color: var(--success); font-weight: 600;">🛵 Free Delivery on orders above ₹199</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- Menu Navigation Tabs -->
        <div class="menu-tabs-bar">
            <button class="menu-tab-btn active" onclick="switchMenuSubTab('tab-menu', this)">
                🍽 Menu (<%= (allMenu != null) ? allMenu.size() : 0 %>)
            </button>
            <button class="menu-tab-btn" onclick="switchMenuSubTab('tab-reviews', this)">
                ⭐ Reviews & Ratings (1.2k)
            </button>
            <button class="menu-tab-btn" onclick="switchMenuSubTab('tab-about', this)">
                ℹ️ About & Location
            </button>
        </div>

        <!-- TAB 1: MENU ITEMS -->
        <div id="tab-menu" class="subtab-content active">

            <!-- Filter & Search Bar inside Menu -->
            <div class="menu-filter-bar">
                <!-- Search within restaurant -->
                <div class="menu-search-input-wrap">
                    <span class="menu-search-icon">🔍</span>
                    <input type="text" id="menuItemSearch" placeholder="Search dishes in <%= resName %>..." oninput="filterMenuItems()">
                </div>

                <!-- Veg / Non-Veg Filters -->
                <div style="display: flex; gap: 10px; align-items: center;">
                    <button type="button" class="veg-toggle-btn" id="vegOnlyFilterBtn" onclick="toggleVegOnlyFilter()">
                        <span class="food-type-icon veg"></span> Veg Only
                    </button>
                    <button type="button" class="veg-toggle-btn" id="nonVegOnlyFilterBtn" onclick="toggleNonVegFilter()">
                        <span class="food-type-icon non-veg"></span> Non-Veg
                    </button>
                </div>
            </div>

            <!-- Category Chips -->
            <div class="category-chips-bar" style="margin-bottom: 24px;">
                <button type="button" class="category-chip active" onclick="filterMenuCategory('All', this)">
                    🍽 All Dishes
                </button>
                <button type="button" class="category-chip" onclick="filterMenuCategory('Bestsellers', this)">
                    ⭐ Bestsellers
                </button>
                <button type="button" class="category-chip" onclick="filterMenuCategory('Biryani', this)">
                    🍚 Biryani & Rice
                </button>
                <button type="button" class="category-chip" onclick="filterMenuCategory('Starters', this)">
                    🍗 Starters & Snacks
                </button>
                <button type="button" class="category-chip" onclick="filterMenuCategory('Combos', this)">
                    🍱 Value Combos
                </button>
                <button type="button" class="category-chip" onclick="filterMenuCategory('Beverages', this)">
                    🥤 Drinks & Shakes
                </button>
                <button type="button" class="category-chip" onclick="filterMenuCategory('Desserts', this)">
                    🍰 Sweet Desserts
                </button>
            </div>

            <!-- Menu Grid -->
            <% if (allMenu != null && !allMenu.isEmpty()) { %>
                <div class="food-grid" id="foodItemsContainer">
                    <%
                        Map<Integer, CartItem> cartMap = (cart != null) ? cart.getItems() : null;

                        for (MenuData m : allMenu) {
                            String itemCat = (m.getCategory() != null) ? m.getCategory() : "Bestsellers";
                            boolean isAvailable = !"no".equalsIgnoreCase(m.getIsAvailable()) && !"false".equalsIgnoreCase(m.getIsAvailable());

                            // Check Veg vs Non-Veg based on item name or category
                            String lowerName = (m.getItemName() != null) ? m.getItemName().toLowerCase() : "";
                            boolean isNonVeg = lowerName.contains("chicken") || lowerName.contains("mutton") 
                                            || lowerName.contains("fish") || lowerName.contains("egg") 
                                            || lowerName.contains("meat") || lowerName.contains("beef")
                                            || lowerName.contains("prawn") || lowerName.contains("peri peri chicken")
                                            || lowerName.contains("roast chicken") || lowerName.contains("tikka");

                            // Resolve food image safely
                            String foodImage = m.getImagePath();
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

                            // Check if already in cart
                            CartItem existingItem = (cartMap != null) ? cartMap.get(m.getId()) : null;
                            int inCartQty = (existingItem != null) ? existingItem.getQuantity() : 0;
                            String itemDesc = (m.getDesc() != null && !m.getDesc().trim().isEmpty()) 
                                ? m.getDesc() 
                                : "Prepared fresh with signature authentic spices and premium ingredients.";
                    %>
                        <div class="food-card" 
                             data-id="<%= m.getId() %>"
                             data-name="<%= m.getItemName() %>"
                             data-desc="<%= itemDesc %>"
                             data-price="<%= String.format(java.util.Locale.US, "%.2f", m.getPrice()) %>"
                             data-category="<%= itemCat %>"
                             data-veg="<%= isNonVeg ? "non-veg" : "veg" %>"
                             data-image="<%= foodImageUrl %>"
                             data-available="<%= isAvailable %>"
                             data-restaurant="<%= resName %>"
                             data-resid="<%= resId %>"
                             data-context-path="<%= request.getContextPath() %>">
                            
                            <div class="food-card-left">
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <span class="food-type-icon <%= isNonVeg ? "non-veg" : "veg" %>" 
                                          title="<%= isNonVeg ? "Non-Vegetarian" : "Vegetarian" %>"></span>
                                    <span style="font-size: 11px; font-weight: 700; color: <%= isNonVeg ? "var(--danger)" : "var(--success)" %>; text-transform: uppercase;">
                                        <%= isNonVeg ? "Non-Veg" : "Pure Veg" %>
                                    </span>
                                </div>

                                <h3 class="food-card-title"><%= m.getItemName() %></h3>
                                <div class="food-card-price">₹<%= String.format("%.2f", m.getPrice()) %></div>
                                
                                <p class="food-card-desc">
                                    <%= (m.getDesc() != null && !m.getDesc().trim().isEmpty()) ? m.getDesc() : "Prepared fresh with signature authentic spices and premium ingredients." %>
                                </p>
                            </div>

                            <div class="food-card-right">
                                <img src="<%= foodImageUrl %>" 
                                     alt="<%= m.getItemName() %>" 
                                     class="food-card-img"
                                     onerror="this.src='<%= request.getContextPath() %>/Foodie/images/menu/pizza.jpg';">

                                <div class="food-card-action">
                                    <% if (!isAvailable) { %>
                                        <button type="button" class="btn-add" disabled style="opacity: 0.5; cursor: not-allowed; border-color: var(--text-muted); color: var(--text-muted);">
                                            Sold Out
                                        </button>
                                    <% } else if (inCartQty > 0) { %>
                                        <!-- In Cart Stepper -->
                                        <div class="quantity-stepper" style="background: var(--bg-card); box-shadow: 0 4px 10px rgba(0,0,0,0.5);">
                                            <form action="<%= request.getContextPath() %>/cart" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="decrease">
                                                <input type="hidden" name="menuId" value="<%= m.getId() %>">
                                                <input type="hidden" name="resId" value="<%= resId %>">
                                                <input type="hidden" name="redirect" value="menu">
                                                <button type="submit" class="btn-step" title="Decrease">−</button>
                                            </form>

                                            <span class="step-value"><%= inCartQty %></span>

                                            <form action="<%= request.getContextPath() %>/cart" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="increase">
                                                <input type="hidden" name="menuId" value="<%= m.getId() %>">
                                                <input type="hidden" name="resId" value="<%= resId %>">
                                                <input type="hidden" name="redirect" value="menu">
                                                <button type="submit" class="btn-step" title="Increase">+</button>
                                            </form>
                                        </div>
                                    <% } else { %>
                                        <!-- Add Button -->
                                        <form action="<%= request.getContextPath() %>/cart" method="post" style="width: 100%;">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="menuId" value="<%= m.getId() %>">
                                            <input type="hidden" name="resId" value="<%= resId %>">
                                            <input type="hidden" name="redirect" value="menu">
                                            <button type="submit" class="btn-add">
                                                ADD +
                                            </button>
                                        </form>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- No Dishes Found (Filtered) -->
                <div id="noDishesFound" style="display: none; text-align: center; padding: 60px 20px;">
                    <div style="font-size: 48px; margin-bottom: 12px;">🔍</div>
                    <h3 style="font-size: 18px; color: #fff; margin-bottom: 6px;">No dishes match your filter</h3>
                    <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 20px;">Try clearing search keywords or filters to see all available items.</p>
                    <button type="button" class="btn-secondary" onclick="resetMenuFilters()">Reset All Filters</button>
                </div>

            <% } else { %>
                <div class="empty-state-view">
                    <span class="empty-state-icon">🍽️</span>
                    <h3 class="empty-state-title">No Menu Items Listed</h3>
                    <p class="empty-state-text">This restaurant is updating its dishes. Please check back shortly or explore other nearby restaurants.</p>
                    <a href="<%= request.getContextPath() %>/restaurant" class="btn-primary">Browse Other Restaurants</a>
                </div>
            <% } %>
        </div>

        <!-- TAB 2: REVIEWS -->
        <div id="tab-reviews" class="subtab-content">
            <div style="background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: var(--radius-xl); padding: 32px; margin-bottom: 40px;">
                <div style="display: flex; gap: 32px; align-items: center; flex-wrap: wrap; margin-bottom: 30px; border-bottom: 1px solid var(--border-subtle); padding-bottom: 24px;">
                    <div style="text-align: center; min-width: 140px;">
                        <div style="font-size: 48px; font-weight: 800; color: var(--warning);"><%= String.format("%.1f", rating) %></div>
                        <div style="color: var(--text-muted); font-size: 13px;">out of 5.0</div>
                        <div style="color: var(--text-secondary); font-size: 13px; font-weight: 600; margin-top: 4px;">1,240 Verified Reviews</div>
                    </div>
                    <div style="flex: 1; min-width: 260px; display: flex; flex-direction: column; gap: 8px;">
                        <div style="display: flex; align-items: center; gap: 12px; font-size: 13px;">
                            <span>5 ★</span>
                            <div style="flex: 1; height: 6px; background: var(--bg-surface); border-radius: var(--radius-pill); overflow: hidden;">
                                <div style="width: 78%; height: 100%; background: var(--success);"></div>
                            </div>
                            <span style="color: var(--text-muted);">78%</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 12px; font-size: 13px;">
                            <span>4 ★</span>
                            <div style="flex: 1; height: 6px; background: var(--bg-surface); border-radius: var(--radius-pill); overflow: hidden;">
                                <div style="width: 15%; height: 100%; background: var(--warning);"></div>
                            </div>
                            <span style="color: var(--text-muted);">15%</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 12px; font-size: 13px;">
                            <span>3 ★</span>
                            <div style="flex: 1; height: 6px; background: var(--bg-surface); border-radius: var(--radius-pill); overflow: hidden;">
                                <div style="width: 5%; height: 100%; background: var(--text-muted);"></div>
                            </div>
                            <span style="color: var(--text-muted);">5%</span>
                        </div>
                    </div>
                </div>

                <!-- Customer Review Cards -->
                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <div style="background: var(--bg-surface); border: 1px solid var(--border-subtle); border-radius: var(--radius-lg); padding: 20px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <div style="width: 38px; height: 38px; border-radius: 50%; background: var(--primary-gradient); display: flex; align-items: center; justify-content: center; font-weight: 700; color: #fff;">A</div>
                                <div>
                                    <div style="font-weight: 700; color: #fff; font-size: 14px;">Ananya Rao</div>
                                    <div style="color: var(--text-muted); font-size: 12px;">Yesterday • Verified Order</div>
                                </div>
                            </div>
                            <span style="color: var(--warning); font-size: 13px; font-weight: 700;">★★★★★ 5.0</span>
                        </div>
                        <p style="color: var(--text-secondary); font-size: 13.5px; line-height: 1.5;">
                            "Food arrived piping hot and fresh! Packaging was spill-proof and neat. The authentic flavor really stands out. Will definitely reorder!"
                        </p>
                    </div>

                    <div style="background: var(--bg-surface); border: 1px solid var(--border-subtle); border-radius: var(--radius-lg); padding: 20px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <div style="width: 38px; height: 38px; border-radius: 50%; background: var(--secondary-blue, #3B82F6); display: flex; align-items: center; justify-content: center; font-weight: 700; color: #fff;">V</div>
                                <div>
                                    <div style="font-weight: 700; color: #fff; font-size: 14px;">Vikram Sharma</div>
                                    <div style="color: var(--text-muted); font-size: 12px;">3 days ago • Verified Order</div>
                                </div>
                            </div>
                            <span style="color: var(--warning); font-size: 13px; font-weight: 700;">★★★★☆ 4.0</span>
                        </div>
                        <p style="color: var(--text-secondary); font-size: 13.5px; line-height: 1.5;">
                            "Generous portions and great taste. Delivery executive arrived 5 minutes earlier than estimated. Truly impressive service."
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- TAB 3: ABOUT & LOCATION -->
        <div id="tab-about" class="subtab-content">
            <div style="background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: var(--radius-xl); padding: 32px; margin-bottom: 40px; display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px;">
                <div>
                    <h3 style="font-size: 18px; color: #fff; margin-bottom: 12px;">About <%= resName %></h3>
                    <p style="color: var(--text-secondary); font-size: 14px; line-height: 1.6; margin-bottom: 18px;">
                        Known for culinary excellence and premium hygiene standards. We source only fresh, locally grown ingredients to craft flavors you remember.
                    </p>
                    <div style="display: flex; flex-direction: column; gap: 10px; font-size: 13.5px; color: var(--text-muted);">
                        <div><strong>📍 Address:</strong> <%= address %></div>
                        <div><strong>⏱ Opening Hours:</strong> 11:00 AM – 11:30 PM (Mon – Sun)</div>
                        <div><strong>🛡 FSSAI License:</strong> 13622011000892</div>
                    </div>
                </div>

                <div style="background: var(--bg-surface); border: 1px solid var(--border-subtle); border-radius: var(--radius-lg); padding: 20px; display: flex; flex-direction: column; justify-content: space-between;">
                    <div>
                        <h4 style="color: #fff; font-size: 15px; margin-bottom: 8px;">Delivery & Hygiene Promise</h4>
                        <ul style="list-style: none; display: flex; flex-direction: column; gap: 10px; font-size: 13px; color: var(--text-secondary); margin-top: 12px;">
                            <li>✅ 100% Contactless Delivery available</li>
                            <li>✅ Temperature checks monitored daily</li>
                            <li>✅ Biodegradable & tamper-proof packaging</li>
                        </ul>
                    </div>
                    <div style="margin-top: 20px;">
                        <a href="tel:+911800123456" class="btn-secondary" style="width: 100%; text-align: center; display: block; font-size: 13px;">
                            📞 Call Restaurant Support
                        </a>
                    </div>
                </div>
            </div>
        </div>

    </main>

    <!-- Floating Bottom Cart Bar (Shows if cart has items) -->
    <% if (cart != null && cart.getTotalQuantity() > 0) { %>
        <aside class="floating-cart-bar" role="region" aria-label="Cart Summary Bar">
            <div style="display: flex; align-items: center; gap: 16px;">
                <div style="width: 44px; height: 44px; border-radius: 50%; background: var(--primary-gradient); display: flex; align-items: center; justify-content: center; font-size: 20px; box-shadow: var(--primary-glow-sm);">
                    🛒
                </div>
                <div>
                    <div style="font-size: 15px; font-weight: 800; color: #fff;">
                        <%= cart.getTotalQuantity() %> <%= (cart.getTotalQuantity() == 1) ? "item" : "items" %> added
                    </div>
                    <div style="font-size: 13px; color: var(--primary); font-weight: 700;">
                        Total: ₹<%= String.format("%.2f", cart.getTotal()) %> <span style="font-size: 11px; color: var(--text-muted); font-weight: 400;">(plus taxes)</span>
                    </div>
                </div>
            </div>

            <a href="<%= request.getContextPath() %>/cart" class="btn-primary" style="padding: 10px 24px; font-size: 14px; border-radius: var(--radius-pill); display: flex; align-items: center; gap: 8px;">
                <span>View Cart</span>
                <span>→</span>
            </a>
        </aside>
    <% } %>

    <!-- Shared Dark Footer -->
    <jsp:include page="/Foodie/includes/footer.jsp" />

    <script>
        function switchMenuSubTab(tabId, btn) {
            document.querySelectorAll('.subtab-content').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('.menu-tab-btn').forEach(b => b.classList.remove('active'));
            const target = document.getElementById(tabId);
            if (target) target.classList.add('active');
            if (btn) btn.classList.add('active');
        }

        let selectedCategory = 'All';
        let vegFilterMode = 'all'; // 'all', 'veg', 'non-veg'

        function filterMenuCategory(catName, btn) {
            selectedCategory = catName;
            document.querySelectorAll('.category-chip').forEach(c => c.classList.remove('active'));
            if (btn) btn.classList.add('active');
            applyAllMenuFilters();
        }

        function toggleVegOnlyFilter() {
            const btn = document.getElementById('vegOnlyFilterBtn');
            const nonVegBtn = document.getElementById('nonVegOnlyFilterBtn');
            if (vegFilterMode === 'veg') {
                vegFilterMode = 'all';
                btn.classList.remove('active');
            } else {
                vegFilterMode = 'veg';
                btn.classList.add('active');
                nonVegBtn.classList.remove('active');
            }
            applyAllMenuFilters();
        }

        function toggleNonVegFilter() {
            const btn = document.getElementById('nonVegOnlyFilterBtn');
            const vegBtn = document.getElementById('vegOnlyFilterBtn');
            if (vegFilterMode === 'non-veg') {
                vegFilterMode = 'all';
                btn.classList.remove('active');
            } else {
                vegFilterMode = 'non-veg';
                btn.classList.add('active');
                vegBtn.classList.remove('active');
            }
            applyAllMenuFilters();
        }

        function filterMenuItems() {
            applyAllMenuFilters();
        }

        function applyAllMenuFilters() {
            const searchInput = document.getElementById('menuItemSearch');
            const query = searchInput ? searchInput.value.toLowerCase().trim() : '';
            const cards = document.querySelectorAll('.food-card');
            let visibleCount = 0;

            cards.forEach(card => {
                const name = (card.getAttribute('data-name') || '').toLowerCase();
                const cat = card.getAttribute('data-category') || '';
                const vegType = card.getAttribute('data-veg') || '';

                const matchesQuery = query === '' || name.includes(query);
                const matchesCat = (selectedCategory === 'All') || 
                                   (cat.toLowerCase().includes(selectedCategory.toLowerCase())) ||
                                   (name.includes(selectedCategory.toLowerCase()));
                
                let matchesVeg = true;
                if (vegFilterMode === 'veg') matchesVeg = (vegType === 'veg');
                if (vegFilterMode === 'non-veg') matchesVeg = (vegType === 'non-veg');

                if (matchesQuery && matchesCat && matchesVeg) {
                    card.style.display = 'flex';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            const noFound = document.getElementById('noDishesFound');
            if (noFound) {
                noFound.style.display = (visibleCount === 0) ? 'block' : 'none';
            }
        }

        function resetMenuFilters() {
            const searchInput = document.getElementById('menuItemSearch');
            if (searchInput) searchInput.value = '';
            selectedCategory = 'All';
            vegFilterMode = 'all';
            document.querySelectorAll('.category-chip').forEach((c, idx) => {
                c.classList.toggle('active', idx === 0);
            });
            document.getElementById('vegOnlyFilterBtn').classList.remove('active');
            document.getElementById('nonVegOnlyFilterBtn').classList.remove('active');
            applyAllMenuFilters();
        }

        function toggleFav(btn) {
            if (btn.innerText.includes('🤍')) {
                btn.innerText = '❤️';
                btn.style.color = '#EF4444';
            } else {
                btn.innerText = '🤍';
                btn.style.color = '';
            }
        }
    </script>
</body>
</html>
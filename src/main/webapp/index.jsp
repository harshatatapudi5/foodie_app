<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.DAOImp.DAOImpRes" %>
<%@ page import="com.tap.model.ResDetails" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Cart" %>
<%
    request.setAttribute("activePage", "home");
    User currentUser = (User) session.getAttribute("user");
    Cart cart = (Cart) session.getAttribute("cart");
    int cartCount = (cart != null) ? cart.getTotalQuantity() : 0;

    DAOImpRes resDAO = new DAOImpRes();
    List<ResDetails> restaurants = null;
    try {
        restaurants = resDAO.getAllRes();
    } catch (Exception e) {
        e.printStackTrace();
    }

    String userLocation = "Hyderabad, Telangana";
    if (currentUser != null && currentUser.getAddress() != null && !currentUser.getAddress().trim().isEmpty()) {
        userLocation = currentUser.getAddress().trim();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Foodie — Delicious Food Delivered To You</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Aurora Glassmorphism Design System -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Foodie/css/theme-dark.css?v=glass">
    <style>
        /* Hero Section (Aurora Glassmorphism) */
        .hero-section {
            position: relative;
            padding: 64px 0 80px;
            overflow: hidden;
        }

        .hero-container {
            max-width: 1320px;
            margin: 0 auto;
            padding: 0 24px;
            display: grid;
            grid-template-columns: 1.15fr 0.85fr;
            align-items: center;
            gap: 48px;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 87, 34, 0.12);
            border: 1px solid rgba(255, 87, 34, 0.3);
            color: var(--primary-light);
            font-size: 13px;
            font-weight: 700;
            padding: 7px 16px;
            border-radius: var(--radius-pill);
            margin-bottom: 22px;
            letter-spacing: 0.6px;
            backdrop-filter: blur(8px);
        }

        .hero-title {
            font-size: 54px;
            font-weight: 800;
            line-height: 1.12;
            color: var(--text-white);
            margin-bottom: 18px;
            letter-spacing: -1.2px;
        }

        .hero-title .hero-highlight {
            color: var(--primary);
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: inline-block;
        }

        .hero-subtitle {
            font-size: 16.5px;
            color: var(--text-secondary);
            margin-bottom: 32px;
            max-width: 520px;
            line-height: 1.6;
        }

        /* Frosted Glass Search Bar */
        .hero-search-bar {
            display: flex;
            align-items: center;
            background: rgba(14, 18, 32, 0.75);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-pill);
            padding: 7px 8px 7px 22px;
            max-width: 560px;
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.4);
            margin-bottom: 24px;
            transition: var(--transition-fast);
        }

        .hero-search-bar:focus-within {
            border-color: var(--primary);
            box-shadow: var(--primary-glow-sm);
        }

        .hero-search-input {
            flex: 1;
            background: transparent;
            border: none;
            color: var(--text-white);
            font-size: 15px;
            padding: 8px 10px;
            outline: none;
        }

        .hero-search-input::placeholder {
            color: var(--text-muted);
        }

        .hero-search-btn {
            background: var(--primary-gradient);
            color: #FFFFFF;
            border-radius: var(--radius-pill);
            padding: 12px 26px;
            font-weight: 700;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: var(--primary-glow-sm);
            transition: var(--transition-fast);
        }

        .hero-search-btn:hover {
            box-shadow: var(--primary-glow);
            transform: translateY(-1px);
        }

        .hero-delivery-loc {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: var(--text-secondary);
        }

        .hero-delivery-loc strong {
            color: var(--text-white);
        }

        /* Right Hero Visual with Aurora Glow */
        .hero-image-wrap {
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .hero-glow-circle {
            position: absolute;
            width: 460px;
            height: 460px;
            background: radial-gradient(circle, rgba(255, 87, 34, 0.28) 0%, rgba(99, 102, 241, 0.18) 45%, transparent 70%);
            border-radius: 50%;
            z-index: 1;
            filter: blur(50px);
            pointer-events: none;
        }

        .hero-main-img-box {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 440px;
            height: 420px;
            border-radius: var(--radius-xl);
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.15);
            box-shadow: 0 24px 50px rgba(0, 0, 0, 0.6);
            background: var(--glass-bg-surface);
        }

        .hero-main-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }

        .hero-main-img-box:hover .hero-main-img {
            transform: scale(1.03);
        }

        /* Floating Frosted Glass Card */
        .hero-float-card {
            position: absolute;
            bottom: -18px;
            left: -18px;
            z-index: 3;
            background: rgba(22, 27, 44, 0.85);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border-light);
            padding: 16px 20px;
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: 0 16px 36px rgba(0, 0, 0, 0.5), var(--primary-glow-sm);
        }

        .hero-float-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: var(--primary-gradient);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: #FFFFFF;
        }

        /* Top Categories Grid */
        .section-wrap {
            max-width: 1320px;
            margin: 0 auto;
            padding: 44px 24px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 28px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .section-title {
            font-size: 28px;
            font-weight: 800;
            color: var(--text-white);
            letter-spacing: -0.5px;
        }

        .section-link {
            font-size: 14px;
            font-weight: 700;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .section-link:hover {
            color: var(--primary-light);
            text-decoration: underline;
        }

        .category-grid {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 18px;
        }

        .category-card {
            background: var(--glass-bg-card);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 22px 14px;
            text-align: center;
            transition: var(--transition-smooth);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
        }

        .category-card:hover {
            background: var(--glass-bg-hover);
            border-color: var(--primary);
            transform: translateY(-5px);
            box-shadow: var(--glass-shadow-hover);
        }

        .category-thumb-box {
            width: 68px;
            height: 68px;
            border-radius: 50%;
            background: rgba(255, 87, 34, 0.1);
            border: 1px solid rgba(255, 87, 34, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 12px;
            transition: transform 0.25s ease;
        }

        .category-card:hover .category-thumb-box {
            transform: scale(1.08);
            background: rgba(255, 87, 34, 0.2);
        }

        .category-thumb-box img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .category-name {
            font-size: 15px;
            font-weight: 700;
            color: var(--text-white);
        }

        .category-count {
            font-size: 12px;
            color: var(--text-muted);
        }

        /* Top Restaurants Section */
        .restaurant-filter-chips {
            display: flex;
            gap: 12px;
            overflow-x: auto;
            margin-bottom: 28px;
            padding-bottom: 6px;
            scrollbar-width: none;
        }

        .restaurant-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 24px;
        }

        .res-card {
            background: var(--glass-bg-card);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            overflow: hidden;
            transition: var(--transition-smooth);
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .res-card:hover {
            background: var(--glass-bg-hover);
            border-color: var(--glass-border-light);
            transform: translateY(-5px);
            box-shadow: var(--glass-shadow-hover);
        }

        .res-thumb-wrap {
            position: relative;
            height: 180px;
            overflow: hidden;
            background: rgba(14, 18, 30, 0.7);
        }

        .res-thumb-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.35s ease;
        }

        .res-card:hover .res-thumb-img {
            transform: scale(1.05);
        }

        .res-discount-badge {
            position: absolute;
            top: 14px;
            left: 14px;
            z-index: 2;
        }

        .res-fav-btn {
            position: absolute;
            top: 14px;
            right: 14px;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: rgba(11, 14, 23, 0.7);
            backdrop-filter: blur(6px);
            border: 1px solid var(--glass-border);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            z-index: 2;
        }

        .res-body {
            padding: 18px 20px 20px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .res-title-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 8px;
        }

        .res-title {
            font-size: 17px;
            font-weight: 700;
            color: var(--text-white);
            margin: 0;
            line-height: 1.3;
        }

        .res-cuisine {
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 12px;
        }

        .res-meta-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: auto;
            padding-top: 12px;
            border-top: 1px solid var(--glass-border);
            font-size: 13px;
            color: var(--text-secondary);
        }

        .res-action-btn {
            margin-top: 14px;
            width: 100%;
            padding: 10px;
            font-size: 13.5px;
            font-weight: 700;
            text-align: center;
        }

        /* Promotional Aurora Banner */
        .promo-banner-section {
            max-width: 1320px;
            margin: 20px auto 44px;
            padding: 0 24px;
        }

        .promo-banner {
            background: linear-gradient(135deg, rgba(42, 22, 16, 0.75) 0%, rgba(20, 25, 44, 0.85) 50%, rgba(15, 18, 30, 0.85) 100%);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 87, 34, 0.3);
            border-radius: var(--radius-xl);
            padding: 38px 48px;
            display: grid;
            grid-template-columns: 1.2fr 0.8fr;
            align-items: center;
            gap: 30px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 48px rgba(0, 0, 0, 0.5), 0 0 30px rgba(255, 87, 34, 0.15);
        }

        .promo-content h3 {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: var(--primary-light);
            margin-bottom: 10px;
            font-weight: 800;
        }

        .promo-content h2 {
            font-size: 36px;
            font-weight: 800;
            color: var(--text-white);
            line-height: 1.18;
            margin-bottom: 12px;
            letter-spacing: -0.5px;
        }

        .promo-content p {
            color: var(--text-secondary);
            font-size: 15px;
            margin-bottom: 24px;
            max-width: 480px;
            line-height: 1.5;
        }

        /* 4 Features Bar */
        .features-grid {
            max-width: 1320px;
            margin: 0 auto 60px;
            padding: 0 24px;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        .feature-card {
            background: var(--glass-bg-card);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 24px 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            transition: var(--transition-smooth);
        }

        .feature-card:hover {
            background: var(--glass-bg-hover);
            border-color: var(--primary);
            transform: translateY(-3px);
            box-shadow: var(--glass-shadow-hover);
        }

        .feature-icon-wrap {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            background: rgba(255, 87, 34, 0.12);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            flex-shrink: 0;
            border: 1px solid rgba(255, 87, 34, 0.25);
        }

        .feature-title {
            font-size: 15px;
            font-weight: 700;
            color: var(--text-white);
            margin-bottom: 3px;
        }

        .feature-desc {
            font-size: 13px;
            color: var(--text-muted);
        }

        @media (max-width: 1100px) {
            .restaurant-grid { grid-template-columns: repeat(3, 1fr); }
            .category-grid { grid-template-columns: repeat(3, 1fr); }
            .features-grid { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 860px) {
            .hero-container { grid-template-columns: 1fr; text-align: center; gap: 40px; }
            .hero-title { font-size: 40px; }
            .hero-subtitle { margin: 0 auto 28px; }
            .hero-search-bar { margin: 0 auto 20px; }
            .hero-delivery-loc { justify-content: center; }
            .hero-float-card { left: 50%; transform: translateX(-50%); bottom: -20px; width: 85%; }
            .restaurant-grid { grid-template-columns: repeat(2, 1fr); }
            .category-grid { grid-template-columns: repeat(2, 1fr); }
            .promo-banner { grid-template-columns: 1fr; text-align: center; padding: 30px 24px; }
            .features-grid { grid-template-columns: 1fr; }
        }

        @media (max-width: 480px) {
            .restaurant-grid { grid-template-columns: 1fr; }
            .hero-title { font-size: 32px; }
            .hero-main-img-box { height: 320px; }
        }
    </style>
</head>
<body>

    <!-- Unified Frosted Glass Navbar -->
    <jsp:include page="/Foodie/includes/navbar.jsp" />

    <!-- =========================================================
         1. HERO SECTION (Aurora Glassmorphism)
         ========================================================= -->
    <section class="hero-section">
        <div class="hero-container">
            <!-- Left Info Column -->
            <div>
                <div class="hero-badge">
                    <span>✨</span> GOOD FOOD • BETTER MOOD
                </div>

                <h1 class="hero-title">
                    Delicious Food,<br>
                    <span class="hero-highlight">Delivered To You.</span>
                </h1>

                <p class="hero-subtitle">
                    Explore top restaurants, discover delicious cuisines, and get your favorite food delivered to your doorstep fast and fresh.
                </p>

                <!-- Frosted Glass Search Bar -->
                <form action="<%= request.getContextPath() %>/restaurant" method="get" class="hero-search-bar">
                    <span style="font-size: 18px; color: var(--text-muted);">🔍</span>
                    <input type="text" name="search" class="hero-search-input" placeholder="Search for biryani, pizza, burgers..." required>
                    <button type="submit" class="hero-search-btn">
                        Search
                    </button>
                </form>

                <!-- Location Display with Existing Data -->
                <div class="hero-delivery-loc">
                    <span style="color: var(--primary); font-size: 16px;">📍</span>
                    <span>Deliver to: <strong><%= userLocation %></strong></span>
                </div>
            </div>

            <!-- Right Hero Visual with Aurora Glow & Floating Glass Card -->
            <div class="hero-image-wrap">
                <div class="hero-glow-circle"></div>
                <div class="hero-carousel-container" id="heroFoodCarousel" tabindex="0" role="region" aria-label="Featured Food Carousel">
                    <div class="hero-carousel-track">
                        <!-- Slide 1: Biryani -->
                        <div class="hero-carousel-slide active" aria-hidden="false">
                            <img src="<%= request.getContextPath() %>/Foodie/images/hero/hero-biryani.jpg" 
                                 alt="Royal Hyderabadi Biryani" 
                                 onerror="this.src='<%= request.getContextPath() %>/Foodie/images/menu/chicken-biryani.jpg';">
                            <div class="hero-carousel-caption">
                                <span class="hero-slide-badge">Bestseller</span>
                                <span class="hero-slide-title">Royal Hyderabadi Dum Biryani</span>
                            </div>
                        </div>

                        <!-- Slide 2: Pizza -->
                        <div class="hero-carousel-slide" aria-hidden="true">
                            <img src="<%= request.getContextPath() %>/Foodie/images/dominos/dominos-farmhouse.jpg" 
                                 alt="Italian Handcrafted Pizza" 
                                 onerror="this.src='<%= request.getContextPath() %>/Foodie/images/menu/pizza.jpg';">
                            <div class="hero-carousel-caption">
                                <span class="hero-slide-badge">Woodfired</span>
                                <span class="hero-slide-title">Artisan Farmhouse Cheesy Pizza</span>
                            </div>
                        </div>

                        <!-- Slide 3: Burgers -->
                        <div class="hero-carousel-slide" aria-hidden="true">
                            <img src="<%= request.getContextPath() %>/Foodie/images/burgerking/bk-whopper.jpg" 
                                 alt="Flame-Grilled Whopper Burger" 
                                 onerror="this.src='<%= request.getContextPath() %>/Foodie/images/menu/burger.jpg';">
                            <div class="hero-carousel-caption">
                                <span class="hero-slide-badge">Gourmet</span>
                                <span class="hero-slide-title">Flame-Grilled Signature Burgers</span>
                            </div>
                        </div>

                        <!-- Slide 4: Fried Chicken -->
                        <div class="hero-carousel-slide" aria-hidden="true">
                            <img src="<%= request.getContextPath() %>/Foodie/images/kfc/kfc-popcorn-chicken.jpg" 
                                 alt="Crispy Fried Chicken" 
                                 onerror="this.src='<%= request.getContextPath() %>/Foodie/images/menu/chicken-biryani.jpg';">
                            <div class="hero-carousel-caption">
                                <span class="hero-slide-badge">Extra Crunchy</span>
                                <span class="hero-slide-title">Crispy Hot &amp; Spicy Fried Chicken</span>
                            </div>
                        </div>

                        <!-- Slide 5: Desserts -->
                        <div class="hero-carousel-slide" aria-hidden="true">
                            <img src="<%= request.getContextPath() %>/Foodie/images/dessertfactory/df-chocolate-lava-cake.jpg" 
                                 alt="Warm Chocolate Lava Cake" 
                                 onerror="this.src='<%= request.getContextPath() %>/Foodie/images/menu/pizza.jpg';">
                            <div class="hero-carousel-caption">
                                <span class="hero-slide-badge">Decadent</span>
                                <span class="hero-slide-title">Warm Molten Lava Cakes &amp; Sweets</span>
                            </div>
                        </div>

                        <!-- Slide 6: Healthy Food -->
                        <div class="hero-carousel-slide" aria-hidden="true">
                            <img src="<%= request.getContextPath() %>/Foodie/images/subway/subway-veggie-delite.jpg" 
                                 alt="Fresh Healthy Subs & Bowls" 
                                 onerror="this.src='<%= request.getContextPath() %>/Foodie/images/menu/burger.jpg';">
                            <div class="hero-carousel-caption">
                                <span class="hero-slide-badge">Fresh &amp; Nutritious</span>
                                <span class="hero-slide-title">Wholesome Subs &amp; Garden Bowls</span>
                            </div>
                        </div>
                    </div>

                    <!-- Carousel Arrow Controls -->
                    <button type="button" class="hero-carousel-arrow prev" aria-label="Previous slide">&#10094;</button>
                    <button type="button" class="hero-carousel-arrow next" aria-label="Next slide">&#10095;</button>

                    <!-- Indicators Dots -->
                    <div class="hero-carousel-dots" role="tablist" aria-label="Food slide indicators">
                        <button type="button" class="hero-carousel-dot active" aria-label="Slide 1" aria-selected="true"></button>
                        <button type="button" class="hero-carousel-dot" aria-label="Slide 2" aria-selected="false"></button>
                        <button type="button" class="hero-carousel-dot" aria-label="Slide 3" aria-selected="false"></button>
                        <button type="button" class="hero-carousel-dot" aria-label="Slide 4" aria-selected="false"></button>
                        <button type="button" class="hero-carousel-dot" aria-label="Slide 5" aria-selected="false"></button>
                        <button type="button" class="hero-carousel-dot" aria-label="Slide 6" aria-selected="false"></button>
                    </div>
                </div>

                <!-- Floating Frosted Glass Card -->
                <div class="hero-float-card">
                    <div class="hero-float-icon">🏷️</div>
                    <div>
                        <div style="font-size: 11px; text-transform: uppercase; color: var(--primary-light); font-weight: 800; letter-spacing: 0.6px;">Special Offer</div>
                        <div style="font-size: 17px; font-weight: 800; color: #FFFFFF;">Up to 50% OFF</div>
                        <div style="font-size: 11.5px; color: var(--text-muted);">On your first food order</div>
                    </div>
                    <a href="<%= request.getContextPath() %>/restaurant" style="color: var(--primary); font-size: 20px; font-weight: 800; margin-left: 6px;" aria-label="View offers">
                        →
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- =========================================================
         2. TOP CATEGORIES (Frosted Glass Cards)
         ========================================================= -->
    <section class="section-wrap">
        <div class="section-header">
            <div>
                <h2 class="section-title">Explore Popular Categories</h2>
                <p style="color: var(--text-muted); font-size: 14.5px; margin-top: 4px;">Find something delicious for every craving.</p>
            </div>
            <a href="<%= request.getContextPath() %>/restaurant" class="section-link">View All Categories →</a>
        </div>

        <div class="category-grid">
            <a href="<%= request.getContextPath() %>/restaurant?cuisine=Biryani" 
               class="category-card"
               data-open-modal="category"
               data-name="Biryani"
               data-count="120+ options"
               data-image="<%= request.getContextPath() %>/Foodie/images/hero/hero-biryani.jpg"
               data-desc="Indulge in royal dum biryanis, aromatic long-grain basmati, and fragrant royal spices slow-cooked to perfection."
               data-dishes="Hyderabadi Dum Biryani, Awadhi Gosht Biryani, Paneer Tikka Biryani, Chicken Dum Biryani"
               data-context-path="<%= request.getContextPath() %>">
                <div class="category-thumb-box">
                    <img src="<%= request.getContextPath() %>/Foodie/images/categories/biryani.svg" alt="Biryani">
                </div>
                <div class="category-name">Biryani</div>
                <div class="category-count">120+ options</div>
            </a>

            <a href="<%= request.getContextPath() %>/restaurant?cuisine=Pizza" 
               class="category-card"
               data-open-modal="category"
               data-name="Pizza"
               data-count="95+ options"
               data-image="<%= request.getContextPath() %>/Foodie/images/dominos/dominos-farmhouse.jpg"
               data-desc="Handcrafted stone-baked pizzas loaded with gooey mozzarella, fresh Italian marinara, and garden-fresh herbs."
               data-dishes="Margherita, Farmhouse Special, Peppy Paneer, Fiery Chicken Feast"
               data-context-path="<%= request.getContextPath() %>">
                <div class="category-thumb-box">
                    <img src="<%= request.getContextPath() %>/Foodie/images/categories/pizza.svg" alt="Pizza">
                </div>
                <div class="category-name">Pizza</div>
                <div class="category-count">95+ options</div>
            </a>

            <a href="<%= request.getContextPath() %>/restaurant?cuisine=Burgers" 
               class="category-card"
               data-open-modal="category"
               data-name="Burgers"
               data-count="85+ options"
               data-image="<%= request.getContextPath() %>/Foodie/images/burgerking/bk-whopper.jpg"
               data-desc="Juicy flame-grilled patties layered with melted cheddar, crisp lettuce, and signature secret sauces inside toasted brioche."
               data-dishes="Classic Whopper, Crispy Veggie Supreme, Double Bacon Cheeseburger, Paneer Crunch"
               data-context-path="<%= request.getContextPath() %>">
                <div class="category-thumb-box">
                    <img src="<%= request.getContextPath() %>/Foodie/images/categories/burgers.svg" alt="Burgers">
                </div>
                <div class="category-name">Burgers</div>
                <div class="category-count">85+ options</div>
            </a>

            <a href="<%= request.getContextPath() %>/restaurant?cuisine=Chinese" 
               class="category-card"
               data-open-modal="category"
               data-name="Chinese"
               data-count="75+ options"
               data-image="<%= request.getContextPath() %>/Foodie/images/menu/chicken-biryani.jpg"
               data-desc="Wok-tossed delicacies featuring sizzling Hakka noodles, golden spring rolls, Manchurian, and authentic Sichuan spices."
               data-dishes="Veg Hakka Noodles, Chicken Fried Rice, Chili Paneer Gravy, Crispy Spring Rolls"
               data-context-path="<%= request.getContextPath() %>">
                <div class="category-thumb-box">
                    <img src="<%= request.getContextPath() %>/Foodie/images/categories/chinese.svg" alt="Chinese">
                </div>
                <div class="category-name">Chinese</div>
                <div class="category-count">75+ options</div>
            </a>

            <a href="<%= request.getContextPath() %>/restaurant?cuisine=Desserts" 
               class="category-card"
               data-open-modal="category"
               data-name="Desserts"
               data-count="60+ options"
               data-image="<%= request.getContextPath() %>/Foodie/images/dessertfactory/df-chocolate-lava-cake.jpg"
               data-desc="Sweet temptations including warm molten lava cakes, artisan pastries, traditional Indian sweets, and creamy gelato."
               data-dishes="Choco Lava Cake, Red Velvet Pastry, Gulab Jamun Sundae, Belgian Waffles"
               data-context-path="<%= request.getContextPath() %>">
                <div class="category-thumb-box">
                    <img src="<%= request.getContextPath() %>/Foodie/images/categories/desserts.svg" alt="Desserts">
                </div>
                <div class="category-name">Desserts</div>
                <div class="category-count">60+ options</div>
            </a>

            <a href="<%= request.getContextPath() %>/restaurant?cuisine=Healthy" 
               class="category-card"
               data-open-modal="category"
               data-name="Healthy"
               data-count="50+ options"
               data-image="<%= request.getContextPath() %>/Foodie/images/subway/subway-veggie-delite.jpg"
               data-desc="Nutrient-dense harvest bowls, keto wraps, fresh sub sandwiches, and organic cold-pressed juices."
               data-dishes="Veggie Delite Sub, Quinoa Avocado Bowl, Grilled Chicken Salad, Fresh Fruit Parfait"
               data-context-path="<%= request.getContextPath() %>">
                <div class="category-thumb-box">
                    <img src="<%= request.getContextPath() %>/Foodie/images/categories/sandwiches.svg" alt="Healthy Food">
                </div>
                <div class="category-name">Healthy Food</div>
                <div class="category-count">50+ options</div>
            </a>
        </div>
    </section>

    <!-- =========================================================
         3. POPULAR RESTAURANTS (Aurora Glass Cards)
         ========================================================= -->
    <section class="section-wrap" style="padding-top: 10px;">
        <div class="section-header">
            <div>
                <h2 class="section-title">Popular Near You</h2>
                <p style="color: var(--text-muted); font-size: 14.5px; margin-top: 4px;">Handpicked culinary spots with top ratings and fast delivery.</p>
            </div>
            <a href="<%= request.getContextPath() %>/restaurant" class="section-link">View All Restaurants →</a>
        </div>

        <!-- Filter Chips Bar -->
        <div class="restaurant-filter-chips">
            <button type="button" class="category-chip active" onclick="filterHomeRestaurants('all', this)">All</button>
            <button type="button" class="category-chip" onclick="filterHomeRestaurants('Biryani', this)">Biryani</button>
            <button type="button" class="category-chip" onclick="filterHomeRestaurants('Pizza', this)">Pizza</button>
            <button type="button" class="category-chip" onclick="filterHomeRestaurants('Burgers', this)">Burgers</button>
            <button type="button" class="category-chip" onclick="filterHomeRestaurants('Chinese', this)">Chinese</button>
            <button type="button" class="category-chip" onclick="filterHomeRestaurants('Desserts', this)">Desserts</button>
        </div>

        <!-- Restaurant Cards Grid -->
        <div class="restaurant-grid" id="homeRestaurantGrid">
            <% 
            if (restaurants != null && !restaurants.isEmpty()) { 
                int maxDisplay = Math.min(restaurants.size(), 8);
                for (int i = 0; i < maxDisplay; i++) {
                    ResDetails r = restaurants.get(i);
                    String discount = (r.getId() % 2 == 0) ? "40% OFF" : "30% OFF";
                    String delTime = (r.getDelTime() != null && !r.getDelTime().isEmpty()) ? r.getDelTime() : "30-40 mins";
            %>
                <div class="res-card" 
                     data-id="<%= r.getId() %>"
                     data-name="<%= r.getResName() %>"
                     data-cuisine="<%= r.getCuisineType() %>"
                     data-rating="<%= String.format("%.1f", r.getRating()) %>"
                     data-reviews="500+ ratings"
                     data-deltime="<%= delTime %>"
                     data-delfee="Free Delivery"
                     data-address="Banjara Hills, Hyderabad"
                     data-image="<%= request.getContextPath() %>/Foodie/images/restaurants/<%= r.getImagePath() %>"
                     data-discount="<%= discount %>"
                     data-desc="Celebrated restaurant known for exceptional culinary taste, fast preparation, and premium packaging."
                     data-context-path="<%= request.getContextPath() %>">
                    <div class="res-thumb-wrap">
                        <span class="badge-discount res-discount-badge"><%= discount %></span>
                        <button type="button" class="res-fav-btn" title="Add to favorites" onclick="toggleFav(this)">🤍</button>
                        <img src="<%= request.getContextPath() %>/Foodie/images/restaurants/<%= r.getImagePath() %>" 
                             alt="<%= r.getResName() %>" 
                             class="res-thumb-img"
                             onerror="this.src='<%= request.getContextPath() %>/Foodie/images/restaurants/dominos.jpg';">
                    </div>

                    <div class="res-body">
                        <div class="res-title-row">
                            <h3 class="res-title"><%= r.getResName() %></h3>
                            <span class="rating-pill">⭐ <%= String.format("%.1f", r.getRating()) %></span>
                        </div>

                        <div class="res-cuisine"><%= r.getCuisineType() %></div>

                        <div class="res-meta-row">
                            <span>⏱ <%= delTime %></span>
                            <span class="badge-free-del">Free Delivery</span>
                        </div>

                        <a href="<%= request.getContextPath() %>/menu?resId=<%= r.getId() %>" class="btn-primary res-action-btn">
                            View Menu →
                        </a>
                    </div>
                </div>
            <% 
                }
            } else { 
            %>
                <div style="grid-column: 1 / -1; padding: 48px; text-align: center; color: var(--text-muted); background: var(--glass-bg); border-radius: var(--radius-lg); border: 1px solid var(--glass-border);">
                    Loading top rated restaurants...
                </div>
            <% } %>
        </div>
    </section>

    <!-- =========================================================
         4. SPECIAL OFFERS PROMO BANNER (Frosted Glass)
         ========================================================= -->
    <section class="promo-banner-section" id="offers">
        <div class="promo-banner">
            <div class="promo-content">
                <h3>Special Deal</h3>
                <h2>Cravings Made Better<br>Up to 50% Off Today</h2>
                <p>Order delicious meals, curated chef combos, and desserts with exclusive discounts and complimentary delivery.</p>
                <a href="<%= request.getContextPath() %>/restaurant" class="btn-primary" style="padding: 12px 28px;">
                    Order Now →
                </a>
            </div>

            <div style="display: flex; justify-content: center; align-items: center; position: relative;">
                <img src="<%= request.getContextPath() %>/Foodie/images/categories/pizza.svg" 
                     alt="Food Offer" 
                     style="width: 240px; filter: drop-shadow(0 20px 30px rgba(0,0,0,0.6));">
            </div>
        </div>
    </section>

    <!-- =========================================================
         5. 4 FEATURES / BENEFITS BAR (Glass Cards)
         ========================================================= -->
    <section class="features-grid">
        <div class="feature-card">
            <div class="feature-icon-wrap">⚡</div>
            <div>
                <div class="feature-title">Fast Delivery</div>
                <div class="feature-desc">Prompt delivery in 30-40 minutes</div>
            </div>
        </div>

        <div class="feature-card">
            <div class="feature-icon-wrap">🛡️</div>
            <div>
                <div class="feature-title">Secure Ordering</div>
                <div class="feature-desc">100% safe checkout & hygiene guarantee</div>
            </div>
        </div>

        <div class="feature-card">
            <div class="feature-icon-wrap">🏷️</div>
            <div>
                <div class="feature-title">Great Offers</div>
                <div class="feature-desc">Daily discounts and delivery perks</div>
            </div>
        </div>

        <div class="feature-card">
            <div class="feature-icon-wrap">🎧</div>
            <div>
                <div class="feature-title">24/7 Support</div>
                <div class="feature-desc">Dedicated assistance anytime</div>
            </div>
        </div>
    </section>

    <!-- Unified Frosted Glass Footer -->
    <jsp:include page="/Foodie/includes/footer.jsp" />

    <!-- Hero Image Carousel Controller -->
    <script src="<%= request.getContextPath() %>/Foodie/js/hero-carousel.js"></script>

    <script>
        function filterHomeRestaurants(category, btn) {
            const chips = document.querySelectorAll('.restaurant-filter-chips .category-chip');
            chips.forEach(chip => chip.classList.remove('active'));
            if (btn) btn.classList.add('active');

            const cards = document.querySelectorAll('#homeRestaurantGrid .res-card');
            cards.forEach(card => {
                const cuisine = card.getAttribute('data-cuisine') || '';
                if (category === 'all' || cuisine.toLowerCase().includes(category.toLowerCase())) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        function toggleFav(btn) {
            if (btn.innerText.includes('🤍')) {
                btn.innerText = '❤️';
                btn.style.color = '#EF4444';
            } else {
                btn.innerText = '🤍';
                btn.style.color = '#FFFFFF';
            }
        }
    </script>
</body>
</html>

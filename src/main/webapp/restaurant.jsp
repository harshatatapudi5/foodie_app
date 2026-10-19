<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.ResDetails" %>
<%@ page import="com.tap.model.User" %>
<%
    request.setAttribute("activePage", "restaurants");
    request.setAttribute("backUrl", request.getContextPath() + "/index.jsp");

    List<ResDetails> restaurants = (List<ResDetails>) request.getAttribute("restaurant");
    if (restaurants == null) {
        // Fallback if accessed directly
        com.tap.DAOImp.DAOImpRes resDAO = new com.tap.DAOImp.DAOImpRes();
        restaurants = resDAO.getAllRes();
    }

    String initialSearch = request.getParameter("search");
    if (initialSearch == null) initialSearch = "";

    String initialCuisine = request.getParameter("cuisine");
    if (initialCuisine == null) initialCuisine = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurants — Foodie</title>
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Theme CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Foodie/css/theme-dark.css">
    <style>
        .res-page-wrap {
            max-width: 1320px;
            margin: 0 auto;
            padding: 30px 24px 80px;
            width: 100%;
        }

        /* Top Search & Category Bar */
        .search-chips-header {
            margin-bottom: 28px;
        }

        .search-row {
            display: flex;
            gap: 16px;
            align-items: center;
            margin-bottom: 20px;
        }

        .filter-search-input-wrap {
            flex: 1;
            position: relative;
        }

        .filter-search-input-wrap .search-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 16px;
            color: var(--text-muted);
        }

        .filter-search-input {
            width: 100%;
            background: var(--bg-card);
            border: 1px solid var(--border-medium);
            border-radius: var(--radius-pill);
            padding: 14px 20px 14px 48px;
            font-size: 15px;
            color: var(--text-white);
            outline: none;
            transition: all 0.2s ease;
        }

        .filter-search-input:focus {
            border-color: var(--primary);
            box-shadow: var(--primary-glow-sm);
        }

        /* Layout Grid: Sidebar (Left) + List (Right) */
        .listing-layout {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 32px;
            align-items: flex-start;
        }

        /* Left Sidebar Filters */
        .filters-sidebar {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            padding: 24px;
            position: sticky;
            top: 90px;
        }

        .filter-group {
            padding-bottom: 20px;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--border-subtle);
        }
        .filter-group:last-child {
            padding-bottom: 0;
            margin-bottom: 0;
            border-bottom: none;
        }

        .filter-group-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 14px;
        }

        .filter-group-title {
            font-size: 15px;
            font-weight: 700;
            color: var(--text-white);
            letter-spacing: -0.2px;
        }

        .filter-clear-btn {
            font-size: 12px;
            font-weight: 600;
            color: var(--primary);
            cursor: pointer;
        }
        .filter-clear-btn:hover {
            text-decoration: underline;
        }

        .filter-option {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            cursor: pointer;
            font-size: 14px;
            color: var(--text-secondary);
            user-select: none;
            transition: color 0.15s ease;
        }
        .filter-option:hover {
            color: var(--text-white);
        }
        .filter-option input[type="checkbox"],
        .filter-option input[type="radio"] {
            accent-color: var(--primary);
            width: 16px;
            height: 16px;
            cursor: pointer;
        }

        /* Listing Header / Stats */
        .listing-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .restaurant-count-title {
            font-size: 20px;
            font-weight: 800;
            color: var(--text-white);
        }

        .sort-select-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 13px;
            color: var(--text-muted);
        }

        .sort-select {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            color: var(--text-white);
            font-size: 13px;
            font-weight: 600;
            padding: 8px 14px;
            border-radius: var(--radius-pill);
            cursor: pointer;
        }

        /* Horizontal Restaurant Cards (Matches Screen 2) */
        .restaurant-list {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .res-list-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            padding: 18px;
            display: grid;
            grid-template-columns: 140px 1fr auto;
            gap: 20px;
            align-items: center;
            transition: all 0.25s ease;
            position: relative;
        }

        .res-list-card:hover {
            background: var(--bg-card-hover);
            border-color: var(--border-medium);
            transform: translateX(4px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.4);
        }

        .res-list-thumb {
            width: 140px;
            height: 110px;
            border-radius: var(--radius-md);
            object-fit: cover;
            background: var(--bg-card-elevated);
        }

        .res-list-info {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .res-list-title {
            font-size: 18px;
            font-weight: 800;
            color: var(--text-white);
        }

        .res-list-rating-row {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 13px;
        }

        .res-list-cuisines {
            font-size: 13px;
            color: var(--text-muted);
        }

        .res-list-meta {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 12px;
            color: var(--text-secondary);
            margin-top: 4px;
        }

        .res-list-actions {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            justify-content: space-between;
            height: 100%;
            gap: 16px;
        }

        .fav-heart-btn {
            font-size: 18px;
            background: none;
            border: none;
            cursor: pointer;
            transition: transform 0.2s ease;
        }
        .fav-heart-btn:hover {
            transform: scale(1.2);
        }

        /* Empty State */
        .empty-filter-state {
            display: none;
            text-align: center;
            padding: 60px 20px;
            background: var(--bg-card);
            border: 1px dashed var(--border-medium);
            border-radius: var(--radius-lg);
        }

        @media (max-width: 900px) {
            .listing-layout {
                grid-template-columns: 1fr;
            }
            .filters-sidebar {
                position: static;
                margin-bottom: 24px;
            }
            .res-list-card {
                grid-template-columns: 1fr;
                text-align: center;
            }
            .res-list-thumb {
                width: 100%;
                height: 160px;
            }
            .res-list-actions {
                align-items: center;
                flex-direction: row;
                justify-content: space-between;
                width: 100%;
            }
        }
    </style>
</head>
<body>

    <!-- Shared Header Navbar -->
    <jsp:include page="/Foodie/includes/navbar.jsp" />

    <main class="res-page-wrap">
        <!-- Search & Category Chips Header -->
        <div class="search-chips-header">
            <div class="search-row">
                <div class="filter-search-input-wrap">
                    <span class="search-icon">🔍</span>
                    <input type="text" id="liveSearchInput" class="filter-search-input" 
                           placeholder="Search for restaurants, cuisines, dishes..." 
                           value="<%= initialSearch %>">
                </div>
            </div>

            <!-- Category Chips (Matches Screen 2) -->
            <div class="category-chips-bar" id="categoryChipsBar">
                <button type="button" class="category-chip <%= initialCuisine.isEmpty() ? "active" : "" %>" data-filter="all">All</button>
                <button type="button" class="category-chip <%= "Biryani".equalsIgnoreCase(initialCuisine) ? "active" : "" %>" data-filter="Biryani">Biryani</button>
                <button type="button" class="category-chip <%= "Pizza".equalsIgnoreCase(initialCuisine) ? "active" : "" %>" data-filter="Pizza">Pizza</button>
                <button type="button" class="category-chip <%= "Burgers".equalsIgnoreCase(initialCuisine) ? "active" : "" %>" data-filter="Burgers">Burgers</button>
                <button type="button" class="category-chip <%= "Chinese".equalsIgnoreCase(initialCuisine) ? "active" : "" %>" data-filter="Chinese">Chinese</button>
                <button type="button" class="category-chip <%= "Desserts".equalsIgnoreCase(initialCuisine) ? "active" : "" %>" data-filter="Desserts">Desserts</button>
                <button type="button" class="category-chip <%= "Healthy".equalsIgnoreCase(initialCuisine) ? "active" : "" %>" data-filter="Healthy">Healthy</button>
            </div>
        </div>

        <!-- Layout Grid: Left Sidebar + Right List -->
        <div class="listing-layout">
            <!-- Left Sidebar Filters -->
            <aside class="filters-sidebar">
                <!-- Cuisines Filter -->
                <div class="filter-group">
                    <div class="filter-group-header">
                        <span class="filter-group-title">Cuisines</span>
                        <span class="filter-clear-btn" onclick="clearCuisines()">Clear All</span>
                    </div>
                    <label class="filter-option"><input type="checkbox" name="cuisine" value="Biryani" <%= "Biryani".equalsIgnoreCase(initialCuisine) ? "checked" : "" %>> Biryani</label>
                    <label class="filter-option"><input type="checkbox" name="cuisine" value="Pizza" <%= "Pizza".equalsIgnoreCase(initialCuisine) ? "checked" : "" %>> Pizza</label>
                    <label class="filter-option"><input type="checkbox" name="cuisine" value="Burgers" <%= "Burgers".equalsIgnoreCase(initialCuisine) ? "checked" : "" %>> Burgers</label>
                    <label class="filter-option"><input type="checkbox" name="cuisine" value="Chinese" <%= "Chinese".equalsIgnoreCase(initialCuisine) ? "checked" : "" %>> Chinese</label>
                    <label class="filter-option"><input type="checkbox" name="cuisine" value="South Indian"> South Indian</label>
                    <label class="filter-option"><input type="checkbox" name="cuisine" value="Desserts" <%= "Desserts".equalsIgnoreCase(initialCuisine) ? "checked" : "" %>> Desserts</label>
                    <label class="filter-option"><input type="checkbox" name="cuisine" value="Healthy" <%= "Healthy".equalsIgnoreCase(initialCuisine) ? "checked" : "" %>> Healthy</label>
                </div>

                <!-- Rating Filter -->
                <div class="filter-group">
                    <div class="filter-group-header">
                        <span class="filter-group-title">Rating</span>
                    </div>
                    <label class="filter-option"><input type="radio" name="rating" value="4.0"> ⭐ 4.0 & above</label>
                    <label class="filter-option"><input type="radio" name="rating" value="3.5"> ⭐ 3.5 & above</label>
                    <label class="filter-option"><input type="radio" name="rating" value="3.0"> ⭐ 3.0 & above</label>
                    <label class="filter-option"><input type="radio" name="rating" value="all" checked> All Ratings</label>
                </div>

                <!-- Delivery Time Filter -->
                <div class="filter-group">
                    <div class="filter-group-header">
                        <span class="filter-group-title">Delivery Time</span>
                    </div>
                    <label class="filter-option"><input type="checkbox" name="delTime" value="30"> Under 30 mins</label>
                    <label class="filter-option"><input type="checkbox" name="delTime" value="45"> 30-45 mins</label>
                    <label class="filter-option"><input type="checkbox" name="delTime" value="60"> 45+ mins</label>
                </div>

                <!-- Price Range Filter -->
                <div class="filter-group">
                    <div class="filter-group-header">
                        <span class="filter-group-title">Price Range</span>
                    </div>
                    <label class="filter-option"><input type="checkbox" name="price" value="1"> ₹ (Budget)</label>
                    <label class="filter-option"><input type="checkbox" name="price" value="2"> ₹₹ (Standard)</label>
                    <label class="filter-option"><input type="checkbox" name="price" value="3"> ₹₹₹ (Premium)</label>
                </div>
            </aside>

            <!-- Main Restaurant Content -->
            <section>
                <div class="listing-header">
                    <h2 class="restaurant-count-title" id="displayedCount">
                        <%= (restaurants != null) ? restaurants.size() : 0 %> Restaurants
                    </h2>

                    <div class="sort-select-wrap">
                        <span>Sort by:</span>
                        <select class="sort-select" id="sortSelect" onchange="applyFilters()">
                            <option value="relevance">Relevance</option>
                            <option value="rating-desc">Rating: High to Low</option>
                            <option value="delivery-asc">Fastest Delivery</option>
                        </select>
                    </div>
                </div>

                <!-- List of Restaurant Cards (Matches Screen 2) -->
                <div class="restaurant-list" id="restaurantCardsList">
                    <%
                    if (restaurants != null && !restaurants.isEmpty()) {
                        for (ResDetails r : restaurants) {
                            String discount = (r.getId() % 2 == 0) ? "40% OFF" : "30% OFF";
                            String delTime = (r.getDelTime() != null && !r.getDelTime().isEmpty()) ? r.getDelTime() : "30-40 mins";
                            double rating = r.getRating();
                    %>
                        <article class="res-list-card" 
                                 data-id="<%= r.getId() %>"
                                 data-name="<%= r.getResName() %>" 
                                 data-cuisine="<%= r.getCuisineType() %>"
                                 data-rating="<%= String.format("%.1f", rating) %>"
                                 data-reviews="12K+ reviews"
                                 data-deltime="<%= delTime %>"
                                 data-delfee="Free Delivery"
                                 data-address="Banjara Hills, Hyderabad"
                                 data-image="<%= request.getContextPath() %>/Foodie/images/restaurants/<%= r.getImagePath() %>"
                                 data-discount="<%= discount %>"
                                 data-desc="Top-rated destination renowned for delicious food, hygienic preparation, and swift contactless delivery."
                                 data-context-path="<%= request.getContextPath() %>">
                            
                            <!-- Thumbnail -->
                            <img src="<%= request.getContextPath() %>/Foodie/images/restaurants/<%= r.getImagePath() %>" 
                                 alt="<%= r.getResName() %>" 
                                 class="res-list-thumb"
                                 onerror="this.src='<%= request.getContextPath() %>/Foodie/images/restaurants/dominos.jpg';">

                            <!-- Info -->
                            <div class="res-list-info">
                                <h3 class="res-list-title"><%= r.getResName() %></h3>

                                <div class="res-list-rating-row">
                                    <span class="rating-pill">⭐ <%= rating %></span>
                                    <span style="color: var(--text-muted); font-size: 12px;">(12K+ reviews)</span>
                                </div>

                                <div class="res-list-cuisines"><%= r.getCuisineType() %></div>

                                <div class="res-list-meta">
                                    <span class="badge-free-del">Free Delivery</span>
                                    <span>⏱ <%= delTime %></span>
                                    <span>📍 2.5 km</span>
                                </div>
                            </div>

                            <!-- Actions & Discount -->
                            <div class="res-list-actions">
                                <button type="button" class="fav-heart-btn" title="Add to Favorites" onclick="toggleHeart(this)">🤍</button>
                                <span class="badge-discount"><%= discount %></span>
                                <a href="<%= request.getContextPath() %>/menu?resId=<%= r.getId() %>" class="btn-primary" style="padding: 9px 18px; font-size: 13px;">
                                    View Menu →
                                </a>
                            </div>
                        </article>
                    <%
                        }
                    }
                    %>
                </div>

                <!-- Empty State -->
                <div class="empty-filter-state" id="emptyState">
                    <div style="font-size: 48px; margin-bottom: 12px;">🔍</div>
                    <h3 style="color: var(--text-white); font-size: 18px; margin-bottom: 6px;">No restaurants match your filters</h3>
                    <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 20px;">Try adjusting your search terms or clearing the selected filters.</p>
                    <button type="button" class="btn-primary" onclick="resetAllFilters()">Reset All Filters</button>
                </div>
            </section>
        </div>
    </main>

    <!-- Shared Footer -->
    <jsp:include page="/Foodie/includes/footer.jsp" />

    <script>
        const searchInput = document.getElementById('liveSearchInput');
        const cardsList = document.getElementById('restaurantCardsList');
        const countDisplay = document.getElementById('displayedCount');
        const emptyState = document.getElementById('emptyState');
        const sortSelect = document.getElementById('sortSelect');

        // Filter event listeners
        searchInput.addEventListener('input', applyFilters);
        document.querySelectorAll('input[name="cuisine"]').forEach(cb => cb.addEventListener('change', applyFilters));
        document.querySelectorAll('input[name="rating"]').forEach(rb => rb.addEventListener('change', applyFilters));
        document.querySelectorAll('input[name="delTime"]').forEach(cb => cb.addEventListener('change', applyFilters));

        // Category chips handler
        document.querySelectorAll('#categoryChipsBar .category-chip').forEach(chip => {
            chip.addEventListener('click', function() {
                document.querySelectorAll('#categoryChipsBar .category-chip').forEach(c => c.classList.remove('active'));
                this.classList.add('active');
                
                const filterVal = this.getAttribute('data-filter');
                document.querySelectorAll('input[name="cuisine"]').forEach(cb => {
                    cb.checked = (filterVal !== 'all' && cb.value.toLowerCase() === filterVal.toLowerCase());
                });
                applyFilters();
            });
        });

        function applyFilters() {
            const query = searchInput.value.toLowerCase().trim();
            const checkedCuisines = Array.from(document.querySelectorAll('input[name="cuisine"]:checked')).map(cb => cb.value.toLowerCase());
            const selectedRatingRadio = document.querySelector('input[name="rating"]:checked');
            const minRating = selectedRatingRadio && selectedRatingRadio.value !== 'all' ? parseFloat(selectedRatingRadio.value) : 0;
            
            const cards = Array.from(document.querySelectorAll('#restaurantCardsList .res-list-card'));
            let visibleCount = 0;

            cards.forEach(card => {
                const name = (card.getAttribute('data-name') || '').toLowerCase();
                const cuisine = (card.getAttribute('data-cuisine') || '').toLowerCase();
                const rating = parseFloat(card.getAttribute('data-rating') || '0');

                // Search query match
                const matchesSearch = !query || name.includes(query) || cuisine.includes(query);

                // Cuisine match
                const matchesCuisine = checkedCuisines.length === 0 || checkedCuisines.some(c => cuisine.includes(c));

                // Rating match
                const matchesRating = rating >= minRating;

                if (matchesSearch && matchesCuisine && matchesRating) {
                    card.style.display = 'grid';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            // Sorting
            const sortMode = sortSelect.value;
            if (sortMode === 'rating-desc') {
                cards.sort((a, b) => parseFloat(b.getAttribute('data-rating')) - parseFloat(a.getAttribute('data-rating')));
                cards.forEach(card => cardsList.appendChild(card));
            }

            countDisplay.innerText = visibleCount + ' Restaurants';
            emptyState.style.display = (visibleCount === 0) ? 'block' : 'none';
        }

        function clearCuisines() {
            document.querySelectorAll('input[name="cuisine"]').forEach(cb => cb.checked = false);
            document.querySelectorAll('#categoryChipsBar .category-chip').forEach(c => c.classList.remove('active'));
            document.querySelector('#categoryChipsBar .category-chip[data-filter="all"]').classList.add('active');
            applyFilters();
        }

        function resetAllFilters() {
            searchInput.value = '';
            clearCuisines();
            document.querySelector('input[name="rating"][value="all"]').checked = true;
            document.querySelectorAll('input[name="delTime"]').forEach(cb => cb.checked = false);
            applyFilters();
        }

        function toggleHeart(btn) {
            btn.innerText = (btn.innerText === '🤍') ? '❤️' : '🤍';
        }

        // Run initial filter on load
        window.addEventListener('DOMContentLoaded', applyFilters);
    </script>
</body>
</html>
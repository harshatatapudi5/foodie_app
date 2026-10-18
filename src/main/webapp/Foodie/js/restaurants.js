/**
 * ===================================================================
 * FOODIE - RESTAURANT LISTING CONTROLLER (js/restaurants.js)
 * Clean, modular client-side logic
 * Features: Search, Category Filters, Multi-Sorting, Favorites,
 *           Menu Navigation with URL params, and Cart Integration.
 * ===================================================================
 */

document.addEventListener('DOMContentLoaded', () => {

    /* ===============================================================
       1. RESTAURANT DATA STORE (Ready to swap with Java Servlet / DB)
       =============================================================== */
    const RESTAURANTS_DATA = [
        {
            id: 'spice-garden',
            name: 'Spice Garden',
            cuisines: ['Biryani', 'North Indian'],
            rating: 4.5,
            deliveryTimeMin: 30,
            deliveryTime: '30–40 mins',
            priceForTwo: 350,
            image: 'images/restaurants/spice-garden.jpg',
            fallbackImage: 'images/restaurants/spice-garden.svg'
        },
        {
            id: 'tandoori-house',
            name: 'Tandoori House',
            cuisines: ['Tandoori', 'Kebabs', 'North Indian'],
            rating: 4.4,
            deliveryTimeMin: 35,
            deliveryTime: '35–45 mins',
            priceForTwo: 400,
            image: 'images/restaurants/tandoori-house.jpg',
            fallbackImage: 'images/restaurants/spice-garden.svg'
        },
        {
            id: 'dosa-corner',
            name: 'Dosa Corner',
            cuisines: ['South Indian', 'Breakfast'],
            rating: 4.6,
            deliveryTimeMin: 20,
            deliveryTime: '20–30 mins',
            priceForTwo: 200,
            image: 'images/restaurants/dosa-corner.jpg',
            fallbackImage: 'images/breakfast/dosa.svg'
        },
        {
            id: 'pizza-palace',
            name: 'Pizza Palace',
            cuisines: ['Pizza', 'Italian'],
            rating: 4.3,
            deliveryTimeMin: 25,
            deliveryTime: '25–35 mins',
            priceForTwo: 450,
            image: 'images/restaurants/pizza-palace.jpg',
            fallbackImage: 'images/restaurants/pizza-palace.svg'
        },
        {
            id: 'burger-hub',
            name: 'Burger Hub',
            cuisines: ['Burgers', 'Fast Food', 'Snacks'],
            rating: 4.4,
            deliveryTimeMin: 20,
            deliveryTime: '20–30 mins',
            priceForTwo: 250,
            image: 'images/restaurants/burger-hub.jpg',
            fallbackImage: 'images/restaurants/burger-hub.svg'
        },
        {
            id: 'noodle-bowl',
            name: 'The Noodle Bowl',
            cuisines: ['Chinese', 'Asian'],
            rating: 4.2,
            deliveryTimeMin: 30,
            deliveryTime: '30–40 mins',
            priceForTwo: 320,
            image: 'images/restaurants/noodle-bowl.jpg',
            fallbackImage: 'images/restaurants/noodle-bowl.svg'
        },
        {
            id: 'cafe-delight',
            name: 'Cafe Delight',
            cuisines: ['Cafe', 'Coffee', 'Snacks', 'Desserts'],
            rating: 4.6,
            deliveryTimeMin: 15,
            deliveryTime: '15–25 mins',
            priceForTwo: 220,
            image: 'images/restaurants/cafe-delight.jpg',
            fallbackImage: 'images/restaurants/cafe-delight.svg'
        },
        {
            id: 'royal-biryani',
            name: 'Royal Biryani',
            cuisines: ['Biryani', 'Hyderabadi Biryani', 'Mughlai'],
            rating: 4.7,
            deliveryTimeMin: 30,
            deliveryTime: '30–40 mins',
            priceForTwo: 480,
            image: 'images/restaurants/royal-biryani.jpg',
            fallbackImage: 'images/restaurants/royal-biryani.svg'
        }
    ];

    /* ===============================================================
       2. DOM REFERENCES
       =============================================================== */
    const restaurantsGrid = document.getElementById('restaurantsGrid');
    const searchInput = document.getElementById('searchInput');
    const searchClearBtn = document.getElementById('searchClearBtn');
    const filterPills = document.querySelectorAll('.filter-pill');
    const sortSelect = document.getElementById('sortSelect');
    const resultsCountEl = document.getElementById('resultsCount');

    // Cart Elements
    const cartBtn = document.getElementById('cartBtn');
    const cartBadge = document.getElementById('cartBadge');
    const cartDrawer = document.getElementById('cartDrawer');
    const cartDrawerOverlay = document.getElementById('cartDrawerOverlay');
    const closeCartBtn = document.getElementById('closeCartBtn');
    const cartItemsList = document.getElementById('cartItemsList');
    const cartTotalPrice = document.getElementById('cartTotalPrice');
    const checkoutBtn = document.getElementById('checkoutBtn');

    // User Dropdown
    const userMenuWrapper = document.getElementById('userMenuWrapper');
    const userMenuBtn = document.getElementById('userMenuBtn');

    // Mobile Navbar
    const mobileMenuToggle = document.getElementById('mobileMenuToggle');
    const navLinks = document.getElementById('navLinks');

    // Toast
    const toastNotice = document.getElementById('toastNotice');

    /* ===============================================================
       3. STATE MANAGEMENT
       =============================================================== */
    let currentCategory = 'all';
    let currentSearchQuery = '';
    let currentSort = 'recommended';
    let favorites = JSON.parse(localStorage.getItem('foodie_favs') || '[]');

    /* ===============================================================
       4. FILTERING & SORTING PIPELINE
       =============================================================== */
    function getProcessedRestaurants() {
        // Step 1: Category Filter
        let result = RESTAURANTS_DATA.filter(rest => {
            if (currentCategory === 'all') return true;

            const targetCategory = currentCategory.toLowerCase().trim();
            return rest.cuisines.some(c => {
                const cuisineLower = c.toLowerCase().trim();
                return cuisineLower.includes(targetCategory) || targetCategory.includes(cuisineLower);
            });
        });

        // Step 2: Search Query Filter
        if (currentSearchQuery) {
            const q = currentSearchQuery.toLowerCase().trim();
            result = result.filter(rest => {
                const nameMatch = rest.name.toLowerCase().includes(q);
                const cuisineMatch = rest.cuisines.some(c => c.toLowerCase().includes(q));
                return nameMatch || cuisineMatch;
            });
        }

        // Step 3: Sorting
        switch (currentSort) {
            case 'rating':
                // Highest rating first
                result.sort((a, b) => b.rating - a.rating);
                break;
            case 'delivery':
                // Fastest delivery first
                result.sort((a, b) => a.deliveryTimeMin - b.deliveryTimeMin);
                break;
            case 'price':
                // Lowest price for two first
                result.sort((a, b) => a.priceForTwo - b.priceForTwo);
                break;
            case 'recommended':
            default:
                // Default order (original)
                break;
        }

        return result;
    }

    /* ===============================================================
       5. CARD RENDERING
       =============================================================== */
    function renderRestaurants() {
        const list = getProcessedRestaurants();

        // Update count
        if (resultsCountEl) {
            resultsCountEl.textContent = `${list.length} restaurant${list.length === 1 ? '' : 's'}`;
        }

        restaurantsGrid.innerHTML = '';

        if (list.length === 0) {
            restaurantsGrid.innerHTML = `
                <div class="empty-state">
                    <div class="empty-icon">🍽</div>
                    <h3 class="empty-title">No Restaurants Found</h3>
                    <p class="empty-desc">We couldn't find any restaurants matching your current search or filter.</p>
                    <button class="btn-reset-filters" id="resetFiltersBtn">Reset All Filters</button>
                </div>
            `;
            const resetBtn = document.getElementById('resetFiltersBtn');
            if (resetBtn) {
                resetBtn.addEventListener('click', () => {
                    resetAllFilters();
                });
            }
            return;
        }

        list.forEach(rest => {
            const isFav = favorites.includes(rest.id);
            const card = document.createElement('article');
            card.className = 'restaurant-card';
            card.setAttribute('data-id', rest.id);

            card.innerHTML = `
                <div class="card-image-wrap">
                    <img 
                        src="${rest.image}" 
                        alt="${rest.name}" 
                        loading="lazy" 
                        onerror="if(this.src!=='${rest.fallbackImage}') this.src='${rest.fallbackImage}';"
                    >
                    <button 
                        class="btn-fav ${isFav ? 'active' : ''}" 
                        data-id="${rest.id}" 
                        aria-label="Add to favorites"
                    >
                        ${isFav ? '❤️' : '♡'}
                    </button>
                    <div class="rating-badge">
                        ⭐ ${rest.rating.toFixed(1)}
                    </div>
                </div>
                <div class="card-content">
                    <div class="card-title-row">
                        <h2 class="restaurant-name">${rest.name}</h2>
                    </div>
                    <p class="restaurant-cuisines">${rest.cuisines.join(' • ')}</p>
                    <div class="card-meta-row">
                        <span class="delivery-time">
                            <span>🕒</span> ${rest.deliveryTime}
                        </span>
                        <span class="cost-for-two">₹${rest.priceForTwo} for two</span>
                    </div>
                    <!-- View Menu Button with Restaurant Parameter -->
                    <a 
                        href="menu.html?restaurant=${encodeURIComponent(rest.id)}" 
                        class="btn-view-menu"
                        data-id="${rest.id}"
                    >
                        View Menu →
                    </a>
                </div>
            `;
            restaurantsGrid.appendChild(card);
        });

        // Attach Favorite Toggle Handlers
        restaurantsGrid.querySelectorAll('.btn-fav').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                const id = btn.getAttribute('data-id');

                if (favorites.includes(id)) {
                    favorites = favorites.filter(favId => favId !== id);
                    btn.classList.remove('active');
                    btn.textContent = '♡';
                    showToast('Removed from favorites');
                } else {
                    favorites.push(id);
                    btn.classList.add('active');
                    btn.textContent = '❤️';
                    showToast('Added to favorites! ❤️');
                }
                localStorage.setItem('foodie_favs', JSON.stringify(favorites));
            });
        });
    }

    function resetAllFilters() {
        currentCategory = 'all';
        currentSearchQuery = '';
        currentSort = 'recommended';

        if (searchInput) {
            searchInput.value = '';
            if (searchClearBtn) searchClearBtn.style.display = 'none';
        }
        if (sortSelect) sortSelect.value = 'recommended';

        filterPills.forEach(pill => {
            pill.classList.toggle('active', pill.getAttribute('data-category') === 'all');
        });

        renderRestaurants();
        showToast('All filters have been reset');
    }

    /* ===============================================================
       6. EVENT HANDLERS (SEARCH, CATEGORY, SORT)
       =============================================================== */

    // Search Input
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            currentSearchQuery = e.target.value.trim();
            if (searchClearBtn) {
                searchClearBtn.style.display = currentSearchQuery.length > 0 ? 'block' : 'none';
            }
            renderRestaurants();
        });
    }

    if (searchClearBtn) {
        searchClearBtn.addEventListener('click', () => {
            searchInput.value = '';
            currentSearchQuery = '';
            searchClearBtn.style.display = 'none';
            renderRestaurants();
            searchInput.focus();
        });
    }

    // Category Filter Pills
    filterPills.forEach(pill => {
        pill.addEventListener('click', () => {
            filterPills.forEach(p => p.classList.remove('active'));
            pill.classList.add('active');

            currentCategory = pill.getAttribute('data-category');
            renderRestaurants();
            showToast(`Filtered by ${pill.textContent.trim()}`);
        });
    });

    // Sorting Dropdown
    if (sortSelect) {
        sortSelect.addEventListener('change', (e) => {
            currentSort = e.target.value;
            renderRestaurants();
        });
    }

    // Check for Category in URL (e.g. restaurants.html?category=biryani)
    const urlParams = new URLSearchParams(window.location.search);
    const categoryParam = urlParams.get('category');
    if (categoryParam) {
        const matchingPill = Array.from(filterPills).find(
            p => p.getAttribute('data-category').toLowerCase() === categoryParam.toLowerCase()
        );
        if (matchingPill) {
            filterPills.forEach(p => p.classList.remove('active'));
            matchingPill.classList.add('active');
            currentCategory = matchingPill.getAttribute('data-category');
        }
    }

    // Initial render
    renderRestaurants();

    /* ===============================================================
       7. CART INTEGRATION
       =============================================================== */
    let cart = JSON.parse(localStorage.getItem('foodieCart') || localStorage.getItem('foodie_cart') || '[]');

    function updateCartCountBadge() {
        const totalCount = cart.reduce((acc, item) => acc + (Number(item.quantity) || 1), 0);
        if (cartBadge) {
            cartBadge.textContent = totalCount;
            cartBadge.animate([
                { transform: 'scale(1.3)' },
                { transform: 'scale(1)' }
            ], { duration: 250 });
        }
    }

    function renderCartDrawer() {
        cartItemsList.innerHTML = '';

        if (cart.length === 0) {
            cartItemsList.innerHTML = `
                <div class="empty-cart-msg">
                    <p style="font-size: 38px; margin-bottom: 8px;">🛒</p>
                    <p style="font-weight: 700; color: #1c1c1c;">Your cart is empty</p>
                    <p style="font-size: 13px; color: #999; margin-top: 4px;">Explore restaurants & menus to add delicious meals!</p>
                </div>
            `;
            cartTotalPrice.textContent = '₹0';
            return;
        }

        let total = 0;
        cart.forEach((item, index) => {
            total += (Number(item.price) || 0) * (Number(item.quantity) || 1);
            const row = document.createElement('div');
            row.className = 'cart-item-row';
            row.innerHTML = `
                <div>
                    <div class="cart-item-name">${item.name}</div>
                    <div class="cart-item-price">₹${item.price} each</div>
                </div>
                <div class="cart-item-qty">
                    <button class="btn-qty" data-action="decrease" data-index="${index}">-</button>
                    <span style="font-size: 14px; font-weight: 700; min-width: 18px; text-align: center;">${item.quantity}</span>
                    <button class="btn-qty" data-action="increase" data-index="${index}">+</button>
                </div>
            `;
            cartItemsList.appendChild(row);
        });

        cartTotalPrice.textContent = `₹${total}`;

        cartItemsList.querySelectorAll('.btn-qty').forEach(btn => {
            btn.addEventListener('click', () => {
                const action = btn.getAttribute('data-action');
                const idx = parseInt(btn.getAttribute('data-index'), 10);

                if (action === 'increase') {
                    cart[idx].quantity += 1;
                } else if (action === 'decrease') {
                    cart[idx].quantity -= 1;
                    if (cart[idx].quantity <= 0) {
                        cart.splice(idx, 1);
                    }
                }
                saveCart();
                renderCartDrawer();
            });
        });
    }

    function saveCart() {
        localStorage.setItem('foodieCart', JSON.stringify(cart));
        localStorage.setItem('foodie_cart', JSON.stringify(cart));
        updateCartCountBadge();
    }

    if (cartBtn) {
        cartBtn.addEventListener('click', () => {
            renderCartDrawer();
            cartDrawer.classList.add('active');
            cartDrawerOverlay.classList.add('active');
        });
    }

    function closeCart() {
        cartDrawer.classList.remove('active');
        cartDrawerOverlay.classList.remove('active');
    }

    if (closeCartBtn) closeCartBtn.addEventListener('click', closeCart);
    if (cartDrawerOverlay) cartDrawerOverlay.addEventListener('click', closeCart);

    if (checkoutBtn) {
        checkoutBtn.addEventListener('click', () => {
            if (cart.length === 0) {
                showToast('Your cart is empty! Add items from the menu.');
                return;
            }
            window.location.href = 'cart.html';
        });
    }

    updateCartCountBadge();

    /* ===============================================================
       8. USER PROFILE DROPDOWN
       =============================================================== */
    if (userMenuBtn) {
        userMenuBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            userMenuWrapper.classList.toggle('active');
        });

        document.addEventListener('click', (e) => {
            if (!userMenuWrapper.contains(e.target)) {
                userMenuWrapper.classList.remove('active');
            }
        });
    }

    /* ===============================================================
       9. MOBILE MENU TOGGLE
       =============================================================== */
    if (mobileMenuToggle && navLinks) {
        mobileMenuToggle.addEventListener('click', () => {
            navLinks.classList.toggle('show-mobile');
        });

        navLinks.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', () => {
                navLinks.classList.remove('show-mobile');
            });
        });
    }

    /* ===============================================================
       10. TOAST NOTIFICATION HELPER
       =============================================================== */
    let toastTimeout;
    function showToast(message) {
        if (!toastNotice) return;
        toastNotice.textContent = message;
        toastNotice.classList.add('show');
        clearTimeout(toastTimeout);
        toastTimeout = setTimeout(() => {
            toastNotice.classList.remove('show');
        }, 3000);
    }
});

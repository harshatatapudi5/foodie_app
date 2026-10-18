/**
 * ===================================================================
 * FOODIE - MODERN HOMEPAGE CONTROLLER (js/home.js)
 * Clean, production-ready client-side logic
 * Features: Hero Carousel, Live Search & Category Filters,
 *           Restaurant Filtering, Brand Carousel, Favorites & Cart.
 * ===================================================================
 */

document.addEventListener('DOMContentLoaded', () => {
    'use strict';

    // LocalStorage Keys
    const STORAGE_KEY_CART = 'foodieCart';
    const STORAGE_KEY_CART_ALT = 'foodie_cart';
    const STORAGE_KEY_FAVS = 'foodie_favs';

    // DOM Elements
    const navCartBadge = document.getElementById('navCartBadge');
    const mobileMenuToggle = document.getElementById('mobileMenuToggle');
    const navLinks = document.getElementById('navLinks');
    const navSearchInput = document.getElementById('navSearchInput');
    const heroSearchInput = document.getElementById('heroSearchInput');
    const heroSearchBtn = document.getElementById('heroSearchBtn');

    // Hero Carousel
    const heroCarouselImg = document.getElementById('heroCarouselImg');
    const carouselPrevBtn = document.getElementById('carouselPrevBtn');
    const carouselNextBtn = document.getElementById('carouselNextBtn');
    const carouselDots = document.querySelectorAll('.carousel-dots .dot');

    // Categories
    const categoriesScrollRow = document.getElementById('categoriesScrollRow');
    const catScrollLeft = document.getElementById('catScrollLeft');
    const catScrollRight = document.getElementById('catScrollRight');
    const categoryCards = document.querySelectorAll('.category-pill-card');

    // Restaurants
    const restaurantsGrid = document.getElementById('restaurantsGrid');
    const restaurantCards = document.querySelectorAll('.restaurant-card');
    const filterIndicatorBar = document.getElementById('filterIndicatorBar');
    const activeSearchTag = document.getElementById('activeSearchTag');
    const btnClearFilter = document.getElementById('btnClearFilter');

    // Famous Brands
    const brandCards = document.querySelectorAll('.brand-badge-card');

    // Toast Notice
    const toastNotice = document.getElementById('toastNotice');
    const toastMessage = document.getElementById('toastMessage');

    /* ===============================================================
       1. HERO DISH CAROUSEL SLIDES
       =============================================================== */
    const HERO_SLIDES = [
        {
            title: "Royal Chicken Dum Biryani",
            price: "From ₹250",
            image: "images/hero/hero-biryani.jpg",
            fallback: "images/menu/chicken-biryani.jpg"
        },
        {
            title: "Gourmet Italian Cheesy Pizza",
            price: "From ₹299",
            image: "images/restaurants/dominos.jpg",
            fallback: "images/menu/pizza.jpg"
        },
        {
            title: "Double Flame-Grilled Burger",
            price: "From ₹180",
            image: "images/restaurants/mcdonalds.jpg",
            fallback: "images/menu/burger.jpg"
        },
        {
            title: "Molten Chocolate Lava Cake",
            price: "From ₹149",
            image: "images/categories/dessert.jpg",
            fallback: "images/menu/gulab-jamun.jpg"
        }
    ];

    let currentSlide = 0;
    let carouselInterval;

    function setHeroSlide(index) {
        currentSlide = (index + HERO_SLIDES.length) % HERO_SLIDES.length;
        const slide = HERO_SLIDES[currentSlide];

        if (heroCarouselImg) {
            heroCarouselImg.style.opacity = '0.3';
            setTimeout(() => {
                heroCarouselImg.src = slide.image;
                heroCarouselImg.alt = slide.title;
                heroCarouselImg.onerror = () => { heroCarouselImg.src = slide.fallback; };
                heroCarouselImg.style.opacity = '1';
            }, 180);
        }

        carouselDots.forEach((dot, idx) => {
            if (idx === currentSlide) {
                dot.classList.add('active');
            } else {
                dot.classList.remove('active');
            }
        });
    }

    function startCarouselTimer() {
        clearInterval(carouselInterval);
        carouselInterval = setInterval(() => {
            setHeroSlide(currentSlide + 1);
        }, 5500);
    }

    if (carouselPrevBtn) {
        carouselPrevBtn.addEventListener('click', () => {
            setHeroSlide(currentSlide - 1);
            startCarouselTimer();
        });
    }

    if (carouselNextBtn) {
        carouselNextBtn.addEventListener('click', () => {
            setHeroSlide(currentSlide + 1);
            startCarouselTimer();
        });
    }

    carouselDots.forEach((dot, index) => {
        dot.addEventListener('click', () => {
            setHeroSlide(index);
            startCarouselTimer();
        });
    });

    startCarouselTimer();

    /* ===============================================================
       2. LIVE CART COUNT SYNCHRONIZATION
       =============================================================== */
    function updateCartBadge() {
        const rawCart = localStorage.getItem(STORAGE_KEY_CART) || localStorage.getItem(STORAGE_KEY_CART_ALT);
        let count = 0;
        if (rawCart) {
            try {
                const parsed = JSON.parse(rawCart);
                if (Array.isArray(parsed)) {
                    count = parsed.reduce((acc, item) => acc + (Number(item.quantity) || 1), 0);
                }
            } catch (e) {
                console.error("Error reading cart badge count:", e);
            }
        }
        if (navCartBadge) {
            navCartBadge.textContent = count;
        }
    }
    updateCartBadge();

    /* ===============================================================
       3. FAVORITES FUNCTIONALITY (Interactive Hearts)
       =============================================================== */
    let favorites = [];
    try {
        favorites = JSON.parse(localStorage.getItem(STORAGE_KEY_FAVS) || '[]');
        if (!Array.isArray(favorites)) favorites = [];
    } catch (e) {
        favorites = [];
    }

    function initFavoritesUI() {
        document.querySelectorAll('.btn-heart-fav').forEach(btn => {
            const id = btn.getAttribute('data-id');
            if (favorites.includes(id)) {
                btn.classList.add('active');
                btn.textContent = '❤️';
            } else {
                btn.classList.remove('active');
                btn.textContent = '♡';
            }

            btn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();

                if (favorites.includes(id)) {
                    favorites = favorites.filter(favId => favId !== id);
                    btn.classList.remove('active');
                    btn.textContent = '♡';
                    showToast('Removed from favorites');
                } else {
                    favorites.push(id);
                    btn.classList.add('active');
                    btn.textContent = '❤️';
                    showToast('Saved to your favorites! ❤️');
                }
                localStorage.setItem(STORAGE_KEY_FAVS, JSON.stringify(favorites));
            });
        });
    }
    initFavoritesUI();

    /* ===============================================================
       4. RESTAURANT & CATEGORY FILTERING / SEARCH
       =============================================================== */
    function filterRestaurants(query) {
        const q = (query || '').toLowerCase().trim();
        let matchCount = 0;

        if (q === '') {
            restaurantCards.forEach(card => {
                card.style.display = 'flex';
            });
            categoryCards.forEach(c => c.classList.remove('active'));
            if (filterIndicatorBar) filterIndicatorBar.style.display = 'none';
            return;
        }

        restaurantCards.forEach(card => {
            const name = (card.getAttribute('data-name') || '').toLowerCase();
            const cuisines = (card.getAttribute('data-cuisines') || '').toLowerCase();

            if (name.includes(q) || cuisines.includes(q)) {
                card.style.display = 'flex';
                matchCount++;
            } else {
                card.style.display = 'none';
            }
        });

        // Highlight matching category card if any
        categoryCards.forEach(c => {
            const cat = (c.getAttribute('data-category') || '').toLowerCase();
            if (cat === q || q.includes(cat)) {
                c.classList.add('active');
            } else {
                c.classList.remove('active');
            }
        });

        if (filterIndicatorBar) {
            filterIndicatorBar.style.display = 'flex';
            if (activeSearchTag) {
                activeSearchTag.textContent = `"${query}" (${matchCount} found)`;
            }
        }

        // Smooth scroll to restaurants section if search was performed
        const restaurantsSec = document.getElementById('restaurantsSection');
        if (restaurantsSec) {
            restaurantsSec.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }

    function clearFilter() {
        if (heroSearchInput) heroSearchInput.value = '';
        if (navSearchInput) navSearchInput.value = '';
        filterRestaurants('');
        showToast('All restaurants displayed');
    }

    if (btnClearFilter) {
        btnClearFilter.addEventListener('click', clearFilter);
    }

    // Hero Search Trigger
    if (heroSearchBtn && heroSearchInput) {
        heroSearchBtn.addEventListener('click', () => {
            filterRestaurants(heroSearchInput.value);
        });
        heroSearchInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                filterRestaurants(heroSearchInput.value);
            }
        });
    }

    // Navbar Live Search
    if (navSearchInput) {
        let navDebounce;
        navSearchInput.addEventListener('input', (e) => {
            clearTimeout(navDebounce);
            navDebounce = setTimeout(() => {
                filterRestaurants(e.target.value);
            }, 250);
        });
    }

    /* ===============================================================
       5. CATEGORY CARDS INTERACTION
       =============================================================== */
    categoryCards.forEach(card => {
        card.addEventListener('click', () => {
            const category = card.getAttribute('data-category');
            if (card.classList.contains('active')) {
                clearFilter();
            } else {
                filterRestaurants(category);
                showToast(`Filtered by ${card.querySelector('.cat-name').textContent}`);
            }
        });
    });

    // Horizontal category scrolling arrows
    if (catScrollLeft && categoriesScrollRow) {
        catScrollLeft.addEventListener('click', () => {
            categoriesScrollRow.scrollBy({ left: -260, behavior: 'smooth' });
        });
    }
    if (catScrollRight && categoriesScrollRow) {
        catScrollRight.addEventListener('click', () => {
            categoriesScrollRow.scrollBy({ left: 260, behavior: 'smooth' });
        });
    }

    /* ===============================================================
       6. FAMOUS FOOD BRANDS INTERACTION
       =============================================================== */
    brandCards.forEach(brand => {
        brand.addEventListener('click', () => {
            const brandName = brand.getAttribute('data-brand');
            filterRestaurants(brandName);
            showToast(`Showing menu for ${brandName}`);
        });
    });

    /* ===============================================================
       7. MOBILE MENU TOGGLE
       =============================================================== */
    if (mobileMenuToggle && navLinks) {
        const navCenter = document.querySelector('.nav-center');
        mobileMenuToggle.addEventListener('click', () => {
            if (navCenter) {
                navCenter.classList.toggle('show-mobile');
            }
        });
    }

    /* ===============================================================
       8. FLOATING TOAST HELPER
       =============================================================== */
    let toastTimer;
    function showToast(msg) {
        if (!toastNotice || !toastMessage) return;
        clearTimeout(toastTimer);

        toastMessage.textContent = msg;
        toastNotice.classList.add('show');

        toastTimer = setTimeout(() => {
            toastNotice.classList.remove('show');
        }, 2800);
    }

    // Expose utility globally
    window.FoodieHome = {
        filterRestaurants,
        clearFilter,
        showToast
    };
});

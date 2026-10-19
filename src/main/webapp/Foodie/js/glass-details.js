/**
 * Foodie Glass Details Modal Controller
 * Provides interactive frosted-glass detail views for Restaurants, Food Items, and Categories
 * with real application data and real cart / navigation actions.
 */
(function() {
    'use strict';

    let lastFocusedElement = null;

    function openModal(modalId) {
        const modal = document.getElementById(modalId);
        if (!modal) return;

        lastFocusedElement = document.activeElement;
        modal.classList.add('active');
        modal.setAttribute('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';

        const focusable = modal.querySelector('button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])');
        if (focusable) {
            setTimeout(() => focusable.focus(), 50);
        }
    }

    function closeModal(modalOrId) {
        let modal = modalOrId;
        if (typeof modalOrId === 'string') {
            modal = document.getElementById(modalOrId);
        }
        if (!modal) return;

        modal.classList.remove('active');
        modal.setAttribute('aria-hidden', 'true');
        document.body.style.overflow = '';

        if (lastFocusedElement && typeof lastFocusedElement.focus === 'function') {
            lastFocusedElement.focus();
        }
    }

    // Global helper exposed for inline calls if needed
    window.closeFoodieModal = closeModal;

    /**
     * Show Restaurant Detail Modal
     */
    function showRestaurantModal(card) {
        const modal = document.getElementById('restaurantDetailModal');
        if (!modal) return;

        const id = card.getAttribute('data-id') || '';
        const name = card.getAttribute('data-name') || 'Restaurant Details';
        const cuisine = card.getAttribute('data-cuisine') || 'Multi-Cuisine';
        const rating = card.getAttribute('data-rating') || '4.5';
        const reviews = card.getAttribute('data-reviews') || '500+ ratings';
        const delTime = card.getAttribute('data-deltime') || '30-40 mins';
        const delFee = card.getAttribute('data-delfee') || 'Free Delivery';
        const address = card.getAttribute('data-address') || 'Hyderabad';
        const image = card.getAttribute('data-image') || '';
        const discount = card.getAttribute('data-discount') || 'Special Deal';
        const desc = card.getAttribute('data-desc') || 'Celebrated kitchen serving authentic recipes prepared fresh with prime ingredients, exceptional hygiene standards, and prompt contactless delivery.';
        const contextPath = card.getAttribute('data-context-path') || '';

        // Fill modal fields
        const imgEl = modal.querySelector('#resModalImg');
        const badgeEl = modal.querySelector('#resModalBadge');
        const titleEl = modal.querySelector('#resModalTitle');
        const cuisineEl = modal.querySelector('#resModalCuisine');
        const ratingEl = modal.querySelector('#resModalRating');
        const reviewsEl = modal.querySelector('#resModalReviews');
        const timeEl = modal.querySelector('#resModalTime');
        const feeEl = modal.querySelector('#resModalFee');
        const addrEl = modal.querySelector('#resModalAddress');
        const descEl = modal.querySelector('#resModalDesc');
        const menuBtn = modal.querySelector('#resModalMenuBtn');

        if (imgEl && image) imgEl.src = image;
        if (badgeEl) badgeEl.innerText = discount;
        if (titleEl) titleEl.innerText = name;
        if (cuisineEl) cuisineEl.innerText = cuisine;
        if (ratingEl) ratingEl.innerText = '⭐ ' + rating;
        if (reviewsEl) reviewsEl.innerText = '(' + reviews + ')';
        if (timeEl) timeEl.innerText = '⏱ ' + delTime;
        if (feeEl) feeEl.innerText = '🛵 ' + delFee;
        if (addrEl) addrEl.innerText = '📍 ' + address;
        if (descEl) descEl.innerText = desc;

        if (menuBtn && id) {
            menuBtn.href = contextPath + '/menu?resId=' + id;
        }

        openModal('restaurantDetailModal');
    }

    /**
     * Show Food Item Detail Modal
     */
    function showFoodModal(card) {
        const modal = document.getElementById('foodDetailModal');
        if (!modal) return;

        const id = card.getAttribute('data-id') || '';
        const name = card.getAttribute('data-name') || 'Food Item';
        const desc = card.getAttribute('data-desc') || 'Prepared fresh with signature authentic spices and premium ingredients.';
        const price = card.getAttribute('data-price') || '0.00';
        const category = card.getAttribute('data-category') || 'Main Course';
        const isVeg = (card.getAttribute('data-veg') || '').toLowerCase() === 'veg';
        const image = card.getAttribute('data-image') || '';
        const isAvailable = card.getAttribute('data-available') !== 'false';
        const resName = card.getAttribute('data-restaurant') || 'Partner Kitchen';
        const resId = card.getAttribute('data-resid') || '0';
        const contextPath = card.getAttribute('data-context-path') || '';

        // Fill modal elements
        const imgEl = modal.querySelector('#foodModalImg');
        const vegIcon = modal.querySelector('#foodModalVegIcon');
        const vegText = modal.querySelector('#foodModalVegText');
        const titleEl = modal.querySelector('#foodModalTitle');
        const priceEl = modal.querySelector('#foodModalPrice');
        const catEl = modal.querySelector('#foodModalCategory');
        const resEl = modal.querySelector('#foodModalRestaurant');
        const descEl = modal.querySelector('#foodModalDesc');
        const statusEl = modal.querySelector('#foodModalStatus');

        // Form elements
        const formEl = modal.querySelector('#foodModalForm');
        const menuIdInput = modal.querySelector('#foodModalMenuId');
        const resIdInput = modal.querySelector('#foodModalResId');
        const qtyInput = modal.querySelector('#foodModalQtyInput');
        const qtyDisplay = modal.querySelector('#foodModalQtyVal');
        const submitBtn = modal.querySelector('#foodModalSubmitBtn');

        if (imgEl && image) imgEl.src = image;
        if (titleEl) titleEl.innerText = name;
        if (priceEl) priceEl.innerText = '₹' + parseFloat(price).toFixed(2);
        if (catEl) catEl.innerText = category;
        if (resEl) resEl.innerText = '🍴 ' + resName;
        if (descEl) descEl.innerText = desc;

        if (vegIcon && vegText) {
            if (isVeg) {
                vegIcon.className = 'food-type-icon veg';
                vegText.style.color = 'var(--success)';
                vegText.innerText = 'Pure Veg';
            } else {
                vegIcon.className = 'food-type-icon non-veg';
                vegText.style.color = 'var(--danger)';
                vegText.innerText = 'Non-Veg';
            }
        }

        if (statusEl) {
            if (isAvailable) {
                statusEl.innerHTML = '<span style="color: var(--success);">● In Stock & Ready to Cook</span>';
            } else {
                statusEl.innerHTML = '<span style="color: var(--danger);">● Sold Out for Today</span>';
            }
        }

        // Reset quantity
        let currentQty = 1;
        if (qtyInput) qtyInput.value = '1';
        if (qtyDisplay) qtyDisplay.innerText = '1';

        if (formEl) {
            formEl.action = contextPath + '/cart';
        }
        if (menuIdInput) menuIdInput.value = id;
        if (resIdInput) resIdInput.value = resId;

        if (submitBtn) {
            submitBtn.disabled = !isAvailable;
            submitBtn.style.opacity = isAvailable ? '1' : '0.5';
            submitBtn.innerText = isAvailable ? 'Add to Cart • ₹' + parseFloat(price).toFixed(2) : 'Currently Sold Out';
        }

        // Qty steppers inside modal
        const decBtn = modal.querySelector('#foodModalDecBtn');
        const incBtn = modal.querySelector('#foodModalIncBtn');

        if (decBtn) {
            decBtn.onclick = function(e) {
                e.preventDefault();
                if (currentQty > 1) {
                    currentQty--;
                    if (qtyInput) qtyInput.value = currentQty;
                    if (qtyDisplay) qtyDisplay.innerText = currentQty;
                    if (submitBtn && isAvailable) {
                        const total = (parseFloat(price) * currentQty).toFixed(2);
                        submitBtn.innerText = 'Add to Cart • ₹' + total;
                    }
                }
            };
        }

        if (incBtn) {
            incBtn.onclick = function(e) {
                e.preventDefault();
                if (currentQty < 20) {
                    currentQty++;
                    if (qtyInput) qtyInput.value = currentQty;
                    if (qtyDisplay) qtyDisplay.innerText = currentQty;
                    if (submitBtn && isAvailable) {
                        const total = (parseFloat(price) * currentQty).toFixed(2);
                        submitBtn.innerText = 'Add to Cart • ₹' + total;
                    }
                }
            };
        }

        openModal('foodDetailModal');
    }

    /**
     * Show Category Detail Modal
     */
    function showCategoryModal(card) {
        const modal = document.getElementById('categoryDetailModal');
        if (!modal) return;

        const name = card.getAttribute('data-name') || 'Cuisine';
        const count = card.getAttribute('data-count') || '50+ options';
        const image = card.getAttribute('data-image') || '';
        const desc = card.getAttribute('data-desc') || 'Explore our handpicked selection of authentic and flavorful dishes.';
        const dishes = card.getAttribute('data-dishes') || 'Bestsellers, Chef Specials, Combo Platters';
        const contextPath = card.getAttribute('data-context-path') || '';

        const imgEl = modal.querySelector('#catModalImg');
        const titleEl = modal.querySelector('#catModalTitle');
        const countEl = modal.querySelector('#catModalCount');
        const descEl = modal.querySelector('#catModalDesc');
        const dishesEl = modal.querySelector('#catModalDishes');
        const exploreBtn = modal.querySelector('#catModalExploreBtn');

        if (imgEl && image) imgEl.src = image;
        if (titleEl) titleEl.innerText = name;
        if (countEl) countEl.innerText = count;
        if (descEl) descEl.innerText = desc;
        if (dishesEl) dishesEl.innerText = dishes;

        if (exploreBtn) {
            exploreBtn.href = contextPath + '/restaurant?cuisine=' + encodeURIComponent(name);
            exploreBtn.innerText = 'Explore All ' + name + ' Restaurants →';
        }

        openModal('categoryDetailModal');
    }

    /**
     * Wire click listeners
     */
    function initGlassDetailListeners() {
        // Close buttons & Backdrop clicks
        document.querySelectorAll('.glass-modal-overlay').forEach(modal => {
            modal.addEventListener('click', function(e) {
                if (e.target === this) {
                    closeModal(this);
                }
            });

            const closeBtn = modal.querySelector('.glass-modal-close-btn');
            if (closeBtn) {
                closeBtn.addEventListener('click', function() {
                    closeModal(modal);
                });
            }
        });

        // Global Escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                const activeModal = document.querySelector('.glass-modal-overlay.active');
                if (activeModal) {
                    closeModal(activeModal);
                }
            }
        });

        // Delegate clicks for restaurant cards (.res-card, .res-list-card)
        document.addEventListener('click', function(e) {
            const resCard = e.target.closest('.res-card, .res-list-card');
            if (resCard) {
                // If user clicked directly on "View Menu" link or fav button, let normal event trigger
                if (e.target.closest('a') || e.target.closest('.res-fav-btn') || e.target.closest('.fav-heart-btn')) {
                    return;
                }
                e.preventDefault();
                showRestaurantModal(resCard);
                return;
            }

            const foodCard = e.target.closest('.food-card');
            if (foodCard) {
                // If user clicked directly inside stepper or submit button, allow regular cart submission
                if (e.target.closest('form') || e.target.closest('button') || e.target.closest('a') || e.target.closest('.quantity-stepper')) {
                    return;
                }
                e.preventDefault();
                showFoodModal(foodCard);
                return;
            }

            const catCard = e.target.closest('.category-card');
            if (catCard && catCard.hasAttribute('data-open-modal')) {
                e.preventDefault();
                showCategoryModal(catCard);
                return;
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initGlassDetailListeners);
    } else {
        initGlassDetailListeners();
    }
})();

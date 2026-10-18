/**
 * ===================================================================
 * FOODIE - CART PAGE SCRIPT (js/cart.js)
 * Clean, modular, beginner-friendly JavaScript
 * Features:
 *   1. LocalStorage Management ('foodieCart')
 *   2. Quantity Controls ([-] 2 [+])
 *   3. Real-Time Item Total & Cart Calculation
 *   4. Cart Count Calculation (Sum of all units)
 *   5. Remove Item with UI & LocalStorage update
 *   6. Dynamic Price Details (Item Total + Delivery Fee - Discount)
 *   7. Coupon Code Engine (FOOD50 for ₹50 discount)
 *   8. Empty Cart State
 *   9. Ready for Checkout Navigation & Java Servlet integration
 * ===================================================================
 */

document.addEventListener('DOMContentLoaded', () => {

    /* ===============================================================
       1. STORAGE KEYS & INITIAL SAMPLE DATA
       The cart uses localStorage with key: 'foodieCart'
       If first time opening without items, seeds the 3 sample items
       =============================================================== */
    const STORAGE_KEY = 'foodieCart';

    // Sample initial items for testing if user has not added anything yet
    const DEFAULT_SAMPLE_ITEMS = [
        {
            id: 1,
            name: "Chicken Biryani",
            price: 250,
            quantity: 2,
            type: "non-veg",
            image: "images/menu/chicken-biryani.jpg",
            description: "Aromatic basmati rice with tender chicken and special spices."
        },
        {
            id: 14,
            name: "Cold Coffee",
            price: 100,
            quantity: 1,
            type: "veg",
            image: "images/menu/cold-coffee.jpg",
            description: "Creamy blended chilled milk and espresso topped with chocolate drizzle."
        },
        {
            id: 11,
            name: "Samosa",
            price: 40,
            quantity: 3,
            type: "veg",
            image: "images/menu/samosa.jpg",
            description: "Flaky golden triangular pastry filled with spiced potato and green peas."
        }
    ];

    // Delivery fee constant
    const DELIVERY_FEE = 40;

    // Coupon state
    let isCouponApplied = false;
    let appliedCouponCode = '';
    const VALID_COUPON = 'FOOD50';
    const COUPON_DISCOUNT = 50;

    // Cart in-memory state
    let cart = [];

    /* ===============================================================
       2. DOM ELEMENT REFERENCES
       =============================================================== */
    const navCartCountEl = document.getElementById('navCartCount');
    const cartItemsHeadingEl = document.getElementById('cartItemsHeading');
    const cartItemsCountBadgeEl = document.getElementById('cartItemsCountBadge');
    const cartItemsContainer = document.getElementById('cartItemsContainer');

    // Layout sections
    const cartMainGrid = document.getElementById('cartMainGrid');
    const emptyCartContainer = document.getElementById('emptyCartContainer');

    // Price Details Summary Elements
    const summaryItemTotalEl = document.getElementById('summaryItemTotal');
    const summaryDeliveryFeeEl = document.getElementById('summaryDeliveryFee');
    const summaryDiscountRowEl = document.getElementById('summaryDiscountRow');
    const summaryDiscountEl = document.getElementById('summaryDiscount');
    const summaryFinalTotalEl = document.getElementById('summaryFinalTotal');

    // Coupon Elements
    const couponInput = document.getElementById('couponInput');
    const btnApplyCoupon = document.getElementById('btnApplyCoupon');
    const couponFeedbackEl = document.getElementById('couponFeedback');

    // Mobile Navbar Elements
    const mobileMenuToggle = document.getElementById('mobileMenuToggle');
    const navLinks = document.getElementById('navLinks');

    // Toast
    const toastNotice = document.getElementById('toastNotice');

    /* ===============================================================
       3. LOAD CART FUNCTION
       Reads cart data from localStorage.
       If empty on first launch, loads sample items for testing.
       =============================================================== */
    function loadCart() {
        const storedCart = localStorage.getItem(STORAGE_KEY);
        const legacyCart = localStorage.getItem('foodie_cart');

        if (storedCart !== null) {
            try {
                cart = JSON.parse(storedCart);
            } catch (e) {
                cart = [];
            }
        } else if (legacyCart !== null) {
            // Read from previous menu.js session if available
            try {
                cart = JSON.parse(legacyCart);
            } catch (e) {
                cart = [];
            }
        } 			else {
			    cart = [];
			}

        // Restore saved coupon if available
        const savedCoupon = localStorage.getItem('foodieCoupon');
        if (savedCoupon) {
            try {
                const parsedCoupon = JSON.parse(savedCoupon);
                if (parsedCoupon && parsedCoupon.code === VALID_COUPON) {
                    isCouponApplied = true;
                    appliedCouponCode = parsedCoupon.code;
                    if (couponInput) couponInput.value = parsedCoupon.code;
                    if (btnApplyCoupon) {
                        btnApplyCoupon.textContent = 'Applied';
                        btnApplyCoupon.style.backgroundColor = 'var(--veg-color)';
                    }
                    showCouponFeedback(`✓ ${parsedCoupon.code} applied! ₹50 discount added.`, true);
                }
            } catch (e) {}
        }
    }

    /* ===============================================================
       4. SAVE CART FUNCTION
       Persists cart array into localStorage and updates count.
       =============================================================== */
    function saveCart() {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(cart));
        // Keep foodie_cart in sync for other pages
        localStorage.setItem('foodie_cart', JSON.stringify(cart));
        updateCartCount();
    }

    /* ===============================================================
       5. CALCULATE ITEM TOTAL
       Formula: Item Total = Price * Quantity
       =============================================================== */
    function calculateItemTotal(price, quantity) {
        return price * quantity;
    }

    /* ===============================================================
       6. UPDATE CART COUNT
       Counts the TOTAL QUANTITY OF ALL ITEMS (e.g. 2 + 1 + 3 = 6).
       =============================================================== */
    function updateCartCount() {
        const totalUnits = cart.reduce((sum, item) => sum + item.quantity, 0);

        if (navCartCountEl) {
            navCartCountEl.textContent = `Cart (${totalUnits})`;
        }
        if (cartItemsHeadingEl) {
            cartItemsHeadingEl.textContent = `Cart Items (${totalUnits})`;
        }
        if (cartItemsCountBadgeEl) {
            cartItemsCountBadgeEl.textContent = `${cart.length} unique dish${cart.length === 1 ? '' : 'es'}, ${totalUnits} total`;
        }
    }

    /* ===============================================================
       7. CALCULATE CART TOTAL
       Calculates Item Total, adds Delivery Fee, subtracts Discount.
       =============================================================== */
    function calculateCartTotal() {
        const itemTotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
        const discountAmount = isCouponApplied ? COUPON_DISCOUNT : 0;
        const finalTotal = Math.max(0, itemTotal + DELIVERY_FEE - discountAmount);

        // Update Price Details card values
        if (summaryItemTotalEl) summaryItemTotalEl.textContent = `₹${itemTotal}`;
        if (summaryDeliveryFeeEl) summaryDeliveryFeeEl.textContent = `₹${DELIVERY_FEE}`;

        if (summaryDiscountRowEl && summaryDiscountEl) {
            if (isCouponApplied) {
                summaryDiscountRowEl.style.display = 'flex';
                summaryDiscountEl.textContent = `-₹${COUPON_DISCOUNT}`;
            } else {
                summaryDiscountRowEl.style.display = 'none';
            }
        }

        if (summaryFinalTotalEl) summaryFinalTotalEl.textContent = `₹${finalTotal}`;
    }

    /* ===============================================================
       8. DISPLAY CART FUNCTION
       Renders the cart cards, or switches to the empty cart view.
       =============================================================== */
    function displayCart() {
        if (!cart || cart.length === 0) {
            // Show empty cart view
            if (cartMainGrid) cartMainGrid.style.display = 'none';
            if (emptyCartContainer) emptyCartContainer.style.display = 'block';
            updateCartCount();
            return;
        }

        // Show cart layout grid
        if (cartMainGrid) cartMainGrid.style.display = 'grid';
        if (emptyCartContainer) emptyCartContainer.style.display = 'none';

        // Clear container
        cartItemsContainer.innerHTML = '';

        // Generate each item card
        cart.forEach((item) => {
            const isVeg = item.type === 'veg';
            const badgeClass = isVeg ? 'veg' : 'non-veg';
            const badgeLabel = isVeg ? '🟢 Veg' : '🔴 Non-Veg';
            const itemTotal = calculateItemTotal(item.price, item.quantity);

            // Default image fallback if needed
            const imagePath = item.image || 'images/menu/chicken-biryani.jpg';
            const desc = item.description || 'Delicious freshly prepared dish from our kitchen.';

            const card = document.createElement('div');
            card.className = 'cart-item-card';
            card.setAttribute('data-id', item.id);

            card.innerHTML = `
                <!-- Food Image -->
                <div class="cart-item-img-wrap">
                    <img 
                        src="${imagePath}" 
                        alt="${item.name}" 
                        class="cart-item-img"
                        loading="lazy"
                        onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80'"
                    >
                </div>

                <!-- Food Details -->
                <div class="cart-item-details">
                    <div class="cart-item-top-row">
                        <h3 class="cart-item-name">${item.name}</h3>
                        <span class="food-type-badge ${badgeClass}">${badgeLabel}</span>
                    </div>

                    <p class="cart-item-desc">${desc}</p>

                    <div class="cart-item-bottom-row">
                        <div class="cart-item-unit-price">₹${item.price}</div>

                        <!-- Quantity Controls [-] Qty [+] -->
                        <div class="quantity-controls-wrap">
                            <button 
                                class="btn-qty btn-decrease" 
                                data-id="${item.id}" 
                                aria-label="Decrease quantity of ${item.name}"
                            >-</button>
                            <span class="qty-display" id="qtyDisplay-${item.id}">${item.quantity}</span>
                            <button 
                                class="btn-qty btn-increase" 
                                data-id="${item.id}" 
                                aria-label="Increase quantity of ${item.name}"
                            >+</button>
                        </div>

                        <!-- Real-time Item Total -->
                        <div class="cart-item-total-price" id="itemTotal-${item.id}">
                            Item Total: ₹${itemTotal}
                        </div>

                        <!-- Remove Button -->
                        <button 
                            class="btn-remove-item" 
                            data-id="${item.id}" 
                            data-name="${item.name}"
                            aria-label="Remove ${item.name} from cart"
                        >
                            🗑 Remove
                        </button>
                    </div>
                </div>
            `;

            cartItemsContainer.appendChild(card);
        });

        // Attach event listeners to quantity controls and remove buttons
        attachItemEventListeners();

        // Calculate totals and update count badge
        calculateCartTotal();
        updateCartCount();
    }

    /* ===============================================================
       9. EVENT LISTENERS FOR ITEM CARDS
       =============================================================== */
    function attachItemEventListeners() {
        // Increase (+) buttons
        const increaseBtns = cartItemsContainer.querySelectorAll('.btn-increase');
        increaseBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const id = parseInt(btn.getAttribute('data-id'), 10);
                increaseQuantity(id);
            });
        });

        // Decrease (-) buttons
        const decreaseBtns = cartItemsContainer.querySelectorAll('.btn-decrease');
        decreaseBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const id = parseInt(btn.getAttribute('data-id'), 10);
                decreaseQuantity(id);
            });
        });

        // Remove (🗑) buttons
        const removeBtns = cartItemsContainer.querySelectorAll('.btn-remove-item');
        removeBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const id = parseInt(btn.getAttribute('data-id'), 10);
                const name = btn.getAttribute('data-name');
                removeFromCart(id, name);
            });
        });
    }

    /* ===============================================================
       10. QUANTITY MANAGEMENT FUNCTIONS
       =============================================================== */

    // Increase Quantity by 1
    function increaseQuantity(id) {
        const item = cart.find(i => i.id === id);
        if (item) {
            item.quantity += 1;
            saveCart();
            updateItemCardDOM(item);
            calculateCartTotal();
        }
    }

    // Decrease Quantity by 1 (Remove if reaches 0)
    function decreaseQuantity(id) {
        const itemIndex = cart.findIndex(i => i.id === id);
        if (itemIndex > -1) {
            const item = cart[itemIndex];
            item.quantity -= 1;

            if (item.quantity <= 0) {
                // Quantity reached 0 -> Remove item
                const itemName = item.name;
                cart.splice(itemIndex, 1);
                saveCart();
                displayCart();
                showToast(`Removed "${itemName}" from cart`);
            } else {
                saveCart();
                updateItemCardDOM(item);
                calculateCartTotal();
            }
        }
    }

    // Fast DOM update for single item without re-rendering entire list
    function updateItemCardDOM(item) {
        const qtyDisplay = document.getElementById(`qtyDisplay-${item.id}`);
        const itemTotalDisplay = document.getElementById(`itemTotal-${item.id}`);

        if (qtyDisplay) {
            qtyDisplay.textContent = item.quantity;
            // Subtle bounce animation
            qtyDisplay.animate([
                { transform: 'scale(1.3)' },
                { transform: 'scale(1)' }
            ], { duration: 180 });
        }

        if (itemTotalDisplay) {
            itemTotalDisplay.textContent = `Item Total: ₹${calculateItemTotal(item.price, item.quantity)}`;
        }

        updateCartCount();
    }

    /* ===============================================================
       11. REMOVE FROM CART FUNCTION
       Removes item by ID, updates localStorage, count, and totals.
       =============================================================== */
    function removeFromCart(id, name = '') {
        const itemIndex = cart.findIndex(i => i.id === id);
        if (itemIndex > -1) {
            const removedName = name || cart[itemIndex].name;
            cart.splice(itemIndex, 1);
            saveCart();
            displayCart();
            showToast(`Removed "${removedName}" from cart`);
        }
    }

    /* ===============================================================
       12. APPLY COUPON FUNCTION
       Sample code: 'FOOD50' gives ₹50 discount.
       Validates code, avoids double application, and recalculates total.
       =============================================================== */
    function applyCoupon() {
        if (!couponInput) return;

        const code = couponInput.value.trim().toUpperCase();

        if (!code) {
            showCouponFeedback('Please enter a coupon code.', false);
            return;
        }

        if (isCouponApplied) {
            showCouponFeedback(`Coupon "${appliedCouponCode}" is already applied!`, true);
            return;
        }

        if (code === VALID_COUPON) {
            isCouponApplied = true;
            appliedCouponCode = VALID_COUPON;
            localStorage.setItem('foodieCoupon', JSON.stringify({ code: VALID_COUPON, discount: COUPON_DISCOUNT }));
            showCouponFeedback(`✓ ${VALID_COUPON} applied! ₹50 discount added.`, true);
            showToast(`Coupon applied! Saved ₹50 🎟`);
            btnApplyCoupon.textContent = 'Applied';
            btnApplyCoupon.style.backgroundColor = 'var(--veg-color)';
            calculateCartTotal();
        } else {
            showCouponFeedback('Invalid coupon code. Try using "FOOD50".', false);
        }
    }

    function showCouponFeedback(message, isSuccess) {
        if (!couponFeedbackEl) return;
        couponFeedbackEl.textContent = message;
        couponFeedbackEl.className = 'coupon-feedback ' + (isSuccess ? 'success' : 'error');
    }

    if (btnApplyCoupon) {
        btnApplyCoupon.addEventListener('click', applyCoupon);
    }
    if (couponInput) {
        couponInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') applyCoupon();
        });
    }

    /* ===============================================================
       13. FLOATING TOAST HELPER
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

    /* ===============================================================
       14. MOBILE MENU TOGGLE
       =============================================================== */
    if (mobileMenuToggle && navLinks) {
        mobileMenuToggle.addEventListener('click', () => {
            navLinks.classList.toggle('show-mobile');
        });
    }

    /* ===============================================================
       15. INITIALIZE CART PAGE
       =============================================================== */
    loadCart();
    displayCart();
});


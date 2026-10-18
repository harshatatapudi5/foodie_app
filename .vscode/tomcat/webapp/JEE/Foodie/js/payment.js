/**
 * ===================================================================
 * FOODIE - PAYMENT / CHECKOUT SCRIPT (js/payment.js)
 * Clean, beginner-friendly client-side checkout logic
 * Features:
 *   1. Load Cart from localStorage ('foodieCart')
 *   2. Dynamic Order Summary & Price Calculation
 *   3. Coupon Discount Inheritance from Cart ('foodieCoupon')
 *   4. Address Form Validation & LocalStorage Persistence ('foodieAddress')
 *   5. Interactive Payment Method Selection (UPI, Card, COD)
 *   6. Order ID Generation & Storage ('foodieOrders')
 *   7. Cart Cleanup after Order
 *   8. Order Success Modal Display
 * ===================================================================
 */

document.addEventListener('DOMContentLoaded', () => {

    /* ===============================================================
       1. CONSTANTS & STATE
       =============================================================== */
    const STORAGE_KEY_CART = 'foodieCart';
    const STORAGE_KEY_COUPON = 'foodieCoupon';
    const STORAGE_KEY_ADDRESS = 'foodieAddress';
    const STORAGE_KEY_ORDERS = 'foodieOrders';

    const DELIVERY_FEE = 40;

    let cart = [];
    let coupon = null;
    let itemTotal = 0;
    let discountAmount = 0;
    let finalTotal = 0;

    /* ===============================================================
       2. DOM ELEMENTS
       =============================================================== */
    // Navbar
    const navCartCountEl = document.getElementById('navCartCount');
    const mobileMenuToggle = document.getElementById('mobileMenuToggle');
    const navLinks = document.getElementById('navLinks');

    // Layout containers
    const checkoutMainGrid = document.getElementById('checkoutMainGrid');
    const emptyCheckoutView = document.getElementById('emptyCheckoutView');

    // Order Summary Elements
    const orderItemsContainer = document.getElementById('orderItemsContainer');
    const orderItemsCountBadge = document.getElementById('orderItemsCountBadge');

    // Price Details Elements
    const summaryItemTotalEl = document.getElementById('summaryItemTotal');
    const summaryDeliveryFeeEl = document.getElementById('summaryDeliveryFee');
    const summaryDiscountRowEl = document.getElementById('summaryDiscountRow');
    const summaryDiscountEl = document.getElementById('summaryDiscount');
    const summaryDiscountCodeEl = document.getElementById('summaryDiscountCode');
    const summaryFinalTotalEl = document.getElementById('summaryFinalTotal');

    // Address Form Inputs
    const inputFullName = document.getElementById('inputFullName');
    const inputPhone = document.getElementById('inputPhone');
    const inputAddress = document.getElementById('inputAddress');
    const selectCity = document.getElementById('selectCity');
    const inputPincode = document.getElementById('inputPincode');
    const checkboxSaveAddress = document.getElementById('checkboxSaveAddress');

    // Field Error Elements
    const errorFullName = document.getElementById('errorFullName');
    const errorPhone = document.getElementById('errorPhone');
    const errorAddress = document.getElementById('errorAddress');
    const errorCity = document.getElementById('errorCity');
    const errorPincode = document.getElementById('errorPincode');
    const errorPayment = document.getElementById('errorPayment');

    // Payment Options & Radio Buttons
    const paymentOptions = document.querySelectorAll('.payment-option');
    const paymentRadios = document.querySelectorAll('input[name="payment"]');

    // Action Buttons & Modals
    const btnPlaceOrder = document.getElementById('btnPlaceOrder');
    const orderSuccessModal = document.getElementById('orderSuccessModal');
    const successOrderIdEl = document.getElementById('successOrderId');

    /* ===============================================================
       3. LOAD CART FUNCTION
       Reads cart data from localStorage.
       =============================================================== */
    function loadCart() {
        const storedCart = localStorage.getItem(STORAGE_KEY_CART);
        if (storedCart) {
            try {
                cart = JSON.parse(storedCart);
            } catch (e) {
                cart = [];
            }
        } else {
            cart = [];
        }

        // Update Navbar cart count (sum of all quantities)
        const totalUnits = cart.reduce((sum, item) => sum + item.quantity, 0);
        if (navCartCountEl) {
            navCartCountEl.textContent = `Cart (${totalUnits})`;
        }
    }

    /* ===============================================================
       4. LOAD COUPON FUNCTION
       Reads any coupon applied from the Cart page.
       =============================================================== */
    function loadCoupon() {
        const storedCoupon = localStorage.getItem(STORAGE_KEY_COUPON);
        if (storedCoupon) {
            try {
                coupon = JSON.parse(storedCoupon);
                discountAmount = coupon.discount || 0;
            } catch (e) {
                coupon = null;
                discountAmount = 0;
            }
        } else {
            coupon = null;
            discountAmount = 0;
        }
    }

    /* ===============================================================
       5. CALCULATE TOTALS FUNCTION
       Item Total = Sum(Price * Quantity)
       Final Total = Item Total + Delivery Fee - Discount
       =============================================================== */
    function calculateTotals() {
        itemTotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
        finalTotal = Math.max(0, itemTotal + DELIVERY_FEE - discountAmount);

        // Update Price Details UI
        if (summaryItemTotalEl) summaryItemTotalEl.textContent = `₹${itemTotal}`;
        if (summaryDeliveryFeeEl) summaryDeliveryFeeEl.textContent = `₹${DELIVERY_FEE}`;

        // Show/hide discount row
        if (summaryDiscountRowEl) {
            if (discountAmount > 0 && coupon) {
                summaryDiscountRowEl.style.display = 'flex';
                if (summaryDiscountEl) summaryDiscountEl.textContent = `-₹${discountAmount}`;
                if (summaryDiscountCodeEl) summaryDiscountCodeEl.textContent = coupon.code;
            } else {
                summaryDiscountRowEl.style.display = 'none';
            }
        }

        if (summaryFinalTotalEl) summaryFinalTotalEl.textContent = `₹${finalTotal}`;
    }

    /* ===============================================================
       6. DISPLAY ORDER SUMMARY FUNCTION
       Renders the items from the cart dynamically.
       =============================================================== */
    function displayOrderSummary() {
        if (!cart || cart.length === 0) {
            // Cart is empty -> show empty view
            if (checkoutMainGrid) checkoutMainGrid.style.display = 'none';
            if (emptyCheckoutView) emptyCheckoutView.style.display = 'block';
            return;
        }

        if (checkoutMainGrid) checkoutMainGrid.style.display = 'grid';
        if (emptyCheckoutView) emptyCheckoutView.style.display = 'none';

        // Clear existing items
        orderItemsContainer.innerHTML = '';

        const totalUnits = cart.reduce((sum, item) => sum + item.quantity, 0);
        if (orderItemsCountBadge) {
            orderItemsCountBadge.textContent = `${totalUnits} item${totalUnits === 1 ? '' : 's'}`;
        }

        cart.forEach(item => {
            const isVeg = item.type === 'veg';
            const badgeClass = isVeg ? 'veg' : 'non-veg';
            const badgeLabel = isVeg ? '🟢 Veg' : '🔴 Non-Veg';
            const itemTotalCost = item.price * item.quantity;
            const imgPath = item.image || 'images/menu/chicken-biryani.jpg';

            const row = document.createElement('div');
            row.className = 'order-item-row';
            row.innerHTML = `
                <div class="order-item-left">
                    <div class="order-item-thumb">
                        <img 
                            src="${imgPath}" 
                            alt="${item.name}"
                            loading="lazy"
                            onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200&q=80'"
                        >
                    </div>
                    <div class="order-item-info">
                        <div class="order-item-title-row">
                            <span>${item.name}</span>
                            <span class="food-type-badge ${badgeClass}" style="font-size: 10px; padding: 1px 6px;">${badgeLabel}</span>
                        </div>
                        <span class="order-item-calc">₹${item.price} × ${item.quantity}</span>
                    </div>
                </div>
                <div class="order-item-total">
                    ₹${itemTotalCost}
                </div>
            `;
            orderItemsContainer.appendChild(row);
        });

        calculateTotals();
    }

    /* ===============================================================
       7. PAYMENT METHOD SELECTION UI
       Toggles highlight on selected payment card.
       =============================================================== */
    paymentOptions.forEach(card => {
        card.addEventListener('click', () => {
            const radio = card.querySelector('input[name="payment"]');
            if (radio) {
                radio.checked = true;
                updatePaymentSelectionUI();
                clearFieldError(errorPayment);
            }
        });
    });

    paymentRadios.forEach(radio => {
        radio.addEventListener('change', () => {
            updatePaymentSelectionUI();
            clearFieldError(errorPayment);
        });
    });

    function updatePaymentSelectionUI() {
        paymentOptions.forEach(card => {
            const radio = card.querySelector('input[name="payment"]');
            if (radio && radio.checked) {
                card.classList.add('selected');
            } else {
                card.classList.remove('selected');
            }
        });
    }

    /* ===============================================================
       8. SAVED ADDRESS RESTORE & PERSISTENCE
       If user previously saved an address, restore it into form.
       =============================================================== */
    function loadSavedAddress() {
        const savedAddressJSON = localStorage.getItem(STORAGE_KEY_ADDRESS);
        if (savedAddressJSON) {
            try {
                const addr = JSON.parse(savedAddressJSON);
                if (inputFullName && addr.fullName) inputFullName.value = addr.fullName;
                if (inputPhone && addr.phone) inputPhone.value = addr.phone;
                if (inputAddress && addr.address) inputAddress.value = addr.address;
                if (selectCity && addr.city) selectCity.value = addr.city;
                if (inputPincode && addr.pincode) inputPincode.value = addr.pincode;
                if (checkboxSaveAddress) checkboxSaveAddress.checked = true;
            } catch (e) {}
        }
    }

    function saveAddressIfRequested() {
        if (checkboxSaveAddress && checkboxSaveAddress.checked) {
            const addressObj = {
                fullName: inputFullName.value.trim(),
                phone: inputPhone.value.trim(),
                address: inputAddress.value.trim(),
                city: selectCity.value,
                pincode: inputPincode.value.trim()
            };
            localStorage.setItem(STORAGE_KEY_ADDRESS, JSON.stringify(addressObj));
        }
    }

    /* ===============================================================
       9. FORM VALIDATION
       Validates Full Name, Phone, Address, City, Pincode & Payment.
       =============================================================== */
    function showFieldError(inputEl, errorEl, message) {
        if (inputEl) inputEl.classList.add('has-error');
        if (errorEl) {
            errorEl.textContent = message;
            errorEl.classList.add('visible');
        }
    }

    function clearFieldError(errorEl, inputEl = null) {
        if (inputEl) inputEl.classList.remove('has-error');
        if (errorEl) {
            errorEl.textContent = '';
            errorEl.classList.remove('visible');
        }
    }

    // Live validation error clearing on input
    [inputFullName, inputPhone, inputAddress, selectCity, inputPincode].forEach(input => {
        if (input) {
            input.addEventListener('input', () => {
                input.classList.remove('has-error');
                const err = input.parentElement.querySelector('.field-error-text');
                if (err) clearFieldError(err, input);
            });
        }
    });

    function validateForm() {
        let isValid = true;

        // 1. Full Name
        const nameVal = inputFullName.value.trim();
        if (!nameVal) {
            showFieldError(inputFullName, errorFullName, 'Please enter your full name.');
            isValid = false;
        } else if (nameVal.length < 3) {
            showFieldError(inputFullName, errorFullName, 'Full name must be at least 3 characters.');
            isValid = false;
        } else {
            clearFieldError(errorFullName, inputFullName);
        }

        // 2. Phone Number (Indian 10-digit mobile starting with 6-9)
        const phoneVal = inputPhone.value.trim().replace(/[\s\-()]/g, '').replace(/^(\+91|0)/, '');
        const phoneRegex = /^[6-9]\d{9}$/;
        if (!phoneVal) {
            showFieldError(inputPhone, errorPhone, 'Please enter your phone number.');
            isValid = false;
        } else if (!phoneRegex.test(phoneVal)) {
            showFieldError(inputPhone, errorPhone, 'Please enter a valid 10-digit Indian mobile number.');
            isValid = false;
        } else {
            clearFieldError(errorPhone, inputPhone);
        }

        // 3. Address
        const addressVal = inputAddress.value.trim();
        if (!addressVal) {
            showFieldError(inputAddress, errorAddress, 'Please enter your complete delivery address.');
            isValid = false;
        } else if (addressVal.length < 8) {
            showFieldError(inputAddress, errorAddress, 'Address is too short. Include street and house/flat details.');
            isValid = false;
        } else {
            clearFieldError(errorAddress, inputAddress);
        }

        // 4. City
        const cityVal = selectCity.value;
        if (!cityVal) {
            showFieldError(selectCity, errorCity, 'Please select your city.');
            isValid = false;
        } else {
            clearFieldError(errorCity, selectCity);
        }

        // 5. Pincode (6-digit Indian PIN)
        const pinVal = inputPincode.value.trim();
        const pinRegex = /^[1-9][0-9]{5}$/;
        if (!pinVal) {
            showFieldError(inputPincode, errorPincode, 'Please enter your pincode.');
            isValid = false;
        } else if (!pinRegex.test(pinVal)) {
            showFieldError(inputPincode, errorPincode, 'Enter a valid 6-digit Indian pincode (e.g. 560001).');
            isValid = false;
        } else {
            clearFieldError(errorPincode, inputPincode);
        }

        // 6. Payment Method Validation
        const selectedPayment = validatePayment();
        if (!selectedPayment) {
            showFieldError(null, errorPayment, 'Please select a payment method.');
            isValid = false;
        } else {
            clearFieldError(errorPayment);
        }

        return isValid;
    }

    function validatePayment() {
        const checkedRadio = document.querySelector('input[name="payment"]:checked');
        return checkedRadio ? checkedRadio.value : null;
    }

    /* ===============================================================
       10. ORDER ID GENERATOR & SAVE ORDER
       Generates dynamic ID e.g. "FD10245"
       =============================================================== */
    function generateOrderId() {
        return "FD" + Math.floor(10000 + Math.random() * 90000);
    }

    function saveOrder(orderData) {
        const orders = JSON.parse(localStorage.getItem(STORAGE_KEY_ORDERS) || '[]');
        orders.unshift(orderData); // Add new order at the top
        localStorage.setItem(STORAGE_KEY_ORDERS, JSON.stringify(orders));
    }

    function clearCart() {
        localStorage.removeItem(STORAGE_KEY_CART);
        localStorage.removeItem('foodie_cart');
        localStorage.removeItem(STORAGE_KEY_COUPON);
        cart = [];
        if (navCartCountEl) {
            navCartCountEl.textContent = 'Cart (0)';
        }
    }

    /* ===============================================================
       11. PLACE ORDER FUNCTION
       =============================================================== */
    function placeOrder() {
        // First check: Is cart empty?
        if (!cart || cart.length === 0) {
            alert("Your cart is empty. Please add some food before placing an order.");
            return;
        }

        // Validate required fields and payment method
        const isFormValid = validateForm();
        if (!isFormValid) {
            // Scroll smoothly to first invalid field
            const firstError = document.querySelector('.form-control.has-error');
            if (firstError) {
                firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                firstError.focus();
            }
            return;
        }

        // Collect payment method readable title
        const paymentType = validatePayment();
        let paymentLabel = "UPI";
        if (paymentType === 'card') paymentLabel = "Credit / Debit Card";
        else if (paymentType === 'cod') paymentLabel = "Cash on Delivery";

        // Generate dynamic unique order ID
        const orderId = generateOrderId();

        // Construct full order object
        const orderData = {
            orderId: orderId,
            restaurantName: "Spice Garden",
            customerName: inputFullName.value.trim(),
            phone: inputPhone.value.trim(),
            address: inputAddress.value.trim(),
            city: selectCity.value,
            pincode: inputPincode.value.trim(),
            paymentMethod: paymentLabel,
            items: [...cart],
            itemTotal: itemTotal,
            deliveryFee: DELIVERY_FEE,
            discount: discountAmount,
            finalTotal: finalTotal,
            orderDate: new Date().toISOString(),
            status: "Placed"
        };

        console.log("Order Placed Successfully:", orderData);

        // Save order data to localStorage
        saveOrder(orderData);

        // Save address if user checked the checkbox
        saveAddressIfRequested();

        // Clear cart & coupon from localStorage
        clearCart();

        // Display order success modal
        showOrderSuccessModal(orderId);
    }

    function showOrderSuccessModal(orderId) {
        if (successOrderIdEl) {
            successOrderIdEl.textContent = `Order ID: ${orderId}`;
        }
        if (orderSuccessModal) {
            orderSuccessModal.classList.add('active');
        }
    }

    if (btnPlaceOrder) {
        btnPlaceOrder.addEventListener('click', (e) => {
            e.preventDefault();
            placeOrder();
        });
    }

    /* ===============================================================
       12. MOBILE MENU TOGGLE
       =============================================================== */
    if (mobileMenuToggle && navLinks) {
        mobileMenuToggle.addEventListener('click', () => {
            navLinks.classList.toggle('show-mobile');
        });
    }

    /* ===============================================================
       13. INITIALIZE CHECKOUT PAGE
       =============================================================== */
    loadCart();
    loadCoupon();
    displayOrderSummary();
    loadSavedAddress();
    updatePaymentSelectionUI();
});


/* ==========================================================================
   FOODIE - ORDERS PAGE JAVASCRIPT (js/orders.js)
   Full client-side order history, status filtering, search, sorting,
   live 5-step tracking simulation, view details modal, and 1-click reorder.
   ========================================================================== */

document.addEventListener('DOMContentLoaded', () => {
    'use strict';

    // LocalStorage Keys
    const STORAGE_KEY_ORDERS = 'foodieOrders';
    const STORAGE_KEY_CART = 'foodieCart';
    const STORAGE_KEY_CART_ALT = 'foodie_cart';

    // DOM Elements
    const ordersListContainer = document.getElementById('ordersListContainer');
    const totalOrdersCountEl = document.getElementById('totalOrdersCount');
    const activeOrdersCountEl = document.getElementById('activeOrdersCount');
    const deliveredOrdersCountEl = document.getElementById('deliveredOrdersCount');
    const orderSearchInput = document.getElementById('orderSearchInput');
    const orderSortSelect = document.getElementById('orderSortSelect');
    const filterPills = document.querySelectorAll('.btn-filter-pill');
    const navCartCountText = document.getElementById('navCartCountText');
    const mobileMenuToggle = document.getElementById('mobileMenuToggle');
    const navLinks = document.getElementById('navLinks');

    // Modals
    const orderDetailsModal = document.getElementById('orderDetailsModal');
    const detailsModalTitle = document.getElementById('detailsModalTitle');
    const detailsModalBody = document.getElementById('detailsModalBody');
    const btnCloseDetailsModal = document.getElementById('btnCloseDetailsModal');

    const orderTrackModal = document.getElementById('orderTrackModal');
    const trackModalTitle = document.getElementById('trackModalTitle');
    const trackModalBody = document.getElementById('trackModalBody');
    const btnCloseTrackModal = document.getElementById('btnCloseTrackModal');

    // Toast
    const toastNotice = document.getElementById('toastNotice');
    const toastIcon = document.getElementById('toastIcon');
    const toastMessage = document.getElementById('toastMessage');

    // State Variables
    let currentFilter = 'all';
    let currentSearch = '';
    let currentSort = 'newest';
    let allOrders = [];

    /* ==========================================================================
       1. SEED INITIAL SAMPLE ORDERS (If localStorage is empty)
       ========================================================================== */
    function seedSampleOrdersIfEmpty() {
        const existingData = localStorage.getItem(STORAGE_KEY_ORDERS);
        if (existingData) {
            try {
                const parsed = JSON.parse(existingData);
                if (Array.isArray(parsed) && parsed.length > 0) {
                    return parsed;
                }
            } catch (err) {
                console.error("Error parsing stored orders:", err);
            }
        }

        // Realistic seed orders for a rich first impression
        const now = new Date();
        const twoHoursAgo = new Date(now.getTime() - (2 * 60 * 60 * 1000)).toISOString();
        const thirtyMinsAgo = new Date(now.getTime() - (30 * 60 * 1000)).toISOString();
        const fifteenMinsAgo = new Date(now.getTime() - (15 * 60 * 1000)).toISOString();

        const sampleOrders = [
            {
                orderId: "FD-96105",
                restaurantName: "Burger Hub",
                customerName: "Rahul Sharma",
                phone: "9876543210",
                address: "Flat 402, Green Valley Apartments, Road No. 12, Banjara Hills",
                city: "Hyderabad",
                pincode: "500034",
                paymentMethod: "UPI",
                items: [
                    {
                        id: 7,
                        name: "Crispy Veg Burger",
                        price: 120,
                        quantity: 2,
                        image: "images/menu/crispy-veg-burger.jpg",
                        isVeg: true
                    },
                    {
                        id: 9,
                        name: "French Fries",
                        price: 90,
                        quantity: 1,
                        image: "images/menu/french-fries.jpg",
                        isVeg: true
                    }
                ],
                itemTotal: 330,
                deliveryFee: 40,
                discount: 30,
                finalTotal: 340,
                orderDate: fifteenMinsAgo,
                status: "Out for Delivery"
            },
            {
                orderId: "FD-94812",
                restaurantName: "Tandoori House",
                customerName: "Rahul Sharma",
                phone: "9876543210",
                address: "Flat 402, Green Valley Apartments, Road No. 12, Banjara Hills",
                city: "Hyderabad",
                pincode: "500034",
                paymentMethod: "Credit / Debit Card",
                items: [
                    {
                        id: 3,
                        name: "Paneer Butter Masala",
                        price: 220,
                        quantity: 1,
                        image: "images/menu/paneer-butter-masala.jpg",
                        isVeg: true
                    },
                    {
                        id: 5,
                        name: "Butter Naan",
                        price: 45,
                        quantity: 3,
                        image: "images/menu/butter-naan.jpg",
                        isVeg: true
                    }
                ],
                itemTotal: 355,
                deliveryFee: 40,
                discount: 0,
                finalTotal: 395,
                orderDate: thirtyMinsAgo,
                status: "Preparing"
            },
            {
                orderId: "FD-92041",
                restaurantName: "Spice Garden",
                customerName: "Rahul Sharma",
                phone: "9876543210",
                address: "Flat 402, Green Valley Apartments, Road No. 12, Banjara Hills",
                city: "Hyderabad",
                pincode: "500034",
                paymentMethod: "UPI",
                items: [
                    {
                        id: 1,
                        name: "Chicken Biryani",
                        price: 250,
                        quantity: 2,
                        image: "images/menu/chicken-biryani.jpg",
                        isVeg: false
                    },
                    {
                        id: 11,
                        name: "Samosa",
                        price: 40,
                        quantity: 2,
                        image: "images/menu/samosa.jpg",
                        isVeg: true
                    },
                    {
                        id: 14,
                        name: "Cold Coffee",
                        price: 100,
                        quantity: 1,
                        image: "images/menu/cold-coffee.jpg",
                        isVeg: true
                    }
                ],
                itemTotal: 680,
                deliveryFee: 40,
                discount: 50,
                finalTotal: 670,
                orderDate: twoHoursAgo,
                status: "Delivered"
            }
        ];

        localStorage.setItem(STORAGE_KEY_ORDERS, JSON.stringify(sampleOrders));
        return sampleOrders;
    }

    /* ==========================================================================
       2. LOAD ORDERS & UPDATE STATS
       ========================================================================== */
    function loadOrders() {
        allOrders = seedSampleOrdersIfEmpty();
        updateOrderSummary();
        displayOrders();
        updateNavCartCount();
    }

    function updateNavCartCount() {
        const rawCart = localStorage.getItem(STORAGE_KEY_CART) || localStorage.getItem(STORAGE_KEY_CART_ALT);
        let count = 0;
        if (rawCart) {
            try {
                const parsed = JSON.parse(rawCart);
                if (Array.isArray(parsed)) {
                    count = parsed.reduce((acc, item) => acc + (Number(item.quantity) || 1), 0);
                }
            } catch (err) {
                console.error("Error reading cart count:", err);
            }
        }
        if (navCartCountText) {
            navCartCountText.textContent = `Cart (${count})`;
        }
    }

    function updateOrderSummary() {
        const total = allOrders.length;
        const active = allOrders.filter(order => {
            const st = (order.status || '').toLowerCase();
            return st === 'placed' || st === 'preparing' || st === 'out for delivery';
        }).length;
        const delivered = allOrders.filter(order => {
            const st = (order.status || '').toLowerCase();
            return st === 'delivered';
        }).length;

        if (totalOrdersCountEl) totalOrdersCountEl.textContent = total;
        if (activeOrdersCountEl) activeOrdersCountEl.textContent = active;
        if (deliveredOrdersCountEl) deliveredOrdersCountEl.textContent = delivered;
    }

    /* ==========================================================================
       3. FILTER, SEARCH & SORT LOGIC
       ========================================================================== */
    function getFilteredAndSortedOrders() {
        let result = [...allOrders];

        // Status Filter
        if (currentFilter !== 'all') {
            result = result.filter(order => {
                const orderStatus = (order.status || '').toLowerCase().trim();
                return orderStatus === currentFilter.toLowerCase().trim();
            });
        }

        // Search Query (matches Order ID, Restaurant Name, or Dish Name)
        if (currentSearch.trim() !== '') {
            const q = currentSearch.toLowerCase().trim();
            result = result.filter(order => {
                const idMatch = (order.orderId || '').toLowerCase().includes(q);
                const restMatch = (order.restaurantName || '').toLowerCase().includes(q);
                const itemMatch = Array.isArray(order.items) && order.items.some(item => 
                    (item.name || '').toLowerCase().includes(q)
                );
                return idMatch || restMatch || itemMatch;
            });
        }

        // Sorting
        result.sort((a, b) => {
            const dateA = new Date(a.orderDate).getTime() || 0;
            const dateB = new Date(b.orderDate).getTime() || 0;
            const amountA = Number(a.finalTotal) || 0;
            const amountB = Number(b.finalTotal) || 0;

            switch (currentSort) {
                case 'oldest':
                    return dateA - dateB;
                case 'highest':
                    return amountB - amountA;
                case 'lowest':
                    return amountA - amountB;
                case 'newest':
                default:
                    return dateB - dateA;
            }
        });

        return result;
    }

    /* ==========================================================================
       4. FORMATTING UTILITIES
       ========================================================================== */
    function formatOrderDate(isoString) {
        if (!isoString) return 'Recent';
        try {
            const date = new Date(isoString);
            return date.toLocaleDateString('en-IN', {
                day: 'numeric',
                month: 'short',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
            });
        } catch (e) {
            return isoString;
        }
    }

    function getStatusBadgeMarkup(status) {
        const s = (status || 'Placed').trim();
        const lower = s.toLowerCase();
        let badgeClass = 'placed';
        let icon = '⏱️';

        if (lower === 'placed') {
            badgeClass = 'placed';
            icon = '⏱️';
        } else if (lower === 'preparing') {
            badgeClass = 'preparing';
            icon = '👨‍🍳';
        } else if (lower === 'out for delivery' || lower === 'out-for-delivery') {
            badgeClass = 'out-for-delivery';
            icon = '🛵';
        } else if (lower === 'delivered') {
            badgeClass = 'delivered';
            icon = '✅';
        } else if (lower === 'cancelled') {
            badgeClass = 'cancelled';
            icon = '✕';
        }

        return `<span class="status-badge ${badgeClass}">${icon} ${s}</span>`;
    }

    /* ==========================================================================
       5. DISPLAY ORDERS (RENDER CARDS OR EMPTY STATE)
       ========================================================================== */
    function displayOrders() {
        const filtered = getFilteredAndSortedOrders();

        if (filtered.length === 0) {
            showEmptyOrders(allOrders.length > 0);
            return;
        }

        let html = '';
        filtered.forEach(order => {
            const orderId = order.orderId || 'FD-00000';
            const restaurant = order.restaurantName || 'Spice Garden';
            const formattedDate = formatOrderDate(order.orderDate);
            const statusBadge = getStatusBadgeMarkup(order.status);
            const statusLower = (order.status || '').toLowerCase().trim();
            const isActive = ['placed', 'preparing', 'out for delivery'].includes(statusLower);
            const isDelivered = statusLower === 'delivered';

            // Items HTML preview (show up to 3 items)
            let itemsHtml = '';
            const items = Array.isArray(order.items) ? order.items : [];
            const displayItems = items.slice(0, 3);

            displayItems.forEach(item => {
                const itemTotal = (Number(item.price) || 0) * (Number(item.quantity) || 1);
                const imgSrc = item.image || 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=120&q=80';

                itemsHtml += `
                    <div class="order-dish-row">
                        <div class="order-dish-left">
                            <div class="order-dish-thumb">
                                <img src="${imgSrc}" alt="${item.name}" loading="lazy" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=120&q=80'">
                            </div>
                            <div class="order-dish-name-qty">
                                ${item.quantity} × ${item.name}
                            </div>
                        </div>
                        <div class="order-dish-price">₹${itemTotal}</div>
                    </div>
                `;
            });

            if (items.length > 3) {
                itemsHtml += `
                    <div style="font-size: 13px; color: var(--text-muted); padding-left: 60px; font-weight: 500;">
                        + ${items.length - 3} more item${items.length - 3 > 1 ? 's' : ''}
                    </div>
                `;
            }

            // Contextual action buttons
            let actionButtons = `
                <button class="btn-order-action btn-view-details" onclick="window.FoodieOrders.viewOrderDetails('${orderId}')">
                    📄 View Details
                </button>
            `;

            if (isActive) {
                actionButtons += `
                    <button class="btn-order-action btn-track-order" onclick="window.FoodieOrders.trackOrder('${orderId}')">
                        🛵 Track Order
                    </button>
                `;
            } else if (isDelivered) {
                actionButtons += `
                    <button class="btn-order-action btn-reorder" onclick="window.FoodieOrders.reorder('${orderId}')">
                        🔄 Reorder
                    </button>
                `;
            }

            const addressSnippet = order.address ? `📍 ${order.address.substring(0, 45)}${order.address.length > 45 ? '...' : ''}` : '📍 Home Delivery';

            html += `
                <article class="order-card" data-order-id="${orderId}">
                    <!-- Card Header -->
                    <div class="order-card-header">
                        <div>
                            <div class="order-card-id-row">
                                <span class="order-card-id">#${orderId}</span>
                                <span class="order-card-restaurant">${restaurant}</span>
                            </div>
                            <div class="order-card-date">Placed on ${formattedDate}</div>
                        </div>
                        <div>
                            ${statusBadge}
                        </div>
                    </div>

                    <!-- Card Items -->
                    <div class="order-card-items-list">
                        ${itemsHtml}
                    </div>

                    <!-- Card Footer -->
                    <div class="order-card-footer">
                        <div class="order-total-block">
                            <div class="order-total-paid">Total: ₹${order.finalTotal || order.itemTotal || 0}</div>
                            <div class="order-address-snippet">${addressSnippet}</div>
                        </div>
                        <div class="order-actions-group">
                            ${actionButtons}
                        </div>
                    </div>
                </article>
            `;
        });

        ordersListContainer.innerHTML = html;
    }

    function showEmptyOrders(hasFilteredResults) {
        if (hasFilteredResults) {
            ordersListContainer.innerHTML = `
                <div class="empty-orders-view">
                    <div class="empty-orders-icon">🔍</div>
                    <h3 class="empty-orders-title">No orders match your criteria</h3>
                    <p class="empty-orders-subtext">We couldn't find any orders matching "${currentSearch || currentFilter}". Try clearing your filters or search term.</p>
                    <button class="btn-browse-restaurants" onclick="window.FoodieOrders.resetFilters()">
                        Reset Filters
                    </button>
                </div>
            `;
        } else {
            ordersListContainer.innerHTML = `
                <div class="empty-orders-view">
                    <div class="empty-orders-icon">📦</div>
                    <h3 class="empty-orders-title">No orders placed yet</h3>
                    <p class="empty-orders-subtext">Looks like you haven't indulged in any delicious meals yet. Explore our freshly curated menu and treat yourself!</p>
                    <a href="menu.html" class="btn-browse-restaurants">
                        🍴 Explore Menu
                    </a>
                </div>
            `;
        }
    }

    /* ==========================================================================
       6. VIEW ORDER DETAILS MODAL
       ========================================================================== */
    function viewOrderDetails(orderId) {
        const order = allOrders.find(o => o.orderId === orderId);
        if (!order) {
            showToast("Order not found!", "error");
            return;
        }

        detailsModalTitle.textContent = `Order Details #${order.orderId}`;

        const statusBadge = getStatusBadgeMarkup(order.status);
        const formattedDate = formatOrderDate(order.orderDate);
        const items = Array.isArray(order.items) ? order.items : [];

        let itemsMarkup = '';
        items.forEach(item => {
            const itemCost = (Number(item.price) || 0) * (Number(item.quantity) || 1);
            const imgSrc = item.image || 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=120&q=80';
            itemsMarkup += `
                <div class="detail-item-row">
                    <div class="detail-item-left">
                        <img src="${imgSrc}" alt="${item.name}" class="detail-item-img" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=120&q=80'">
                        <div>
                            <div class="detail-item-name">${item.name}</div>
                            <div class="detail-item-qty">₹${item.price} × ${item.quantity}</div>
                        </div>
                    </div>
                    <div class="detail-item-total">₹${itemCost}</div>
                </div>
            `;
        });

        const statusLower = (order.status || '').toLowerCase().trim();
        const isActive = ['placed', 'preparing', 'out for delivery'].includes(statusLower);
        const isDelivered = statusLower === 'delivered';

        let actionButtonMarkup = '';
        if (isActive) {
            actionButtonMarkup = `
                <button class="btn-order-action btn-track-order" onclick="window.FoodieOrders.closeAllModals(); window.FoodieOrders.trackOrder('${order.orderId}')">
                    🛵 Live Track Order
                </button>
            `;
        } else if (isDelivered) {
            actionButtonMarkup = `
                <button class="btn-order-action btn-reorder" onclick="window.FoodieOrders.reorder('${order.orderId}')">
                    🔄 Reorder All Items
                </button>
            `;
        }

        detailsModalBody.innerHTML = `
            <div class="detail-grid-2">
                <div class="detail-section">
                    <div class="detail-section-title">Status & Date</div>
                    <div>${statusBadge}</div>
                    <div class="detail-value" style="font-size: 13px; color: var(--text-muted); margin-top: 4px;">${formattedDate}</div>
                </div>
                <div class="detail-section">
                    <div class="detail-section-title">Restaurant</div>
                    <div class="detail-value" style="color: var(--primary-orange);">${order.restaurantName || 'Spice Garden'}</div>
                    <div style="font-size: 12.5px; color: var(--text-muted);">Express Foodie Kitchen</div>
                </div>
            </div>

            <div class="detail-section">
                <div class="detail-section-title">Delivery Address</div>
                <div class="detail-value">${order.customerName || 'Customer'} (${order.phone || ''})</div>
                <div style="font-size: 13.5px; color: var(--text-muted); margin-top: 2px;">
                    ${order.address || ''}${order.city ? ', ' + order.city : ''}${order.pincode ? ' - ' + order.pincode : ''}
                </div>
            </div>

            <div class="detail-section">
                <div class="detail-section-title">Payment Method</div>
                <div class="detail-value">${order.paymentMethod || 'UPI Payment'}</div>
            </div>

            <div class="detail-section">
                <div class="detail-section-title">Ordered Dishes (${items.length})</div>
                <div class="detail-items-container">
                    ${itemsMarkup}
                </div>
            </div>

            <div class="detail-bill-summary">
                <div class="detail-bill-row">
                    <span>Items Subtotal:</span>
                    <span>₹${order.itemTotal || order.finalTotal || 0}</span>
                </div>
                <div class="detail-bill-row">
                    <span>Delivery Partner Fee:</span>
                    <span>₹${order.deliveryFee !== undefined ? order.deliveryFee : 40}</span>
                </div>
                ${order.discount ? `
                <div class="detail-bill-row" style="color: #10b981;">
                    <span>Discount Applied:</span>
                    <span>- ₹${order.discount}</span>
                </div>
                ` : ''}
                <div class="detail-bill-row total">
                    <span>Final Amount Paid:</span>
                    <span style="color: var(--primary-orange);">₹${order.finalTotal || 0}</span>
                </div>
            </div>

            <div class="modal-footer-actions">
                ${actionButtonMarkup}
            </div>
        `;

        orderDetailsModal.classList.add('active');
    }

    /* ==========================================================================
       7. TRACK ORDER MODAL (5-STEP TIMELINE)
       ========================================================================== */
    function trackOrder(orderId) {
        const order = allOrders.find(o => o.orderId === orderId);
        if (!order) {
            showToast("Order not found!", "error");
            return;
        }

        trackModalTitle.textContent = `Tracking #${order.orderId}`;

        const status = (order.status || 'Placed').toLowerCase().trim();

        // 5 Steps definition
        // 1: Placed, 2: Confirmed, 3: Preparing, 4: Out for Delivery, 5: Delivered
        let activeIndex = 1;
        let etaText = "Arriving in 30 - 35 mins";

        if (status === 'placed') {
            activeIndex = 1;
            etaText = "Order Received • Arriving in ~35 mins";
        } else if (status === 'preparing') {
            activeIndex = 2;
            etaText = "Food in the Kitchen • Arriving in ~25 mins";
        } else if (status === 'out for delivery' || status === 'out-for-delivery') {
            activeIndex = 3;
            etaText = "Rider on the way • Arriving in ~10 mins";
        } else if (status === 'delivered') {
            activeIndex = 4;
            etaText = "Delivered • Enjoy your hot meal!";
        } else if (status === 'cancelled') {
            activeIndex = -1;
            etaText = "Order was cancelled";
        }

        const steps = [
            { title: "Order Placed", desc: "We have received your order." },
            { title: "Order Confirmed", desc: `${order.restaurantName || 'Restaurant'} has accepted your order.` },
            { title: "Food Preparing", desc: "Chef is preparing your delicious meal." },
            { title: "Out for Delivery", desc: "Delivery partner is on the way to your location." },
            { title: "Order Delivered", desc: "Food handed over. Bon Appétit!" }
        ];

        let timelineMarkup = '';
        steps.forEach((step, index) => {
            let stepClass = '';
            let bulletContent = index + 1;

            if (activeIndex === -1) {
                stepClass = index === 0 ? 'completed' : '';
            } else if (index < activeIndex) {
                stepClass = 'completed';
                bulletContent = '✓';
            } else if (index === activeIndex) {
                stepClass = 'active';
                bulletContent = '●';
            }

            timelineMarkup += `
                <div class="timeline-step ${stepClass}">
                    <div class="timeline-step-bullet">${bulletContent}</div>
                    <div style="font-weight: 700; font-size: 14.5px;">${step.title}</div>
                    <div style="font-size: 12.5px; color: var(--text-muted); font-weight: normal; margin-top: 2px;">
                        ${step.desc}
                    </div>
                </div>
            `;
        });

        trackModalBody.innerHTML = `
            <div class="tracking-header-info">
                <div>
                    <div class="tracking-eta-title">Estimated Delivery</div>
                    <div class="tracking-eta-time">${etaText}</div>
                </div>
                <div>
                    ${getStatusBadgeMarkup(order.status)}
                </div>
            </div>

            <div class="tracking-timeline">
                ${timelineMarkup}
            </div>

            <div class="tracking-rider-card">
                <div class="rider-profile">
                    <div class="rider-avatar">🛵</div>
                    <div>
                        <div class="rider-name">Delivery Partner: Suresh K.</div>
                        <div class="rider-status">● Live On Duty (Vaccinated)</div>
                    </div>
                </div>
                <a href="tel:+919876543210" class="btn-call-rider">
                    📞 Call Rider
                </a>
            </div>

            <div style="margin-top: 18px; padding-top: 14px; border-top: 1px solid var(--border-color); font-size: 13px; color: var(--text-muted);">
                <strong>Delivering to:</strong> ${order.customerName || 'Customer'} • ${order.address || 'Address on file'}
            </div>
        `;

        orderTrackModal.classList.add('active');
    }

    /* ==========================================================================
       8. REORDER FUNCTION (ADDS ITEMS TO CART & NAVIGATES)
       ========================================================================== */
    function reorder(orderId) {
        const order = allOrders.find(o => o.orderId === orderId);
        if (!order || !Array.isArray(order.items) || order.items.length === 0) {
            showToast("Cannot reorder items from this order.", "error");
            return;
        }

        // Get existing cart
        let currentCart = [];
        const rawCart = localStorage.getItem(STORAGE_KEY_CART) || localStorage.getItem(STORAGE_KEY_CART_ALT);
        if (rawCart) {
            try {
                currentCart = JSON.parse(rawCart);
                if (!Array.isArray(currentCart)) currentCart = [];
            } catch (e) {
                currentCart = [];
            }
        }

        // Merge order items into cart
        let addedCount = 0;
        order.items.forEach(orderItem => {
            const existingIndex = currentCart.findIndex(c => String(c.id) === String(orderItem.id));
            if (existingIndex > -1) {
                currentCart[existingIndex].quantity = (Number(currentCart[existingIndex].quantity) || 0) + (Number(orderItem.quantity) || 1);
            } else {
                currentCart.push({
                    id: orderItem.id,
                    name: orderItem.name,
                    price: Number(orderItem.price),
                    quantity: Number(orderItem.quantity) || 1,
                    image: orderItem.image,
                    isVeg: orderItem.isVeg !== undefined ? orderItem.isVeg : true
                });
            }
            addedCount += (Number(orderItem.quantity) || 1);
        });

        // Persist to both cart keys
        localStorage.setItem(STORAGE_KEY_CART, JSON.stringify(currentCart));
        localStorage.setItem(STORAGE_KEY_CART_ALT, JSON.stringify(currentCart));

        updateNavCartCount();
        showToast(`Added ${order.items.length} items to your cart! Redirecting...`, "success");

        // Navigate to Cart page after a short feedback pause
        setTimeout(() => {
            window.location.href = 'cart.html';
        }, 800);
    }

    /* ==========================================================================
       9. TOAST NOTIFICATION UTILITY
       ========================================================================== */
    let toastTimeout;
    function showToast(msg, type = 'success') {
        if (!toastNotice) return;
        clearTimeout(toastTimeout);

        toastMessage.textContent = msg;
        toastIcon.textContent = type === 'success' ? '✓' : 'ℹ';
        toastNotice.classList.add('show');

        toastTimeout = setTimeout(() => {
            toastNotice.classList.remove('show');
        }, 3200);
    }

    function resetFilters() {
        currentFilter = 'all';
        currentSearch = '';
        currentSort = 'newest';

        if (orderSearchInput) orderSearchInput.value = '';
        if (orderSortSelect) orderSortSelect.value = 'newest';

        filterPills.forEach(pill => {
            if (pill.dataset.filter === 'all') {
                pill.classList.add('active');
            } else {
                pill.classList.remove('active');
            }
        });

        displayOrders();
    }

    function closeAllModals() {
        if (orderDetailsModal) orderDetailsModal.classList.remove('active');
        if (orderTrackModal) orderTrackModal.classList.remove('active');
    }

    /* ==========================================================================
       10. EVENT LISTENERS
       ========================================================================== */
    // Filter Pills
    filterPills.forEach(pill => {
        pill.addEventListener('click', () => {
            filterPills.forEach(p => p.classList.remove('active'));
            pill.classList.add('active');
            currentFilter = pill.dataset.filter || 'all';
            displayOrders();
        });
    });

    // Search Input (Instant with debounce)
    let searchDebounce;
    if (orderSearchInput) {
        orderSearchInput.addEventListener('input', (e) => {
            clearTimeout(searchDebounce);
            searchDebounce = setTimeout(() => {
                currentSearch = e.target.value;
                displayOrders();
            }, 180);
        });
    }

    // Sort Select
    if (orderSortSelect) {
        orderSortSelect.addEventListener('change', (e) => {
            currentSort = e.target.value;
            displayOrders();
        });
    }

    // Modal Close buttons
    if (btnCloseDetailsModal) {
        btnCloseDetailsModal.addEventListener('click', () => {
            orderDetailsModal.classList.remove('active');
        });
    }

    if (btnCloseTrackModal) {
        btnCloseTrackModal.addEventListener('click', () => {
            orderTrackModal.classList.remove('active');
        });
    }

    // Click outside modal to close
    window.addEventListener('click', (e) => {
        if (e.target === orderDetailsModal) {
            orderDetailsModal.classList.remove('active');
        }
        if (e.target === orderTrackModal) {
            orderTrackModal.classList.remove('active');
        }
    });

    // ESC key to close modals
    window.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            closeAllModals();
        }
    });

    // Mobile Navbar Toggle
    if (mobileMenuToggle && navLinks) {
        mobileMenuToggle.addEventListener('click', () => {
            navLinks.classList.toggle('show-mobile');
        });
    }

    // Expose functions globally for inline onclick handlers
    window.FoodieOrders = {
        viewOrderDetails,
        trackOrder,
        reorder,
        resetFilters,
        closeAllModals
    };

    /* ==========================================================================
       11. INITIALIZATION
       ========================================================================== */
    loadOrders();
});


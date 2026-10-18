// ==========================================
// FOODIE - MENU CART FUNCTIONALITY
// ==========================================

const CART_KEY = "foodieCart";


// ==========================================
// GET CART FROM LOCAL STORAGE
// ==========================================

function getCart() {

    const cart = localStorage.getItem(CART_KEY);

    if (cart) {
        try {
            return JSON.parse(cart);
        } catch (error) {
            console.error("Invalid cart data:", error);
            return [];
        }
    }

    return [];
}


// ==========================================
// SAVE CART TO LOCAL STORAGE
// ==========================================

function saveCart(cart) {

    localStorage.setItem(CART_KEY, JSON.stringify(cart));

}


// ==========================================
// ADD ITEM TO CART
// ==========================================

function addToCart(button) {

    const menuId = button.dataset.menuId;
    const itemName = button.dataset.itemName;
    const price = parseFloat(button.dataset.price);
    const image = button.dataset.image;
    const resId = button.dataset.resId;
    const description = button.dataset.description;


    let cart = getCart();


    // Check whether item already exists
    const existingItem = cart.find(function(item) {

        return String(item.id) === String(menuId);

    });


    if (existingItem) {

        // Item already exists
        existingItem.quantity++;

    } else {

        // New item
        const newItem = {

            id: menuId,

            name: itemName,

            price: price,

            quantity: 1,

            type: "veg",

            image: image,

            description: description,

            resId: resId

        };

        cart.push(newItem);

    }


    // Save updated cart
    saveCart(cart);


    // Update button
    button.innerText = "✓ Added";

    button.classList.add("added");


    // Return button to normal after short time
    setTimeout(function() {

        button.innerText = "+ Add";

        button.classList.remove("added");

    }, 1000);


    // Update navbar cart count
    updateMenuCartCount();


    console.log("Cart:", cart);

}


// ==========================================
// UPDATE CART COUNT
// ==========================================

function updateMenuCartCount() {

    const cart = getCart();

    let totalQuantity = 0;


    cart.forEach(function(item) {

        totalQuantity += Number(item.quantity);

    });


    const cartLink = document.querySelector(".cart-link");

    if (cartLink) {

        cartLink.innerText = "Cart (" + totalQuantity + ")";

    }


    // If your cart count has this ID
    const navCartCount = document.getElementById("navCartCount");

    if (navCartCount) {

        navCartCount.innerText = totalQuantity;

    }

}


// ==========================================
// ADD CLICK EVENT TO ALL ADD BUTTONS
// ==========================================

document.addEventListener("DOMContentLoaded", function() {

    const addButtons = document.querySelectorAll(".btn-add-item");


    addButtons.forEach(function(button) {

        button.addEventListener("click", function() {

            addToCart(button);

        });

    });


    updateMenuCartCount();

});
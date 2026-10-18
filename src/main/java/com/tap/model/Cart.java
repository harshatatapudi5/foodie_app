package com.tap.model;

import java.util.HashMap;
import java.util.Map;

public class Cart {

    // menuId -> CartItem
    private Map<Integer, CartItem> items;

    // Restaurant ID for this cart
    private int res_id;

    // Constructor
    public Cart() {
        items = new HashMap<>();
        res_id = 0;
    }

    // Add item to cart
    public boolean addItem(MenuData menu) {

        if (menu == null) {
            return false;
        }

        // If cart is empty, set restaurant ID
        if (items.isEmpty()) {
            res_id = menu.getRes_id();
        }

        // Allow items only from the same restaurant
        if (res_id != menu.getRes_id()) {
            return false;
        }

        int menuId = menu.getId();

        // Check whether item already exists
        CartItem existingItem = items.get(menuId);

        if (existingItem != null) {

            // Increase quantity
            existingItem.setQuantity(existingItem.getQuantity() + 1);

        } else {

            // Create new CartItem
            CartItem cartItem = new CartItem();

            cartItem.setMenu(menu);
            cartItem.setQuantity(1);

            // menuId is the key
            items.put(menuId, cartItem);
        }

        return true;
    }

    // Increase quantity
    public void increaseQuantity(int menuId) {

        CartItem item = items.get(menuId);

        if (item != null) {
            item.setQuantity(item.getQuantity() + 1);
        }
    }

    // Decrease quantity
    public void decreaseQuantity(int menuId) {

        CartItem item = items.get(menuId);

        if (item != null) {

            if (item.getQuantity() > 1) {

                item.setQuantity(item.getQuantity() - 1);

            } else {

                // Quantity becomes 0, so remove item
                items.remove(menuId);
            }
        }

        // If cart becomes empty, reset restaurant ID
        if (items.isEmpty()) {
            res_id = 0;
        }
    }

    // Remove item completely
    public void removeItem(int menuId) {

        items.remove(menuId);

        // If cart becomes empty, reset restaurant ID
        if (items.isEmpty()) {
            res_id = 0;
        }
    }

    // Get all cart items
    public Map<Integer, CartItem> getItems() {
        return items;
    }

    // Get restaurant ID
    public int getRes_id() {
        return res_id;
    }

    // Set restaurant ID
    public void setRes_id(int res_id) {
        this.res_id = res_id;
    }

    // Calculate total price
    public double getTotal() {

        double total = 0;

        for (CartItem item : items.values()) {
            total += item.getSubtotal();
        }

        return total;
    }

    // Calculate total quantity
    public int getTotalQuantity() {

        int quantity = 0;

        for (CartItem item : items.values()) {
            quantity += item.getQuantity();
        }

        return quantity;
    }

    // Check whether cart is empty
    public boolean isEmpty() {
        return items.isEmpty();
    }

    // Clear cart
    public void clear() {

        items.clear();
        res_id = 0;
    }

    @Override
    public String toString() {
        return "Cart [items=" + items + ", res_id=" + res_id + "]";
    }
}
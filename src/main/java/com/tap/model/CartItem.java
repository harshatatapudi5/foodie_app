package com.tap.model;

public class CartItem {

    private MenuData menu;
    private int quantity;

    public void setMenu(MenuData menu) {
        this.menu = menu;
    }

    public MenuData getMenu() {
        return menu;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getQuantity() {
        return quantity;
    }

    public double getSubtotal() {
        return menu.getPrice() * quantity;
    }

    @Override
    public String toString() {
        return "CartItem [menu=" + menu + ", quantity=" + quantity + "]";
    }
}
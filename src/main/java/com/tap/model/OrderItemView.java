package com.tap.model;

public class OrderItemView {

    private int menuId;
    private String itemName;
    private String imagePath;
    private double price;
    private int quantity;
    private double itemTotal;

    public OrderItemView() {
    }

    public OrderItemView(
            int menuId,
            String itemName,
            String imagePath,
            double price,
            int quantity,
            double itemTotal) {

        this.menuId = menuId;
        this.itemName = itemName;
        this.imagePath = imagePath;
        this.price = price;
        this.quantity = quantity;
        this.itemTotal = itemTotal;
    }

    public int getMenuId() {
        return menuId;
    }

    public String getItemName() {
        return itemName;
    }

    public String getImagePath() {
        return imagePath;
    }

    public double getPrice() {
        return price;
    }

    public int getQuantity() {
        return quantity;
    }

    public double getItemTotal() {
        return itemTotal;
    }
}
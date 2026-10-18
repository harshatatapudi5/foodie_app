package com.tap.model;

import java.time.LocalDateTime;

public class MenuData {

	private int id;
	private int res_id;
	private String itemName;
	private String desc;
	private double price;
	private String isAvailable;
	private String category;
	private String imagePath;
	private LocalDateTime createdAt;
	private LocalDateTime updateAt;
	private LocalDateTime deletedAt;
	
	public MenuData() {
		
	}
	
	public MenuData(int id) {
			
		this.id=id;
		
	}
	
	
	public MenuData(int res_id, String itemName, String desc, double price, String isAvailable, String category) {
		
		this.res_id = res_id;
		this.itemName = itemName;
		this.desc = desc;
		this.price = price;
		this.isAvailable = isAvailable;
		this.category = category;
		
	}
	
	
	
	
	
	public MenuData(int id, int res_id, String itemName, String desc,
	        double price, String isAvailable, String category,
	        String imagePath,
	        LocalDateTime createdAt, LocalDateTime updateAt,
	        LocalDateTime deletedAt) {

	    this.id = id;
	    this.res_id = res_id;
	    this.itemName = itemName;
	    this.desc = desc;
	    this.price = price;
	    this.isAvailable = isAvailable;
	    this.category = category;
	    this.imagePath = imagePath;
	    this.createdAt = createdAt;
	    this.updateAt = updateAt;
	    this.deletedAt = deletedAt;
	}
	
	
	public int getId() {
		return id;
	}
	
	
	public void setId(int id) {
		this.id = id;
	}
	
	
	public int getRes_id() {
		return res_id;
	}
	
	
	public void setRes_id(int res_id) {
		this.res_id = res_id;
	}
	
	
	public String getItemName() {
		return itemName;
	}
	
	
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}
	
	
	public String getDesc() {
		return desc;
	}
	
	
	public void setDesc(String desc) {
		this.desc = desc;
	}
	
	
	public double getPrice() {
		return price;
	}
	
	
	public void setPrice(double price) {
		this.price = price;
	}
	
	
	public String getIsAvailable() {
		return isAvailable;
	}
	
	
	public void setIsAvailable(String isAvailable) {
		this.isAvailable = isAvailable;
	}
	
	
	public String getCategory() {
		return category;
	}
	
	
	public void setCategory(String category) {
		this.category = category;
	}
	
	
	public LocalDateTime getCreatedAt() {
		return createdAt;
	}
	
	
	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}
	
	
	public LocalDateTime getUpdateAt() {
		return updateAt;
	}
	
	
	public void setUpdateAt(LocalDateTime updateAt) {
		this.updateAt = updateAt;
	}
	
	
	public LocalDateTime getDeletedAt() {
		return deletedAt;
	}
	
	
	public void setDeletedAt(LocalDateTime deletedAt) {
		this.deletedAt = deletedAt;
	}
	
	public String getImagePath() {
	    return imagePath;
	}

	public void setImagePath(String imagePath) {
	    this.imagePath = imagePath;
	}

	public String getResolvedImageUrl(String contextPath) {
		if (imagePath == null || imagePath.trim().isEmpty()) {
			return contextPath + "/Foodie/images/menu/pizza.jpg";
		}
		String path = imagePath.trim();
		if (path.startsWith("/")) {
			path = path.substring(1);
		}
		if (path.startsWith("images/")) {
			return contextPath + "/Foodie/" + path;
		} else if (path.contains("/")) {
			return contextPath + "/Foodie/images/" + path;
		} else {
			return contextPath + "/Foodie/images/menu/" + path;
		}
	}
	
	
	
	
	@Override
	public String toString() {
	    return "MenuData [id=" + id
	            + ", res_id=" + res_id
	            + ", itemName=" + itemName
	            + ", desc=" + desc
	            + ", price=" + price
	            + ", isAvailable=" + isAvailable
	            + ", category=" + category
	            + ", imagePath=" + imagePath
	            + ", createdAt=" + createdAt
	            + ", updateAt=" + updateAt
	            + ", deletedAt=" + deletedAt + "]";
	}
	
	
	
	
	
	
}

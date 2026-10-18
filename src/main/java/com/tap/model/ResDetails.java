package com.tap.model;

import java.sql.Timestamp;

public class ResDetails {

	
	private int id;
	private String resName;
	private String cuisineType;
	private String delTime;
	private String address;
	private int user_id;
	private double rating;
	private String imagePath;
	
	
	public ResDetails() {
		
	}
	
	public ResDetails(int id) {
		this.id=id;
	}
	
	public ResDetails(String resName,String cuisineType,String address,int user_id,double rating) {
		
		this.resName=resName;
		this.cuisineType=cuisineType;
	
		this.address=address;
		this.user_id=user_id;
		this.rating=rating;
		
	}
	
	
	public ResDetails(int id,String resName,String cuisineType,String delTime,String address,int user_id,double rating,String imagePath) {
		
		this.id=id;
		this.resName=resName;
		this.cuisineType=cuisineType;
		this.delTime=delTime;
		this.address=address;
		this.user_id=user_id;
		this.rating=rating;
		this.imagePath=imagePath;
		
		
	}

	public String getImagePath() {
		return imagePath;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getResName() {
		return resName;
	}

	public void setResName(String resName) {
		this.resName = resName;
	}

	public String getCuisineType() {
		return cuisineType;
	}

	public void setCuisineType(String cuisineType) {
		this.cuisineType = cuisineType;
	}

	public String getDelTime() {
		return delTime;
	}

	public void setDelTime(String delTime) {
		this.delTime = delTime;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public int getUser_id() {
		return user_id;
	}

	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}

	public double getRating() {
		return rating;
	}

	public void setRating(double rating) {
		this.rating = rating;
	}

//	@Override
//	public String toString() {
//		return "ResDetails [id=" + id + ", resName=" + resName + ", cuisineType=" + cuisineType + ", delTime=" + delTime
//				+ ", address=" + address + ", user_id=" + user_id + ", rating=" + rating + "]";
//	}
	
	@Override
	public String toString() {
		return "ResDetails [id=" + id + ", resName=" + resName + ", cuisineType=" + cuisineType + ", delTime=" + delTime
				+ ", address=" + address + ", user_id=" + user_id + ", rating=" + rating + ", imagePath=" + imagePath
				+ "]";
	}
	
	
}
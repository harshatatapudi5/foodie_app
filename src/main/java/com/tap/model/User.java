


package com.tap.model;

import java.sql.Timestamp;

public class User { 
	private int id;
	private String name;
	private String email;
	private String password;
	private String address;
	private String role;
	private Timestamp createdDate;
	private Timestamp lastLoginDate;
	
	
	public User() {
		
	}
	
	public User(int id) {
		this.id=id;
	}
	
	
	public User(int id,String name,String email,String password,String address,String role,Timestamp createdDate,Timestamp lastLoginDate) {
		this.id=id;
		this.name=name;
		this.email=email;
		this.password=password;
		this.address=address;
		this.role=role;
		this.createdDate=createdDate;
		this.lastLoginDate=lastLoginDate;
	}
	
	
	public User(String name,String email,String password,String address,String role,Timestamp createdDate,Timestamp lastLoginDate) {
		this.name=name;
		this.email=email;
		this.password=password;
		this.address=address;
		this.role=role;
		this.createdDate=createdDate;
		this.lastLoginDate=lastLoginDate;
	}
	
	public User(String name,String email,String password,String address,String role) {
		this.name=name;
		this.email=email;
		this.password=password;
		this.address=address;
		this.role=role;
	}
	
	public void setDetailsAll(int id,String name,String email,String password,String address,String role,Timestamp createdDate,Timestamp lastLoginDate) {
		
		this.id=id;
		this.name=name;
		this.email=email;
		this.password=password;
		this.address=address;
		this.role=role;
		this.createdDate=createdDate;
		this.lastLoginDate=lastLoginDate;
	}
	
	
	
	public void setName(String name) {
		this.name=name;
	}
	
	public void setEmail(String email) {
		this.email=email;
	}
	
	
	public void setPassWord(String password) {
		this.password=password;
	}
	
	public void setAddress(String address) {
		this.address=address;
	}
	
	public void setRole(String role) {
		this.role=role;
	}
	
	public int getId() {
		return id;
	}
	
	public String getName() {
		return name;
	}
	
	public String getEmail() {
		return email;
	}
	
	public String getPassWord() {
		return password;
	}
	
	public String getAddress() {
		return address;
	}
	
	public String getRole() {
		return role;
	}
	
	public Timestamp getCreatedDate() {
		return createdDate;
	}
	
	public Timestamp getLastDate() {
		return lastLoginDate;
	}
	
	@Override
	public String toString() {
	    return id + " " + name + " " + email + " " + password + " "
	            + address + " " + role + " " + createdDate + " " + lastLoginDate;
	}
	
	
	public static void main(String[] args) {
		
	}

}

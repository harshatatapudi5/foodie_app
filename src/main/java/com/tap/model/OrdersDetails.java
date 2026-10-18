package com.tap.model;

import java.sql.Timestamp;

public class OrdersDetails {
	
	private int oders_id;
	private int user_id;
	private int res_id;
	private Timestamp order_date;
	private double totalamount;
	private String status;
	private String payment;
	
	
	
	public OrdersDetails(){
		
	}
	
	public OrdersDetails(int oders_id){
			this.oders_id=oders_id;
	}
	
	public OrdersDetails(double totalamount,int oders_id) {
		this.totalamount=totalamount;
		this.oders_id=oders_id;
	}
	
	
	public OrdersDetails(int user_id,int res_id,double totalamount,String status,String payment) {
		this.user_id=user_id;
		this.res_id=res_id;
		this.totalamount=totalamount;
		this.status=status;
		this.payment=payment;
	}
	
	
	
	public OrdersDetails(int oders_id,int user_id,int res_id,Timestamp order_date,double totalamount,String status,String payment) {
		
		this.oders_id=oders_id;
		this.user_id=user_id;
		this.res_id=res_id;
		this.order_date=order_date;
		this.totalamount=totalamount;
		this.status=status;
		this.payment=payment;
		
	}

	public double getTotalamount() {
		return totalamount;
	}

	public void setTotalamount(double totalamount) {
		this.totalamount = totalamount;
	}

	public int getOders_id() {
		return oders_id;
	}

	public void setOders_id(int oders_id) {
		this.oders_id = oders_id;
	}

	public int getUser_id() {
		return user_id;
	}

	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}

	public int getRes_id() {
		return res_id;
	}

	public void setRes_id(int res_id) {
		this.res_id = res_id;
	}

	public Timestamp getOrder_date() {
		return order_date;
	}

	public void setOrder_date(Timestamp order_date) {
		this.order_date = order_date;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPayment() {
		return payment;
	}

	public void setPayment(String payment) {
		this.payment = payment;
	}

	@Override
	public String toString() {
		return "OrdersDetails [oders_id=" + oders_id + ", user_id=" + user_id + ", res_id=" + res_id + ", order_date="
				+ order_date + ", totalamount=" + totalamount + ", status=" + status + ", payment=" + payment + "]";
	}
	
	
	
}


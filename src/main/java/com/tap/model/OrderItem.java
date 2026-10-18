package com.tap.model;

public class OrderItem {
	
	
	private int oi_id;
	private int o_id;
	private int m_id;
	private int quantity;
	private double itemTotal;
	
	
	
	public OrderItem() {
		
	}
	public OrderItem(int quantity, int o_id) {
	    this.quantity = quantity;
	    this.o_id = o_id;
	}
	
	public OrderItem(int o_id,int m_id,int quantity,double itemTotal) {
			
			this.o_id=o_id;
			this.m_id=m_id;
			this.quantity=quantity;
			this.itemTotal=itemTotal;
			
	}
	
	public OrderItem(int oi_id,int o_id,int m_id,int quantity,double itemTotal) {
		
		this.oi_id=oi_id;
		this.o_id=o_id;
		this.m_id=m_id;
		this.quantity=quantity;
		this.itemTotal=itemTotal;
		
	}

	public int getOi_id() {
		return oi_id;
	}

	public void setOi_id(int oi_id) {
		this.oi_id = oi_id;
	}

	public int getO_id() {
		return o_id;
	}

	public void setO_id(int o_id) {
		this.o_id = o_id;
	}

	public int getM_id() {
		return m_id;
	}

	public void setM_id(int m_id) {
		this.m_id = m_id;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public double getItemTotal() {
		return itemTotal;
	}

	public void setItemTotal(double itemTotal) {
		this.itemTotal = itemTotal;
	}

	@Override
	public String toString() {
		return "OrderItem [oi_id=" + oi_id + ", o_id=" + o_id + ", m_id=" + m_id + ", quantity=" + quantity
				+ ", itemTotal=" + itemTotal + "]";
	}
	
	
	
}

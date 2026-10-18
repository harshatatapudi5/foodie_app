package com.tap.DAO;

import java.util.List;

import com.tap.model.MenuData;
import com.tap.model.OrderItem;
import com.tap.model.OrdersDetails;

public interface OrderItemDAO {
	
	public void addOrderItem(OrderItem oi,OrdersDetails od,MenuData m);
	public OrderItem getOI(int id);
	public void updateOI(OrderItem oi);
	public void deleteOI(int id);
	List<OrderItem> getAllOI();
	List<OrderItem> getOrderItemsByOrder(int orderId);
	
	
	
}

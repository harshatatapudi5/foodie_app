package com.tap.DAO;

import java.util.List;

import com.tap.model.OrdersDetails;
import com.tap.model.ResDetails;
import com.tap.model.User;

public interface OrderDAO {
	
	
	public void addOrders(OrdersDetails o,User user,ResDetails res);
	public OrdersDetails getOrder(int id);
	public void updateOrders(OrdersDetails o);
	public void deleteOrders(int id);
	List<OrdersDetails> getAllOrders();
	List<OrdersDetails> getOrdersByUser(int userId);
}
	
	


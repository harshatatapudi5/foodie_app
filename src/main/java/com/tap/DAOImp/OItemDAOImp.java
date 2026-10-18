package com.tap.DAOImp;



import java.util.List;


import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import com.tap.DAO.OrderItemDAO;
import com.tap.model.MenuData;
import com.tap.model.OrderItem;
import com.tap.model.OrdersDetails;
//import com.tap.Orders.OrdersDetails;
//import com.tap.menu.MenuData;
//import com.tap.orderItem.OrderItem;
//import com.tap.orderItemDAO.OrderItemDAO;
import com.tap.util.DBConnection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class OItemDAOImp implements OrderItemDAO{
	
	private static final String INSERT_QUERY="insert into orderitem(order_id,menu_id,quantity,ItemTotal) values(?,?,?,?)";
	private static final String SELECT_ID="select * from orderitem where ordIt_id=?";
	private static final String UPDATE_QUERY="update orderitem set quantity=? where ordIt_id=?";
	private static final String DELETE_QUERY="delete from orderitem where ordIt_id=?";
	private static final String SELECT_ALL="select * from orderitem";
	private static final String SELECT_ORDERITEM = "SELECT * FROM orderitem WHERE order_id=?";


@Override
public void addOrderItem(OrderItem oi, OrdersDetails od, MenuData m) {

    String sql =
        "INSERT INTO orderitem (order_id, menu_id, quantity, ItemTotal) "
      + "VALUES (?, ?, ?, ?)";

    Connection con = DBConnection.getConnection();

    if (con == null) {
        throw new IllegalStateException(
            "Database connection is null. Check DBConnection."
        );
    }

    try (PreparedStatement pt = con.prepareStatement(sql)) {

        pt.setInt(1, od.getOders_id());
        pt.setInt(2, m.getId());
        pt.setInt(3, oi.getQuantity());
        pt.setDouble(4, oi.getItemTotal());

        int rowsInserted = pt.executeUpdate();

        if (rowsInserted != 1) {
            throw new SQLException("Order item was not inserted.");
        }

    } catch (SQLException e) {
        e.printStackTrace();

        // Let the controller know the insert failed
        throw new RuntimeException("Failed to save an order item.", e);
    }
}


	@Override
	public OrderItem getOI(int id) {
		Connection con=DBConnection.getConnection();
		OrderItem oi=null;
		try {
			PreparedStatement pt=con.prepareStatement(SELECT_ID);
			pt.setInt(1, id);
			ResultSet res=pt.executeQuery();
			oi=getOItem(res);
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return oi;
	}

	@Override
	public void updateOI(OrderItem oi) {
		Connection con=DBConnection.getConnection();
		try {
			PreparedStatement pt=con.prepareStatement(UPDATE_QUERY);
			
			pt.setInt(1, oi.getQuantity());
			
			pt.setInt(2, oi.getOi_id());
			int i=pt.executeUpdate();
			System.out.println(i+" row upddated");
			
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public void deleteOI(int id) {
		Connection con=DBConnection.getConnection();
		try {
			PreparedStatement pt=con.prepareStatement(DELETE_QUERY);
			pt.setInt(1, id);
			int i=pt.executeUpdate();
			System.out.println(i+" row deleted");
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public List<OrderItem> getAllOI() {
		ArrayList<OrderItem> al=new ArrayList<>();
		Connection con=DBConnection.getConnection();
		OrderItem oi=null;
		try {
			Statement st=con.createStatement();
			ResultSet res=st.executeQuery(SELECT_ALL);
			while(res.next()) {
				oi=getOIAll(res);
				al.add(oi);
			}
			
			
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		
		
		return al;
	}
	
	
	
	
	public static OrderItem getOItem(ResultSet res) {
		
		OrderItem oi=null;
		try {
			while(res.next()) {
				int id=res.getInt(1);
				int o_id=res.getInt(2);
				int m_id=res.getInt(3);
				int quan=res.getInt(4);
				double itemTotal=res.getDouble(5);
				
				oi=new OrderItem(id,o_id,m_id,quan,itemTotal);
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		
		return oi;
	}
	
	
	public static OrderItem getOIAll(ResultSet res) {
		
		OrderItem oi=null;
		
		try {
			int id=res.getInt(1);
			int o_id=res.getInt(2);
			int m_id=res.getInt(3);
			int qua=res.getInt(4);
			double itemTotal=res.getDouble(5);
			
			oi=new OrderItem(id,o_id,m_id,qua,itemTotal);
		}
		
		catch(SQLException e) {
			e.printStackTrace();
		}
		return oi;
	}

	@Override
	public List<OrderItem> getOrderItemsByOrder(int orderId) {

	    ArrayList<OrderItem> all = new ArrayList<>();

	    Connection con = DBConnection.getConnection();

	   

	    try {

	        PreparedStatement pt = con.prepareStatement(SELECT_ORDERITEM);

	        pt.setInt(1, orderId);

	        ResultSet res = pt.executeQuery();

	        while (res.next()) {

	            OrderItem oi = getOIAll(res);

	            all.add(oi);
	        }

	    } catch (SQLException e) {

	        e.printStackTrace();
	    }

	    return all;
	}
	
	
	
	
	
	
}


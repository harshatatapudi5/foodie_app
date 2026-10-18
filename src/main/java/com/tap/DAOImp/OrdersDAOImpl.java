package com.tap.DAOImp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.OrderDAO;
import com.tap.model.OrdersDetails;
import com.tap.model.ResDetails;
import com.tap.model.User;
import com.tap.util.DBConnection;

public class OrdersDAOImpl implements OrderDAO {

	private static final String INSERT_QUERY = "insert into orders(user_id,res_id,order_date,TotalAmount,status,payment_method) values(?,?,?,?,?,?)";
	private static final String SELECT_ID = "select * from orders where order_id=?";
	private static final String UPDATE_QUERY = "update orders set TotalAmount=? where order_id=?";
	private static final String DELETE_QUERY = "delete from orders where order_id=?";
	private static final String SELECT = "select * from orders";
	private static final String SELECT_ORDERS = "select * from orders where user_id=?";

	@Override
	public void addOrders(OrdersDetails o, User user, ResDetails res) {
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(INSERT_QUERY, Statement.RETURN_GENERATED_KEYS) : null) {

			if (con == null || pt == null) {
				System.out.println("ERROR: Database connection is NULL.");
				return;
			}

			pt.setInt(1, user.getId());
			pt.setInt(2, res.getId());
			pt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
			pt.setDouble(4, o.getTotalamount());
			pt.setString(5, o.getStatus());
			pt.setString(6, o.getPayment());

			int rows = pt.executeUpdate();

			if (rows == 0) {
				System.out.println("ERROR: Order was not inserted.");
				return;
			}

			try (ResultSet generatedKeys = pt.getGeneratedKeys()) {
				if (generatedKeys.next()) {
					int orderId = generatedKeys.getInt(1);
					o.setOders_id(orderId);
					System.out.println("Generated Order ID: " + orderId);
				} else {
					System.out.println("ERROR: MySQL did not return generated order_id.");
				}
			}

		} catch (SQLException e) {
			System.out.println("========== ORDER INSERT ERROR ==========");
			e.printStackTrace();
		}
	}

	@Override
	public OrdersDetails getOrder(int id) {
		OrdersDetails od = null;
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(SELECT_ID) : null) {
			if (pt == null) return null;
			pt.setInt(1, id);
			try (ResultSet res = pt.executeQuery()) {
				od = dataAll(res);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return od;
	}

	@Override
	public void updateOrders(OrdersDetails o) {
		if (o == null) return;
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(UPDATE_QUERY) : null) {
			if (pt == null) return;
			pt.setDouble(1, o.getTotalamount());
			pt.setInt(2, o.getOders_id());
			int i = pt.executeUpdate();
			System.out.println(i + " row updated");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deleteOrders(int id) {
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(DELETE_QUERY) : null) {
			if (pt == null) return;
			pt.setInt(1, id);
			int i = pt.executeUpdate();
			System.out.println(i + " row deleted");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<OrdersDetails> getAllOrders() {
		ArrayList<OrdersDetails> all = new ArrayList<>();
		try (Connection con = DBConnection.getConnection();
		     Statement st = con != null ? con.createStatement() : null;
		     ResultSet res = st != null ? st.executeQuery(SELECT) : null) {
			if (res == null) return all;
			while (res.next()) {
				OrdersDetails o = data(res);
				all.add(o);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return all;
	}

	public static OrdersDetails dataAll(ResultSet res) {
		OrdersDetails o = null;
		try {
			while (res.next()) {
				int id = res.getInt(1);
				int u_id = res.getInt(2);
				int r_id = res.getInt(3);
				Timestamp t = res.getTimestamp(4);
				double d = res.getDouble(5);
				String s = res.getString(6);
				String p = res.getString(7);

				o = new OrdersDetails(id, u_id, r_id, t, d, s, p);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return o;
	}

	public static OrdersDetails data(ResultSet res) {
		OrdersDetails od = null;
		try {
			int id = res.getInt(1);
			int u_id = res.getInt(2);
			int r_id = res.getInt(3);
			Timestamp t = res.getTimestamp(4);
			double d = res.getDouble(5);
			String s = res.getString(6);
			String p = res.getString(7);

			od = new OrdersDetails(id, u_id, r_id, t, d, s, p);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return od;
	}

	@Override
	public List<OrdersDetails> getOrdersByUser(int userId) {
		ArrayList<OrdersDetails> all = new ArrayList<>();
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(SELECT_ORDERS) : null) {
			if (pt == null) return all;
			pt.setInt(1, userId);
			try (ResultSet res = pt.executeQuery()) {
				while (res.next()) {
					OrdersDetails od = data(res);
					all.add(od);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return all;
	}
}

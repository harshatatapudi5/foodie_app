package com.tap.DAOImp;

import java.util.List;
import com.tap.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.tap.model.*;

import java.sql.ResultSet;

import com.tap.DAO.ResDAO;
import java.util.ArrayList;
import java.sql.Statement;

public class DAOImpRes implements ResDAO {
	private static final String INSERT_QUERY = "insert into restaurant(res_name,cuisine_type,delivery_time,address,user_id,rating,imagePath) values(?,?,?,?,?,?,?)";
	private static final String SELECT_ID = "select * from restaurant where res_id=?";
	private static final String UPADTE_QUERY = "update restaurant set cuisine_type=? where res_id=?";
	private static final String DELETE_QUERY = "delete from restaurant where res_id=?";
	private static final String SELECT_QUERY = "select * from restaurant";

	@Override
	public void addRes(ResDetails res, User user) {
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(INSERT_QUERY) : null) {
			if (pt == null) return;
			pt.setString(1, res.getResName());
			pt.setString(2, res.getCuisineType());
			pt.setString(3, res.getDelTime());
			pt.setString(4, res.getAddress());
			int userId = user.getId();
			pt.setInt(5, userId);
			pt.setDouble(6, res.getRating());
			pt.setString(7, res.getImagePath());

			int i = pt.executeUpdate();
			System.out.print(i + " row affected");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public ResDetails getRes(int id) {
		ResDetails res = null;
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(SELECT_ID) : null) {
			if (pt == null) return null;
			pt.setInt(1, id);
			try (ResultSet re = pt.executeQuery()) {
				res = printAllData(re);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return res;
	}

	private ResDetails printAllData(ResultSet re) throws SQLException {
		ResDetails res = null;
		if (re.next()) {
			int res_id = re.getInt(1);
			String name = re.getString(2);
			String cuisine = re.getString(3);
			String deTime = re.getString(4);
			String address = re.getString(5);
			int id = re.getInt(6);
			double rating = re.getDouble(7);
			String image = re.getString(8);
			res = new ResDetails(res_id, name, cuisine, deTime, address, id, rating, image);
		}
		return res;
	}

	@Override
	public void updateRes(ResDetails res) {
		if (res == null) return;
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(UPADTE_QUERY) : null) {
			if (pt == null) return;
			pt.setString(1, res.getCuisineType());
			pt.setInt(2, res.getId());
			int i = pt.executeUpdate();
			System.out.println(i + " updated");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deleteRes(int id) {
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
	public List<ResDetails> getAllRes() {
		ArrayList<ResDetails> li = new ArrayList<ResDetails>();
		try (Connection con = DBConnection.getConnection();
		     Statement st = con != null ? con.createStatement() : null;
		     ResultSet res = st != null ? st.executeQuery(SELECT_QUERY) : null) {
			if (res == null) return li;
			while (res.next()) {
				ResDetails rd = listOfUser(res);
				li.add(rd);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return li;
	}

	private ResDetails listOfUser(ResultSet res) throws SQLException {
		int re_id = res.getInt(1);
		String name = res.getString(2);
		String cusine = res.getString(3);
		String deTime = res.getString(4);
		String address = res.getString(5);
		int id = res.getInt(6);
		double rating = res.getDouble(7);
		String image = res.getString(8);
		return new ResDetails(re_id, name, cusine, deTime, address, id, rating, image);
	}
}

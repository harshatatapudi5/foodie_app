package com.tap.DAOImp;

import com.tap.DAO.UserDAO;
import com.tap.model.User;
import com.tap.util.DBConnection;

import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;

import org.mindrot.jbcrypt.BCrypt;

public class UserDAOImp implements UserDAO {

	private static final String INSER_QUERY = "insert into user_details(name,email,password,address,role,date,login_date) values(?,?,?,?,?,?,?)";
	private static final String SELECT_QUERY = "select * from user_details where user_id=?";
	private static final String UPDATE_USER = "update user_details set name=?, address=? where user_id=?";
	private static final String DELETE_USER = "delete from user_details where user_id=?";
	private static final String QUERY = "select * from user_details";
	private static final String USER_BY_EMAIL = "select * from user_details where email=?";

	@Override
	public boolean addUser(User user) {
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(INSER_QUERY) : null) {

			if (con == null || pt == null) {
				System.out.println("Database connection is null.");
				return false;
			}

			String hashedPassword = BCrypt.hashpw(user.getPassWord(), BCrypt.gensalt(10));

			pt.setString(1, user.getName());
			pt.setString(2, user.getEmail());
			pt.setString(3, hashedPassword);
			pt.setString(4, user.getAddress());
			pt.setString(5, user.getRole());
			pt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
			pt.setTimestamp(7, null);

			int rows = pt.executeUpdate();
			if (rows > 0) {
				System.out.println("User registered successfully.");
				return true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public User getUserEmail(String email) {
		User u = null;
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(USER_BY_EMAIL) : null) {
			if (pt == null) return null;
			pt.setString(1, email);
			try (ResultSet res = pt.executeQuery()) {
				if (res.next()) {
					int id = res.getInt(1);
					String name = res.getString(2);
					String mail = res.getString(3);
					String password = res.getString(4);
					String address = res.getString(5);
					String role = res.getString(6);
					Timestamp datetime = res.getTimestamp(7);
					Timestamp login_date = res.getTimestamp(8);

					u = new User(id, name, mail, password, address, role, datetime, login_date);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return u;
	}

	@Override
	public User getUser(int id) {
		User user = null;
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(SELECT_QUERY) : null) {
			if (pt == null) return null;
			pt.setInt(1, id);
			try (ResultSet res = pt.executeQuery()) {
				user = extractUserDetails(res);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return user;
	}

	public User extractUserDetails(ResultSet res) throws SQLException {
		User user = null;
		if (res.next()) {
			int id = res.getInt(1);
			String name = res.getString(2);
			String email = res.getString(3);
			String password = res.getString(4);
			String address = res.getString(5);
			String role = res.getString(6);
			Timestamp t = res.getTimestamp(7);
			Timestamp t1 = res.getTimestamp(8);

			user = new User(id, name, email, password, address, role, t, t1);
		}
		return user;
	}

	private User listOfUser(ResultSet res) throws SQLException {
		int id = res.getInt(1);
		String name = res.getString(2);
		String email = res.getString(3);
		String password = res.getString(4);
		String address = res.getString(5);
		String role = res.getString(6);
		Timestamp t = res.getTimestamp(7);
		Timestamp t1 = res.getTimestamp(8);

		return new User(id, name, email, password, address, role, t, t1);
	}

	@Override
	public void updateUser(User user) {
		if (user == null) {
			return;
		}
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(UPDATE_USER) : null) {
			if (pt == null) return;
			pt.setString(1, user.getName());
			pt.setString(2, user.getAddress());
			pt.setInt(3, user.getId());
			pt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deleteUser(int id) {
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(DELETE_USER) : null) {
			if (pt == null) return;
			pt.setInt(1, id);
			pt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<User> getAllUser() {
		ArrayList<User> all = new ArrayList<>();
		try (Connection con = DBConnection.getConnection();
		     Statement st = con != null ? con.createStatement() : null;
		     ResultSet res = st != null ? st.executeQuery(QUERY) : null) {
			if (res == null) return all;
			while (res.next()) {
				User user = listOfUser(res);
				all.add(user);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return all;
	}
}

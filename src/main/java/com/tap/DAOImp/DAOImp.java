package com.tap.DAOImp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.MenuDAO;
import com.tap.model.MenuData;
import com.tap.model.ResDetails;
import com.tap.util.DBConnection;

public class DAOImp implements MenuDAO {

	private static final String INSERT_QUERY = "insert into menu(res_id,item_name,description,price,IsAvailable,category,imagePath,createdAt,updateAt,deletedAt) "
			+ "values(?,?,?,?,?,?,?,?,?,?)";

	private static final String SELECT_ID = "select * from menu where menu_id=?";
	private static final String UPDATE_QUERY = "update menu set category=? where menu_id=?";
	private static final String DELETE_QUERY = "delete from menu where menu_id=?";
	private static final String QUERY = "select * from menu";
	private static final String IDQUERY = "SELECT * FROM menu WHERE res_id = ?";

	@Override
	public void addMenu(MenuData menu, ResDetails res) {
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(INSERT_QUERY) : null) {
			if (pt == null) return;
			int res1 = res.getId();
			pt.setInt(1, res1);
			pt.setString(2, menu.getItemName());
			pt.setString(3, menu.getDesc());
			pt.setDouble(4, menu.getPrice());
			pt.setString(5, menu.getIsAvailable());
			pt.setString(6, menu.getCategory());
			pt.setString(7, menu.getImagePath());
			pt.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
			pt.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now()));
			pt.setTimestamp(10, null);

			int i = pt.executeUpdate();
			System.out.print(i + " row affected");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public MenuData MenuAll(ResultSet res) {
		MenuData m = null;
		try {
			if (res.next()) {
				int id = res.getInt(1);
				int res_id = res.getInt(2);
				String item = res.getString(3);
				String desc = res.getString(4);
				double price = res.getDouble(5);
				String isavail = res.getString(6);
				String category = res.getString(7);
				String image = res.getString(8);
				Timestamp create = res.getTimestamp(9);
				Timestamp update = res.getTimestamp(10);
				Timestamp delete = res.getTimestamp(11);

				LocalDateTime createdAt = create != null ? create.toLocalDateTime() : null;
				LocalDateTime updateAt = update != null ? update.toLocalDateTime() : null;
				LocalDateTime deletedAt = delete != null ? delete.toLocalDateTime() : null;

				m = new MenuData(id, res_id, item, desc, price, isavail, category, image, createdAt, updateAt, deletedAt);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return m;
	}

	@Override
	public MenuData getMenu(int id) {
		MenuData m = null;
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(SELECT_ID) : null) {
			if (pt == null) return null;
			pt.setInt(1, id);
			try (ResultSet res = pt.executeQuery()) {
				m = MenuAll(res);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return m;
	}

	@Override
	public void updateMenu(MenuData menu) {
		if (menu == null) return;
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(UPDATE_QUERY) : null) {
			if (pt == null) return;
			pt.setString(1, menu.getCategory());
			pt.setInt(2, menu.getId());
			int i = pt.executeUpdate();
			System.out.print(i + " updated");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deleteMenu(int id) {
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(DELETE_QUERY) : null) {
			if (pt == null) return;
			pt.setInt(1, id);
			int i = pt.executeUpdate();
			System.out.print(i + " deleted");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<MenuData> getAllMenu() {
		ArrayList<MenuData> all = new ArrayList<>();
		try (Connection con = DBConnection.getConnection();
		     Statement st = con != null ? con.createStatement() : null;
		     ResultSet res = st != null ? st.executeQuery(QUERY) : null) {
			if (res == null) return all;
			while (res.next()) {
				MenuData m = MenuAll1(res);
				all.add(m);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return all;
	}

	public MenuData MenuAll1(ResultSet res) throws SQLException {
		int id = res.getInt(1);
		int res_id = res.getInt(2);
		String item = res.getString(3);
		String desc = res.getString(4);
		double price = res.getDouble(5);
		String isavail = res.getString(6);
		String category = res.getString(7);
		String image = res.getString(8);
		Timestamp create = res.getTimestamp(9);
		Timestamp update = res.getTimestamp(10);
		Timestamp delete = res.getTimestamp(11);

		LocalDateTime createdAt = create != null ? create.toLocalDateTime() : null;
		LocalDateTime updateAt = update != null ? update.toLocalDateTime() : null;
		LocalDateTime deletedAt = delete != null ? delete.toLocalDateTime() : null;

		return new MenuData(id, res_id, item, desc, price, isavail, category, image, createdAt, updateAt, deletedAt);
	}

	@Override
	public List<MenuData> getMenuByRestaurant(int resId) {
		List<MenuData> menuList = new ArrayList<>();
		try (Connection con = DBConnection.getConnection();
		     PreparedStatement pt = con != null ? con.prepareStatement(IDQUERY) : null) {
			if (pt == null) return menuList;
			pt.setInt(1, resId);
			try (ResultSet rs = pt.executeQuery()) {
				while (rs.next()) {
					int id = rs.getInt(1);
					int restaurantId = rs.getInt(2);
					String itemName = rs.getString(3);
					String description = rs.getString(4);
					double price = rs.getDouble(5);
					String isAvailable = rs.getString(6);
					String category = rs.getString(7);
					String image = rs.getString(8);
					Timestamp create = rs.getTimestamp(9);
					Timestamp update = rs.getTimestamp(10);
					Timestamp delete = rs.getTimestamp(11);

					LocalDateTime createdAt = create != null ? create.toLocalDateTime() : null;
					LocalDateTime updateAt = update != null ? update.toLocalDateTime() : null;
					LocalDateTime deletedAt = delete != null ? delete.toLocalDateTime() : null;

					MenuData menu = new MenuData(
							id, restaurantId, itemName, description, price, isAvailable, category, image,
							createdAt, updateAt, deletedAt
					);
					menuList.add(menu);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return menuList;
	}
}

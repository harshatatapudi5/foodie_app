package com.tap.DAO;


import java.util.List;

import com.tap.model.MenuData;
import com.tap.model.ResDetails;
//import com.tap.model.User;


public interface MenuDAO {

	void addMenu(MenuData menu,ResDetails res);
	MenuData getMenu(int id);
	void updateMenu(MenuData menu);
	void deleteMenu(int id);
	List<MenuData> getAllMenu();
	List<MenuData> getMenuByRestaurant(int resId);
}

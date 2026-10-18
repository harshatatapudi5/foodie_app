package com.tap.DAO;

import com.tap.model.User;
import java.util.List;


public interface UserDAO {
	
	boolean addUser(User user);
	User getUserEmail(String email);
	User getUser(int id);
	void updateUser(User user);
	void deleteUser(int id);
	List<User> getAllUser();
}

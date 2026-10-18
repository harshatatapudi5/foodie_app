package com.tap.DAO;

import com.tap.model.ResDetails;
import com.tap.model.User;
import java.util.List;



public interface ResDAO {
	
	
	void addRes(ResDetails res,User user);
	ResDetails getRes(int id);
	void updateRes(ResDetails res);
	void deleteRes(int id);
	List<ResDetails> getAllRes();
	
	
}


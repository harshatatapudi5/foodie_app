package com.tap.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.tap.DAOImp.DAOImpRes;
import com.tap.model.ResDetails;


@WebServlet("/restaurant")
public class RestaurantController extends HttpServlet{
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {

		
		DAOImpRes re=new DAOImpRes();
		List<ResDetails> allrestaurants=re.getAllRes();
		req.setAttribute("restaurant", allrestaurants);
		
		RequestDispatcher rd=req.getRequestDispatcher("restaurant.jsp");
		rd.forward(req, res);
		
	}
}

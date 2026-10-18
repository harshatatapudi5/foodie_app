package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.DAOImp.DAOImp;
import com.tap.DAOImp.DAOImpRes;
import com.tap.model.MenuData;
import com.tap.model.ResDetails;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuController extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws IOException, ServletException {

        String resIdParameter = req.getParameter("resId");

        if (resIdParameter == null || resIdParameter.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/restaurant");
            return;
        }

        try {
            int resId = Integer.parseInt(resIdParameter);

            DAOImp menuDAO = new DAOImp();
            List<MenuData> menu = menuDAO.getMenuByRestaurant(resId);

            DAOImpRes resDAO = new DAOImpRes();
            ResDetails restaurant = resDAO.getRes(resId);

            req.setAttribute("allMenu", menu);
            req.setAttribute("restaurant", restaurant);
            req.setAttribute("resId", resId);

            RequestDispatcher rd = req.getRequestDispatcher("/menu.jsp");
            rd.forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/restaurant");
        }
    }
}
package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.DAO.OrderDAO;
import com.tap.DAO.UserDAO;
import com.tap.DAOImp.OrdersDAOImpl;
import com.tap.DAOImp.UserDAOImp;
import com.tap.model.OrdersDetails;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    private UserDAO userDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImp();
        orderDAO = new OrdersDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        User freshUser = userDAO.getUserEmail(sessionUser.getEmail());
        if (freshUser != null) {
            sessionUser = freshUser;
            session.setAttribute("user", freshUser);
        }

        List<OrdersDetails> userOrders = orderDAO.getOrdersByUser(sessionUser.getId());
        int totalOrders = (userOrders != null) ? userOrders.size() : 0;
        double totalSpent = 0.0;
        if (userOrders != null) {
            for (OrdersDetails o : userOrders) {
                totalSpent += o.getTotalamount();
            }
        }

        req.setAttribute("user", sessionUser);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("totalSpent", totalSpent);
        req.setAttribute("orders", userOrders);

        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String name = req.getParameter("name");
        String address = req.getParameter("address");

        if (name != null && !name.trim().isEmpty()) {
            user.setName(name.trim());
        }
        if (address != null && !address.trim().isEmpty()) {
            user.setAddress(address.trim());
        }

        userDAO.updateUser(user);
        session.setAttribute("user", user);
        session.setAttribute("profileMessage", "Profile updated successfully!");

        resp.sendRedirect(req.getContextPath() + "/profile");
    }
}


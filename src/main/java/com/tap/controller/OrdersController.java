
package com.tap.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.DAO.OrderDAO;
import com.tap.DAO.OrderItemDAO;
import com.tap.DAOImp.DAOImp;
import com.tap.DAOImp.DAOImpRes;
import com.tap.DAOImp.OItemDAOImp;
import com.tap.DAOImp.OrdersDAOImpl;

import com.tap.model.MenuData;
import com.tap.model.OrderItem;
import com.tap.model.OrdersDetails;
import com.tap.model.ResDetails;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrdersController extends HttpServlet {

    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;
    private DAOImp menuDAO;
    private DAOImpRes restaurantDAO;

    // Initialize DAO objects once when the servlet starts.
    @Override
    public void init() throws ServletException {

        orderDAO = new OrdersDAOImpl();
        orderItemDAO = new OItemDAOImp();
        menuDAO = new DAOImp();
        restaurantDAO = new DAOImpRes();
    }

    // Handle the Orders page, View Details, and Track Order.
    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Check whether the user is logged in.
        User user = (session == null)
                ? null
                : (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(
                    req.getContextPath() + "/login.jsp");
            return;
        }

        // 1. Track Order
        String trackOrderId =
                req.getParameter("trackOrderId");

        if (trackOrderId != null
                && !trackOrderId.trim().isEmpty()) {

            showOrderTracking(
                    req, resp, user, trackOrderId);

            return;
        }

        // 2. View Details
        String orderId =
                req.getParameter("orderId");

        if (orderId != null
                && !orderId.trim().isEmpty()) {

            showOrderDetails(
                    req, resp, user, orderId);

            return;
        }

        // 3. Otherwise display all the user's orders.
        showAllOrders(req, resp, user);
    }

    // ---------------------------------------------------------
    // DISPLAY ALL ORDERS
    // ---------------------------------------------------------
    private void showAllOrders(
            HttpServletRequest req,
            HttpServletResponse resp,
            User user)
            throws ServletException, IOException {

        List<OrdersDetails> orders =
                orderDAO.getOrdersByUser(user.getId());

        if (orders == null) {
            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to retrieve orders.");
            return;
        }

        Map<Integer, List<OrderItem>> orderItemsMap =
                new HashMap<>();

        Map<Integer, MenuData> menuMap =
                new HashMap<>();

        Map<Integer, ResDetails> restaurantMap =
                new HashMap<>();

        // Load the items, menu information, and restaurant
        // for each order.
        for (OrdersDetails order : orders) {

            int orderId = order.getOders_id();

            List<OrderItem> orderItems =
                    orderItemDAO.getOrderItemsByOrder(orderId);

            if (orderItems == null) {
                continue;
            }

            orderItemsMap.put(orderId, orderItems);

            for (OrderItem item : orderItems) {

                int menuId = item.getM_id();

                if (!menuMap.containsKey(menuId)) {

                    MenuData menu =
                            menuDAO.getMenu(menuId);

                    if (menu != null) {
                        menuMap.put(menuId, menu);
                    }
                }
            }

            int restaurantId = order.getRes_id();

            if (!restaurantMap.containsKey(restaurantId)) {

                ResDetails restaurant =
                        restaurantDAO.getRes(restaurantId);

                if (restaurant != null) {
                    restaurantMap.put(
                            restaurantId, restaurant);
                }
            }
        }

        req.setAttribute("orders", orders);
        req.setAttribute("orderItemsMap", orderItemsMap);
        req.setAttribute("menuMap", menuMap);
        req.setAttribute("restaurantMap", restaurantMap);

        req.getRequestDispatcher("/orders.jsp")
           .forward(req, resp);
    }

    // ---------------------------------------------------------
    // VIEW ONE ORDER'S DETAILS
    // ---------------------------------------------------------
    private void showOrderDetails(
            HttpServletRequest req,
            HttpServletResponse resp,
            User user,
            String orderIdParameter)
            throws ServletException, IOException {

        int orderId;

        try {
            orderId = Integer.parseInt(orderIdParameter);

            if (orderId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {

            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid order ID.");
            return;
        }

        OrdersDetails order = orderDAO.getOrder(orderId);

        // Check that the order exists.
        if (order == null) {
            resp.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Order not found.");
            return;
        }

        // Prevent users from viewing another user's order.
        if (order.getUser_id() != user.getId()) {
            resp.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You cannot view this order.");
            return;
        }

        List<OrderItem> orderItems =
                orderItemDAO.getOrderItemsByOrder(orderId);

        if (orderItems == null) {
            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to retrieve order items.");
            return;
        }

        Map<Integer, MenuData> menuMap =
                new HashMap<>();

        for (OrderItem item : orderItems) {

            int menuId = item.getM_id();

            if (!menuMap.containsKey(menuId)) {

                MenuData menu = menuDAO.getMenu(menuId);

                if (menu != null) {
                    menuMap.put(menuId, menu);
                }
            }
        }

        ResDetails restaurant =
                restaurantDAO.getRes(order.getRes_id());

        req.setAttribute("order", order);
        req.setAttribute("orderItems", orderItems);
        req.setAttribute("menuMap", menuMap);
        req.setAttribute("restaurant", restaurant);

        req.getRequestDispatcher("/Foodie/order-details.jsp")
        .forward(req, resp);
    }

    // ---------------------------------------------------------
    // TRACK ONE ORDER
    // ---------------------------------------------------------
    private void showOrderTracking(
            HttpServletRequest req,
            HttpServletResponse resp,
            User user,
            String orderIdParameter)
            throws ServletException, IOException {

        int orderId;

        try {
            orderId = Integer.parseInt(orderIdParameter);

            if (orderId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {

            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid order ID.");
            return;
        }

        // Retrieve the order from the database.
        OrdersDetails order = orderDAO.getOrder(orderId);

        if (order == null) {
            resp.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Order not found.");
            return;
        }

        // Users may track only their own orders.
        if (order.getUser_id() != user.getId()) {
            resp.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You cannot track this order.");
            return;
        }

        // Provide the order to the tracking JSP.
        req.setAttribute("order", order);

        req.getRequestDispatcher("/order-tracking.jsp")
           .forward(req, resp);
    }
}


package com.tap.controller;

import java.io.IOException;
import java.util.Map;

import com.tap.DAO.OrderDAO;
import com.tap.DAO.OrderItemDAO;
import com.tap.DAOImp.OItemDAOImp;
import com.tap.DAOImp.OrdersDAOImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
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

@WebServlet("/payment")
public class PaymentController extends HttpServlet {

    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrdersDAOImpl();
        orderItemDAO = new OItemDAOImp();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        req.setAttribute("cart", cart);
        req.getRequestDispatcher("/payment.jsp").forward(req, resp);
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
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // Check if delivery details are being saved from checkout page
        String fromCheckout = req.getParameter("fromCheckout");
        if ("true".equalsIgnoreCase(fromCheckout)) {
            session.setAttribute("checkout_name", req.getParameter("name"));
            session.setAttribute("checkout_phone", req.getParameter("phone"));
            session.setAttribute("checkout_address", req.getParameter("address"));
            session.setAttribute("checkout_city", req.getParameter("city"));
            session.setAttribute("checkout_pincode", req.getParameter("pincode"));
            session.setAttribute("checkout_instructions", req.getParameter("instructions"));
            session.setAttribute("checkout_deliveryType", req.getParameter("deliveryType"));

            resp.sendRedirect(req.getContextPath() + "/payment");
            return;
        }

        // Process final payment & place order
        String paymentMethod = req.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "Cash on Delivery";
        }

        String name = (String) session.getAttribute("checkout_name");
        String phone = (String) session.getAttribute("checkout_phone");
        String address = (String) session.getAttribute("checkout_address");
        String city = (String) session.getAttribute("checkout_city");
        String pincode = (String) session.getAttribute("checkout_pincode");
        String deliveryType = (String) session.getAttribute("checkout_deliveryType");

        if (name == null || name.trim().isEmpty()) name = user.getName();
        if (address == null || address.trim().isEmpty()) address = user.getAddress();
        if (city == null || city.trim().isEmpty()) city = "Hyderabad";
        if (pincode == null || pincode.trim().isEmpty()) pincode = "500081";

        double deliveryFee = "express".equalsIgnoreCase(deliveryType) ? 70.0 : 40.0;
        double platformFee = 5.0;
        double itemTotal = cart.getTotal();
        double finalTotal = itemTotal + deliveryFee + platformFee;

        try {
            int restaurantId = cart.getRes_id();
            ResDetails restaurant = new ResDetails(restaurantId);

            OrdersDetails order = new OrdersDetails(
                    user.getId(),
                    restaurantId,
                    finalTotal,
                    "Pending",
                    paymentMethod
            );

            orderDAO.addOrders(order, user, restaurant);
            int orderId = order.getOders_id();

            if (orderId > 0) {
                for (Map.Entry<Integer, CartItem> entry : cart.getItems().entrySet()) {
                    CartItem cartItem = entry.getValue();
                    MenuData menu = cartItem.getMenu();

                    OrderItem orderItem = new OrderItem(
                            orderId,
                            menu.getId(),
                            cartItem.getQuantity(),
                            cartItem.getSubtotal()
                    );
                    orderItemDAO.addOrderItem(orderItem, order, menu);
                }

                session.setAttribute("lastOrderId", orderId);
                session.setAttribute("lastOrderName", name);
                session.setAttribute("lastOrderPhone", phone);
                session.setAttribute("lastOrderAddress", address);
                session.setAttribute("lastOrderCity", city);
                session.setAttribute("lastOrderPincode", pincode);
                session.setAttribute("lastOrderPayment", paymentMethod);
                session.setAttribute("lastOrderTotal", finalTotal);

                cart.clear();

                resp.sendRedirect(req.getContextPath() + "/orders?trackOrderId=" + orderId);
            } else {
                throw new IllegalStateException("Failed to generate order ID");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Could not complete order. Please try again.");
            req.setAttribute("cart", cart);
            req.getRequestDispatcher("/payment.jsp").forward(req, resp);
        }
    }
}


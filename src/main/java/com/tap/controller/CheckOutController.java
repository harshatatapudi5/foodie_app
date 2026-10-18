
package com.tap.controller;

import java.io.IOException;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.DAO.OrderDAO;
import com.tap.DAO.OrderItemDAO;
import com.tap.DAOImp.OrdersDAOImpl;
import com.tap.DAOImp.OItemDAOImp;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.MenuData;
import com.tap.model.OrderItem;
import com.tap.model.OrdersDetails;
import com.tap.model.ResDetails;
import com.tap.model.User;

@WebServlet("/checkout")
public class CheckOutController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrdersDAOImpl();
        orderItemDAO = new OItemDAOImp();
    }

    // Open the checkout page
    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        if (cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        req.setAttribute("cart", cart);
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    // Place the order
    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            showCheckoutError(
                    req, resp,
                    "Your cart is empty. Please add food before placing an order.",
                    cart);
            return;
        }

        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String pincode = req.getParameter("pincode");
        String paymentMethod = req.getParameter("paymentMethod");

        // Validate required fields on the server
        if (isBlank(name) || isBlank(phone) || isBlank(address)
                || isBlank(city) || isBlank(pincode)
                || isBlank(paymentMethod)) {

            showCheckoutError(
                    req, resp,
                    "Please complete all delivery and payment fields.",
                    cart);
            return;
        }

        phone = phone.trim();
        pincode = pincode.trim();

        if (!phone.matches("[0-9]{10}")) {
            showCheckoutError(
                    req, resp,
                    "Please enter a valid 10-digit phone number.",
                    cart);
            return;
        }

        if (!pincode.matches("[0-9]{6}")) {
            showCheckoutError(
                    req, resp,
                    "Please enter a valid 6-digit pincode.",
                    cart);
            return;
        }

        if (!paymentMethod.equals("UPI")
                && !paymentMethod.equals("Card")
                && !paymentMethod.equals("Cash on Delivery")) {

            showCheckoutError(
                    req, resp,
                    "Please select a valid payment method.",
                    cart);
            return;
        }

        try {
            int restaurantId = cart.getRes_id();

            double itemTotal = cart.getTotal();
            double deliveryFee = 40.0;
            double finalTotal = itemTotal + deliveryFee;

            ResDetails restaurant = new ResDetails(restaurantId);

            // Create the order with Pending status
            OrdersDetails order = new OrdersDetails(
                    user.getId(),
                    restaurantId,
                    finalTotal,
                    "Pending",
                    paymentMethod
            );

            // Save the order. DAO must set the generated order ID
            // on this same order object.
            orderDAO.addOrders(order, user, restaurant);

            int orderId = order.getOders_id();

            if (orderId <= 0) {
                throw new IllegalStateException(
                        "The order was saved without a generated order ID. "
                        + "Check OrdersDAOImpl.addOrders().");
            }

            // Save each item belonging to this order
            for (Map.Entry<Integer, CartItem> entry
                    : cart.getItems().entrySet()) {

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

            // Save delivery information for the success page
            session.setAttribute("lastOrderId", orderId);
            session.setAttribute("lastOrderName", name.trim());
            session.setAttribute("lastOrderPhone", phone);
            session.setAttribute("lastOrderAddress", address.trim());
            session.setAttribute("lastOrderCity", city.trim());
            session.setAttribute("lastOrderPincode", pincode);
            session.setAttribute("lastOrderPayment", paymentMethod);
            session.setAttribute("lastOrderTotal", finalTotal);

            // Save address only when checkbox is selected
            if ("true".equals(req.getParameter("saveAddress"))) {
                session.setAttribute("savedAddress", address.trim());
                session.setAttribute("savedCity", city.trim());
                session.setAttribute("savedPincode", pincode);
            }

            // Clear the cart after the order and items are saved
            cart.clear();

            // Forward to the JSP at src/main/webapp/order-success.jsp
            req.getRequestDispatcher("/order-success.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();

            showCheckoutError(
                    req, resp,
                    "We could not complete your order. Please check the server "
                    + "console and try again.",
                    cart);
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void showCheckoutError(
            HttpServletRequest req,
            HttpServletResponse resp,
            String message,
            Cart cart) throws ServletException, IOException {

        req.setAttribute("error", message);
        req.setAttribute("cart", cart);

        req.getRequestDispatcher("/checkout.jsp")
           .forward(req, resp);
    }
}

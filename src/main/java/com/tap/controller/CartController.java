package com.tap.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.DAOImp.DAOImp;
import com.tap.model.Cart;
import com.tap.model.MenuData;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    private DAOImp menuDAO;

    @Override
    public void init() throws ServletException {
        menuDAO = new DAOImp();
    }

    @Override
    protected void doPost(HttpServletRequest req,
                           HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        String menuIdParameter = req.getParameter("menuId");

        String resIdParameter = req.getParameter("resId");

        String redirect = req.getParameter("redirect");


        HttpSession session = req.getSession();


        // Get existing cart from session

        Cart cart = (Cart) session.getAttribute("cart");


        // If cart doesn't exist, create it

        if (cart == null) {

            cart = new Cart();

            session.setAttribute("cart", cart);
        }


        // =====================================================
        // ADD ITEM
        // =====================================================

        if (action == null || action.equals("add")) {

            if (menuIdParameter == null ||
                menuIdParameter.isEmpty()) {

                resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Menu ID is required"
                );

                return;
            }


            int menuId = Integer.parseInt(menuIdParameter);


            // Get menu item from database

            MenuData menu = menuDAO.getMenu(menuId);


            if (menu == null) {

                resp.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Menu item not found"
                );

                return;
            }


            // Add item to cart

            boolean added = cart.addItem(menu);


            if (added) {

                session.setAttribute(
                    "cartMessage",
                    menu.getItemName() + " added to cart."
                );

            } else {

                session.setAttribute(
                    "cartMessage",
                    "You can order from only one restaurant at a time."
                );
            }

        }


        // =====================================================
        // INCREASE QUANTITY
        // =====================================================

        else if (action.equals("increase")) {

            if (menuIdParameter != null &&
                !menuIdParameter.isEmpty()) {

                int menuId = Integer.parseInt(menuIdParameter);

                cart.increaseQuantity(menuId);
            }

        }


        // =====================================================
        // DECREASE QUANTITY
        // =====================================================

        else if (action.equals("decrease")) {

            if (menuIdParameter != null &&
                !menuIdParameter.isEmpty()) {

                int menuId = Integer.parseInt(menuIdParameter);

                cart.decreaseQuantity(menuId);
            }

        }


        // =====================================================
        // REMOVE ITEM
        // =====================================================

        else if (action.equals("remove")) {

            if (menuIdParameter != null &&
                !menuIdParameter.isEmpty()) {

                int menuId = Integer.parseInt(menuIdParameter);

                cart.removeItem(menuId);
            }

        }


        // Save updated cart

        session.setAttribute("cart", cart);


        // =====================================================
        // REDIRECT
        // =====================================================

        /*
         * If the request came from Menu page,
         * return to Menu page.
         */

        if ("menu".equalsIgnoreCase(redirect)) {

            if (resIdParameter != null &&
                !resIdParameter.isEmpty()) {

                resp.sendRedirect(
                    req.getContextPath()
                    + "/menu?resId="
                    + resIdParameter
                );

            } else {

                resp.sendRedirect(
                    req.getContextPath()
                    + "/menu"
                );
            }

            return;
        }


        /*
         * Otherwise return to Cart page.
         */

        resp.sendRedirect(
            req.getContextPath() + "/cart"
        );
    }


    // =========================================================
    // OPEN CART PAGE
    // =========================================================

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();


        Cart cart = (Cart) session.getAttribute("cart");


        if (cart == null) {

            cart = new Cart();

            session.setAttribute("cart", cart);
        }


        req.setAttribute("cart", cart);


        req.getRequestDispatcher("/cart.jsp")
           .forward(req, resp);
    }
}
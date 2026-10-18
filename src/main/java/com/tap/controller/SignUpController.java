package com.tap.controller;

import java.io.IOException;

import com.tap.DAOImp.UserDAOImp;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;




@WebServlet("/signup")
public class SignUpController extends HttpServlet {

    private UserDAOImp userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImp();
    }

    @Override
    protected void doPost(HttpServletRequest req,
                           HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword =
                req.getParameter("confirmPassword");
        String address = req.getParameter("address");

        // Check password confirmation
        if (password == null ||
            !password.equals(confirmPassword)) {

            req.setAttribute(
                "error",
                "Passwords do not match."
            );

            req.getRequestDispatcher("/signup.jsp")
               .forward(req, resp);

            return;
        }

        // Check if email already exists
        User existingUser =
                userDAO.getUserEmail(email);

        if (existingUser != null) {

            req.setAttribute(
                "error",
                "Email is already registered."
            );

            req.getRequestDispatcher("/signup.jsp")
               .forward(req, resp);

            return;
        }

        /*
         * Create User object.
         *
         * IMPORTANT:
         * At this point password is still plain text.
         *
         * BCrypt hashing happens inside addUser().
         */
        User user = new User();

        user.setName(name);
        user.setEmail(email);
        user.setPassWord(password);
        user.setAddress(address);
        user.setRole("customer");

        boolean added =
                userDAO.addUser(user);

        if (added) {

            // Automatically login after signup
            User savedUser =
                    userDAO.getUserEmail(email);

            HttpSession session =
                    req.getSession();

            session.setAttribute(
                "user",
                savedUser
            );

            resp.sendRedirect(
                req.getContextPath() + "/restaurant"
            );

        } else {

            req.setAttribute(
                "error",
                "Account creation failed. Please try again."
            );

            req.getRequestDispatcher("/signup.jsp")
               .forward(req, resp);
        }
    }
}
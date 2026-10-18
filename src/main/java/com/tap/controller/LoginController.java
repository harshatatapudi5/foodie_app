package com.tap.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.DAOImp.UserDAOImp;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private UserDAOImp userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImp();
    }

    @Override
    protected void doPost(HttpServletRequest req,
                           HttpServletResponse resp)
            throws ServletException, IOException {

        String email =
                req.getParameter("email");

        String password =
                req.getParameter("password");

        User user =
                userDAO.getUserEmail(email);

        // User doesn't exist
        if (user == null) {

            req.setAttribute(
                "error",
                "Invalid email or password."
            );

            req.getRequestDispatcher("/login.jsp")
               .forward(req, resp);

            return;
        }

        /*
         * Password entered on login page
         */
        String enteredPassword = password;

        /*
         * BCrypt hash stored in MySQL
         */
        String storedHash =
                user.getPassWord();

        /*
         * Compare entered password with stored hash or plaintext fallback safely
         */
        boolean passwordMatched = false;
        try {
            if (storedHash != null && (storedHash.startsWith("$2a$") || storedHash.startsWith("$2b$") || storedHash.startsWith("$2y$"))) {
                passwordMatched = BCrypt.checkpw(enteredPassword, storedHash);
            } else {
                passwordMatched = (storedHash != null && storedHash.equals(enteredPassword));
            }
        } catch (Exception e) {
            passwordMatched = (storedHash != null && storedHash.equals(enteredPassword));
        }

        if (passwordMatched) {

            System.out.println(
                "Login successful for: " + email
            );

            HttpSession session =
                    req.getSession();

            session.setAttribute(
                "user",
                user
            );

            resp.sendRedirect(
                req.getContextPath() + "/restaurant"
            );

        } else {

            System.out.println(
                "Invalid password for: " + email
            );

            req.setAttribute(
                "error",
                "Invalid email or password."
            );

            req.getRequestDispatcher("/login.jsp")
               .forward(req, resp);
        }
    }
}
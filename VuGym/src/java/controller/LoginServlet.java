package controller;

import Dao.NguoiDungDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Model.NguoiDung;

@WebServlet(name="LoginServlet", urlPatterns={"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String roleId = request.getParameter("roleId"); 
        String remember = request.getParameter("remember");

        NguoiDungDAO dao = new NguoiDungDAO();
        NguoiDung user = dao.checkLoginWithRole(username, password, roleId);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getMaNguoiDung());
            session.setAttribute("fullName", user.getHoTen());
            session.setAttribute("roleId", user.getMaNhom());

            Cookie userCookie = new Cookie("saved_user", username);
            if (remember != null) {
                userCookie.setMaxAge(604800); 
            } else {
                userCookie.setMaxAge(0);
            }
            userCookie.setPath(request.getContextPath());
            response.addCookie(userCookie);

            if (user.getMaNhom() == 1 || user.getMaNhom() == 2) {

                response.sendRedirect("HLVServlet");
            } else if (user.getMaNhom() == 3) {
                request.getRequestDispatcher("main.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Tài khoản, mật khẩu không đúng hoặc không khớp vai trò!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Login Controller for VUXGYM";
    }
}
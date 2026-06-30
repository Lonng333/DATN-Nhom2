package controller;

import Dao.KhachHangDAO;
import Model.KhachHang;
import java.io.IOException;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "KhachHangServlet", urlPatterns = {"/KhachHangServlet"})
public class KhachHangServlet extends HttpServlet {

    KhachHangDAO dao = new KhachHangDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action != null) {
            if (action.equals("load")) {
                long id = Long.parseLong(request.getParameter("id"));
                KhachHang khSelected = null;
                for (KhachHang kh : dao.getAll()) {
                    if (kh.getMaKhachHang() == id) {
                        khSelected = kh;
                        break;
                    }
                }
                request.setAttribute("khSelected", khSelected);
            } else if (action.equals("delete")) {
                long id = Long.parseLong(request.getParameter("id"));
                dao.delete(id);
                request.setAttribute("success", "Xóa khách hàng thành công!");
            }
        }
        
        request.setAttribute("LIST_KH", dao.getAll());
        request.getRequestDispatcher("./main.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        String action = request.getParameter("action");
        
        try {
            String idRaw = request.getParameter("id");
            String ten = request.getParameter("hoTen");
            String gioiTinh = request.getParameter("gioiTinh");
            Date ngaySinh = Date.valueOf(request.getParameter("ngaySinh"));
            String sdt = request.getParameter("sdt");
            String email = request.getParameter("email");
            String diaChi = request.getParameter("diaChi");
            String pt = request.getParameter("pt");
            String goiTap = request.getParameter("goiTap");
            Date hanSuDung = Date.valueOf(request.getParameter("hanSuDung"));
            String trangThai = request.getParameter("trangThai");

            if (action.equals("add")) {
                dao.addToList(new KhachHang(0, ten, gioiTinh, ngaySinh, sdt, email, diaChi, pt, goiTap, hanSuDung, trangThai));
                request.setAttribute("success", "Thêm khách hàng thành công!");
                
            } else if (action.equals("edit")) {
                long id = Long.parseLong(idRaw);
                if (!dao.checkID(id)) {
                    request.setAttribute("error", "Mã khách hàng không tồn tại để sửa!");
                } else {
                    dao.edit(new KhachHang(id, ten, gioiTinh, ngaySinh, sdt, email, diaChi, pt, goiTap, hanSuDung, trangThai));
                    request.setAttribute("success", "Cập nhật thành công!");
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Vui lòng kiểm tra lại định dạng dữ liệu!");
        }
        
        request.setAttribute("LIST_KH", dao.getAll());
        request.getRequestDispatcher("./main.jsp").forward(request, response);
    }
}
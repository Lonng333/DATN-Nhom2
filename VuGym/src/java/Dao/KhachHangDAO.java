package Dao;

import java.util.*;
import java.sql.*;
import Model.KhachHang;
import KetNoi.DBConnect;

public class KhachHangDAO {

    List<KhachHang> list = new ArrayList<>();

    // 1. Lấy toàn bộ danh sách khách hàng
    public List<KhachHang> getAll(){
        list.clear(); 
        String sql = "SELECT * FROM KhachHang";
        Connection conn = DBConnect.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {                
                long maKhachHang = rs.getLong("MaKhachHang");
                String hoTen = rs.getString("HoTen");
                String gioiTinh = rs.getString("GioiTinh");
                java.sql.Date ngaySinh = rs.getDate("NgaySinh");
                String soDienThoai = rs.getString("SoDienThoai");
                String email = rs.getString("Email");
                String diaChi = rs.getString("DiaChi");
                String ptPhuTrach = rs.getString("PTPhuTrach");
                String goiTap = rs.getString("GoiTap");
                java.sql.Date hanSuDung = rs.getDate("HanSuDung");
                String trangThai = rs.getString("TrangThai");
                
                list.add(new KhachHang(maKhachHang, hoTen, gioiTinh, ngaySinh, soDienThoai, email, diaChi, ptPhuTrach, goiTap, hanSuDung, trangThai));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Thêm mới khách hàng (Bỏ cột MaKhachHang vì dùng tự tăng)
    public void addToList(KhachHang kh){
        String sql = "INSERT INTO KhachHang (HoTen, GioiTinh, NgaySinh, SoDienThoai, Email, DiaChi, PTPhuTrach, GoiTap, HanSuDung, TrangThai) VALUES(?,?,?,?,?,?,?,?,?,?)";
        Connection conn = DBConnect.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, kh.getHoTen());
            ps.setString(2, kh.getGioiTinh());
            ps.setDate(3, kh.getNgaySinh());
            ps.setString(4, kh.getSoDienThoai());
            ps.setString(5, kh.getEmail());
            ps.setString(6, kh.getDiaChi());
            ps.setString(7, kh.getPtPhuTrach());
            ps.setString(8, kh.getGoiTap());
            ps.setDate(9, kh.getHanSuDung());
            ps.setString(10, kh.getTrangThai());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 3. Kiểm tra trùng ID 
    public boolean checkID(long id){
        getAll(); 
        for (KhachHang kh : list) {
            if(kh.getMaKhachHang() == id){
                return true;
            }
        }
        return false;
    }

    // 4. Cập nhật thông tin khách hàng 
    public void edit(KhachHang kh){
        String sql = "UPDATE KhachHang SET HoTen = ?, GioiTinh = ?, NgaySinh = ?, SoDienThoai = ?, Email = ?, DiaChi = ?, PTPhuTrach = ?, GoiTap = ?, HanSuDung = ?, TrangThai = ? WHERE MaKhachHang = ?";
        Connection conn = DBConnect.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, kh.getHoTen());
            ps.setString(2, kh.getGioiTinh());
            ps.setDate(3, kh.getNgaySinh());
            ps.setString(4, kh.getSoDienThoai());
            ps.setString(5, kh.getEmail());
            ps.setString(6, kh.getDiaChi());
            ps.setString(7, kh.getPtPhuTrach());
            ps.setString(8, kh.getGoiTap());
            ps.setDate(9, kh.getHanSuDung());
            ps.setString(10, kh.getTrangThai());
            ps.setLong(11, kh.getMaKhachHang());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 5. Xóa khách hàng
    public void delete(long id){
        String sql = "DELETE FROM KhachHang WHERE MaKhachHang = ?";
        Connection conn = DBConnect.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
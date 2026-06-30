package Dao;

import KetNoi.DBConnect; 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import Model.NguoiDung;

public class NguoiDungDAO {

    public Connection getConnection() throws Exception {
        return DBConnect.getConnection();
    }


    public NguoiDung checkLoginWithRole(String username, String password, String roleId) {
        String sql = "SELECT MaNguoiDung, HoTen, MaNhom FROM NguoiDung WHERE TenDangNhap = ? AND MatKhau = ? AND MaNhom = ? AND TrangThai = 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, roleId); 
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    NguoiDung u = new NguoiDung();
                    u.setMaNguoiDung(rs.getLong("MaNguoiDung"));
                    u.setHoTen(rs.getString("HoTen"));
                    u.setMaNhom(Long.parseLong(rs.getString("MaNhom"))); 
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<NguoiDung> getDanhSachHLV() {
        List<NguoiDung> danhSach = new ArrayList<>();
        String sql = "SELECT MaNguoiDung, HoTen, GhiChu, TrangThai FROM NguoiDung WHERE MaNhom = '3'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                NguoiDung hlv = new NguoiDung();
                hlv.setMaNguoiDung(rs.getLong("MaNguoiDung"));
                hlv.setHoTen(rs.getString("HoTen"));
                hlv.setChuyenMon(rs.getString("GhiChu") != null ? rs.getString("GhiChu") : "Gym & Fitness");
                    hlv.setTrangThai(rs.getInt("TrangThai") == 1 ? "Đang làm" : "Nghỉ phép");

                hlv.setSoKhachHang((int) (Math.random() * 20) + 20);
                hlv.setDanhGia(4.5 + Math.random() * 0.5);

                danhSach.add(hlv);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return danhSach;
    }
}
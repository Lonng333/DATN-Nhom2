package Model;

import java.sql.Date;

public class KhachHang {

    private long maKhachHang;
    private String hoTen;
    private String gioiTinh;
    private Date ngaySinh;
    private String soDienThoai;
    private String email;
    private String diaChi;
    private String ptPhuTrach;
    private String goiTap;
    private Date hanSuDung;
    private String trangThai;

    public KhachHang() {
    }

    public KhachHang(long maKhachHang, String hoTen, String gioiTinh,
            Date ngaySinh, String soDienThoai, String email,
            String diaChi, String ptPhuTrach,
            String goiTap, Date hanSuDung,
            String trangThai) {
        this.maKhachHang = maKhachHang;
        this.hoTen = hoTen;
        this.gioiTinh = gioiTinh;
        this.ngaySinh = ngaySinh;
        this.soDienThoai = soDienThoai;
        this.email = email;
        this.diaChi = diaChi;
        this.ptPhuTrach = ptPhuTrach;
        this.goiTap = goiTap;
        this.hanSuDung = hanSuDung;
        this.trangThai = trangThai;
    }

    public long getMaKhachHang() { return maKhachHang; }
    public void setMaKhachHang(long maKhachHang) { this.maKhachHang = maKhachHang; }

    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }

    public String getGioiTinh() { return gioiTinh; }
    public void setGioiTinh(String gioiTinh) { this.gioiTinh = gioiTinh; }

    public Date getNgaySinh() { return ngaySinh; }
    public void setNgaySinh(Date ngaySinh) { this.ngaySinh = ngaySinh; }

    public String getSoDienThoai() { return soDienThoai; }
    public void setSoDienThoai(String soDienThoai) { this.soDienThoai = soDienThoai; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }

    public String getPtPhuTrach() { return ptPhuTrach; }
    public void setPtPhuTrach(String ptPhuTrach) { this.ptPhuTrach = ptPhuTrach; }

    public String getGoiTap() { return goiTap; }
    public void setGoiTap(String goiTap) { this.goiTap = goiTap; }

    public Date getHanSuDung() { return hanSuDung; }
    public void setHanSuDung(Date hanSuDung) { this.hanSuDung = hanSuDung; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
}
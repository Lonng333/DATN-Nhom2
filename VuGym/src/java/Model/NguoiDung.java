package Model;

public class NguoiDung {
    private long maNguoiDung;
    private String hoTen;
    private String tenDangNhap;
    private String matKhau;
    private long maNhom;
    private String chuyenMon;
    private String trangThai;
    private int soKhachHang; 
    private double danhGia; 


    public NguoiDung() {
    }

    public NguoiDung(long maNguoiDung, String hoTen, String tenDangNhap, String matKhau, long maNhom, String chuyenMon, String trangThai, int soKhachHang, double danhGia) {
        this.maNguoiDung = maNguoiDung;
        this.hoTen = hoTen;
        this.tenDangNhap = tenDangNhap;
        this.matKhau = matKhau;
        this.maNhom = maNhom;
        this.chuyenMon = chuyenMon;
        this.trangThai = trangThai;
        this.soKhachHang = soKhachHang;
        this.danhGia = danhGia;
    }

    // --- Hệ thống Getter và Setter ---
    public long getMaNguoiDung() {
        return maNguoiDung;
    }

    public void setMaNguoiDung(long maNguoiDung) {
        this.maNguoiDung = maNguoiDung;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getTenDangNhap() {
        return tenDangNhap;
    }

    public void setTenDangNhap(String tenDangNhap) {
        this.tenDangNhap = tenDangNhap;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }

    public long getMaNhom() {
        return maNhom;
    }

    public void setMaNhom(long maNhom) {
        this.maNhom = maNhom;
    }

    public String getChuyenMon() {
        return chuyenMon;
    }

    public void setChuyenMon(String chuyenMon) {
        this.chuyenMon = chuyenMon;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public int getSoKhachHang() {
        return soKhachHang;
    }

    public void setSoKhachHang(int soKhachHang) {
        this.soKhachHang = soKhachHang;
    }

    public double getDanhGia() {
        return danhGia;
    }

    public void setDanhGia(double danhGia) {
        this.danhGia = danhGia;
    }
}
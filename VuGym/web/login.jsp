<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - VUXGYM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root { 
            --nen-chinh: #F5F3EE; 
            --cam-vuxgym: #FF5722; 
        }
        body { 
            background-color: var(--nen-chinh); 
            font-family: 'Segoe UI', sans-serif; 
            height: 100vh; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            margin: 0; 
        }
        

        .the-dang-nhap { 
            background: #ffffff; 
            border-radius: 24px; 
            padding: 40px; 
            width: 100%; 
            max-width: 440px; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .vung-tieu-de {
            text-align: center;
            margin-bottom: 24px;
        }
        .chu-in-dam { 
            font-weight: bold; 
            margin: 0; 
        }
        .dong-chu-cam { 
            color: var(--cam-vuxgym); 
        }
        .chu-nho-mo { 
            color: #6c757d; 
            font-size: 0.875rem; 
            margin-top: 4px;
        }
        

        .o-nhap-lieu { 
            background-color: #FAFAFA; 
            border: 1px solid #E0E0E0; 
            border-radius: 12px; 
            padding: 12px 16px; 
            width: 100%;
            outline: none;
            transition: 0.2s;
        }
        .o-nhap-lieu:focus { 
            border-color: var(--cam-vuxgym); 
            box-shadow: 0 0 0 3px rgba(255, 87, 34, 0.15); 
        }
        

        .chu-nhan {
            display: block;
            font-size: 0.875rem;
            font-weight: bold;
            color: #6c757d;
            margin-bottom: 8px;
        }
        .o-khoang-cach-duoi {
            margin-bottom: 16px;
        }
        .o-khoang-cach-lon-duoi {
            margin-bottom: 24px;
        }
        

        .nut-bam-cam-lon { 
            background-color: var(--cam-vuxgym); 
            color: white; 
            border: none; 
            border-radius: 12px; 
            padding: 14px; 
            font-weight: 600; 
            width: 100%; 
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(255, 87, 34, 0.2);
            transition: 0.2s;
        }
        .nut-bam-cam-lon:hover { 
            background-color: #E64A19; 
            color: white; 
        }
        

        .cum-chon-vai-tro { 
            display: flex; 
            gap: 8px; 
            background: #F0F0F0; 
            padding: 4px; 
            border-radius: 12px; 
        }
        .o-vai-tro { 
            flex: 1; 
            text-align: center; 
        }
        .o-vai-tro input[type="radio"] { 
            display: none; 
        }
        .o-vai-tro label { 
            display: block; 
            padding: 8px 4px; 
            border-radius: 10px; 
            cursor: pointer; 
            font-size: 0.85rem; 
            font-weight: 500; 
            color: #666; 
            transition: 0.2s;
        }
        .o-vai-tro input[type="radio"]:checked + label { 
            background: #fff; 
            color: var(--cam-vuxgym); 
            box-shadow: 0 2px 6px rgba(0,0,0,0.08); 
            font-weight: 600; 
        }
        

        .dong-chan-form {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .chu-lien-ket {
            font-size: 0.875rem;
            text-decoration: none;
            color: var(--cam-vuxgym);
        }
    </style>
</head>
<body>

<div class="the-dang-nhap">
    <div class="vung-tieu-de">
        <h2 class="chu-in-dam"><span class="dong-chu-cam">VUX</span>GYM</h2>
        <p class="chu-nho-mo">Hệ thống quản lý vận hành phòng tập</p>
    </div>

    <% String error = (String) request.getAttribute("error"); 
       if(error != null) { %>
        <div class="alert alert-danger border-0 small text-center rounded-3 mb-3" style="background-color: #FFEBEB; color: #D32F2F;">
            <i class="bi bi-exclamation-circle-fill me-1"></i> <%= error %>
        </div>
    <% } %>

    <%
        String savedUsername = "";
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("saved_user")) { savedUsername = cookie.getValue(); break; }
            }
        }
    %>

    <form action="LoginServlet" method="POST">
        <div class="o-khoang-cach-lon-duoi">
            <label class="chu-nhan">Bạn là ai?</label>
            <div class="cum-chon-vai-tro">
                <div class="o-vai-tro">
                    <input type="radio" id="role-admin" name="roleId" value="1" checked>
                    <label for="role-admin">Quản trị</label>
                </div>
                <div class="o-vai-tro">
                    <input type="radio" id="role-staff" name="roleId" value="2">
                    <label for="role-staff">Lễ tân</label>
                </div>
                <div class="o-vai-tro">
                    <input type="radio" id="role-pt" name="roleId" value="3">
                    <label for="role-pt">HLV (PT)</label>
                </div>
            </div>
        </div>

        <div class="o-khoang-cach-duoi">
            <label class="chu-nhan">Tên đăng nhập</label>
            <input type="text" class="o-nhap-lieu" name="username" value="<%= savedUsername %>" required placeholder="Nhập tên tài khoản">
        </div>

        <div class="o-khoang-cach-duoi">
            <label class="chu-nhan">Mật khẩu</label>
            <input type="password" class="o-nhap-lieu" name="password" required placeholder="Nhập mật khẩu">
        </div>

        <div class="dong-chan-form o-khoang-cach-lon-duoi">
            <div class="form-check m-0">
                <input type="checkbox" class="form-check-input" id="remember" name="remember" <%= !savedUsername.isEmpty() ? "checked" : "" %>>
                <label class="form-check-label small text-muted" for="remember">Ghi nhớ</label>
            </div>
            <a href="#" class="chu-lien-ket">Quên mật khẩu?</a>
        </div>

        <button type="submit" class="nut-bam-cam-lon">Đăng nhập vào hệ thống</button>
    </form>
</div>

</body>
</html>
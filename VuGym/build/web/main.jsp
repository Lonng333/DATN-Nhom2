<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    // Bắt buộc đăng nhập: chưa có session thì đẩy về login.jsp
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String fullName = (String) session.getAttribute("fullName");
    Long roleId = (Long) session.getAttribute("roleId");

    String roleLabel = "Quản trị viên";
    String avatarInit = "QA";
    String initialMode = "admin"; // admin hoặc customer

    if (roleId != null) {
        if (roleId == 2) {
            roleLabel = "Lễ tân";
            initialMode = "admin";
        } else if (roleId == 3) {
            roleLabel = "Huấn luyện viên / Hội viên";
            initialMode = "customer";
        }
    }

    // ===== PHÂN QUYỀN THEO ROLE =====
    // 1 = Admin (toàn quyền), 2 = Lễ tân (giới hạn), 3 = PT/Khách hàng (dùng giao diện customer)
    boolean isAdmin = (roleId != null && roleId == 1);
    boolean isStaff  = (roleId != null && roleId == 2);

    boolean canViewDashboard   = isAdmin || isStaff; // Tổng quan
    boolean canManageCustomers = isAdmin || isStaff; // Khách hàng
    boolean canManageSchedule  = isAdmin || isStaff; // Lịch tập
    boolean canManageTrainers  = isAdmin;            // Huấn luyện viên
    boolean canManageRevenue   = isAdmin;            // Gói tập & Doanh thu
    boolean canViewReports     = isAdmin;            // Báo cáo & thống kê
    boolean canManageUsers     = isAdmin;            // Người dùng & phân quyền
    if (fullName != null && fullName.trim().length() > 0) {
        String[] parts = fullName.trim().split("\\s+");
        StringBuilder sb = new StringBuilder();
        for (int i = Math.max(0, parts.length - 2); i < parts.length; i++) {
            if (parts[i].length() > 0) sb.append(Character.toUpperCase(parts[i].charAt(0)));
        }
        if (sb.length() > 0) avatarInit = sb.toString();
    } else {
        fullName = "Người dùng";
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>VuxGym — Thiết kế giao diện hệ thống</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root{
                --bg-page:#F4F1EA;
                --bg-surface:#FFFFFF;
                --bg-soft:#FAF8F3;
                --ink:#1B1B1D;
                --ink-soft:#6E6C64;
                --ink-faint:#A9A69C;
                --line:#E6E2D6;
                --line-strong:#D7D2C2;
                --ember:#FF5A36;
                --ember-dark:#C2431F;
                --ember-soft:#FFE6DC;
                --teal:#0E6E56;
                --teal-soft:#DCEFE7;
                --amber:#B5740F;
                --amber-soft:#FBEAD0;
                --red:#C23B3B;
                --red-soft:#FBE3E3;
                --sidebar:#17171A;
                --sidebar-soft:#232327;
                --sidebar-line:#2D2D31;
                --sidebar-text:#B7B5AE;
                --r-sm:6px;
                --r-md:10px;
                --r-lg:18px;
                --font-d:'Oswald',Arial Narrow,sans-serif;
                --font-b:'Inter',-apple-system,Segoe UI,sans-serif;
            }
            *{
                box-sizing:border-box;
            }
            body{
                margin:0;
                background:var(--bg-page);
                color:var(--ink);
                font-family:var(--font-b);
                font-size:14px;
                line-height:1.5;
            }
            .icon{
                width:1em;
                height:1em;
                display:inline-block;
                vertical-align:-0.15em;
                stroke:currentColor;
                fill:none;
            }
            h1,h2,h3,h4{
                font-family:var(--font-d);
                font-weight:600;
                letter-spacing:0.02em;
                margin:0;
                color:var(--ink);
            }
            p{
                margin:0;
            }
            button{
                font-family:var(--font-b);
                cursor:pointer;
            }
            .page-wrap{
                max-width:1320px;
                margin:0 auto;
                padding:28px 28px 64px;
            }

            .top-header{
                display:flex;
                align-items:center;
                justify-content:space-between;
                gap:16px;
                margin-bottom:22px;
                flex-wrap:wrap;
            }
            .brandmark{
                display:flex;
                align-items:center;
                gap:10px;
            }
            .brandmark svg{
                width:30px;
                height:30px;
            }
            .brandmark .name{
                font-family:var(--font-d);
                font-size:22px;
                letter-spacing:0.03em;
            }
            .brandmark .name span{
                color:var(--ember);
            }
            .top-header .tagline{
                color:var(--ink-soft);
                font-size:12.5px;
                margin-top:2px;
            }
            .role-switch{
                display:flex;
                background:var(--bg-surface);
                border:1px solid var(--line);
                border-radius:999px;
                padding:4px;
                gap:4px;
            }
            .role-btn{
                border:none;
                background:transparent;
                padding:9px 18px;
                border-radius:999px;
                font-size:13px;
                font-weight:600;
                color:var(--ink-soft);
                display:flex;
                align-items:center;
                gap:7px;
                transition:all .15s;
            }
            .role-btn.active{
                background:var(--ink);
                color:#fff;
            }
            .role-btn .icon{
                width:15px;
                height:15px;
            }

            .btn{
                border:1px solid var(--line-strong);
                background:var(--bg-surface);
                color:var(--ink);
                padding:8px 14px;
                border-radius:var(--r-md);
                font-size:13px;
                font-weight:600;
                display:inline-flex;
                align-items:center;
                gap:6px;
            }
            .btn:hover{
                background:var(--bg-soft);
            }
            .btn-primary{
                background:var(--ember);
                border-color:var(--ember);
                color:#fff;
            }
            .btn-primary:hover{
                background:var(--ember-dark);
            }
            .btn-sm{
                padding:6px 11px;
                font-size:12px;
            }
            .btn .icon{
                width:14px;
                height:14px;
            }
            .badge{
                display:inline-flex;
                align-items:center;
                gap:5px;
                font-size:11.5px;
                font-weight:700;
                padding:3px 9px;
                border-radius:999px;
                letter-spacing:0.01em;
            }
            .badge-ok{
                background:var(--teal-soft);
                color:var(--teal);
            }
            .badge-warn{
                background:var(--amber-soft);
                color:var(--amber);
            }
            .badge-danger{
                background:var(--red-soft);
                color:var(--red);
            }
            .badge-info{
                background:var(--ember-soft);
                color:var(--ember-dark);
            }
            .card{
                background:var(--bg-surface);
                border:1px solid var(--line);
                border-radius:var(--r-lg);
                padding:20px;
            }
            .card-head{
                display:flex;
                align-items:baseline;
                justify-content:space-between;
                margin-bottom:14px;
            }
            .card-head h3{
                font-size:14px;
            }
            .card-head .muted{
                font-size:12px;
                color:var(--ink-faint);
            }
            .muted{
                color:var(--ink-soft);
            }
            .section-head{
                display:flex;
                align-items:flex-end;
                justify-content:space-between;
                margin-bottom:20px;
                flex-wrap:wrap;
                gap:12px;
            }
            .section-head h2{
                font-size:23px;
            }
            .section-head .sub{
                color:var(--ink-soft);
                font-size:13px;
                margin-top:4px;
            }
            .grid-2{
                display:grid;
                grid-template-columns:1.3fr 1fr;
                gap:18px;
            }
            .grid-4{
                display:grid;
                grid-template-columns:repeat(4,1fr);
                gap:14px;
            }
            @media (max-width:980px){
                .grid-2{
                    grid-template-columns:1fr;
                }
                .grid-4{
                    grid-template-columns:repeat(2,1fr);
                }
            }

            .admin-shell{
                display:flex;
                gap:22px;
                align-items:flex-start;
            }
            .sidebar{
                width:228px;
                flex-shrink:0;
                background:var(--sidebar);
                border-radius:var(--r-lg);
                padding:18px 14px;
                position:sticky;
                top:20px;
            }
            .side-brand{
                display:flex;
                align-items:center;
                gap:9px;
                color:#fff;
                padding:6px 10px 18px;
            }
            .side-brand svg{
                width:24px;
                height:24px;
            }
            .side-brand span{
                font-family:var(--font-d);
                font-size:17px;
                letter-spacing:0.03em;
            }
            .side-brand span b{
                color:var(--ember);
            }
            .nav-item{
                width:100%;
                display:flex;
                align-items:center;
                gap:10px;
                background:transparent;
                border:none;
                color:var(--sidebar-text);
                padding:11px 12px;
                border-radius:var(--r-md);
                font-size:13px;
                font-weight:600;
                text-align:left;
                margin-bottom:2px;
            }
            .nav-item .icon{
                width:17px;
                height:17px;
                flex-shrink:0;
            }
            .nav-item:hover{
                background:var(--sidebar-soft);
                color:#fff;
            }
            .nav-item.active{
                background:var(--ember);
                color:#fff;
            }
            .sidebar-divider{
                height:1px;
                background:var(--sidebar-line);
                margin:12px 4px;
            }
            .sidebar-foot{
                display:flex;
                align-items:center;
                gap:10px;
                padding:10px 8px 4px;
            }
            .avatar{
                width:34px;
                height:34px;
                border-radius:50%;
                background:var(--ember-soft);
                color:var(--ember-dark);
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:700;
                font-size:13px;
                flex-shrink:0;
            }
            .sidebar-foot .who{
                color:#fff;
                font-size:12.5px;
                font-weight:600;
            }
            .sidebar-foot .role{
                color:var(--sidebar-text);
                font-size:11.5px;
            }

            .content{
                flex:1;
                min-width:0;
            }
            .topbar{
                display:flex;
                align-items:center;
                gap:12px;
                margin-bottom:22px;
            }
            .search-box{
                flex:1;
                display:flex;
                align-items:center;
                gap:8px;
                background:var(--bg-surface);
                border:1px solid var(--line);
                border-radius:var(--r-md);
                padding:9px 13px;
                color:var(--ink-faint);
            }
            .search-box .icon{
                width:16px;
                height:16px;
            }
            .search-box input{
                border:none;
                outline:none;
                background:transparent;
                font-size:13px;
                width:100%;
                color:var(--ink);
                font-family:var(--font-b);
            }
            .icon-btn{
                width:38px;
                height:38px;
                border-radius:var(--r-md);
                background:var(--bg-surface);
                border:1px solid var(--line);
                display:flex;
                align-items:center;
                justify-content:center;
                flex-shrink:0;
                position:relative;
            }
            .icon-btn .icon{
                width:17px;
                height:17px;
                color:var(--ink-soft);
            }
            .dot-flag{
                position:absolute;
                top:7px;
                right:8px;
                width:6px;
                height:6px;
                border-radius:50%;
                background:var(--ember);
            }

            .admin-section{
                display:none;
            }
            .admin-section.active{
                display:block;
                animation:fade .2s ease;
            }
            @keyframes fade{
                from{
                    opacity:0;
                    transform:translateY(3px);
                }
                to{
                    opacity:1;
                    transform:translateY(0);
                }
            }

            .kpi-card{
                background:var(--bg-surface);
                border:1px solid var(--line);
                border-radius:var(--r-lg);
                padding:16px 18px;
            }
            .kpi-label{
                font-size:12px;
                color:var(--ink-soft);
                font-weight:600;
                display:flex;
                align-items:center;
                gap:6px;
                margin-bottom:10px;
            }
            .kpi-label .icon{
                width:14px;
                height:14px;
            }
            .kpi-value{
                font-family:var(--font-d);
                font-size:25px;
            }
            .kpi-delta{
                font-size:11.5px;
                font-weight:700;
                margin-top:6px;
                display:inline-flex;
                align-items:center;
                gap:3px;
            }
            .kpi-delta.up{
                color:var(--teal);
            }
            .kpi-delta.down{
                color:var(--red);
            }
            .kpi-delta .icon{
                width:11px;
                height:11px;
            }

            .bars{
                display:flex;
                align-items:flex-end;
                gap:14px;
                height:150px;
                padding-top:10px;
            }
            .bar-col{
                flex:1;
                display:flex;
                flex-direction:column;
                align-items:center;
                justify-content:flex-end;
                height:100%;
            }
            .bar-val{
                font-size:11px;
                font-weight:700;
                color:var(--ink-soft);
                margin-bottom:6px;
            }
            .bar-fill{
                width:100%;
                max-width:34px;
                background:var(--ember);
                border-radius:6px 6px 2px 2px;
            }
            .bar-col:nth-child(6) .bar-fill{
                background:var(--ink);
            }
            .bar-name{
                font-size:11px;
                color:var(--ink-faint);
                margin-top:8px;
            }

            .donut-wrap{
                display:flex;
                align-items:center;
                gap:20px;
            }
            .donut{
                width:118px;
                height:118px;
                border-radius:50%;
                flex-shrink:0;
                position:relative;
            }
            .donut::after{
                content:"";
                position:absolute;
                inset:20px;
                background:var(--bg-surface);
                border-radius:50%;
            }
            .legend{
                display:flex;
                flex-direction:column;
                gap:9px;
            }
            .legend-row{
                display:flex;
                align-items:center;
                gap:8px;
                font-size:12.5px;
            }
            .legend-dot{
                width:9px;
                height:9px;
                border-radius:3px;
                flex-shrink:0;
            }
            .legend-row b{
                margin-left:auto;
                font-size:12.5px;
            }

            .ring{
                width:58px;
                height:58px;
                border-radius:50%;
                position:relative;
                flex-shrink:0;
            }
            .ring::after{
                content:"";
                position:absolute;
                inset:9px;
                background:var(--bg-surface);
                border-radius:50%;
            }
            .ring-val{
                position:absolute;
                inset:0;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:13px;
                font-weight:700;
                font-family:var(--font-d);
            }

            .sparkline{
                width:100%;
                height:64px;
            }

            .rank-row{
                display:flex;
                align-items:center;
                gap:10px;
                margin-bottom:13px;
            }
            .rank-row .rname{
                width:118px;
                font-size:12.5px;
                font-weight:600;
                flex-shrink:0;
            }
            .rank-track{
                flex:1;
                height:8px;
                background:var(--bg-soft);
                border-radius:5px;
                overflow:hidden;
            }
            .rank-fill{
                height:100%;
                background:var(--ember);
                border-radius:5px;
            }
            .rank-row .rval{
                width:34px;
                text-align:right;
                font-size:12px;
                font-weight:700;
                color:var(--ink-soft);
            }

            .table-wrap{
                overflow-x:auto;
                border:1px solid var(--line);
                border-radius:var(--r-lg);
                background:var(--bg-surface);
            }
            table{
                width:100%;
                border-collapse:collapse;
                font-size:13px;
            }
            th{
                text-align:left;
                font-size:11.5px;
                text-transform:uppercase;
                letter-spacing:0.04em;
                color:var(--ink-faint);
                font-weight:700;
                padding:13px 16px;
                border-bottom:1px solid var(--line);
                background:var(--bg-soft);
            }
            td{
                padding:12px 16px;
                border-bottom:1px solid var(--line);
                vertical-align:middle;
            }
            tbody tr:last-child td{
                border-bottom:none;
            }
            tbody tr{
                cursor:pointer;
            }
            tbody tr:hover{
                background:var(--bg-soft);
            }
            tbody tr.selected{
                background:var(--ember-soft);
            }
            .cell-name{
                font-weight:600;
            }
            .cell-sub{
                font-size:11.5px;
                color:var(--ink-faint);
            }
            .row-actions{
                display:flex;
                gap:6px;
                justify-content:flex-end;
            }
            .row-icon-btn{
                width:28px;
                height:28px;
                border-radius:7px;
                border:1px solid var(--line);
                background:var(--bg-surface);
                display:flex;
                align-items:center;
                justify-content:center;
            }
            .row-icon-btn .icon{
                width:14px;
                height:14px;
                color:var(--ink-soft);
            }

            .toolbar{
                display:flex;
                gap:10px;
                margin-bottom:16px;
                flex-wrap:wrap;
                align-items:center;
            }
            .toolbar .search-box{
                max-width:260px;
            }
            select{
                border:1px solid var(--line);
                border-radius:var(--r-md);
                padding:9px 12px;
                font-size:13px;
                background:var(--bg-surface);
                color:var(--ink);
                font-family:var(--font-b);
            }
            .spacer{
                flex:1;
            }

            /* ---- detail / tabs ---- */
            .detail-card{
                margin-top:18px;
            }
            .detail-head{
                display:flex;
                align-items:center;
                gap:14px;
                padding-bottom:16px;
                border-bottom:1px solid var(--line);
                margin-bottom:16px;
            }
            .detail-head .avatar{
                width:50px;
                height:50px;
                font-size:16px;
            }
            .detail-head .meta b{
                font-size:16px;
                display:block;
            }
            .detail-head .meta span{
                font-size:12px;
                color:var(--ink-faint);
            }
            .detail-head .right{
                margin-left:auto;
                display:flex;
                gap:8px;
            }
            .tabs{
                display:flex;
                gap:6px;
                margin-bottom:18px;
                border-bottom:1px solid var(--line);
            }
            .tab-btn{
                background:transparent;
                border:none;
                padding:10px 4px;
                margin-right:18px;
                font-size:13px;
                font-weight:600;
                color:var(--ink-faint);
                border-bottom:2px solid transparent;
            }
            .tab-btn.active{
                color:var(--ink);
                border-color:var(--ember);
            }
            .tab-panel{
                display:none;
            }
            .tab-panel.active{
                display:block;
                animation:fade .15s ease;
            }

            .field-grid{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:16px 28px;
            }
            .field-label{
                font-size:11.5px;
                color:var(--ink-faint);
                text-transform:uppercase;
                letter-spacing:0.03em;
                font-weight:700;
                margin-bottom:3px;
            }
            .field-value{
                font-size:13.5px;
                font-weight:500;
            }
            @media (max-width:700px){
                .field-grid{
                    grid-template-columns:1fr;
                }
            }

            .progress-track{
                height:8px;
                background:var(--bg-soft);
                border-radius:5px;
                overflow:hidden;
                margin:8px 0;
            }
            .progress-fill{
                height:100%;
                background:var(--teal);
                border-radius:5px;
            }
            .macro-row{
                display:flex;
                align-items:center;
                gap:10px;
                margin-bottom:10px;
            }
            .macro-row .mname{
                width:64px;
                font-size:12.5px;
                font-weight:600;
            }
            .macro-row .gval{
                width:60px;
                text-align:right;
                font-size:12px;
                color:var(--ink-soft);
            }

            .trainer-grid{
                display:grid;
                grid-template-columns:repeat(4,1fr);
                gap:14px;
            }
            @media (max-width:980px){
                .trainer-grid{
                    grid-template-columns:repeat(2,1fr);
                }
            }
            .trainer-card{
                background:var(--bg-surface);
                border:1px solid var(--line);
                border-radius:var(--r-lg);
                padding:16px;
                text-align:center;
            }
            .trainer-card .avatar{
                width:54px;
                height:54px;
                font-size:16px;
                margin:0 auto 10px;
            }
            .trainer-card b{
                display:block;
                font-size:14px;
                margin-bottom:2px;
            }
            .trainer-card .spec{
                font-size:11.5px;
                color:var(--ink-faint);
                margin-bottom:10px;
            }
            .trainer-stats{
                display:flex;
                justify-content:space-around;
                border-top:1px solid var(--line);
                padding-top:10px;
                margin-top:10px;
            }
            .trainer-stats div{
                text-align:center;
            }
            .trainer-stats b{
                display:block;
                font-family:var(--font-d);
                font-size:16px;
            }
            .trainer-stats span{
                font-size:10.5px;
                color:var(--ink-faint);
            }
            .status-dot{
                display:inline-block;
                width:7px;
                height:7px;
                border-radius:50%;
                background:var(--teal);
                margin-right:5px;
            }

            .week-toolbar{
                display:flex;
                align-items:center;
                gap:10px;
                margin-bottom:16px;
            }
            .week-grid{
                display:grid;
                grid-template-columns:repeat(7,1fr);
                gap:10px;
            }
            @media (max-width:980px){
                .week-grid{
                    grid-template-columns:repeat(3,1fr);
                }
            }
            .day-col{
                background:var(--bg-surface);
                border:1px solid var(--line);
                border-radius:var(--r-md);
                padding:10px;
                min-height:160px;
            }
            .day-head{
                font-size:11.5px;
                font-weight:700;
                text-transform:uppercase;
                color:var(--ink-faint);
                margin-bottom:9px;
                padding-bottom:7px;
                border-bottom:1px solid var(--line);
            }
            .day-head .num{
                color:var(--ink);
                font-size:13px;
                margin-left:4px;
            }
            .chip{
                border-radius:8px;
                padding:7px 8px;
                margin-bottom:7px;
                font-size:11.5px;
            }
            .chip b{
                display:block;
                font-size:11.5px;
            }
            .chip span{
                font-size:10.5px;
                opacity:0.85;
            }
            .chip-light{
                background:var(--teal-soft);
                color:var(--teal);
            }
            .chip-mid{
                background:var(--amber-soft);
                color:var(--amber);
            }
            .chip-heavy{
                background:var(--ember-soft);
                color:var(--ember-dark);
            }

            .package-grid{
                display:grid;
                grid-template-columns:repeat(4,1fr);
                gap:14px;
                margin-bottom:24px;
            }
            @media (max-width:980px){
                .package-grid{
                    grid-template-columns:repeat(2,1fr);
                }
            }
            .package-card{
                position:relative;
                background:var(--bg-surface);
                border:1px solid var(--line);
                border-radius:var(--r-lg);
                padding:18px;
            }
            .package-card.featured{
                border:2px solid var(--ember);
            }
            .badge-pop{
                position:absolute;
                top:-10px;
                left:18px;
                background:var(--ember);
                color:#fff;
                font-size:10.5px;
                font-weight:700;
                padding:3px 9px;
                border-radius:999px;
            }
            .package-card .ptype{
                font-size:11px;
                color:var(--ink-faint);
                text-transform:uppercase;
                letter-spacing:0.03em;
                font-weight:700;
            }
            .package-card .pname{
                font-size:17px;
                margin:5px 0 10px;
            }
            .package-card .price{
                font-family:var(--font-d);
                font-size:22px;
                color:var(--ember-dark);
            }
            .package-card .price span{
                font-family:var(--font-b);
                font-size:11.5px;
                color:var(--ink-faint);
                font-weight:600;
            }
            .package-card ul{
                list-style:none;
                margin:12px 0 0;
                padding:0;
                font-size:12px;
                color:var(--ink-soft);
                display:flex;
                flex-direction:column;
                gap:6px;
            }
            .package-card ul li{
                display:flex;
                align-items:center;
                gap:6px;
            }
            .package-card ul li .icon{
                width:13px;
                height:13px;
                color:var(--teal);
            }

            .period-row{
                display:flex;
                gap:6px;
                margin-bottom:20px;
            }
            .period-btn{
                background:var(--bg-surface);
                border:1px solid var(--line);
                border-radius:999px;
                padding:7px 16px;
                font-size:12.5px;
                font-weight:600;
                color:var(--ink-soft);
            }
            .period-btn.active{
                background:var(--ink);
                color:#fff;
                border-color:var(--ink);
            }

            .perm-grid{
                display:grid;
                grid-template-columns:repeat(3,1fr);
                gap:14px;
                margin-bottom:24px;
            }
            @media (max-width:980px){
                .perm-grid{
                    grid-template-columns:1fr;
                }
            }
            .perm-card{
                background:var(--bg-surface);
                border:1px solid var(--line);
                border-radius:var(--r-lg);
                padding:18px;
            }
            .perm-card .pcount{
                font-size:11.5px;
                color:var(--ink-faint);
                margin-top:2px;
            }
            .perm-tags{
                display:flex;
                flex-wrap:wrap;
                gap:6px;
                margin-top:12px;
            }
            .perm-tag{
                background:var(--bg-soft);
                border:1px solid var(--line);
                font-size:11px;
                padding:4px 9px;
                border-radius:999px;
                color:var(--ink-soft);
                font-weight:600;
            }

            /* ====== CUSTOMER MOBILE APP ====== */
            .customer-wrap{
                display:flex;
                justify-content:center;
                padding:20px 0;
            }
            .phone{
                width:380px;
                background:var(--ink);
                border-radius:42px;
                padding:14px;
                box-sizing:border-box;
            }
            .phone-inner{
                background:var(--bg-page);
                border-radius:30px;
                overflow:hidden;
                display:flex;
                flex-direction:column;
                height:760px;
            }
            .phone-status{
                display:flex;
                justify-content:space-between;
                padding:14px 22px 6px;
                font-size:12px;
                font-weight:700;
                color:var(--ink);
            }
            .phone-screen{
                flex:1;
                overflow-y:auto;
                padding:6px 18px 16px;
            }
            .cscreen{
                display:none;
            }
            .cscreen.active{
                display:block;
                animation:fade .18s ease;
            }
            .tabbar{
                display:flex;
                justify-content:space-around;
                padding:10px 8px 16px;
                background:var(--bg-surface);
                border-top:1px solid var(--line);
            }
            .tab-item{
                background:transparent;
                border:none;
                display:flex;
                flex-direction:column;
                align-items:center;
                gap:4px;
                color:var(--ink-faint);
                font-size:10.5px;
                font-weight:600;
            }
            .tab-item .icon{
                width:19px;
                height:19px;
            }
            .tab-item.active{
                color:var(--ember-dark);
            }

            .greet{
                font-family:var(--font-d);
                font-size:20px;
                margin:14px 0 16px;
            }
            .today-card{
                background:var(--ink);
                color:#fff;
                border-radius:var(--r-lg);
                padding:16px 18px;
                margin-bottom:14px;
            }
            .today-card .label{
                font-size:11px;
                color:var(--sidebar-text);
                text-transform:uppercase;
                letter-spacing:0.04em;
                font-weight:700;
            }
            .today-card .when{
                font-family:var(--font-d);
                font-size:19px;
                margin:6px 0 4px;
            }
            .today-card .with{
                font-size:12px;
                color:var(--sidebar-text);
            }
            .today-card .row{
                display:flex;
                justify-content:space-between;
                align-items:flex-end;
                margin-top:12px;
            }
            .stat-tiles{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:10px;
                margin-bottom:14px;
            }
            .stat-tile{
                background:var(--bg-surface);
                border:1px solid var(--line);
                border-radius:var(--r-md);
                padding:12px 14px;
            }
            .stat-tile .lbl{
                font-size:11px;
                color:var(--ink-faint);
                font-weight:600;
            }
            .stat-tile .val{
                font-family:var(--font-d);
                font-size:19px;
                margin-top:4px;
            }
            .cta-row{
                display:flex;
                gap:10px;
                margin-bottom:18px;
            }
            .cta-row .btn{
                flex:1;
                justify-content:center;
            }

            .sched-day-label{
                font-size:11.5px;
                font-weight:700;
                text-transform:uppercase;
                color:var(--ink-faint);
                margin:16px 0 8px;
            }
            .sched-item{
                display:flex;
                align-items:center;
                gap:12px;
                background:var(--bg-surface);
                border:1px solid var(--line);
                border-radius:var(--r-md);
                padding:11px 13px;
                margin-bottom:8px;
            }
            .sched-time{
                font-family:var(--font-d);
                font-size:14px;
                width:48px;
                flex-shrink:0;
            }
            .sched-item .sname{
                font-size:13px;
                font-weight:600;
            }
            .sched-item .swith{
                font-size:11.5px;
                color:var(--ink-faint);
            }
            .sched-tag{
                margin-left:auto;
            }

            .qr-box{
                width:188px;
                height:188px;
                margin:18px auto 14px;
                background:#fff;
                border:1px solid var(--line);
                border-radius:var(--r-md);
                display:grid;
                grid-template-columns:repeat(9,1fr);
                grid-template-rows:repeat(9,1fr);
                gap:2px;
                padding:14px;
            }
            .qr-box i{
                background:var(--ink);
                border-radius:1px;
            }
            .checkin-history .ci-row{
                display:flex;
                justify-content:space-between;
                font-size:12.5px;
                padding:9px 0;
                border-bottom:1px solid var(--line);
            }
            .checkin-history .ci-row:last-child{
                border-bottom:none;
            }
            .checkin-history .ci-date{
                color:var(--ink-faint);
                font-size:11.5px;
            }

            .pkg-progress-card{
                background:var(--bg-surface);
                border:1px solid var(--line);
                border-radius:var(--r-lg);
                padding:16px;
                margin-bottom:14px;
            }
            .pkg-progress-card .pname{
                font-size:15px;
                font-weight:600;
            }
            .pkg-progress-card .pdate{
                font-size:11.5px;
                color:var(--ink-faint);
                margin-top:2px;
                margin-bottom:10px;
            }

            .body-row2{
                display:grid;
                grid-template-columns:1fr 1fr 1fr;
                gap:8px;
                margin:14px 0;
            }
            .body-mini{
                background:var(--bg-surface);
                border:1px solid var(--line);
                border-radius:var(--r-md);
                padding:10px;
                text-align:center;
            }
            .body-mini .v{
                font-family:var(--font-d);
                font-size:17px;
            }
            .body-mini .l{
                font-size:10px;
                color:var(--ink-faint);
                font-weight:600;
            }
            .ring-block{
                display:flex;
                align-items:center;
                gap:16px;
                background:var(--bg-surface);
                border:1px solid var(--line);
                border-radius:var(--r-lg);
                padding:14px 16px;
                margin:14px 0;
            }
            .ring-block .ring{
                width:62px;
                height:62px;
            }
            .ring-block .ring-val{
                font-size:14px;
            }
            .ring-block .rb-title{
                font-size:13px;
                font-weight:600;
            }
            .ring-block .rb-sub{
                font-size:11.5px;
                color:var(--ink-faint);
            }
            .brandmark{
                display:flex;
                align-items:center;
                gap:14px;
            }

            .brandmark img{
                width:48px;
                height:48px;
                object-fit:contain;
                filter: drop-shadow(0 2px 6px rgba(0,0,0,.15));
            }

            .side-brand{
                display:flex;
                align-items:center;
                gap:12px;
            }

            .side-brand img{
                width:32px;
                height:32px;
                object-fit:contain;
                filter: brightness(1.1);
            }
        </style>
    </head>
    <body>
        <svg style="display:none">
    <symbol id="i-dumbbell" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round"><path d="M5 9v6"/><path d="M2 10v4"/><path d="M9 7v10"/><path d="M15 7v10"/><path d="M19 9v6"/><path d="M22 10v4"/><path d="M9 12h6"/></symbol>
    <symbol id="i-grid" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></symbol>
    <symbol id="i-users" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="8" r="3.2"/><path d="M2.8 19c0-3.2 2.7-5.6 6.2-5.6s6.2 2.4 6.2 5.6"/><path d="M16 8.4a3 3 0 1 1 0 5.6"/><path d="M21.2 19c0-2.5-1.6-4.5-3.9-5.3"/></symbol>
    <symbol id="i-user" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="3.6"/><path d="M4.5 20c0-3.6 3.1-6.2 7.5-6.2s7.5 2.6 7.5 6.2"/></symbol>
    <symbol id="i-calendar" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 10h18"/><path d="M8 3v4"/><path d="M16 3v4"/></symbol>
    <symbol id="i-box" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 8 12 3 3 8v8l9 5 9-5z"/><path d="M3 8l9 5 9-5"/><path d="M12 13v8"/></symbol>
    <symbol id="i-chart" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 20V10"/><path d="M11 20V4"/><path d="M18 20v-7"/><path d="M2 21h20"/></symbol>
    <symbol id="i-shield" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3 4 6v6c0 5 3.5 7.5 8 9 4.5-1.5 8-4 8-9V6z"/></symbol>
    <symbol id="i-search" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="10.5" cy="10.5" r="6.5"/><path d="M20 20l-4.8-4.8"/></symbol>
    <symbol id="i-bell" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9a6 6 0 1 1 12 0c0 4 1.2 5.5 2 6.5H4c.8-1 2-2.5 2-6.5z"/><path d="M10 19a2 2 0 0 0 4 0"/></symbol>
    <symbol id="i-plus" viewBox="0 0 24 24" stroke-width="2.2" stroke-linecap="round"><path d="M12 5v14"/><path d="M5 12h14"/></symbol>
    <symbol id="i-edit" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16.5 3.5 20 7l-11 11-4.5 1L5.5 14.5z"/></symbol>
    <symbol id="i-trash" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 7h16"/><path d="M9 7V4h6v3"/><path d="M6 7l1 13h10l1-13"/></symbol>
    <symbol id="i-up" viewBox="0 0 24 24" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M5 16 12 8l7 8"/></symbol>
    <symbol id="i-down" viewBox="0 0 24 24" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M5 8l7 8 7-8"/></symbol>
    <symbol id="i-check" viewBox="0 0 24 24" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12.5 9.5 18 20 6"/></symbol>
    <symbol id="i-qr" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><path d="M14 14h3v3h-3z"/><path d="M19 19h2v2h-2z"/></symbol>
    <symbol id="i-home" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 11 12 4l8 7"/><path d="M6 10v10h12V10"/></symbol>
    <symbol id="i-activity" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12h4l2 7 4-14 2 7h6"/></symbol>
    </svg>

    <div class="page-wrap">
        <div class="top-header">
            <div>
                <div class="brandmark">
                    <div class="brandmark">
                        <img src="./image/vux.webp" alt="Logo" class="logo" width="40" height="60">
                        <span class="name">VUX<span>GYM</span></span>
                    </div>
                </div>
                <p class="tagline">Bản thiết kế giao diện — Dự án Quản lý khách hàng phòng gym</p>
            </div>
            <div class="role-switch" style="align-items:center;">
                <div style="display:flex;align-items:center;gap:8px;padding:4px 10px;">
                    <svg class="icon" viewBox="0 0 24 24" style="width:16px;height:16px;"><use href="#i-user"/></svg>
                    <span style="font-size:13px;font-weight:600;color:var(--ink);"><%= fullName %></span>
                    <span style="font-size:11.5px;color:var(--ink-soft);">· <%= roleLabel %></span>
                </div>
                <a href="LogoutServlet" class="role-btn" style="text-decoration:none;color:var(--ember-dark);">
                    <svg class="icon" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><path d="M16 17l5-5-5-5"/><path d="M21 12H9"/></svg>
                    Đăng xuất
                </a>
            </div>
        </div>

        <div class="admin-shell" id="adminShell">
            <aside class="sidebar">
                <div class="side-brand">
                    <img src="./image/vux.webp" alt="Logo" class="logo" width="40" height="60">
                    <span>VUX<b>GYM</b></span>
                </div>
                <% if (canManageCustomers) { %>
                <button class="nav-item" data-section="customers" onclick="showSection('customers', this)"><svg class="icon" viewBox="0 0 24 24"><use href="#i-users"/></svg>Khách hàng</button>
                    <% } %>
                    <% if (canManageTrainers) { %>
                <button class="nav-item" data-section="trainers" onclick="showSection('trainers', this)"><svg class="icon" viewBox="0 0 24 24"><use href="#i-user"/></svg>Huấn luyện viên</button>
                    <% } %>
                    <% if (canManageSchedule) { %>
                <button class="nav-item" data-section="schedule" onclick="showSection('schedule', this)"><svg class="icon" viewBox="0 0 24 24"><use href="#i-calendar"/></svg>Lịch tập</button>
                    <% } %>
                    <% if (canManageRevenue) { %>
                <button class="nav-item" data-section="packages" onclick="showSection('packages', this)"><svg class="icon" viewBox="0 0 24 24"><use href="#i-box"/></svg>Gói tập &amp; Doanh thu</button>
                    <% } %>
                    <% if (canViewReports) { %>
                <button class="nav-item" data-section="reports" onclick="showSection('reports', this)"><svg class="icon" viewBox="0 0 24 24"><use href="#i-chart"/></svg>Báo cáo &amp; thống kê</button>
                    <% } %>
                    <% if (canManageUsers) { %>
                <button class="nav-item" data-section="users" onclick="showSection('users', this)"><svg class="icon" viewBox="0 0 24 24"><use href="#i-shield"/></svg>Người dùng &amp; phân quyền</button>
                    <% } %>
                <div class="sidebar-divider"></div>
                <div class="sidebar-foot">
                    <div class="avatar"><%= avatarInit %></div>
                    <div><div class="who"><%= fullName %></div><div class="role"><%= roleLabel %></div></div>
                </div>
            </aside>

            <main class="content">
                <div class="topbar">
                    <div class="search-box"><svg class="icon" viewBox="0 0 24 24"><use href="#i-search"/></svg><input placeholder="Tìm khách hàng, huấn luyện viên, gói tập..."></div>
                    <button class="icon-btn"><svg class="icon" viewBox="0 0 24 24"><use href="#i-bell"/></svg><span class="dot-flag"></span></button>
                    <button class="btn btn-primary"><svg class="icon" viewBox="0 0 24 24"><use href="#i-plus"/></svg>Thêm mới</button>
                </div>


                <!-- ===== CUSTOMERS ===== -->
                <section class="admin-section" id="sec-customers">
                    <div style="display: grid; grid-template-columns: 380px 1fr; gap: 20px; margin-top: 15px; align-items: start;">
                        
                        <div style="background: #1e1e1e; border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; padding: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.3);">
                            <h3 style="margin-top: 0; color: #fff; border-bottom: 2px solid #ff4757; padding-bottom: 8px;">Thông Tin Hội Viên</h3>
                            
                            <c:if test="${not empty success}">
                                <div style="padding: 10px; background: rgba(46, 213, 115, 0.2); color: #2ed573; border: 1px solid #2ed573; border-radius: 5px; margin-bottom: 10px; font-weight: bold; font-size: 0.9rem;">${success}</div>
                            </c:if>
                            <c:if test="${not empty error}">
                                <div style="padding: 10px; background: rgba(255, 71, 87, 0.2); color: #ff4757; border: 1px solid #ff4757; border-radius: 5px; margin-bottom: 10px; font-weight: bold; font-size: 0.9rem;">${error}</div>
                            </c:if>

                            <form action="KhachHangServlet" method="POST">
                                <div style="margin-bottom: 12px;">
                                    <label style="display:block; color:#a4b0be; font-size:0.85rem; margin-bottom:4px;">Mã Khách Hàng:</label>
                                    <input type="text" name="id" value="${khSelected.maKhachHang}" readonly placeholder="Tự tăng hệ thống" style="width:100%; padding:8px; background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.1); border-radius:4px; color:#777; cursor:not-allowed; box-sizing:border-box;">
                                </div>

                                <div style="margin-bottom: 12px;">
                                    <label style="display:block; color:#a4b0be; font-size:0.85rem; margin-bottom:4px;">Họ và Tên:</label>
                                    <input type="text" name="hoTen" value="${khSelected.hoTen}" required placeholder="Nhập họ và tên" style="width:100%; padding:8px; background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:4px; color:#fff; box-sizing:border-box;">
                                </div>

                                <div style="margin-bottom: 12px;">
                                    <label style="display:block; color:#a4b0be; font-size:0.85rem; margin-bottom:4px;">Giới Tính:</label>
                                    <select name="gioiTinh" style="width:100%; padding:8px; background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:4px; color:#fff; box-sizing:border-box;">
                                        <option value="Nam" ${khSelected.gioiTinh == 'Nam' ? 'selected' : ''}>Nam</option>
                                        <option value="Nữ" ${khSelected.gioiTinh == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                    </select>
                                </div>

                                <div style="margin-bottom: 12px;">
                                    <label style="display:block; color:#a4b0be; font-size:0.85rem; margin-bottom:4px;">Ngày Sinh:</label>
                                    <input type="date" name="ngaySinh" value="${khSelected.ngaySinh}" required style="width:100%; padding:8px; background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:4px; color:#fff; box-sizing:border-box;">
                                </div>

                                <div style="margin-bottom: 12px;">
                                    <label style="display:block; color:#a4b0be; font-size:0.85rem; margin-bottom:4px;">Số Điện Thoại:</label>
                                    <input type="text" name="sdt" value="${khSelected.soDienThoai}" required placeholder="Ví dụ: 0982111222" style="width:100%; padding:8px; background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:4px; color:#fff; box-sizing:border-box;">
                                </div>

                                <div style="margin-bottom: 12px;">
                                    <label style="display:block; color:#a4b0be; font-size:0.85rem; margin-bottom:4px;">Email:</label>
                                    <input type="email" name="email" value="${khSelected.email}" placeholder="Gym@gmail.com" style="width:100%; padding:8px; background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:4px; color:#fff; box-sizing:border-box;">
                                </div>

                                <div style="margin-bottom: 12px;">
                                    <label style="display:block; color:#a4b0be; font-size:0.85rem; margin-bottom:4px;">Địa Chỉ:</label>
                                    <input type="text" name="diaChi" value="${khSelected.diaChi}" placeholder="Tỉnh / Thành phố" style="width:100%; padding:8px; background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:4px; color:#fff; box-sizing:border-box;">
                                </div>

                                <div style="margin-bottom: 12px;">
                                    <label style="display:block; color:#a4b0be; font-size:0.85rem; margin-bottom:4px;">PT Phụ Trách:</label>
                                    <select name="pt" style="width:100%; padding:8px; background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:4px; color:#fff; box-sizing:border-box;">
                                        <option value="Nguyễn Nhật Minh" ${khSelected.ptPhuTrach == 'Nguyễn Nhật Minh' ? 'selected' : ''}>Nguyễn Nhật Minh</option>
                                        <option value="Trần Gia Khánh" ${khSelected.ptPhuTrach == 'Trần Gia Khánh' ? 'selected' : ''}>Trần Gia Khánh</option>
                                        <option value="Phạm Đức Anh" ${khSelected.ptPhuTrach == 'Phạm Đức Anh' ? 'selected' : ''}>Phạm Đức Anh</option>
                                        <option value="Hoàng Thúy Vi" ${khSelected.ptPhuTrach == 'Hoàng Thúy Vi' ? 'selected' : ''}>Hoàng Thúy Vi</option>
                                    </select>
                                </div>

                                <div style="margin-bottom: 12px;">
                                    <label style="display:block; color:#a4b0be; font-size:0.85rem; margin-bottom:4px;">Gói Tập Đăng Ký:</label>
                                    <input type="text" name="goiTap" value="${khSelected.goiTap}" placeholder="VIP 12 tháng, Gym 6 tháng..." style="width:100%; padding:8px; background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:4px; color:#fff; box-sizing:border-box;">
                                </div>

                                <div style="margin-bottom: 12px;">
                                    <label style="display:block; color:#a4b0be; font-size:0.85rem; margin-bottom:4px;">Hạn Sử Dụng:</label>
                                    <input type="date" name="hanSuDung" value="${khSelected.hanSuDung}" required style="width:100%; padding:8px; background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:4px; color:#fff; box-sizing:border-box;">
                                </div>

                                <div style="margin-bottom: 15px;">
                                    <label style="display:block; color:#a4b0be; font-size:0.85rem; margin-bottom:4px;">Trạng Thái:</label>
                                    <select name="trangThai" style="width:100%; padding:8px; background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:4px; color:#fff; box-sizing:border-box;">
                                        <option value="Đang hoạt động" ${khSelected.trangThai == 'Đang hoạt động' ? 'selected' : ''}>Đang hoạt động</option>
                                        <option value="Sắp hết hạn" ${khSelected.trangThai == 'Sắp hết hạn' ? 'selected' : ''}>Sắp hết hạn</option>
                                        <option value="Đã ngừng" ${khSelected.trangThai == 'Đã ngừng' ? 'selected' : ''}>Đã ngừng</option>
                                    </select>
                                </div>

                                <div style="display: flex; gap: 8px;">
                                    <button type="submit" name="action" value="add" style="flex:1; padding:10px; font-weight:bold; background:#2ed573; color:#fff; border:none; border-radius:4px; cursor:pointer;">Thêm mới</button>
                                    <button type="submit" name="action" value="edit" style="flex:1; padding:10px; font-weight:bold; background:#1e90ff; color:#fff; border:none; border-radius:4px; cursor:pointer;">Cập nhật</button>
                                </div>
                            </form>
                        </div>

                        <div style="background: #1e1e1e; border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; padding: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.3); overflow-x: auto;">
                            <h3 style="margin-top: 0; color: #fff; border-bottom: 2px solid #ff4757; padding-bottom: 8px;">Danh Sách Hội Viên</h3>
                            <table style="width: 100%; border-collapse: collapse; margin-top: 10px; color: #fff; font-size: 0.9rem;">
                                <thead>
                                    <tr style="background-color: rgba(255,255,255,0.05); text-align: left;">
                                        <th style="padding: 10px; border-bottom: 1px solid rgba(255,255,255,0.1);">Mã</th>
                                        <th style="padding: 10px; border-bottom: 1px solid rgba(255,255,255,0.1);">Họ Tên</th>
                                        <th style="padding: 10px; border-bottom: 1px solid rgba(255,255,255,0.1);">Phái</th>
                                        <th style="padding: 10px; border-bottom: 1px solid rgba(255,255,255,0.1);">Điện Thoại</th>
                                        <th style="padding: 10px; border-bottom: 1px solid rgba(255,255,255,0.1);">PT Phụ Trách</th>
                                        <th style="padding: 10px; border-bottom: 1px solid rgba(255,255,255,0.1);">Gói Tập</th>
                                        <th style="padding: 10px; border-bottom: 1px solid rgba(255,255,255,0.1);">Trạng Thái</th>
                                        <th style="padding: 10px; border-bottom: 1px solid rgba(255,255,255,0.1);">Hành Động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${LIST_KH}" var="kh">
                                        <tr style="border-bottom: 1px solid rgba(255,255,255,0.05);">
                                            <td style="padding: 10px;">${kh.maKhachHang}</td>
                                            <td style="padding: 10px; font-weight: bold;">${kh.hoTen}</td>
                                            <td style="padding: 10px;">${kh.gioiTinh}</td>
                                            <td style="padding: 10px;">${kh.soDienThoai}</td>
                                            <td style="padding: 10px; color: #00d2d3;">${kh.ptPhuTrach}</td>
                                            <td style="padding: 10px;">${kh.goiTap}</td>
                                            <td style="padding: 10px;">
                                                <c:choose>
                                                    <c:when test="${kh.trangThai == 'Đang hoạt động'}">
                                                        <span style="color:#2ed573;">● ${kh.trangThai}</span>
                                                    </c:when>
                                                    <c:when test="${kh.trangThai == 'Sắp hết hạn'}">
                                                        <span style="color:#ffa502;">● ${kh.trangThai}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color:#ff4757;">● ${kh.trangThai}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 10px;">
                                                <a href="KhachHangServlet?action=load&id=${kh.maKhachHang}" style="text-decoration: none; padding: 4px 8px; background: #ffa502; color: #fff; border-radius: 4px; font-size: 0.8rem; margin-right: 4px;">Sửa</a>
                                                <a href="KhachHangServlet?action=delete&id=${kh.maKhachHang}" style="text-decoration: none; padding: 4px 8px; background: #ff4757; color: #fff; border-radius: 4px; font-size: 0.8rem;" onclick="return confirm('Bạn chắc chắn muốn xóa?')">Xóa</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty LIST_KH}">
                                        <tr>
                                            <td colspan="8" style="text-align: center; padding: 20px; color: #a4b0be;">Không tìm thấy dữ liệu hội viên! Hãy chạy link trực tiếp bằng Servlet nhé.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>

                <!-- ===== TRAINERS ===== -->
                <% if (canManageTrainers) { %>
                <section class="admin-section" id="sec-trainers">
                    <div class="section-head"><div><h2>Huấn luyện viên</h2><p class="sub">14 PT đang hoạt động</p></div><button class="btn btn-primary"><svg class="icon" viewBox="0 0 24 24"><use href="#i-plus"/></svg>Thêm huấn luyện viên</button></div>

                    <div class="trainer-grid" style="margin-bottom:24px;">
                        <div class="trainer-card"><div class="avatar">TK</div><b>Trần Minh Khoa</b><div class="spec">Gym · Tăng cơ giảm mỡ</div><span class="status-dot"></span><span class="muted" style="font-size:11.5px;">Đang làm</span>
                            <div class="trainer-stats"><div><b>38</b><span>Khách hàng</span></div><div><b>4.9</b><span>Đánh giá</span></div></div></div>
                        <div class="trainer-card"><div class="avatar">QB</div><b>Phạm Quốc Bảo</b><div class="spec">PT chuyên sâu · Strength</div><span class="status-dot"></span><span class="muted" style="font-size:11.5px;">Đang làm</span>
                            <div class="trainer-stats"><div><b>31</b><span>Khách hàng</span></div><div><b>4.7</b><span>Đánh giá</span></div></div></div>
                        <div class="trainer-card"><div class="avatar">TH</div><b>Lê Thị Hồng</b><div class="spec">Yoga · Phục hồi vận động</div><span class="status-dot"></span><span class="muted" style="font-size:11.5px;">Đang làm</span>
                            <div class="trainer-stats"><div><b>27</b><span>Khách hàng</span></div><div><b>4.8</b><span>Đánh giá</span></div></div></div>
                        <div class="trainer-card"><div class="avatar">HN</div><b>Bùi Hải Nam</b><div class="spec">Gym · Dinh dưỡng thể hình</div><span class="status-dot" style="background:var(--ink-faint);"></span><span class="muted" style="font-size:11.5px;">Nghỉ phép</span>
                            <div class="trainer-stats"><div><b>22</b><span>Khách hàng</span></div><div><b>4.6</b><span>Đánh giá</span></div></div></div>
                    </div>

                    <div class="card">
                        <div class="card-head"><h3>Xếp hạng hiệu suất theo số khách hàng phụ trách</h3></div>
                        <div class="rank-row"><span class="rname">Trần Minh Khoa</span><div class="rank-track"><div class="rank-fill" style="width:95%;"></div></div><span class="rval">38</span></div>
                        <div class="rank-row"><span class="rname">Phạm Quốc Bảo</span><div class="rank-track"><div class="rank-fill" style="width:78%;"></div></div><span class="rval">31</span></div>
                        <div class="rank-row"><span class="rname">Lê Thị Hồng</span><div class="rank-track"><div class="rank-fill" style="width:68%;"></div></div><span class="rval">27</span></div>
                        <div class="rank-row"><span class="rname">Bùi Hải Nam</span><div class="rank-track"><div class="rank-fill" style="width:55%;"></div></div><span class="rval">22</span></div>
                    </div>
                </section>
                <% } %>

                <!-- ===== SCHEDULE ===== -->
                <section class="admin-section" id="sec-schedule">
                    <div class="section-head"><div><h2>Lịch tập</h2><p class="sub">Tuần 22/06 — 28/06/2026</p></div><button class="btn btn-primary"><svg class="icon" viewBox="0 0 24 24"><use href="#i-plus"/></svg>Thêm lịch tập</button></div>

                    <div class="week-toolbar">
                        <select><option>Tất cả huấn luyện viên</option><option>Trần Minh Khoa</option><option>Phạm Quốc Bảo</option><option>Lê Thị Hồng</option></select>
                        <span class="spacer"></span>
                        <button class="btn btn-sm">‹ Tuần trước</button><button class="btn btn-sm">Tuần sau ›</button>
                    </div>

                    <div class="week-grid">
                        <div class="day-col"><div class="day-head">T2<span class="num">22</span></div>
                            <div class="chip chip-light"><b>06:30 — Hoàng Hân</b><span>Lê Thị Hồng · Nhẹ</span></div>
                            <div class="chip chip-heavy"><b>17:00 — Văn Long</b><span>Trần Minh Khoa · Nặng</span></div></div>
                        <div class="day-col"><div class="day-head">T3<span class="num">23</span></div>
                            <div class="chip chip-mid"><b>18:30 — Thị Lan</b><span>Phạm Quốc Bảo · TB</span></div>
                            <div class="chip chip-light"><b>19:00 — Gia Hân</b><span>Lê Thị Hồng · Nhẹ</span></div></div>
                        <div class="day-col"><div class="day-head">T4<span class="num">24</span></div>
                            <div class="chip chip-heavy"><b>17:00 — Văn Long</b><span>Trần Minh Khoa · Nặng</span></div></div>
                        <div class="day-col"><div class="day-head">T5<span class="num">25</span></div>
                            <div class="chip chip-mid"><b>18:00 — Bảo Châu</b><span>Phạm Quốc Bảo · TB</span></div>
                            <div class="chip chip-light"><b>19:30 — Thanh Tùng</b><span>Lê Thị Hồng · Nhẹ</span></div></div>
                        <div class="day-col"><div class="day-head">T6<span class="num">26</span></div>
                            <div class="chip chip-heavy"><b>17:30 — Văn Long</b><span>Trần Minh Khoa · Nặng</span></div></div>
                        <div class="day-col"><div class="day-head">T7<span class="num">27</span></div>
                            <div class="chip chip-light"><b>08:00 — Thị Lan</b><span>Lê Thị Hồng · Nhẹ</span></div>
                            <div class="chip chip-mid"><b>10:00 — Bảo Châu</b><span>Phạm Quốc Bảo · TB</span></div></div>
                        <div class="day-col"><div class="day-head">CN<span class="num">28</span></div>
                            <p class="muted" style="font-size:12px;text-align:center;margin-top:30px;">Không có lịch tập</p></div>
                    </div>
                </section>

                <!-- ===== PACKAGES & REVENUE ===== -->
                <% if (canManageRevenue) { %>
                <section class="admin-section" id="sec-packages">
                    <div class="section-head"><div><h2>Gói tập &amp; Doanh thu</h2><p class="sub">4 gói đang bán</p></div><button class="btn btn-primary"><svg class="icon" viewBox="0 0 24 24"><use href="#i-plus"/></svg>Thêm gói tập</button></div>

                    <div class="package-grid">
                        <div class="package-card"><div class="ptype">Gym</div><div class="pname">Gym cơ bản</div><div class="price">450.000đ<span>/tháng</span></div>
                            <ul><li><svg class="icon" viewBox="0 0 24 24"><use href="#i-check"/></svg>Toàn bộ khu tập gym</li><li><svg class="icon" viewBox="0 0 24 24"><use href="#i-check"/></svg>Check-in không giới hạn</li></ul></div>
                        <div class="package-card featured"><span class="badge-pop">Phổ biến nhất</span><div class="ptype">Gym + PT</div><div class="pname">Gym kèm huấn luyện viên</div><div class="price">1.200.000đ<span>/tháng</span></div>
                            <ul><li><svg class="icon" viewBox="0 0 24 24"><use href="#i-check"/></svg>48 buổi PT riêng / 6 tháng</li><li><svg class="icon" viewBox="0 0 24 24"><use href="#i-check"/></svg>Theo dõi chỉ số cơ thể</li><li><svg class="icon" viewBox="0 0 24 24"><use href="#i-check"/></svg>Thực đơn dinh dưỡng</li></ul></div>
                        <div class="package-card"><div class="ptype">Yoga</div><div class="pname">Yoga &amp; Phục hồi</div><div class="price">550.000đ<span>/tháng</span></div>
                            <ul><li><svg class="icon" viewBox="0 0 24 24"><use href="#i-check"/></svg>12 lớp nhóm / tháng</li><li><svg class="icon" viewBox="0 0 24 24"><use href="#i-check"/></svg>Phòng yoga riêng</li></ul></div>
                        <div class="package-card"><div class="ptype">VIP</div><div class="pname">VIP All-Access</div><div class="price">2.500.000đ<span>/tháng</span></div>
                            <ul><li><svg class="icon" viewBox="0 0 24 24"><use href="#i-check"/></svg>Không giới hạn buổi PT</li><li><svg class="icon" viewBox="0 0 24 24"><use href="#i-check"/></svg>Tủ đồ riêng &amp; ưu tiên giờ tập</li></ul></div>
                    </div>

                    <div class="grid-2">
                        <div class="card">
                            <div class="card-head"><h3>Doanh thu theo gói tập</h3></div>
                            <div class="rank-row"><span class="rname">Gym + PT</span><div class="rank-track"><div class="rank-fill" style="width:100%;"></div></div><span class="rval">98tr</span></div>
                            <div class="rank-row"><span class="rname">Gym cơ bản</span><div class="rank-track"><div class="rank-fill" style="width:62%;"></div></div><span class="rval">61tr</span></div>
                            <div class="rank-row"><span class="rname">VIP All-Access</span><div class="rank-track"><div class="rank-fill" style="width:21%;"></div></div><span class="rval">21tr</span></div>
                            <div class="rank-row"><span class="rname">Yoga</span><div class="rank-track"><div class="rank-fill" style="width:15%;"></div></div><span class="rval">15tr</span></div>
                        </div>
                        <div class="card">
                            <div class="card-head"><h3>Hóa đơn gần đây</h3></div>
                            <table>
                                <tr><td><b class="cell-name">HD20260612</b><div class="cell-sub">Phan Bảo Châu</div></td><td>2.500.000đ</td><td><span class="badge badge-ok">Đã thanh toán</span></td></tr>
                                <tr><td><b class="cell-name">HD20260611</b><div class="cell-sub">Vũ Thị Lan</div></td><td>550.000đ</td><td><span class="badge badge-warn">Chờ thanh toán</span></td></tr>
                                <tr><td><b class="cell-name">HD20260610</b><div class="cell-sub">Đặng Văn Long</div></td><td>1.200.000đ</td><td><span class="badge badge-ok">Đã thanh toán</span></td></tr>
                            </table>
                        </div>
                    </div>
                </section>
                <% } %>

                <!-- ===== REPORTS ===== -->
                <% if (canViewReports) { %>
                <section class="admin-section" id="sec-reports">
                    <div class="section-head"><div><h2>Báo cáo &amp; thống kê</h2><p class="sub">Tổng hợp tình hình vận hành phòng gym</p></div></div>

                    <div class="period-row">
                        <button class="period-btn">7 ngày</button><button class="period-btn active">30 ngày</button><button class="period-btn">Theo quý</button><button class="period-btn">Theo năm</button>
                    </div>

                    <div class="grid-4" style="margin-bottom:18px;">
                        <div class="kpi-card"><div class="kpi-label">Tổng doanh thu</div><div class="kpi-value">186,5tr</div><div class="kpi-delta up">+12%</div></div>
                        <div class="kpi-card"><div class="kpi-label">Hội viên mới</div><div class="kpi-value">18</div><div class="kpi-delta up">+5 so với tháng trước</div></div>
                        <div class="kpi-card"><div class="kpi-label">Tỷ lệ gia hạn</div><div class="kpi-value">86%</div><div class="kpi-delta up">+4%</div></div>
                        <div class="kpi-card"><div class="kpi-label">Hội viên rời đi</div><div class="kpi-value">7</div><div class="kpi-delta down"><svg class="icon" viewBox="0 0 24 24"><use href="#i-down"/></svg>-2 so với tháng trước</div></div>
                    </div>

                    <div class="grid-2" style="margin-bottom:18px;">
                        <div class="card">
                            <div class="card-head"><h3>Xu hướng doanh thu</h3></div>
                            <svg class="sparkline" style="height:120px;" viewBox="0 0 280 110" preserveAspectRatio="none">
                            <polyline points="0,80 40,76 80,82 120,60 160,66 200,40 240,32 280,14" fill="none" stroke="var(--ember)" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                            <div style="display:flex;justify-content:space-between;font-size:11px;color:var(--ink-faint);"><span>T11</span><span>T12</span><span>T1</span><span>T2</span><span>T3</span><span>T4</span><span>T5</span><span>T6</span></div>
                        </div>
                        <div class="card">
                            <div class="card-head"><h3>Phân bổ trạng thái hội viên</h3></div>
                            <div class="donut-wrap">
                                <div class="donut" style="background:conic-gradient(var(--teal) 0% 78%, var(--amber) 78% 92%, var(--red) 92% 100%);"></div>
                                <div class="legend">
                                    <div class="legend-row"><span class="legend-dot" style="background:var(--teal);"></span>Đang hoạt động<b>78%</b></div>
                                    <div class="legend-row"><span class="legend-dot" style="background:var(--amber);"></span>Sắp hết hạn<b>14%</b></div>
                                    <div class="legend-row"><span class="legend-dot" style="background:var(--red);"></span>Đã ngừng<b>8%</b></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-head"><h3>Hiệu suất huấn luyện viên</h3></div>
                        <div class="rank-row"><span class="rname">Trần Minh Khoa</span><div class="rank-track"><div class="rank-fill" style="width:95%;"></div></div><span class="rval">4.9</span></div>
                        <div class="rank-row"><span class="rname">Lê Thị Hồng</span><div class="rank-track"><div class="rank-fill" style="width:90%;"></div></div><span class="rval">4.8</span></div>
                        <div class="rank-row"><span class="rname">Phạm Quốc Bảo</span><div class="rank-track"><div class="rank-fill" style="width:85%;"></div></div><span class="rval">4.7</span></div>
                        <div class="rank-row"><span class="rname">Bùi Hải Nam</span><div class="rank-track"><div class="rank-fill" style="width:80%;"></div></div><span class="rval">4.6</span></div>
                    </div>
                </section>
                <% } %>

                <!-- ===== USERS & PERMISSIONS ===== -->
                <% if (canManageUsers) { %>
                <section class="admin-section" id="sec-users">
                    <div class="section-head"><div><h2>Người dùng &amp; phân quyền</h2><p class="sub">3 nhóm quyền · 22 tài khoản</p></div><button class="btn btn-primary"><svg class="icon" viewBox="0 0 24 24"><use href="#i-plus"/></svg>Thêm tài khoản</button></div>

                    <div class="perm-grid">
                        <div class="perm-card"><b>Admin</b><div class="pcount">2 tài khoản</div><div class="perm-tags"><span class="perm-tag">Toàn quyền</span><span class="perm-tag">Quản lý nhân sự</span><span class="perm-tag">Doanh thu</span><span class="perm-tag">Phân quyền</span></div></div>
                        <div class="perm-card"><b>Nhân viên</b><div class="pcount">6 tài khoản</div><div class="perm-tags"><span class="perm-tag">Quản lý khách hàng</span><span class="perm-tag">Hóa đơn</span><span class="perm-tag">Báo cáo</span></div></div>
                        <div class="perm-card"><b>Huấn luyện viên</b><div class="pcount">14 tài khoản</div><div class="perm-tags"><span class="perm-tag">Lịch tập</span><span class="perm-tag">Chỉ số cơ thể</span><span class="perm-tag">Khách hàng phụ trách</span></div></div>
                    </div>

                    <div class="table-wrap">
                        <table>
                            <thead><tr><th>Họ tên</th><th>Tên đăng nhập</th><th>Nhóm quyền</th><th>Trạng thái</th><th></th></tr></thead>
                            <tr><td><b class="cell-name">Lê Thị Quỳnh Anh</b></td><td>quynhanh.le</td><td>Admin</td><td><span class="badge badge-ok">Hoạt động</span></td><td><div class="row-actions"><button class="row-icon-btn"><svg class="icon" viewBox="0 0 24 24"><use href="#i-edit"/></svg></button></div></td></tr>
                            <tr><td><b class="cell-name">Đỗ Minh Quân</b></td><td>quan.do</td><td>Nhân viên</td><td><span class="badge badge-ok">Hoạt động</span></td><td><div class="row-actions"><button class="row-icon-btn"><svg class="icon" viewBox="0 0 24 24"><use href="#i-edit"/></svg></button></div></td></tr>
                            <tr><td><b class="cell-name">Trần Minh Khoa</b></td><td>khoa.tran</td><td>Huấn luyện viên</td><td><span class="badge badge-ok">Hoạt động</span></td><td><div class="row-actions"><button class="row-icon-btn"><svg class="icon" viewBox="0 0 24 24"><use href="#i-edit"/></svg></button></div></td></tr>
                            <tr><td><b class="cell-name">Bùi Hải Nam</b></td><td>nam.bui</td><td>Huấn luyện viên</td><td><span class="badge badge-danger">Đã khóa</span></td><td><div class="row-actions"><button class="row-icon-btn"><svg class="icon" viewBox="0 0 24 24"><use href="#i-edit"/></svg></button></div></td></tr>
                        </table>
                    </div>
                </section>
                <% } %>
            </main>
        </div>

        <!-- ================= CUSTOMER MOBILE APP ================= -->
        <div class="customer-wrap" id="customerShell" style="display:none;">
            <div class="phone">
                <div class="phone-inner">
                    <div class="phone-status"><span>9:41</span><span>VuxGym</span></div>
                    <div class="phone-screen">

                        <div class="cscreen active" id="cs-home">
                            <p class="greet">Chào <%= fullName %>,</p>
                            <p class="muted" style="font-size:13px;margin-bottom:14px;">Bạn còn 1 buổi tập trong hôm nay.</p>
                            <div class="today-card">
                                <div class="label">Buổi tập tiếp theo</div>
                                <div class="when">19:00 — Hôm nay</div>
                                <div class="with">Cùng PT Lê Thị Hồng · Yoga phục hồi</div>
                                <div class="row"><button class="btn btn-sm" style="background:#fff;">Xem chi tiết</button><button class="btn btn-sm btn-primary">Check-in</button></div>
                            </div>
                            <div class="stat-tiles">
                                <div class="stat-tile"><div class="lbl">Buổi đã tập tháng này</div><div class="val">11/16</div></div>
                                <div class="stat-tile"><div class="lbl">Calo tiêu thụ hôm nay</div><div class="val">420 kcal</div></div>
                            </div>
                            <div class="cta-row">
                                <button class="btn" onclick="showCust('schedule', this)">Xem lịch tập</button>
                                <button class="btn" onclick="showCust('package', this)">Gói tập của tôi</button>
                            </div>
                            <div class="card-head"><h3 style="font-size:13px;">Thông báo</h3></div>
                            <div class="sched-item"><div><div class="sname">Gói Yoga của bạn còn 4 ngày</div><div class="swith">Gia hạn ngay để không gián đoạn lịch tập</div></div></div>
                        </div>

                        <div class="cscreen" id="cs-schedule">
                            <h2 style="font-size:18px;margin:14px 0 6px;">Lịch tập của tôi</h2>
                            <div class="sched-day-label">Hôm nay, 23/06</div>
                            <div class="sched-item"><div class="sched-time">19:00</div><div><div class="sname">Yoga phục hồi</div><div class="swith">PT Lê Thị Hồng</div></div><span class="badge badge-ok sched-tag">Nhẹ</span></div>
                            <div class="sched-day-label">Thứ Năm, 25/06</div>
                            <div class="sched-item"><div class="sched-time">19:00</div><div><div class="sname">Yoga cân bằng cơ thể</div><div class="swith">PT Lê Thị Hồng</div></div><span class="badge badge-ok sched-tag">Nhẹ</span></div>
                            <div class="sched-day-label">Thứ Bảy, 27/06</div>
                            <div class="sched-item"><div class="sched-time">08:00</div><div><div class="sname">Yoga ngoài trời</div><div class="swith">PT Lê Thị Hồng</div></div><span class="badge badge-ok sched-tag">Nhẹ</span></div>
                        </div>

                        <div class="cscreen" id="cs-checkin">
                            <h2 style="font-size:18px;margin:14px 0 4px;">Check-in bằng mã QR</h2>
                            <p class="muted" style="font-size:12.5px;">Đưa mã này cho lễ tân hoặc quét tại cổng vào</p>
                            <div class="qr-box" id="qrGrid"></div>
                            <p style="text-align:center;font-size:12px;color:var(--ink-faint);margin-bottom:18px;">Mã hội viên: KH00130</p>
                            <div class="card-head"><h3 style="font-size:13px;">Lịch sử check-in</h3></div>
                            <div class="checkin-history">
                                <div class="ci-row"><span>Hôm nay</span><span class="ci-date">06:42 — 07:38</span></div>
                                <div class="ci-row"><span>21/06/2026</span><span class="ci-date">18:05 — 19:10</span></div>
                                <div class="ci-row"><span>19/06/2026</span><span class="ci-date">06:30 — 07:25</span></div>
                            </div>
                        </div>

                        <div class="cscreen" id="cs-body">
                            <h2 style="font-size:18px;margin:14px 0 10px;">Chỉ số cơ thể &amp; dinh dưỡng</h2>
                            <svg class="sparkline" viewBox="0 0 320 70" preserveAspectRatio="none">
                            <polyline points="0,18 45,22 90,20 135,30 180,34 225,40 270,44 320,50" fill="none" stroke="var(--ember)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                            <div style="display:flex;justify-content:space-between;font-size:11px;color:var(--ink-faint);margin-bottom:6px;"><span>58.4 kg</span><span>54.2 kg</span></div>
                            <div class="body-row2">
                                <div class="body-mini"><div class="v">21.1</div><div class="l">BMI</div></div>
                                <div class="body-mini"><div class="v">22%</div><div class="l">Tỷ lệ mỡ</div></div>
                                <div class="body-mini"><div class="v">54.2kg</div><div class="l">Cân nặng</div></div>
                            </div>
                            <div class="ring-block">
                                <div class="ring" style="background:conic-gradient(var(--teal) 0% 62%, var(--line) 62% 100%);"><div class="ring-val">62%</div></div>
                                <div><div class="rb-title">Tiến độ tới mục tiêu</div><div class="rb-sub">Mục tiêu: 52kg trước 30/08/2026</div></div>
                            </div>
                            <div class="card-head"><h3 style="font-size:13px;">Dinh dưỡng hôm nay</h3><span class="muted" style="font-size:11.5px;">TDEE 1.940 kcal</span></div>
                            <div class="macro-row"><span class="mname">Protein</span><div class="rank-track"><div class="rank-fill" style="width:70%;background:var(--ember);"></div></div><span class="gval">98g</span></div>
                            <div class="macro-row"><span class="mname">Carb</span><div class="rank-track"><div class="rank-fill" style="width:55%;background:var(--teal);"></div></div><span class="gval">176g</span></div>
                            <div class="macro-row"><span class="mname">Fat</span><div class="rank-track"><div class="rank-fill" style="width:40%;background:var(--amber);"></div></div><span class="gval">52g</span></div>
                            <button class="btn btn-sm" style="margin-top:6px;"><svg class="icon" viewBox="0 0 24 24"><use href="#i-plus"/></svg>Cập nhật chỉ số</button>
                        </div>

                        <div class="cscreen" id="cs-package">
                            <h2 style="font-size:18px;margin:14px 0 10px;">Gói tập của tôi</h2>
                            <div class="pkg-progress-card">
                                <div class="pname">Yoga &amp; Phục hồi</div>
                                <div class="pdate">Hết hạn ngày 29/06/2026 — còn 6 ngày</div>
                                <div class="progress-track"><div class="progress-fill" style="width:80%;background:var(--amber);"></div></div>
                                <button class="btn btn-primary btn-sm" style="margin-top:12px;width:100%;justify-content:center;">Gia hạn ngay</button>
                            </div>
                            <div class="card-head"><h3 style="font-size:13px;">Lịch sử hóa đơn</h3></div>
                            <div class="checkin-history">
                                <div class="ci-row"><span>Yoga &amp; Phục hồi — 1 tháng</span><span class="ci-date">550.000đ</span></div>
                                <div class="ci-row"><span>Gym cơ bản — 3 tháng</span><span class="ci-date">1.250.000đ</span></div>
                            </div>
                        </div>

                    </div>
                    <nav class="tabbar">
                        <button class="tab-item active" onclick="showCust('home', this)"><svg class="icon" viewBox="0 0 24 24"><use href="#i-home"/></svg>Trang chủ</button>
                        <button class="tab-item" onclick="showCust('schedule', this)"><svg class="icon" viewBox="0 0 24 24"><use href="#i-calendar"/></svg>Lịch tập</button>
                        <button class="tab-item" onclick="showCust('checkin', this)"><svg class="icon" viewBox="0 0 24 24"><use href="#i-qr"/></svg>Check-in</button>
                        <button class="tab-item" onclick="showCust('body', this)"><svg class="icon" viewBox="0 0 24 24"><use href="#i-activity"/></svg>Chỉ số</button>
                        <button class="tab-item" onclick="showCust('package', this)"><svg class="icon" viewBox="0 0 24 24"><use href="#i-box"/></svg>Gói tập</button>
                    </nav>
                </div>
            </div>
        </div>

    </div>

    <script>
        var INITIAL_MODE = "<%= initialMode %>";
        function setMode(mode, btn) {
            document.getElementById('adminShell').style.display = mode === 'admin' ? 'flex' : 'none';
            document.getElementById('customerShell').style.display = mode === 'customer' ? 'flex' : 'none';
            document.querySelectorAll('.role-btn[data-mode]').forEach(function (b) {
                b.classList.toggle('active', b === btn);
            });
        }
        function showSection(id, btn) {
            document.querySelectorAll('.admin-section').forEach(function (s) {
                s.classList.toggle('active', s.id === 'sec-' + id);
            });
            document.querySelectorAll('.nav-item').forEach(function (b) {
                b.classList.toggle('active', b === btn);
            });
        }
        function selectCustomerRow(row) {
            document.querySelectorAll('#customerTable tbody tr').forEach(function (r) {
                r.classList.remove('selected');
            });
            row.classList.add('selected');
        }
        function showCustTab(id, btn) {
            document.querySelectorAll('.tab-panel').forEach(function (p) {
                p.classList.toggle('active', p.id === 'ctab-' + id);
            });
            document.querySelectorAll('#sec-customers .tab-btn').forEach(function (b) {
                b.classList.toggle('active', b === btn);
            });
        }
        function showCust(id, btn) {
            document.querySelectorAll('.cscreen').forEach(function (s) {
                s.classList.toggle('active', s.id === 'cs-' + id);
            });
            document.querySelectorAll('.tab-item').forEach(function (b) {
                b.classList.toggle('active', b === btn);
            });
            if (!btn) {
                document.querySelectorAll('.tab-item').forEach(function (b) {
                    if (b.getAttribute('onclick') && b.getAttribute('onclick').indexOf("'" + id + "'") > -1) {
                        b.classList.add('active');
                    } else {
                        b.classList.remove('active');
                    }
                });
            }
        }
        (function () {
            var grid = document.getElementById('qrGrid');
            var pattern = [1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1];
            for (var i = 0; i < pattern.length; i++) {
                var cell = document.createElement('i');
                cell.style.opacity = pattern[i] ? '1' : '0';
                grid.appendChild(cell);
            }
        })();
        setMode(INITIAL_MODE, null);
    </script>
</body>
</html>
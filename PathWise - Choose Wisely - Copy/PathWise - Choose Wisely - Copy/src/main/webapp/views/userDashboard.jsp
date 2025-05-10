<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PathWise - User Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f5f7fa, #eef2f7);
            min-height: 100vh;
            color: #333;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            background: linear-gradient(135deg, #3CB371, #20B2AA);
            color: white;
            padding: 20px 0;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
        }

        .nav-links {
            display: flex;
            gap: 20px;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 8px 12px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .nav-links a:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logout-btn {
            background-color: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .logout-btn:hover {
            background-color: rgba(255, 255, 255, 0.3);
        }

        .dashboard {
            margin-top: 30px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .card-title {
            font-size: 18px;
            margin-bottom: 15px;
            color: #3CB371;
            font-weight: 600;
        }

        .stat {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .stat-description {
            color: #666;
            font-size: 14px;
        }

        .chart-container {
            height: 200px;
            margin-top: 15px;
        }

        .recent-trips {
            margin-top: 30px;
        }

        .recent-trips h2 {
            margin-bottom: 20px;
            color: #333;
        }

        .trip-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 15px;
        }

        .trip-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 15px;
        }

        .trip-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .trip-date {
            color: #666;
            font-size: 14px;
        }

        .trip-mode {
            background: #e8f5e9;
            color: #3CB371;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }

        .trip-route {
            margin-bottom: 10px;
            font-weight: 600;
        }

        .trip-stats {
            display: flex;
            gap: 10px;
            font-size: 14px;
            color: #666;
        }

        .view-all-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 8px 16px;
            background: #3CB371;
            color: white;
            border-radius: 4px;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .view-all-btn:hover {
            background: #2e8b57;
        }

        @media (max-width: 768px) {
            .dashboard {
                grid-template-columns: 1fr;
            }
            
            .header-content {
                flex-direction: column;
                gap: 10px;
            }
            
            .nav-links {
                margin-top: 10px;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="logo">PathWise</div>
            <nav class="nav-links">
                <a href="${pageContext.request.contextPath}/sustainableHome">Home</a>
                <a href="${pageContext.request.contextPath}/user/dashboard">Dashboard</a>
                <a href="${pageContext.request.contextPath}/user/trip-history">Trip History</a>
            </nav>
            <div class="user-info">
                <span>Welcome, ${user.fullName}</span>
                <form action="${pageContext.request.contextPath}/logout" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="dashboard">
            <div class="card">
                <div class="card-title">Total Trips</div>
                <div class="stat">${tripCount}</div>
                <div class="stat-description">Sustainable journeys completed</div>
            </div>
            
            <div class="card">
                <div class="card-title">Carbon Saved</div>
                <div class="stat"><fmt:formatNumber value="${totalCarbonSaved}" pattern="#,##0.00" /> kg</div>
                <div class="stat-description">CO₂ emissions prevented</div>
            </div>
            
            <div class="card">
                <div class="card-title">Cost Saved</div>
                <div class="stat">₹<fmt:formatNumber value="${totalCostSaved}" pattern="#,##0.00" /></div>
                <div class="stat-description">Money saved by choosing sustainable options</div>
            </div>
            
            <div class="card">
                <div class="card-title">Top Transportation Mode</div>
                <div class="stat">
                    <c:set var="topMode" value="" />
                    <c:set var="topCount" value="0" />
                    <c:forEach var="entry" items="${modeStats}">
                        <c:if test="${entry.value > topCount}">
                            <c:set var="topMode" value="${entry.key}" />
                            <c:set var="topCount" value="${entry.value}" />
                        </c:if>
                    </c:forEach>
                    ${topMode}
                </div>
                <div class="stat-description">Your most frequently used travel method</div>
            </div>
        </div>
        
        <a href="${pageContext.request.contextPath}/user/trip-history" class="view-all-btn">View Full Trip History</a>
    </div>
    
    <script>
        // Add chart logic here if needed
    </script>
</body>
</html> 
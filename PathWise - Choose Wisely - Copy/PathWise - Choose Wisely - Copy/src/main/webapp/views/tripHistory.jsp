<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PathWise - Trip History</title>
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

        .page-title {
            margin: 30px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #eee;
            font-size: 24px;
            color: #333;
        }

        .trip-history {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .trip-table {
            width: 100%;
            border-collapse: collapse;
        }

        .trip-table th {
            background: #f5f7fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #333;
            border-bottom: 1px solid #eee;
        }

        .trip-table td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }

        .trip-table tr:last-child td {
            border-bottom: none;
        }

        .trip-table tr:hover {
            background: #f9f9f9;
        }

        .mode-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
        }

        .mode-bike {
            background: #e8f5e9;
            color: #2e7d32;
        }

        .mode-walk {
            background: #e3f2fd;
            color: #1565c0;
        }

        .mode-bus {
            background: #fff3e0;
            color: #e65100;
        }

        .mode-train {
            background: #f3e5f5;
            color: #6a1b9a;
        }

        .mode-car {
            background: #fbe9e7;
            color: #d84315;
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: #666;
        }

        .empty-state p {
            margin-top: 10px;
        }

        .start-trip-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 16px;
            background: #3CB371;
            color: white;
            border-radius: 4px;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .start-trip-btn:hover {
            background: #2e8b57;
        }

        .back-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 8px 16px;
            background: #607d8b;
            color: white;
            border-radius: 4px;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .back-btn:hover {
            background: #455a64;
        }

        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: 10px;
            }
            
            .nav-links {
                margin-top: 10px;
            }
            
            .trip-table {
                font-size: 14px;
            }
            
            .trip-table th,
            .trip-table td {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="logo">PathWise</div>
            <nav class="nav-links">
                <a href="${pageContext.request.contextPath}/sustainable/home">Home</a>
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
        <h1 class="page-title">Your Trip History</h1>
        
        <div class="trip-history">
            <c:choose>
                <c:when test="${empty trips}">
                    <div class="empty-state">
                        <h3>No trips recorded yet</h3>
                        <p>Start your first sustainable journey to begin tracking your impact!</p>
                        <a href="${pageContext.request.contextPath}/sustainable/home" class="start-trip-btn">Plan a Trip</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="trip-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Route</th>
                                <th>Mode</th>
                                <th>Distance</th>
                                <th>Carbon Saved</th>
                                <th>Cost Saved</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="trip" items="${trips}">
                                <tr>
                                    <td><fmt:formatDate value="${date}" pattern="MMM dd, yyyy HH:mm" /></td>
                                    <td>${trip.origin} → ${trip.destination}</td>
                                    <td>
                                        <span class="mode-badge mode-${trip.travelMode.toLowerCase()}">${trip.travelMode}</span>
                                    </td>
                                    <td><fmt:formatNumber value="${trip.distanceKm}" pattern="#,##0.0" /> km</td>
                                    <td><fmt:formatNumber value="${trip.carbonSavedKg}" pattern="#,##0.00" /> kg</td>
                                    <td>₹<fmt:formatNumber value="${trip.costSaved}" pattern="#,##0.00" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
        
        <a href="${pageContext.request.contextPath}/user/dashboard" class="back-btn">Back to Dashboard</a>
    </div>
</body>
</html> 
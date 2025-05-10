<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EcoJourney - Trip History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #343a40;
        }
        .header {
            background: linear-gradient(135deg, #8BC34A 0%, #009688 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            margin-bottom: 20px;
            overflow: hidden;
        }
        .btn-eco {
            background: linear-gradient(135deg, #8BC34A 0%, #009688 100%);
            color: white;
            border: none;
            border-radius: 10px;
            transition: all 0.3s ease;
        }
        .btn-eco:hover {
            background: linear-gradient(135deg, #7CB342 0%, #00897B 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .trip-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 1.5rem;
        }
        .trip-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .mode-icon {
            font-size: 1.5rem;
            margin-right: 10px;
        }
        .trip-card-header {
            background-color: #f8f9fa;
            padding: 1rem;
            border-bottom: 1px solid rgba(0,0,0,.05);
        }
        .trip-metrics {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 15px;
        }
        .metric {
            padding: 8px 15px;
            background-color: #f8f9fa;
            border-radius: 10px;
            font-size: 0.9rem;
            color: #6c757d;
        }
        .metric strong {
            color: #343a40;
        }
        .eco-tag {
            background-color: #e9ecef;
            color: #495057;
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 0.8rem;
            margin-right: 5px;
        }
        .eco-tag.good {
            background-color: #d4edda;
            color: #155724;
        }
        .eco-tag.medium {
            background-color: #fff3cd;
            color: #856404;
        }
        .eco-tag.bad {
            background-color: #f8d7da;
            color: #721c24;
        }
        .footer {
            background-color: #343a40;
            color: white;
            padding: 2rem 0;
            margin-top: 4rem;
        }
        .empty-state {
            text-align: center;
            padding: 3rem;
        }
        .empty-state-icon {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 1rem;
        }
        @media (max-width: 767px) {
            .trip-metrics {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
<body>

<div class="header text-center">
    <div class="container">
        <h1>Your Trip History</h1>
        <p>Review your past sustainable journeys</p>
    </div>
</div>

<div class="container">
    <c:choose>
        <c:when test="${empty trips}">
            <div class="card empty-state">
                <i class="fas fa-route empty-state-icon"></i>
                <h3>No trips yet</h3>
                <p class="text-muted">You haven't completed any sustainable trips yet. Start planning your first eco-friendly journey!</p>
                <a href="/sustainable/" class="btn btn-eco mt-3">
                    <i class="fas fa-plus-circle me-2"></i> Plan Your First Trip
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:forEach var="trip" items="${trips}">
                    <div class="col-lg-6">
                        <div class="card trip-card">
                            <div class="trip-card-header d-flex justify-content-between align-items-center">
                                <div>
                                    <h5 class="mb-0">${trip.origin} to ${trip.destination}</h5>
                                    <small class="text-muted"><fmt:formatDate value="${date}" pattern="MMM dd, yyyy h:mm a" /></small>
                                </div>
                                
                                <c:forEach var="option" items="${trip.travelOptions}">
                                    <c:if test="${option.selected}">
                                        <div class="d-flex align-items-center">
                                            <c:choose>
                                                <c:when test="${option.transportMode == 'WALKING'}">
                                                    <i class="fas fa-walking mode-icon"></i>
                                                </c:when>
                                                <c:when test="${option.transportMode == 'CYCLING'}">
                                                    <i class="fas fa-bicycle mode-icon"></i>
                                                </c:when>
                                                <c:when test="${option.transportMode == 'BIKE'}">
                                                    <i class="fas fa-motorcycle mode-icon"></i>
                                                </c:when>
                                                <c:when test="${option.transportMode == 'CAR'}">
                                                    <i class="fas fa-car mode-icon"></i>
                                                </c:when>
                                                <c:when test="${option.transportMode == 'BUS'}">
                                                    <i class="fas fa-bus mode-icon"></i>
                                                </c:when>
                                            </c:choose>
                                            
                                            <c:choose>
                                                <c:when test="${option.actualCo2Emission == 0}">
                                                    <span class="eco-tag good">
                                                        <i class="fas fa-leaf me-1"></i> Zero Emission
                                                    </span>
                                                </c:when>
                                                <c:when test="${option.actualCo2Emission < 500}">
                                                    <span class="eco-tag medium">
                                                        <i class="fas fa-leaf me-1"></i> Low Emission
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="eco-tag bad">
                                                        <i class="fas fa-smog me-1"></i> High Emission
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                            
                            <div class="card-body">
                                <p><strong>Priority:</strong> ${trip.userPreference}</p>
                                <p><strong>Travel Type :</strong> ${trip.travelType}</p>
                                
                                <div class="trip-metrics">
                                    <c:forEach var="option" items="${trip.travelOptions}">
                                        <c:if test="${option.selected}">
                                            <div class="metric">
                                                <i class="fas fa-route me-1"></i> <strong><fmt:formatNumber value="${option.actualDistance / 1000}" pattern="#,##0.0" /> km</strong>
                                            </div>
                                            
                                            <div class="metric">
                                                <i class="fas fa-clock me-1"></i>
                                                <strong>
                                                    <c:set var="hours" value="${Math.floor(option.actualDuration / 3600)}" />
                                                    <c:set var="minutes" value="${Math.floor((option.actualDuration % 3600) / 60)}" />
                                                    <c:choose>
                                                        <c:when test="${hours > 0}">
                                                            ${hours}h ${minutes}m
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${minutes} min
                                                        </c:otherwise>
                                                    </c:choose>
                                                </strong>
                                            </div>
                                            
                                            <div class="metric">
                                                <i class="fa-solid fa-indian-rupee-sign"></i> <strong>₹<fmt:formatNumber value="${option.actualCost}" pattern="#,##0.00" /></strong>
                                            </div>
                                            
                                            <div class="metric">
                                                <i class="fas fa-leaf me-1"></i> <strong><fmt:formatNumber value="${option.actualCo2Emission}" pattern="#,##0" /> g</strong>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
    
    <div class="text-center mt-4">
        <a href="/sustainable/" class="btn btn-eco">
            <i class="fas fa-plus-circle me-2"></i> Plan New Journey
        </a>
    </div>
</div>

<footer class="footer text-center">
    <div class="container">
        <p>© 2025 Pathwise - Choose Wisely. Commute Smartly.</p>
        <p>Built with <i class="fas fa-heart"></i> for a greener future</p>
    </div>
</footer>

</body>
</html> 
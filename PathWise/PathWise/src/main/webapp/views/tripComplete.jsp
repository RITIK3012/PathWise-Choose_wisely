<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pathwise - Trip Completed</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=${apiKey}&callback=initMap" defer></script>
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
        }
        .map-container {
            height: 400px;
            width: 100%;
            border-radius: 15px;
            overflow: hidden;
            margin-bottom: 20px;
        }
        #map {
            height: 100%;
            width: 100%;
        }
        .btn-eco {
            background: linear-gradient(135deg, #8BC34A 0%, #009688 100%);
            color: white;
            border: none;
            border-radius: 10px;
            padding: 10px 20px;
            transition: all 0.3s ease;
        }
        .btn-eco:hover {
            background: linear-gradient(135deg, #7CB342 0%, #00897B 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            position: relative;
            padding-left: 15px;
            border-left: 5px solid #8BC34A;
        }
        .compare-card {
            padding: 15px;
            border-radius: 15px;
            margin-bottom: 15px;
            background-color: white;
            transition: all 0.3s ease;
        }
        .compare-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.05);
        }
        .stat-title {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        .stat-value {
            font-size: 1.5rem;
            font-weight: 600;
        }
        .stat-diff {
            font-size: 0.85rem;
            padding: 3px 8px;
            border-radius: 10px;
            display: inline-block;
            margin-left: 10px;
        }
        .diff-positive {
            background-color: #f8d7da;
            color: #721c24;
        }
        .diff-negative {
            background-color: #d4edda;
            color: #155724;
        }
        .diff-neutral {
            background-color: #e9ecef;
            color: #495057;
        }
        .eco-impact {
            background-color: #e8f5e9;
            border-radius: 15px;
            padding: 20px;
            margin-top: 20px;
        }
        .impact-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            color: #4CAF50;
        }
        .footer {
            background-color: #343a40;
            color: white;
            padding: 2rem 0;
            margin-top: 4rem;
        }
        .transport-badge {
            background-color: #e9ecef;
            color: #495057;
            padding: 5px 10px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
        }
        .transport-badge i {
            margin-right: 5px;
        }
        @media (max-width: 767px) {
            .compare-card {
                margin-bottom: 15px;
            }
            .stat-value {
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>

<div class="header text-center">
    <div class="container">
        <h1><i class="fas fa-check-circle me-2"></i> Trip Completed!</h1>
        <p>From ${trip.origin} to ${trip.destination}</p>
    </div>
</div>

<div class="container">
    <div class="transport-badge mb-4">
        <c:choose>
            <c:when test="${option.transportMode == 'WALKING'}">
                <i class="fas fa-walking"></i>
            </c:when>
            <c:when test="${option.transportMode == 'CYCLING'}">
                <i class="fas fa-bicycle"></i>
            </c:when>
            <c:when test="${option.transportMode == 'BIKE'}">
                <i class="fas fa-motorcycle"></i>
            </c:when>
            <c:when test="${option.transportMode == 'CAR'}">
                <i class="fas fa-car"></i>
            </c:when>
            <c:when test="${option.transportMode == 'BUS'}">
                <i class="fas fa-bus"></i>
            </c:when>
        </c:choose>
        ${option.transportMode} Mode
    </div>
    
    <div class="map-container">
        <div id="map"></div>
    </div>
    
    <div class="card p-4">
        <h2 class="section-title">Trip Summary</h2>
        
        <div class="row">
            <div class="col-md-3 col-6 mb-4">
                <div class="compare-card">
                    <div class="stat-title">Distance</div>
                    <div class="stat-value">
                        <fmt:formatNumber value="${option.actualDistance / 1000}" pattern="#,##0.0" /> km
                        
                        <c:set var="distanceDiffPercent" value="${(distanceDiff / option.distance) * 100}" />
                        <c:choose>
                            <c:when test="${distanceDiff > 0}">
                                <span class="stat-diff diff-positive">
                                    +<fmt:formatNumber value="${distanceDiffPercent}" pattern="#,##0.0" />%
                                </span>
                            </c:when>
                            <c:when test="${distanceDiff < 0}">
                                <span class="stat-diff diff-negative">
                                    <fmt:formatNumber value="${distanceDiffPercent}" pattern="#,##0.0" />%
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="stat-diff diff-neutral">0%</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="small text-muted">
                        Expected: <fmt:formatNumber value="${option.distance / 1000}" pattern="#,##0.0" /> km
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 col-6 mb-4">
                <div class="compare-card">
                    <div class="stat-title">Duration</div>
                    <div class="stat-value">
                        <c:set var="actualHours" value="${Math.floor(option.actualDuration / 3600)}" />
                        <c:set var="actualMinutes" value="${Math.floor((option.actualDuration % 3600) / 60)}" />
                        <c:choose>
                            <c:when test="${actualHours > 0}">
                                ${actualHours}h ${actualMinutes}m
                            </c:when>
                            <c:otherwise>
                                ${actualMinutes} min
                            </c:otherwise>
                        </c:choose>
                        
                        <c:set var="durationDiffPercent" value="${(durationDiff / option.duration) * 100}" />
                        <c:choose>
                            <c:when test="${durationDiff > 0}">
                                <span class="stat-diff diff-positive">
                                    +<fmt:formatNumber value="${durationDiffPercent}" pattern="#,##0.0" />%
                                </span>
                            </c:when>
                            <c:when test="${durationDiff < 0}">
                                <span class="stat-diff diff-negative">
                                    <fmt:formatNumber value="${durationDiffPercent}" pattern="#,##0.0" />%
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="stat-diff diff-neutral">0%</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="small text-muted">
                        Expected: 
                        <c:set var="estHours" value="${Math.floor(option.duration / 3600)}" />
                        <c:set var="estMinutes" value="${Math.floor((option.duration % 3600) / 60)}" />
                        <c:choose>
                            <c:when test="${estHours > 0}">
                                ${estHours}h ${estMinutes}m
                            </c:when>
                            <c:otherwise>
                                ${estMinutes} min
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 col-6 mb-4">
                <div class="compare-card">
                    <div class="stat-title">Cost</div>
                    <div class="stat-value">
                        ₹<fmt:formatNumber value="${option.actualCost}" pattern="#,##0.00" />
                        
                        <c:set var="costDiffPercent" value="${(costDiff / option.cost) * 100}" />
                        <c:choose>
                            <c:when test="${costDiff > 0}">
                                <span class="stat-diff diff-positive">
                                    +<fmt:formatNumber value="${costDiffPercent}" pattern="#,##0.0" />%
                                </span>
                            </c:when>
                            <c:when test="${costDiff < 0}">
                                <span class="stat-diff diff-negative">
                                    <fmt:formatNumber value="${costDiffPercent}" pattern="#,##0.0" />%
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="stat-diff diff-neutral">0%</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="small text-muted">
                        Expected: ₹<fmt:formatNumber value="${option.cost}" pattern="#,##0.00" />
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 col-6 mb-4">
                <div class="compare-card">
                    <div class="stat-title">CO₂ Emissions</div>
                    <div class="stat-value">
                        <fmt:formatNumber value="${option.actualCo2Emission}" pattern="#,##0" /> g
                        
                        <c:set var="co2DiffPercent" value="${(co2Diff / option.co2Emission) * 100}" />
                        <c:choose>
                            <c:when test="${co2Diff > 0}">
                                <span class="stat-diff diff-positive">
                                    +<fmt:formatNumber value="${co2DiffPercent}" pattern="#,##0.0" />%
                                </span>
                            </c:when>
                            <c:when test="${co2Diff < 0}">
                                <span class="stat-diff diff-negative">
                                    <fmt:formatNumber value="${co2DiffPercent}" pattern="#,##0.0" />%
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="stat-diff diff-neutral">0%</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="small text-muted">
                        Expected: <fmt:formatNumber value="${option.co2Emission}" pattern="#,##0" /> g
                    </div>
                </div>
            </div>
        </div>
        
        <div class="eco-impact text-center">
            <i class="fas fa-leaf impact-icon"></i>
            <h3>Your Environmental Impact</h3>
            
            <c:if test="${option.transportMode == 'WALKING' || option.transportMode == 'CYCLING'}">
                <p class="lead">Congratulations on choosing a zero-emission transport mode!</p>
                <p>Your trip saved approximately <strong><fmt:formatNumber value="${170 * (option.actualDistance / 1000)}" pattern="#,##0" /> g</strong> of CO₂ compared to driving a car.</p>
            </c:if>

            <c:if test="${option.transportMode == 'BIKE'}">
                <p class="lead">Great choice using bike transportation mode.</p>
                <p>Your trip saved approximately <strong><fmt:formatNumber value="${30 * (option.actualDistance / 1000)}" pattern="#,##0" /> g</strong> of CO₂ compared to driving a car.</p>
            </c:if>
            
            <c:if test="${option.transportMode == 'BUS'}">
                <p class="lead">Great choice using public transport!</p>
                <p>Your bus trip produced approximately <strong><fmt:formatNumber value="${65 * (option.actualDistance / 1000)}" pattern="#,##0" /> g</strong> less CO₂ than if you had taken a car.</p>
            </c:if>
            
            <c:if test="${option.transportMode == 'CAR'}">
                <p class="lead">Next time, consider a greener alternative!</p>
                <p>Walking or cycling would have saved <strong><fmt:formatNumber value="${option.actualCo2Emission}" pattern="#,##0" /> g</strong> of CO₂ emissions.</p>
            </c:if>
        </div>
    </div>
    
    <div class="text-center mt-4">
        <a href="/sustainable/" class="btn btn-eco">
            <i class="fas fa-route me-2"></i> Plan Another Journey
        </a>
        <a href="/sustainable/history" class="btn btn-outline-secondary ms-2">
            <i class="fas fa-history me-2"></i> View Trip History
        </a>
    </div>
</div>

<footer class="footer text-center">
    <div class="container">
        <p>© 2025 Pathwise - Choose Wisely. Commute Smartly.</p>
        <p>Built with <i class="fas fa-heart"></i> for a greener future</p>
    </div>
</footer>

<script>
    let map;
    let directionsService;
    let directionsRenderer;
    
    function initMap() {
        map = new google.maps.Map(document.getElementById("map"), {
            zoom: 13,
            center: { lat: Number('${trip.originLat}'), lng: Number('${trip.originLng}') },
        });
        
        directionsService = new google.maps.DirectionsService();
        directionsRenderer = new google.maps.DirectionsRenderer({
            map: map
        });
        
        // Show the route
        showRoute('${option.transportMode}');
    }
    
    function showRoute(mode) {
        // Convert mode to Google Maps DirectionsTravelMode
        let travelMode;
        switch(mode) {
            case 'WALKING':
                travelMode = 'WALKING';
                break;
            case 'CYCLING':
                travelMode = 'BICYCLING';
                break;
            case 'BIKE':
                travelMode = 'DRIVING';
                break;
            case 'CAR':
                travelMode = 'DRIVING';
                break;
            case 'BUS':
                travelMode = 'TRANSIT';
                break;
            default:
                travelMode = 'DRIVING';
        }
        
        const request = {
            origin: { lat: Number('${trip.originLat}'), lng: Number('${trip.originLng}') },
            destination: { lat: Number('${trip.destinationLat}'), lng: Number('${trip.destinationLng}') },
            travelMode: travelMode
        };
        
        directionsService.route(request, (result, status) => {
            if (status === "OK") {
                directionsRenderer.setDirections(result);
            }
        });
    }
</script>

</body>
</html> 
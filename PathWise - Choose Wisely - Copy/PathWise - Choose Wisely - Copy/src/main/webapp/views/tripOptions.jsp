<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pathwise - Travel Options</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
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
        .nav-links {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 10px;
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
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            margin-bottom: 20px;
            overflow: hidden;
        }
        .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid rgba(0,0,0,.05);
        }
        .recommendation-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-left: 5px solid #8BC34A;
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
        .option-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .option-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .mode-icon {
            font-size: 2rem;
            margin-right: 15px;
        }
        .stat-box {
            text-align: center;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 10px;
        }
        .stat-value {
            font-size: 1.2rem;
            font-weight: bold;
        }
        .stat-label {
            font-size: 0.8rem;
            color: #6c757d;
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
        .preference-form {
            margin-bottom: 30px;
        }
        .preference-select {
            padding: 10px;
            border-radius: 10px;
            border: 1px solid #ced4da;
        }
        .analysis-section {
            margin-top: 2rem;
            margin-bottom: 2rem;
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
        @media (max-width: 767px) {
            .mode-icon {
                font-size: 1.5rem;
            }
            .stat-value {
                font-size: 1rem;
            }
        }


        .analysis-section p {
          margin: 0 0 3px 0; /* reduce paragraph bottom margin */
        }

        .analysis-section ul {
          margin: 3px 0;
          padding-left: 20px;
        }

        .analysis-section li {
          margin-bottom: 3px;
          line-height: 1.4; /* tighter line spacing */
        }

        .analysis-section h3, .analysis-section h4 {
          margin-top: 6px;
          margin-bottom: 3px;
          font-weight: bold;
        }

        .recommendation-card p,
        .recommendation-card ul,
        .recommendation-card li {
          margin: 0;
          padding: 0;
        }

        .recommendation-card ul {
          margin-left: 20px;
          margin-top: 6px;
          margin-bottom: 6px;
        }

        .recommendation-card li {
          margin-bottom: 4px;
          line-height: 1.5;
        }

        .recommendation-card strong {
          color: #2c3e50;
        }
    </style>
</head>
<body>

<div class="header text-center">
    <div class="container">
        <h1>Your Travel Options</h1>
        <p>From ${trip.origin} to ${trip.destination}</p>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/sustainable/home"><i class="fas fa-home"></i> Home</a>
            <a href="${pageContext.request.contextPath}/user/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/user/trip-history"><i class="fas fa-history"></i> Trip History</a>
        </nav>
    </div>
</div>

<div class="container">
    <div class="map-container">
        <div id="map"></div>
    </div>
    
    <div class="row">
        <div class="col-md-8">
            <form class="preference-form" action="${pageContext.request.contextPath}/sustainable/${trip.id}/update-preference" method="post">
                <div class="d-flex align-items-center">
                    <label for="preference" class="me-3">Update your priority:</label>
                    <select class="preference-select me-3" id="preference" name="preference">
                        <option value="FASTEST" ${trip.userPreference == 'FASTEST' ? 'selected' : ''}>Fastest Route</option>
                        <option value="CHEAPEST" ${trip.userPreference == 'CHEAPEST' ? 'selected' : ''}>Cheapest Route</option>
                        <option value="GREENEST" ${trip.userPreference == 'GREENEST' ? 'selected' : ''}>Eco-friendly (Lowest CO₂)</option>
                        <option value="BALANCED" ${trip.userPreference == 'BALANCED' ? 'selected' : ''}>Balanced</option>
                    </select>
                    <button type="submit" class="btn btn-eco">Update</button>
                </div>
            </form>
        </div>
    </div>
    
    <div class="recommendation-card card p-4 mb-4">
        <h4><i class="fas fa-robot me-2"></i> AI Recommendation</h4>
        <div id="formattedRecommendation"></div>
    </div>
    
    <div class="row">
        <c:forEach var="option" items="${travelOptions}">
            <div class="col-md-6 mb-4">
                <div class="card option-card h-100">
                    <div class="card-header d-flex align-items-center">
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
                        <h5 class="mb-0">${option.transportMode}</h5>
                        
                        <c:choose>
                            <c:when test="${option.co2Emission == 0}">
                                <span class="ms-auto eco-tag good">
                                    <i class="fas fa-leaf me-1"></i> Zero Emission
                                </span>
                            </c:when>
                            <c:when test="${option.co2Emission < 500}">
                                <span class="ms-auto eco-tag medium">
                                    <i class="fas fa-leaf me-1"></i> Low Emission
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="ms-auto eco-tag bad">
                                    <i class="fas fa-smog me-1"></i> High Emission
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col">
                                <div class="stat-box">
                                    <div class="stat-value">
                                        <fmt:formatNumber value="${option.distance / 1000}" pattern="#,##0.0" /> km
                                    </div>
                                    <div class="stat-label">Distance</div>
                                </div>
                            </div>
                            <div class="col">
                                <div class="stat-box">
                                    <div class="stat-value">
                                        <c:set var="hours" value="${Math.floor(option.duration / 3600)}" />
                                        <c:set var="minutes" value="${Math.floor((option.duration % 3600) / 60)}" />
                                        <c:choose>
                                            <c:when test="${hours > 0}">
                                                ${hours}h ${minutes}m
                                            </c:when>
                                            <c:otherwise>
                                                ${minutes} min
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="stat-label">Duration</div>
                                </div>
                            </div>
                            <div class="col">
                                <div class="stat-box">
                                    <div class="stat-value">₹<fmt:formatNumber value="${option.cost}" pattern="#,##0.00" /></div>
                                    <div class="stat-label">Cost</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="stat-box mb-3">
                            <div class="stat-value">
                                <fmt:formatNumber value="${option.co2Emission}" pattern="#,##0" /> g
                            </div>
                            <div class="stat-label">CO₂ Emissions</div>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/sustainable/${trip.id}/select-option" method="post">
                            <input type="hidden" name="transportMode" value="${option.transportMode}" />
                            <div class="d-grid">
                                <button type="submit" class="btn btn-eco">
                                    <i class="fas fa-check-circle me-2"></i> Select This Option
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    
    <div class="analysis-section">
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-chart-line me-2"></i> Detailed Analysis</h4>
            </div>
            <div class="card-body">
                <div id="markdown-analysis" style="white-space: pre-wrap;"></div>
            </div>
        </div>
    </div>
    
    <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/sustainable/home" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i> Plan Another Journey
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
    const rawRecommendation = `${recommendation}`; // JSP variable
    const formatted = marked.parse(rawRecommendation); // using marked.js
    document.getElementById('formattedRecommendation').innerHTML = formatted;

    const rawMarkdown = `<c:out value="${analysis}" />`;
    const html = marked.parse(rawMarkdown);
    document.getElementById('markdown-analysis').innerHTML = html;

    let map;
    let directionsService;
    let directionsRenderer;
    
    function initMap() {
        map = new google.maps.Map(document.getElementById("map"), {
            zoom: 12,
            center: { lat: Number('${trip.originLat}'), lng: Number('${trip.originLng}') },
        });
        
        directionsService = new google.maps.DirectionsService();
        directionsRenderer = new google.maps.DirectionsRenderer({
            map: map
        });
        
        // Show the first route by default (can be enhanced to show the recommended one)
        <c:if test="${not empty travelOptions}">
            showRoute('${travelOptions[0].transportMode}');
        </c:if>
        
        // Add event listeners to the selection buttons
        document.querySelectorAll('button[type="submit"]').forEach(button => {
            button.addEventListener('click', function(e) {
                // Not blocking the form submission, just adding visual feedback
                button.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i> Selecting...';
            });
        });
    }
    
    function showRoute(mode) {
        // Convert mode to Google Maps DirectionsTravelMode
        let travelMode;
        switch(mode) {
            case 'WALKING':
                travelMode = 'WALKING';
                break;
            case 'CYCLING':
                travelMode = 'DRIVING';
                break;
            case 'BIKE':
                travelMode = 'DRIVING'; // Use driving as proxy for motorbike
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
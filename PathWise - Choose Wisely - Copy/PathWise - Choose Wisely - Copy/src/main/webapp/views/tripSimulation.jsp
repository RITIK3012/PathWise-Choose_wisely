<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pathwise - Trip Simulation</title>
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
        }
        .map-container {
            height: 500px;
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
        .progress {
            height: 20px;
            border-radius: 10px;
            margin-bottom: 15px;
        }
        .progress-bar {
            background: linear-gradient(135deg, #8BC34A 0%, #009688 100%);
        }
        .stat-card {
            padding: 15px;
            border-radius: 15px;
            margin-bottom: 15px;
            background-color: white;
            box-shadow: 0 4px 10px rgba(0,0,0,0.03);
            transition: all 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.05);
        }
        .stat-icon {
            font-size: 2rem;
            margin-right: 15px;
            color: #009688;
        }
        .stat-value {
            font-size: 1.5rem;
            font-weight: bold;
        }
        .stat-label {
            font-size: 0.9rem;
            color: #6c757d;
        }
        .mode-badge {
            background-color: #e9ecef;
            color: #495057;
            padding: 5px 10px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            margin-bottom: 15px;
        }
        .mode-badge i {
            margin-right: 5px;
        }
        .footer {
            background-color: #343a40;
            color: white;
            padding: 2rem 0;
            margin-top: 4rem;
        }
        #simulation-controls {
            margin-bottom: 20px;
        }
        #trip-complete-form {
            display: none;
        }
        @media (max-width: 767px) {
            .stat-icon {
                font-size: 1.5rem;
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
        <h1>Trip Simulation</h1>
        <p>From ${trip.origin} to ${trip.destination}</p>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/sustainable/home"><i class="fas fa-home"></i> Home</a>
            <a href="${pageContext.request.contextPath}/user/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/user/trip-history"><i class="fas fa-history"></i> Trip History</a>
        </nav>
    </div>
</div>

<div class="container">
    <div class="mode-badge mb-4">
        <c:choose>
            <c:when test="${selectedOption.transportMode == 'WALKING'}">
                <i class="fas fa-walking"></i>
            </c:when>
            <c:when test="${selectedOption.transportMode == 'CYCLING'}">
                <i class="fas fa-bicycle"></i>
            </c:when>
            <c:when test="${selectedOption.transportMode == 'BIKE'}">
                <i class="fas fa-motorcycle"></i>
            </c:when>
            <c:when test="${selectedOption.transportMode == 'CAR'}">
                <i class="fas fa-car"></i>
            </c:when>
            <c:when test="${selectedOption.transportMode == 'BUS'}">
                <i class="fas fa-bus"></i>
            </c:when>
        </c:choose>
        ${selectedOption.transportMode} Mode
    </div>
    
    <div class="map-container">
        <div id="map"></div>
    </div>
    
    <div id="simulation-controls" class="card p-4">
        <h3 class="mb-3">Trip Progress</h3>
        <div class="progress">
            <div id="progress-bar" class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">0%</div>
        </div>
        
        <div class="row mt-4">
            <div class="col-md-3 col-6">
                <div class="stat-card d-flex align-items-center">
                    <i class="fas fa-route stat-icon"></i>
                    <div>
                        <div id="current-distance" class="stat-value">0.0 km</div>
                        <div class="stat-label">Distance</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card d-flex align-items-center">
                    <i class="fas fa-clock stat-icon"></i>
                    <div>
                        <div id="current-duration" class="stat-value">0 min</div>
                        <div class="stat-label">Time</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card d-flex align-items-center">
                    <div>
                        <div id="current-cost" class="stat-value">₹0.00</div>
                        <div class="stat-label">Cost</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card d-flex align-items-center">
                    <i class="fas fa-leaf stat-icon"></i>
                    <div>
                        <div id="current-co2" class="stat-value">0 g</div>
                        <div class="stat-label">CO₂</div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="d-flex justify-content-between mt-4">
            <button id="start-simulation" class="btn btn-eco">
                <i class="fas fa-play me-2"></i> Start Trip
            </button>
            <button id="pause-simulation" class="btn btn-secondary" disabled>
                <i class="fas fa-pause me-2"></i> Pause
            </button>
        </div>
    </div>
    
    <form id="trip-complete-form" action="${pageContext.request.contextPath}/sustainable/${selectedOption.id}/complete" method="post" class="card p-4">
        <h3 class="mb-3">Trip Completed!</h3>
        <p>Your journey has been completed. Here are the final metrics:</p>
        
        <input type="hidden" id="actual-distance" name="actualDistance" value="${selectedOption.distance}">
        <input type="hidden" id="actual-duration" name="actualDuration" value="${selectedOption.duration}">
        <input type="hidden" id="actual-polyline" name="actualPolyline" value="${selectedOption.encodedPolyline}">
        
        <div class="row mt-3 mb-4">
            <div class="col-md-3 col-6">
                <div class="stat-card d-flex align-items-center">
                    <i class="fas fa-route stat-icon"></i>
                    <div>
                        <div id="final-distance" class="stat-value">
                            <fmt:formatNumber value="${selectedOption.distance / 1000}" pattern="#,##0.0" /> km
                        </div>
                        <div class="stat-label">Final Distance</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card d-flex align-items-center">
                    <i class="fas fa-clock stat-icon"></i>
                    <div>
                        <div id="final-duration" class="stat-value">
                            <c:set var="hours" value="${Math.floor(selectedOption.duration / 3600)}" />
                            <c:set var="minutes" value="${Math.floor((selectedOption.duration % 3600) / 60)}" />
                            <c:choose>
                                <c:when test="${hours > 0}">
                                    ${hours}h ${minutes}m
                                </c:when>
                                <c:otherwise>
                                    ${minutes} min
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="stat-label">Final Time</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card d-flex align-items-center">
                    <div>
                        <div id="final-cost" class="stat-value">
                            ₹<fmt:formatNumber value="${selectedOption.cost}" pattern="#,##0.00" />
                        </div>
                        <div class="stat-label">Final Cost</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card d-flex align-items-center">
                    <i class="fas fa-leaf stat-icon"></i>
                    <div>
                        <div id="final-co2" class="stat-value">
                            <fmt:formatNumber value="${selectedOption.co2Emission}" pattern="#,##0" /> g
                        </div>
                        <div class="stat-label">Final CO₂</div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="d-grid">
            <button type="submit" class="btn btn-eco btn-lg">
                <i class="fas fa-check-circle me-2"></i> Confirm Trip Completion
            </button>
        </div>
    </form>
    
    <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/sustainable/home" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i> Plan Another Journey
        </a>
        <a href="${pageContext.request.contextPath}/user/trip-history" class="btn btn-outline-secondary ms-2">
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
    let marker;
    let route;
    let routeIndex = 0;
    let simulationInterval;
    let isSimulationRunning = false;
    
    // Initial stats
    const totalDistance = Number('${selectedOption.distance}');
    const totalDuration = Number('${selectedOption.duration}');
    const totalCost = Number('${selectedOption.cost}');
    const totalCO2 = Number('${selectedOption.co2Emission}');
    
    function initMap() {
        map = new google.maps.Map(document.getElementById("map"), {
            zoom: 13,
            center: { lat: Number('${trip.originLat}'), lng: Number('${trip.originLng}') },
        });
        
        directionsService = new google.maps.DirectionsService();
        directionsRenderer = new google.maps.DirectionsRenderer({
            map: map,
            suppressMarkers: true
        });
        
        // Create marker for current position
        marker = new google.maps.Marker({
            position: { lat: Number('${trip.originLat}'), lng: Number('${trip.originLng}') },
            map: map,
            icon: {
                path: google.maps.SymbolPath.CIRCLE,
                scale: 8,
                fillColor: "#4CAF50",
                fillOpacity: 1,
                strokeColor: "#fff",
                strokeWeight: 2
            },
            title: "Current Position"
        });
        
        // Show the route
        showRoute('${selectedOption.transportMode}');
        
        // Set up UI controls
        document.getElementById('start-simulation').addEventListener('click', startSimulation);
        document.getElementById('pause-simulation').addEventListener('click', togglePauseSimulation);
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
                route = result.routes[0].overview_path;
            }
        });
    }
    
    function startSimulation() {
        if (isSimulationRunning) return;
        
        isSimulationRunning = true;
        document.getElementById('start-simulation').disabled = true;
        document.getElementById('pause-simulation').disabled = false;
        document.getElementById('pause-simulation').innerHTML = '<i class="fas fa-pause me-2"></i> Pause';
        
        // Reset progress if needed
        if (routeIndex >= route.length) {
            routeIndex = 0;
            updateProgressUI(0);
        }
        
        // Start moving along the route
        simulationInterval = setInterval(() => {
            if (routeIndex < route.length) {
                // Move marker
                marker.setPosition(route[routeIndex]);
                
                // Calculate progress percentage
                const progress = (routeIndex / (route.length - 1)) * 100;
                
                // Update UI
                updateProgressUI(progress);
                
                routeIndex++;
                
                // Pan the map to follow the marker
                map.panTo(marker.getPosition());
            } else {
                // Simulation complete
                clearInterval(simulationInterval);
                completeSimulation();
            }
        }, 200); // Update every 200ms for smooth animation
    }
    
    function togglePauseSimulation() {
        if (isSimulationRunning) {
            // Pause
            clearInterval(simulationInterval);
            isSimulationRunning = false;
            document.getElementById('pause-simulation').innerHTML = '<i class="fas fa-play me-2"></i> Resume';
        } else {
            // Resume
            startSimulation();
        }
    }
    
    function updateProgressUI(progress) {
        const progressBar = document.getElementById('progress-bar');
        progressBar.style.width = progress + '%';
        progressBar.setAttribute('aria-valuenow', progress);
        progressBar.textContent = Math.round(progress) + '%';
        
        // Calculate current values based on progress
        const currentDistance = (totalDistance * progress) / 100;
        const currentDuration = (totalDuration * progress) / 100;
        const currentCost = (totalCost * progress) / 100;
        const currentCO2 = (totalCO2 * progress) / 100;
        
        // Update distance
        document.getElementById('current-distance').textContent = 
            (currentDistance / 1000).toFixed(1) + ' km';
        
        // Update duration
        const currentMinutes = Math.floor(currentDuration / 60);
        const currentHours = Math.floor(currentMinutes / 60);
        const remainingMinutes = currentMinutes % 60;
        
        if (currentHours > 0) {
            document.getElementById('current-duration').textContent = 
                currentHours + 'h ' + remainingMinutes + 'm';
        } else {
            document.getElementById('current-duration').textContent = 
                currentMinutes + ' min';
        }
        
        // Update cost
        document.getElementById('current-cost').textContent = 
            '₹' + currentCost.toFixed(2);
        
        // Update CO2
        document.getElementById('current-co2').textContent = 
            Math.round(currentCO2) + ' g';
            
        // Update hidden form values for submission
        document.getElementById('actual-distance').value = currentDistance;
        document.getElementById('actual-duration').value = currentDuration;
    }
    
    function completeSimulation() {
        document.getElementById('simulation-controls').style.display = 'none';
        document.getElementById('trip-complete-form').style.display = 'block';
        
        // Slight variation in actual values for realism
        const variationFactor = 1 + (Math.random() * 0.3); // Between 1 and 1.2
        
        const actualDistance = totalDistance * variationFactor;
        const actualDuration = totalDuration * variationFactor;
        
        document.getElementById('actual-distance').value = actualDistance;
        document.getElementById('actual-duration').value = actualDuration;
        
        // Get the encoded polyline from the current route
        // In a real implementation, this would be more accurate based on actual path taken
        document.getElementById('actual-polyline').value = '${selectedOption.encodedPolyline}';
    }
</script>

</body>
</html> 
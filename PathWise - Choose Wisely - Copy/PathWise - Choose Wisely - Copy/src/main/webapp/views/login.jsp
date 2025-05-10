<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PathWise - Login</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Glassmorphism background */
        body {
            position: relative;
            background: linear-gradient(135deg, #87CEEB, #3CB371, #20B2AA);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
            overflow: hidden;
        }

        /* Animated background */
        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* Glass elements in background */
        .glass-decoration {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            z-index: 0;
        }

        .decoration-1 {
            width: 300px;
            height: 300px;
            top: 10%;
            left: 20%;
        }

        .decoration-2 {
            width: 200px;
            height: 200px;
            bottom: 15%;
            right: 15%;
        }

        .decoration-3 {
            width: 150px;
            height: 150px;
            top: 60%;
            left: 10%;
        }

        .decoration-4 {
            width: 250px;
            height: 250px;
            top: 5%;
            right: 25%;
        }

        /* App header */
        .app-header {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            width: 100%;
            padding: 20px 0;
            text-align: center;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 100;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .app-logo {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .app-name {
            font-size: 32px;
            font-weight: 700;
            color: white;
            letter-spacing: 1px;
            margin-bottom: 5px;
            text-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .app-tagline {
            font-size: 16px;
            color: rgba(255, 255, 255, 0.9);
            font-weight: 400;
            font-style: italic;
        }

        /* Solid form container */
        .container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 450px;
            padding: 40px;
            position: relative;
            z-index: 10;
            margin-top: 80px;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header h1 {
            color: #2e7d60;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .header p {
            color: #666;
            font-size: 16px;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            background: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            color: #333;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
            position: relative;
            z-index: 1;
        }

        /* Hover elevation effect */
        .form-control:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border-color: #3CB371;
        }

        .form-control:focus {
            transform: translateY(-3px);
            border-color: #3CB371;
            box-shadow: 0 5px 15px rgba(60, 179, 113, 0.2);
            outline: none;
        }

        .form-control::placeholder {
            color: #aaa;
        }

        .error {
            color: #e74c3c;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }

        .button {
            background: linear-gradient(135deg, #3CB371, #20B2AA);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 14px 20px;
            width: 100%;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            position: relative;
            z-index: 1;
        }

        .button:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        .button:active {
            transform: translateY(0);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .form-group.error-state .form-control {
            border-color: #e74c3c;
            background-color: #fff8f8;
        }

        .form-group.error-state .error {
            display: block;
        }

        .options {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
            margin-bottom: 25px;
            font-size: 14px;
        }

        .forgot-password {
            color: #3CB371;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
        }

        .forgot-password:hover {
            color: #2e7d60;
            text-decoration: underline;
        }

        .remember-me {
            display: flex;
            align-items: center;
        }

        .remember-me input {
            margin-right: 5px;
        }

        .signup-link {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            font-size: 15px;
            color: #666;
        }

        .signup-link a {
            color: #3CB371;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
        }

        .signup-link a:hover {
            color: #2e7d60;
            text-decoration: underline;
        }

        .success-message {
            color: #2ecc71;
            text-align: center;
            margin-top: 20px;
            font-weight: 600;
            font-size: 18px;
        }
        
        .error-message {
            color: #e74c3c;
            background-color: #fde8e7;
            border-radius: 4px;
            padding: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            text-align: center;
        }
        
        .success-message {
            color: #2ecc71;
            background-color: #e8f8f2;
            border-radius: 4px;
            padding: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            text-align: center;
        }

        /* Make the page responsive */
        @media (max-width: 768px) {
            .app-name {
                font-size: 28px;
            }

            .app-tagline {
                font-size: 14px;
            }

            .container {
                padding: 30px;
            }
        }
    </style>
</head>
<body>
    <!-- App Header -->
    <div class="app-header">
        <div class="app-logo">
            <div class="app-name">PathWise</div>
            <div class="app-tagline">Travel sustainably, see the difference</div>
        </div>
    </div>

    <!-- Glassmorphism background decorations -->
    <div class="glass-decoration decoration-1"></div>
    <div class="glass-decoration decoration-2"></div>
    <div class="glass-decoration decoration-3"></div>
    <div class="glass-decoration decoration-4"></div>

    <!-- Solid form container -->
    <div class="container">
        <div class="header">
            <h1>Welcome Back</h1>
            <p>Sign in to continue your sustainable journey</p>
        </div>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        
        <c:if test="${not empty message}">
            <div class="success-message">${message}</div>
        </c:if>
        
        <c:if test="${not empty successMessage}">
            <div class="success-message">${successMessage}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control" placeholder="Enter your username" required>
                <div class="error">Please enter your username</div>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required>
                <div class="error">Please enter your password</div>
            </div>

            <div class="options">
                <div class="remember-me">
                    <input type="checkbox" id="remember-me" name="remember-me">
                    <label for="remember-me">Remember me</label>
                </div>
                <div class="forgot-password">
                    <a href="#">Forgot password?</a>
                </div>
            </div>

            <button type="submit" class="button">Sign In</button>

            <div class="create-account">
                Don't have an account? <a href="/register">Sign Up</a>
            </div>
        </form>
    </div>

    <script>
        // Login form validation can be added here
    </script>
</body>
</html>
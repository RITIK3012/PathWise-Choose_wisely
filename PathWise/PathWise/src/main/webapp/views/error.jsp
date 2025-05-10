<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        :root {
            --primary-color: #1E3A8A;
            --secondary-color: #22C55E;
            --background-color: #0F172A;
            --text-color: #F8FAFC;
            --card-bg: #1E293B;
            --input-bg: #334155;
            --danger-color: #EF4444;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: var(--background-color);
            color: var(--text-color);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        header {
            background-color: var(--primary-color);
            padding: 1rem 2rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .logo {
            font-size: 1.8rem;
            font-weight: bold;
            color: var(--text-color);
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .card {
            background-color: var(--card-bg);
            border-radius: 15px;
            padding: 2.5rem;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .icon-container {
            margin-bottom: 2rem;
        }
        
        .icon-circle {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: rgba(239, 68, 68, 0.1);
        }
        
        .icon-circle i {
            font-size: 3rem;
            color: var(--danger-color);
        }
        
        h1 {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: var(--danger-color);
        }
        
        .message {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        
        .error-box {
            background-color: rgba(239, 68, 68, 0.1);
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            text-align: left;
            overflow-wrap: break-word;
            word-wrap: break-word;
        }
        
        .error-box h2 {
            font-size: 1.2rem;
            margin-bottom: 1rem;
            color: var(--danger-color);
        }
        
        .btn-row {
            display: flex;
            justify-content: center;
            gap: 1rem;
        }
        
        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        
        .btn-primary {
            background-color: var(--secondary-color);
            color: #0F172A;
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        .btn-primary:hover {
            background-color: #16A34A;
        }
        
        footer {
            text-align: center;
            padding: 1.5rem;
            background-color: var(--primary-color);
            margin-top: auto;
        }
    </style>
</head>
<body>
    <header>
        <div class="logo">FareLens</div>
    </header>
    
    <div class="container">
        <div class="card">
            <div class="icon-container">
                <div class="icon-circle">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
            </div>
            
            <h1>Oops! Something went wrong</h1>
            
            <p class="message">
                We encountered an error while processing your request. Please try again or contact support if the problem persists.
            </p>
            
            <div class="error-box">
                <h2>Error Details</h2>
                <p>${error}</p>
            </div>
            
            <div class="btn-row">
                <a href="/rides/" class="btn btn-primary">Back to Home</a>
            </div>
        </div>
    </div>
    
    <footer>
        <p>&copy; 2025 FareLens : From Route To Rupee - Track It All!</p>
    </footer>
</body>
</html> 
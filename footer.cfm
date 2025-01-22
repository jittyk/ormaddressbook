<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Addressbook</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="styles/index.css">
        <style>
            /* Additional custom styles can be added here */
        </style>
    </head>
    
    <body class="d-flex flex-column min-vh-100">  
        <footer class="mt-auto bg-dark text-white py-3">
            
                <div class="row">
                    <div class="col-12 mb-3">
                        <ul class="list-unstyled d-flex flex-column flex-md-row justify-content-center mb-0">
                            <li class="me-md-3 mb-2 mb-md-0"><a href="#" class="text-white text-decoration-none">Family</a></li>
                            <li class="me-md-3 mb-2 mb-md-0"><a href="#" class="text-white text-decoration-none">Friends</a></li>
                            <li><a href="#" class="text-white text-decoration-none">Colleagues</a></li>
                        </ul>
                    </div>
                    <div class="col-12 mb-3 d-flex justify-content-center">
                        <div class="col-10 col-md-6 col-lg-4">
                            <form method="get" action="index.cfm">
                                <input type="search" class="form-control" placeholder="Search" name="searchTerm">
                            </form>
                        </div>
                    </div>
                    <div class="col-12 text-center text-md-end">
                        <a class="navbar-brand" href="user.cfm"><b>Address Book</b></a>
                    </div>
            
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
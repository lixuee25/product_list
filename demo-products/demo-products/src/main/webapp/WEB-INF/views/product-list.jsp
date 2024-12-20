<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product List</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        body {
            font-family: Arial, sans-serif;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: left;
        }

        img {
            border-radius: 5px;
        }

        td img {
            margin-right: 10px;
        }

        .rating {
            display: flex;
        }

        .rating img {
            width: 20px;
            height: 20px;
        }
    </style>
</head>
<body>

<h2>Product List</h2>

<table border="1" id="productTable">
    <thead>
        <tr>
            <th>No.</th>
            <th>Product</th>
            <th>Category</th>
            <th>Total Order</th>
            <th>Delivered</th>
            <th>Pending</th>
            <th>Status</th>
            <th>Price</th>
            <th>Rating</th>
        </tr>
    </thead>
    <tbody>
       
    </tbody>
</table>

<script>
  
    function loadProducts() {
        $.ajax({
            url: '/v1/api/getListProduct',
            method: 'GET',
            dataType: 'json',
            success: function(response) {
                var products = response.result; 
                var tableBody = $('#productTable tbody');
                tableBody.empty(); 

               
                $.each(products, function(index, product) {
                    var row = $('<tr>');
                    row.append('<td>' + (index + 1) + '</td>');
                    row.append('<td><img src="' + (product.image || 'default-image.png') + '" alt="' + product.productName + '" width="50" height="50">' + product.productName + '</td>');
                    row.append('<td>' + product.categoryName + '</td>');
                    row.append('<td>' + product.totalOrder + '</td>');
                    row.append('<td>' + product.delivered + '</td>');
                    row.append('<td>' + product.pending + '</td>');
                    row.append('<td>' + product.status + '</td>');
                    row.append('<td>' + product.price + '</td>');

                    // Rating
                    var ratingHtml = '';
                    for (var i = 0; i < product.rating; i++) {
                        ratingHtml += '<img src="star-icon.png" alt="star" width="20" height="20">';
                    }
                    row.append('<td>' + ratingHtml + '</td>');

                    // Thêm dòng vào bảng
                    tableBody.append(row);
                });
            },
            error: function(xhr, status, error) {
                console.error('API error: ' + error);
            }
        });
    }

    // Gọi hàm để tải sản phẩm khi trang được tải
    $(document).ready(function() {
        loadProducts();
    });
</script>

</body>
</html>

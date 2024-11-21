<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product List</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        body {
            font-family: Arial, sans-serif;
        }

        .status-active {
            color: green;
        }

        .status-inactive {
            color: red;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: left;
        }

        td img {
            margin-right: 10px;
            max-width: 50px;
        }
    </style>
</head>
<body>

<div class="container mt-5">
    <h2>Product List</h2>

    <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#productModal" onclick="clearForm()">Add Product</button>

    <table class="table table-bordered" id="productTable">
        <thead>
            <tr>
                <th>No.</th>
                <th>Image</th>
                <th>Bar Code</th>
                <th>Product Name</th>
                <th>Category</th>
                <th>Status</th>
                <th>Price</th>
                <th>Unit</th>
                <th>Created At</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <!-- Data sẽ được điền qua AJAX -->
        </tbody>
    </table>
</div>

<div class="modal fade" id="productModal" tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="productModalLabel">Add Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="productForm">
                    <input type="hidden" id="productId">
                    <div class="mb-3">
                        <label for="productBarcode" class="form-label">BarCode</label>
                        <input type="text" class="form-control" id="productBarcode" required>
                    </div>
                    <div class="mb-3">
                        <label for="productName" class="form-label">Product Name</label>
                        <input type="text" class="form-control" id="productName" required>
                    </div>
                    <div class="mb-3">
                        <label for="productCategory" class="form-label">Category</label>
                        <input type="text" class="form-control" id="productCategory" required>
                    </div>
                    <div class="mb-3">
                        <label for="productPrice" class="form-label">Price</label>
                        <input type="number" class="form-control" id="productPrice" required>
                    </div>
                    <div class="mb-3">
                        <label for="productUnit" class="form-label">Unit</label>
                        <input type="text" class="form-control" id="productUnit" required>
                    </div>
                    <div class="mb-3">
                        <label for="productStatus" class="form-label">Status</label>
                        <select class="form-control" id="productStatus">
                            <option value="1">Available</option>
                            <option value="0">Out of Stock</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" onclick="saveProduct()">Save</button>
            </div>
        </div>
    </div>
</div>

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
                    row.append('<td><img src="" alt="product image"></td>');
                    row.append('<td>' + product.barCode + '</td>');
                    row.append('<td>' + product.productName + '</td>');
                    row.append('<td>' + product.categoryName + '</td>');
                    row.append('<td class="' + (product.status === "0" ? "status-inactive" : "status-active") + '">' + (product.status === "0" ? "Out of Stock" : "Available") + '</td>');
                    row.append('<td>' + product.price.toLocaleString('en-US', { style: 'currency', currency: 'VND' }) + '</td>');
                    row.append('<td>' + product.unit + '</td>');

                    var createdAt = new Date(product.createdAt);
                    var formattedDate = createdAt.toLocaleDateString('vi-VN') + ' ' + createdAt.toLocaleTimeString('vi-VN');
                    row.append('<td>' + formattedDate + '</td>');

                    row.append('<td><button class="btn btn-warning btn-sm" onclick="editProduct(' + product.id + ')">Edit</button> ' +
                               '<button class="btn btn-danger btn-sm" onclick="deleteProduct(' + product.id + ')">Delete</button></td>');

                    tableBody.append(row);
                });
            },
            error: function(xhr, status, error) {
                console.error('API error: ' + error);
            }
        });
    }

    function saveProduct() {
        var productData = {
        	barCode: $('#productBarcode').val(),
            productName: $('#productName').val(),
            categoryName: $('#productCategory').val(),
            price: $('#productPrice').val(),
            unit: $('#productUnit').val(),
            status: $('#productStatus').val()
        };

        var productId = $('#productId').val();
        if (productId) {
            $.ajax({
                url: '/v1/api/updateProduct/' + productId,
                method: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(productData),
                success: function(response) {
                    loadProducts();
                    $('#productModal').modal('hide');
                },
                error: function(xhr, status, error) {
                    console.error('Error updating product: ' + error);
                }
            });
        } else {
            $.ajax({
                url: '/v1/api/createProduct',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(productData),
                success: function(response) {
                    loadProducts();
                    $('#productModal').modal('hide');
                },
                error: function(xhr, status, error) {
                    console.error('Error adding product: ' + error);
                }
            });
        }
    }

    function editProduct(productId) {
        $.ajax({
            url: '/v1/api/detailProduct/' + productId,
            method: 'GET',
            success: function(response) {
                var product = response.result;
                $('#productId').val(product.id);
                $('#productBarcode').val(product.barCode);
                $('#productName').val(product.productName);
                $('#productCategory').val(product.categoryName);
                $('#productPrice').val(product.price);
                $('#productUnit').val(product.unit);
                $('#productStatus').val(product.status);
                $('#productModalLabel').text('Edit Product');
                $('#productModal').modal('show');
            },
            error: function(xhr, status, error) {
                console.error('Error fetching product details: ' + error);
            }
        });
    }

    function deleteProduct(productId) {
        if (confirm("Are you sure you want to delete this product?")) {
            $.ajax({
                url: '/v1/api/deleteProduct/' + productId,
                method: 'DELETE',
                success: function(response) {
                    loadProducts();
                },
                error: function(xhr, status, error) {
                    console.error('Error deleting product: ' + error);
                }
            });
        }
    }

    function clearForm() {
        $('#productForm')[0].reset();
        $('#productId').val('');
        $('#productModalLabel').text('Add Product');
    }

    $(document).ready(function() {
        loadProducts();
    });
</script>

</body>
</html>

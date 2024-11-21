package com.products.controller;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;  // Sửa import từ ch.qos.logback.core.model.Model thành org.springframework.ui.Model
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.products.dto.request.AddProductRequest;
import com.products.dto.request.UpdateProductRequest;
import com.products.dto.response.APICustomize;
import com.products.dto.response.AddProductResponse;
import com.products.dto.response.DeleteProductResponse;
import com.products.dto.response.DetailProductResponse;
import com.products.dto.response.ProductsResponse;
import com.products.dto.response.UpdateProductResponse;
import com.products.service.ProductService;

@RestController
@RequestMapping("/v1/api")
public class ProductController {

    @Autowired
    private ProductService productService;

    @GetMapping("/getListProduct")
    public ResponseEntity<?> products() {
        APICustomize<List<ProductsResponse>> response = productService.products();
        return ResponseEntity.status(Integer.parseInt(response.getStatusCode())).body(response); // Trả phản hồi theo HTTP và thông báo
    }

    @PostMapping("/createProduct")
    public ResponseEntity<?> create(@RequestBody AddProductRequest request) {
        APICustomize<AddProductResponse> response = productService.create(request.getBarCode(),
                request.getProductName(), request.getCategoryName(), request.getStatus(), request.getPrice(),
                request.getUnit());
        return ResponseEntity.status(Integer.parseInt(response.getStatusCode())).body(response);
    }

    @PutMapping("/updateProduct/{id}")
    public ResponseEntity<?> update(@PathVariable int id, @RequestBody UpdateProductRequest request) {
        APICustomize<UpdateProductResponse> response = productService.update(id, request.getBarCode(),
                request.getProductName(), request.getCategoryName(), request.getStatus(), request.getPrice(),
                request.getUnit());
        return ResponseEntity.status(Integer.parseInt(response.getStatusCode())).body(response);
    }

    @DeleteMapping("/deleteProduct/{id}")
    public ResponseEntity<?> delete(@PathVariable int id) {

        APICustomize<DeleteProductResponse> response = productService.delete(id);

        return ResponseEntity.status(Integer.parseInt(response.getStatusCode())).body(response);
    }

    @GetMapping("/detailProduct/{id}")
    public ResponseEntity<?> detail(@PathVariable int id) {
        APICustomize<DetailProductResponse> response = productService.detail(id);
        return ResponseEntity.status(Integer.parseInt(response.getStatusCode())).body(response);
    }

    @GetMapping("/getViewProduct")
    public ResponseEntity<APICustomize<List<ProductsResponse>>> getListProduct() {
        APICustomize<List<ProductsResponse>> response = productService.products();
        return ResponseEntity.ok(response); // Trả về dữ liệu dưới dạng JSON
    }
}
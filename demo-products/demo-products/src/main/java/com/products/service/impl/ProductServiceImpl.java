package com.products.service.impl;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.products.dto.response.APICustomize;
import com.products.dto.response.AddProductResponse;
import com.products.dto.response.DeleteProductResponse;
import com.products.dto.response.DetailProductResponse;
import com.products.dto.response.ProductsResponse;
import com.products.dto.response.UpdateProductResponse;
import com.products.enums.ApiError;
import com.products.model.Product;
import com.products.repository.ProductRepository;
import com.products.service.ProductService;

@Service
public class ProductServiceImpl implements ProductService {

	@Autowired
	private ProductRepository productRepository;

	@Override
	public APICustomize<List<ProductsResponse>> products() {

		List<Product> products = productRepository.findAll();

		List<ProductsResponse> productsResponse = products.stream()
				.map(product -> new ProductsResponse(product.getId(), product.getBarCode(), product.getProductName(),
						product.getCategoryName(), product.getStatus(), product.getPrice(), product.getUnit(),
						product.getCreatedAt()))
				.toList();

		return new APICustomize<>(ApiError.OK.getCode(), ApiError.OK.getMessage(), productsResponse);
	}

	@Override
	public APICustomize<AddProductResponse> create(String barCode, String productName, String categoryName,
			String status, BigDecimal price, String unit) {
		Product newProduct = new Product();
		newProduct.setBarCode(barCode);
		newProduct.setProductName(productName);
		newProduct.setCategoryName(categoryName);
		newProduct.setStatus(status);
		newProduct.setPrice(price);
		newProduct.setUnit(unit);

		productRepository.save(newProduct);

		AddProductResponse response = new AddProductResponse(newProduct.getId(), newProduct.getBarCode(),
				newProduct.getProductName(), newProduct.getCategoryName(), newProduct.getStatus(),
				newProduct.getPrice(), newProduct.getUnit());

		return new APICustomize<>(ApiError.CREATED.getCode(), ApiError.CREATED.getMessage(), response);

	}
	
	@Override
	public APICustomize update(int id, String barCode, String productName, String categoryName,
	        String status, BigDecimal price, String unit) {
	    Product existingProduct = productRepository.findById(id)
	            .orElseThrow(() -> new RuntimeException("Product not found"));

	    existingProduct.setBarCode(barCode);
	    existingProduct.setProductName(productName);
	    existingProduct.setCategoryName(categoryName);
	    existingProduct.setStatus(status);
	    existingProduct.setPrice(price);
	    existingProduct.setUnit(unit);

	    productRepository.save(existingProduct);

	    ProductsResponse response = new ProductsResponse(existingProduct.getId(), existingProduct.getBarCode(),
	            existingProduct.getProductName(), existingProduct.getCategoryName(), existingProduct.getStatus(),
	            existingProduct.getPrice(), existingProduct.getUnit(), existingProduct.getCreatedAt());

	    return new APICustomize<>(ApiError.OK.getCode(), ApiError.OK.getMessage(), response);
	}
	
	
	
	@Override
	public APICustomize<DeleteProductResponse> delete(int id) {
		productRepository.deleteById(id);
		return new APICustomize<>(ApiError.OK.getCode(), "Product delete successfully", null);
	}


	@Override
	public APICustomize<DetailProductResponse> detail(int id) {

		Product product = productRepository.findById(id).orElse(null);

		if (product == null) {
			return new APICustomize<>(ApiError.NOT_FOUND.getCode(), "Product not found", null);
		}

		DetailProductResponse response = new DetailProductResponse(product.getId(), product.getBarCode(),
				product.getProductName(), product.getCategoryName(), product.getStatus(), product.getPrice(),
				product.getUnit(), product.getCreatedAt());

		return new APICustomize<>(ApiError.OK.getCode(), ApiError.OK.getMessage(), response);
	}
	
	
}
//	
//	@Override
//	public APICustomize<List<ProductsResponse>> products() {
//	    List<Product> products = productRepository.findAll();
//	    if (products.isEmpty()) {
//	        System.out.println("No products found in database.");
//	    }
//
//	    List<ProductsResponse> productsResponse = products.stream()
//	            .map(product -> new ProductsResponse(product.getId(), product.getBarCode(), product.getProductName(),
//	                    product.getCategoryName(), product.getStatus(), product.getPrice(), product.getUnit(),
//	                    product.getCreatedAt()))
//	            .toList();
//
//	    return new APICustomize<>(ApiError.OK.getCode(), ApiError.OK.getMessage(), productsResponse);
//	}
//
//	
//    
//}

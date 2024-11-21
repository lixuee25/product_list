package com.products.service;

import java.math.BigDecimal;
import java.util.List;

import com.products.dto.response.APICustomize;
import com.products.dto.response.AddProductResponse;
import com.products.dto.response.DeleteProductResponse;
import com.products.dto.response.DetailProductResponse;
import com.products.dto.response.ProductsResponse;
import com.products.dto.response.UpdateProductResponse;

public interface ProductService {

	public APICustomize<List<ProductsResponse>> products();
	public APICustomize<AddProductResponse> create(String barCode, 
			String productName, String categoryName, String status, BigDecimal price, String unit);
	public APICustomize<UpdateProductResponse> update(int id, String barCode, String productName,
			String categoryName, String status, BigDecimal price, String unit);
	public APICustomize<DeleteProductResponse> delete(int id);
	public APICustomize<DetailProductResponse> detail(int id);
	
	
	
}

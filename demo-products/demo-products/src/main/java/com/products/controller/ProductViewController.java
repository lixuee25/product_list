package com.products.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ProductViewController {
	@GetMapping("/products")
    public String showProductList() {
        return "product-list";
    }
	
	@GetMapping("/products2")
    public String showProductList2() {
        return "product-list2";
    }
	
	@GetMapping("/product-view")
    public String showProductView() {
        return "product-view";
    }
	
	@GetMapping("/test")
    public String testMappingJSP() {
        return "testView";
    }
}

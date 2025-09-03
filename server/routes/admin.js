const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const Product = require("../models/product");

//Add Product
adminRouter.post("/admin/add-products", admin, async (req, res) => {
  try {
    const { name, price, description, category, images, quantity } = req.body;
    let product = new Product({
      name,
      price,
      description,
      category,
      images,
      quantity,
    });
    product = await product.save();
    res.json({ product });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});


//Get All Products
adminRouter.get("/admin/get-products", admin, async (req, res) =>{
  try {
    const products = await Product.find({});
    res.json({ products });
    
  } catch (error) {
    res.status(500).json({ error: error.message });
    
  }
});

//Delete a Product
adminRouter.delete("/admin/delete-product/:id", admin, async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findByIdAndDelete(id);
    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }
    res.json({ message: "Product deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = adminRouter;

const express = require("express");
const Product = require("../models/product");

const productRouter = express.Router();
const auth = require("../middlewares/auth");

// GET /api/products?category=Mobiles&q=iphone
productRouter.get("/api/products", async (req, res) => {
  try {
    const { category, q } = req.query;
    const filter = {};
    if (category) {
      filter.category = category;
    }
    if (q) {
      const regex = new RegExp(q, "i");
      filter.$or = [{ name: regex }, { description: regex }];
    }
    const products = await Product.find(filter).sort({ _id: -1 });
    res.json({ products });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/products/:id - fetch single product by id
productRouter.get("/api/products/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    if (!product) return res.status(404).json({ error: "Product not found" });
    res.json({ product });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/products/related/:id - other products in same category
productRouter.get("/api/products/related/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    if (!product) return res.status(404).json({ error: "Product not found" });
    const related = await Product.find({
      category: product.category,
      _id: { $ne: product._id },
    })
      .sort({ _id: -1 })
      .limit(10);
    res.json({ products: related });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /api/cart - add to cart and persist on user
productRouter.post("/api/cart", auth, async (req, res) => {
  try {
    const { productId, quantity } = req.body;
    if (!productId || !quantity) return res.status(400).json({ error: "Missing fields" });
    const User = require("../models/user");
    const user = await User.findById(req.user);
    if (!user) return res.status(404).json({ error: "User not found" });
    const idx = user.cart.findIndex((c) => c.product?.toString() === productId);
    if (idx >= 0) {
      user.cart[idx].quantity += quantity;
    } else {
      user.cart.push({ product: productId, quantity });
    }
    await user.save();
    res.json({ cart: user.cart });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/cart - fetch current cart
productRouter.get("/api/cart", auth, async (req, res) => {
  try {
    const User = require("../models/user");
    const user = await User.findById(req.user).populate('cart.product');
    if (!user) return res.status(404).json({ error: "User not found" });
    res.json({ cart: user.cart });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /api/orders - checkout and clear cart
productRouter.post("/api/orders", auth, async (req, res) => {
  try {
    const User = require("../models/user");
    const user = await User.findById(req.user);
    if (!user) return res.status(404).json({ error: "User not found" });
    if (!user.cart.length) return res.status(400).json({ error: "Cart is empty" });
    user.orders.push({ items: user.cart.map((c) => ({ product: c.product, quantity: c.quantity })) });
    user.cart = [];
    await user.save();
    res.json({ orders: user.orders });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/orders - user's orders
productRouter.get("/api/orders", auth, async (req, res) => {
  try {
    const User = require("../models/user");
    const user = await User.findById(req.user).populate('orders.items.product');
    if (!user) return res.status(404).json({ error: "User not found" });
    res.json({ orders: user.orders });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /api/products/:id/rate - rate a product 1..5
productRouter.post("/api/products/:id/rate", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const { rating } = req.body;
    if (!rating || rating < 1 || rating > 5) return res.status(400).json({ error: "Invalid rating" });
    const product = await Product.findById(id);
    if (!product) return res.status(404).json({ error: "Product not found" });
    // remove existing rating by this user
    product.ratings = product.ratings.filter(r => r.userId?.toString() !== req.user);
    product.ratings.push({ userId: req.user, rating });
    await product.save();
    res.json({ product });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = productRouter;



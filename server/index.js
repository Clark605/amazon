//IMPORTS FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");

//IMPORTS FROM ROUTES
const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const productRouter = require("./routes/product");

//INIT
const PORT = 3000;
const app = express();
const DB = process.env.MONGO_DB;

//MIDDLEWARE
app.use(express.json()); // Add this line to parse JSON bodies
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);

//Connections
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connected to MongoDB");
  })
  .catch((err) => {
    console.error("MongoDB connection error:", err);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});

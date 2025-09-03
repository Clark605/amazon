const express = require("express");
const User = require("../models/user");
const bcryptjs = require("bcryptjs"); // Import bcryptjs for password hashing
const jwt = require("jsonwebtoken"); // Import jsonwebtoken for token generation
const auth = require("../middlewares/auth");


const authRouter = express.Router();

authRouter.post("/api/signup", async (req, res) => {
  try {
    //get and validate  data from client
    const { username, email, password } = req.body;
    // Validate input
    if (!username || !email || !password) {
      return res.status(400).json({ message: "All fields are required" });
    }

    // Validate password length BEFORE hashing
    if (password.length < 6) {
      return res
        .status(400)
        .json({ message: "Password must be at least 6 characters long" });
    }
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: "User already exists" });
    }
    //Hash Password
    const hashedPassword = await bcryptjs.hash(password, 8);
    let user = new User({
      username,
      email,
      password: hashedPassword,
    });
    //save user to database
    user = await user.save();
    if (!user) {
      return res.status(500).json({ message: "Error creating user" });
    }
    //send response to client
    res.json({ user });
  } catch (error) {
    console.error("Error during signup:", error);
    res.status(500).json({ error: `Internal server error: ${error}` });
  }
});

authRouter.post("/api/signin", async (req, res) => {
  try {
    //get and validate data from client
    const { email, password } = req.body;
    // Validate input
    if (!email || !password) {
      return res.status(400).json({ message: "All fields are required" });
    }
    //find user in database
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: "User not found" });
    }
    //check password
    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid credentials" });
    }
    //Generate a JWT token
    const token = jwt.sign({ id: user._id }, "passwordKey");

    //send response to client
    res.json({ token, ...user._doc });
  } catch (error) {
    console.error("Error during signin:", error);
    res.status(500).json({ error: `Internal server error: ${error}` });
  }
});

authRouter.post("/tokenISValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (error) {
    res.status(500).json({ error: `Internal server error: ${error}` });
  }
});

//get user data
authRouter.get("/", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json({ ...user._doc, token: req.token }); // Return user data and token
  } catch (error) {
    console.error("Error fetching user data:", error);
    res.status(500).json({ error: `Internal server error: ${error}` });
  }
});

module.exports = authRouter;

const jwt = require("jsonwebtoken");
const auth = async function (req, res, next)  {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      return res
        .status(401)
        .json({ msg: "No authentication token, authorization denied" });
    }
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) {
      return res
        .status(401)
        .json({ msg: "Token verification failed, authorization denied" });
    }
    req.user = verified.id; // Attach user data to request object
    req.token = token; // Attach token to request object
    next(); // Call the next middleware or route handler
  } catch (error) {
    console.error("Authentication error:", error);
    res.status(500).json({ error: `Internal server error: ${error}` });
  }
};

module.exports = auth;

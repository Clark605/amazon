const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
    username : {
        type: String,
        required: true,
        trim: true,
    },
    email: {
        type: String,
        required: true,
        trim: true,
        validate: {
            validator: (value)=>{
                // Regular expression for validating an email address
                const re = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            message: "Please enter a valid email address"
        }
        
    },
    password: {
        type: String,
        required: true,
    },
    address: {
        type: String,
        default: "",
    },
    type: {
        type: String,
        default: "user"
    },
    cart: [
        {
            product: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
            quantity: { type: Number, default: 1 }
        }
    ],
    orders: [
        {
            items: [
                {
                    product: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
                    quantity: { type: Number, default: 1 }
                }
            ],
            createdAt: { type: Date, default: Date.now }
        }
    ]
});

const User = mongoose.model("User", userSchema);

module.exports = User;

const mongoose = require('mongoose');

const employeeSchema = mongoose.Schema({
    firstName: {
        required: true,
        type: String,
        trim: true,
    },
    middleName: {
        required: true,
        type: String,
        trim: true,
    },
    lastName: {
        required: true,
        type: String,
        trim: true,
    },
    suffix: {
        required: false,
        type: String,
        trim: true,
    },
    email: {
        required: true,
        type: String,
        trim: true,
    },
    password: {
        required: true,
        type: String,
        trim: true,
    },
    phoneNo: {
        required: true,
        type: String,
        trim: true,
    },
}, { timestamps: true });

const Employee = mongoose.model("Employee", employeeSchema);
module.exports = Employee;
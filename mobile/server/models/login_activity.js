const mongoose = require('mongoose');

const ActivitySchema = mongoose.Schema({
    userId: {
        required: false,
        type: mongoose.Types.ObjectId,
        trim: true,
    },
    timeIn: {
        required: false,
        type: Date,
        trim: true,
    },
    timeOut: {
        required: false,
        type: Date,
        trim: true,
    },
}, { timestamps: true });

const Activity = mongoose.model("Activity", ActivitySchema);
module.exports = Activity;
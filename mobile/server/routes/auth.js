const express = require('express');
const bcryptjs = require('bcryptjs');
const User = require('../models/user');
const authRouter = express.Router();
const jwt = require('jsonwebtoken');
const auth = require('../middleware/auth');
const Employee = require('../models/employee');
const Activity = require('../models/login_activity');
const datefns = require('date-fns');

// Employee Details
authRouter.post('/api/employee', async (req, res) => {
    try {
        const { firstName, middleName, lastName, suffix, email, password, phoneNo } = req.body;
        const existingEmployee = await Employee.findOne({ email });
        if (existingEmployee) {
            return res
                .status(400)
                .json({msg: "Employee with same email already exists!"});
        }

        const hashedPassword = await bcryptjs.hash(password, 8);
        let employee = new Employee({
            firstName,
            middleName,
            lastName,
            suffix,
            email,
            password: hashedPassword,
            phoneNo,
        });
        employee = await employee.save();
        res.json(employee);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Time In
// still incomplete- needs to check if the existing activity also has the user's id
authRouter.post('/api/timein', async (req, res) => {
    try{
        let now = new Date();
        const existingActivity = await Activity.findOne({
            timeIn: {
                $gte: datefns.startOfDay(now),
                $lte: datefns.endOfDay(now),
            }
        });
        if (existingActivity) {
            return res
                .status(400)
                .json({msg: "You've already timed in!"})
        }
        let activity = new Activity({
            timeIn: now,
        });
        activity = await activity.save();
        res.json(activity);
    } catch (e) {
        res.status(500).json({error: e.message});
    }
});

// Time Out
// still incomplete- needs to check if the existing activity also has the user's id
authRouter.post('/api/timeout', async (req, res) => {
    try{
        let now = new Date();
        
        const existingActivity = await Activity.findOne({
            timeIn: {
                $gte: datefns.startOfDay(now),
                $lte: datefns.endOfDay(now),
            }
        });
        if (!existingActivity) {
            return res
                .status(400)
                .json({msg: "You haven't timed in yet!"})
        }
        existingActivity.timeOut = now;
        activity = await existingActivity.save();
        res.json(activity);
    } catch (e) {
        res.status(500).json({error: e.message});
    }
});

// Sign Up
authRouter.post('/api/signup', async (req, res) => {
    try{
        const { name, email, password } = req.body;
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res
                .status(400)
                .json({msg: "User with same email already exists!"});
        }

        const hashedPassword = await bcryptjs.hash(password, 8);
        let user = new User({
            email,
            password: hashedPassword,
            name,
        });
        user = await user.save();
        res.json(user);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Sign In
authRouter.post('/api/signin', async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email });
        if (!user) {
            return res
                .status(400)
                .json({ msg: "User with this email does not exist." });
        }

        const isMatch = await bcryptjs.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ msg: "Incorrect password." });
        }

        const token = jwt.sign({ id: user._id }, "passwordKey");
        res.json({ token, ...user._doc });

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

authRouter.post("/tokenIsValid", async (req, res) => {
    try {
        const token = req.header("x-auth-token");
        if (!token) return res.json(false);
        const verified = jwt.verify(token, "passwordKey");
        if (!verified) return res.json(false);

        const user = await User.findById(verified.id);
        if (!user) return res.json(false);
        res.json(true);
        
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

// get user data
authRouter.get("/", auth, async (req, res) => {
    const user = await User.findById(req.user);
    res.json({ ...user._doc, token: req.token });
});

module.exports = authRouter;
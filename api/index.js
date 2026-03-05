const express = require('express');
const { MongoClient } = require('mongodb');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

const uri = process.env.MONGODB_URI;
if (!uri) {
    console.error("MONGODB_URI is not defined in environment variables!");
}

const client = new MongoClient(uri);
let db;

async function connectDB() {
    try {
        await client.connect();
        db = client.db('testcar');
        console.log("Connected to MongoDB");
    } catch (e) {
        console.error("MongoDB Connection failed:", e);
    }
}
connectDB();

// Health Check
app.get('/', (req, res) => res.send('TestCar API is running...'));

// Auth API: Authenticate User
app.post('/api/users/auth', async (req, res) => {
    try {
        const { username, password } = req.body;
        const query = { username };
        if (password) query.password = password;
        
        const user = await db.collection('users').findOne(query);
        res.json(user);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Auth API: Register User
app.post('/api/users/register', async (req, res) => {
    try {
        const user = req.body;
        // Basic duplicate check
        const existing = await db.collection('users').findOne({ username: user.username });
        if (existing) {
            return res.status(400).json({ error: 'Username already exists' });
        }
        const result = await db.collection('users').insertOne(user);
        res.json(result);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Vehicle API: Get All Vehicles
app.get('/api/vehicles', async (req, res) => {
    try {
        const vehicles = await db.collection('vehicles').find({}).toArray();
        res.json(vehicles);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Vehicle API: Save/Update Vehicle
app.post('/api/vehicles', async (req, res) => {
    try {
        const vehicle = req.body;
        const result = await db.collection('vehicles').updateOne(
            { id: vehicle.id },
            { $set: vehicle },
            { upsert: true }
        );
        res.json(result);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

const PORT = process.env.PORT || 10000;
app.listen(PORT, '0.0.0.0', () => console.log(`Server running on port ${PORT}`));

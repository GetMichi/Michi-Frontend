// server.js
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Configuration, PlaidApi, PlaidEnvironments } = require('plaid');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

const config = new Configuration({
    basePath: PlaidEnvironments[process.env.PLAID_ENV],
    baseOptions: {
        headers: {
            'PLAID-CLIENT-ID': process.env.PLAID_CLIENT_ID,
            'PLAID-SECRET': process.env.PLAID_SECRET,
        },
    },
});
const client = new PlaidApi(config);

// 1. Create Link token
app.post('/create_link_token', async (req, res) => {
    try {
        const response = await client.linkTokenCreate({
            user: { client_user_id: 'demo_user' },
            client_name: 'Plaid Demo',
            products: ['transactions'],
            country_codes: ['US'],
            language: 'en',
        });
        res.json({ link_token: response.data.link_token });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// 2. Exchange public token for access token
let ACCESS_TOKEN = null;
app.post('/exchange_public_token', async (req, res) => {
    const { public_token } = req.body;
    try {
        const response = await client.itemPublicTokenExchange({ public_token });
        ACCESS_TOKEN = response.data.access_token;
        res.json({ success: true });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// 3. Get recent transactions (last 30 days, up to 10)
app.get('/transactions', async (req, res) => {
    if (!ACCESS_TOKEN) {
        return res.status(400).json({ error: 'No access token. Link an account first.' });
    }
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - 30);
    const endDate = new Date();
    try {
        const response = await client.transactionsGet({
            access_token: ACCESS_TOKEN,
            start_date: startDate.toISOString().split('T')[0],
            end_date: endDate.toISOString().split('T')[0],
            options: { count: 10 },
        });
        res.json({ transactions: response.data.transactions });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));

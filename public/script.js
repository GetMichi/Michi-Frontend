// public/script.js
(async () => {
    const linkButton = document.getElementById('link-button');
    const txSection = document.getElementById('transactions');
    const txList = document.getElementById('tx-list');

    // Helper to create list items
    const renderTransactions = (transactions) => {
        txList.innerHTML = '';
        transactions.forEach((tx) => {
            const li = document.createElement('li');
            const amountSpan = document.createElement('span');
            amountSpan.className = 'amount';
            amountSpan.textContent = `$${(tx.amount).toFixed(2)}`;
            li.textContent = `${tx.name} – ${tx.date}`;
            li.appendChild(amountSpan);
            txList.appendChild(li);
        });
        txSection.classList.remove('hidden');
    };

    // Get a Link token from the server
    const getLinkToken = async () => {
        const res = await fetch('/create_link_token', { method: 'POST' });
        const data = await res.json();
        return data.link_token;
    };

    // Exchange public token for access token
    const exchangePublicToken = async (publicToken) => {
        const res = await fetch('/exchange_public_token', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ public_token: publicToken }),
        });
        const data = await res.json();
        return data.success;
    };

    // Fetch recent transactions
    const fetchTransactions = async () => {
        const res = await fetch('/transactions');
        const data = await res.json();
        if (data.transactions) renderTransactions(data.transactions);
        else console.error('Error fetching transactions', data);
    };

    // Initialize Plaid Link once we have a token
    const initPlaid = async () => {
        const token = await getLinkToken();
        const handler = Plaid.create({
            token,
            onSuccess: async (public_token, metadata) => {
                await exchangePublicToken(public_token);
                await fetchTransactions();
            },
            onExit: (err, metadata) => {
                if (err) console.error('Plaid exit error', err);
            },
            onEvent: (eventName, metadata) => {
                // optional: console.log(eventName, metadata);
            },
        });
        linkButton.addEventListener('click', () => handler.open());
    };

    // Start the flow
    initPlaid();
})();

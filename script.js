// script.js
// Fetch data from a public API and render cards

const API_URL = "https://jsonplaceholder.typicode.com/posts?_limit=6";

async function fetchData() {
  try {
    const response = await fetch(API_URL);
    if (!response.ok) throw new Error("Network response was not ok");
    const data = await response.json();
    renderCards(data);
  } catch (error) {
    console.error("Fetch error:", error);
    const container = document.getElementById("content");
    container.innerHTML = `<p style="color:#ff6b6b;">Failed to load data.</p>`;
  }
}

function createCard(item) {
  const card = document.createElement("div");
  card.className = "card";
  const title = document.createElement("h3");
  title.textContent = item.title;
  const body = document.createElement("p");
  body.textContent = item.body;
  card.appendChild(title);
  card.appendChild(body);
  return card;
}

function renderCards(items) {
  const container = document.getElementById("content");
  container.innerHTML = ""; // clear any placeholder
  items.forEach(item => {
    const card = createCard(item);
    container.appendChild(card);
  });
}

// Initialize
fetchData();

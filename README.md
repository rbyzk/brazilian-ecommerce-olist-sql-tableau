# 📊 Brazilian E-Commerce Analysis (Olist) – SQL + Tableau Dashboard

This project analyzes the **Brazilian E-Commerce Public Dataset** to uncover insights into **sales performance**, **customer behavior**, **product categories**, and **delivery performance** for the **Olist marketplace** in Brazil.  

Using **PostgreSQL** for querying and **Tableau** for interactive visualization, the project delivers a **comprehensive analysis**, a **dynamic dashboard**, and a **detailed technical report**.

---

## 📝 Project Overview

- **Dataset:** Brazilian E-Commerce Public Dataset (Kaggle)  
- **Scope:** Orders placed on Olist between **2016 and 2018**  
- **Key Objectives:**
  - Analyze **sales performance** across states and product categories
  - Understand **customer behavior** via segmentation and repeat purchases
  - Examine **return, cancellation, and delivery patterns**
  - Build an **interactive Tableau dashboard** to present findings visually

---

## 📂 Project Structure

```
brazilian-ecommerce-olist-tableau/
├── data/
│ └── brazilian_ecommerce_public_dataset
├── sql/
│ ├── olist_analysis_queries.sql # Core SQL queries
│ ├── monthly_revenue.sql
│ ├── top_categories.sql
│ ├── delivery_performance.sql
│ └── customer_segmentation.sql
├── tableau/
│ ├── Brazilian_Ecommerce_Dashboard.twbx # Tableau packaged workbook
│ └── screenshots/
│ ├── overview.png
│ ├── sales_analysis.png
│ ├── customer_segments.png
│ └── regional_analysis.png
├── reports/
│ ├── Brazilian E-Commerce Analysis – Technical Report.pdf
│ └── Tableau Dashboard – Executive Summary.pdf
├── README.md
└── LICENSE
```

---

## 📸 Dashboard Preview

<img width="4724" height="945" alt="Brazilian E-Commerce Dashboard" src="https://github.com/user-attachments/assets/ecfdf6eb-93a0-4b0f-bb2c-7a41f7d1d0ff" />

---

## 🔍 Key Insights

### **1. Sales Performance**
- **São Paulo**, **Rio de Janeiro**, and **Minas Gerais** dominate overall revenue.
- **beleza_saude**, **cama_mesa_banho**, and **esporte_lazer** are the top-performing categories.

### **2. Customer Segmentation**
- Customers are grouped based on spending levels:
  - **Premium (> BRL 1000):** Contribute nearly **50% of total revenue**.
  - **Regular (BRL 500–1000):** Provide moderate revenue.
  - **Low (< BRL 500):** High order volume but smaller revenue share.

### **3. Delivery Performance**
- States like **Alagoas (24%)** and **Maranhão (20%)** have **high late delivery rates**.
- Faster deliveries lead to **higher customer satisfaction scores**:
  - **Fast deliveries (0–2 days):** Avg. rating **4.48**
  - **Late deliveries:** Avg. rating drops to **4.09**

### **4. Returns & Cancellations**
- **pc_gamer** has the highest return rate (**11.11%**).
- Other notable categories:  
  - **portateis_cozinha_e_preparadores:** **6.67%**  
  - **dvds_blu_ray:** **3.13%**
- High-volume categories show **lower return ratios**, while **niche categories** tend to have **higher returns**.

---

## 📊 Tableau Dashboard Sections

The **interactive Tableau dashboard** visualizes Olist’s marketplace performance across four main views:

| **Section**      | **Highlights**                                      |
|-------------------|---------------------------------------------------|
| **Overview**      | Revenue trends, order volumes, and overall KPIs   |
| **Sales**         | Top categories, average order values, and returns |
| **Segments**      | Customer segmentation and contribution analysis   |
| **Regions**       | Revenue distribution across Brazilian states      |

---

## ▶️ How to Use

1. **Clone the repository**  
```bash
git clone https://github.com/rbyzk/brazilian-ecommerce-olist-tableau.git
```

## 🤝 Contributing
Contributions are welcome! If you'd like to add tutorials, fix typos, or share use cases, feel free to fork this repository and submit a pull request.


## 👩‍💻 About Me
I'm Beyza Küçük — a Data Scientist & Data Analyst, passionate about building ML/DL solutions that are interpretable, effective, and impactful.


## 🌐 Let's connect and grow together in data:

**GitHub** [github.com/rbyzk](https://github.com/rbyzk)

**Kaggle** [kaggle.com/beyzakucuk](https://www.kaggle.com/beyzakucuk)

✨ If you find this repository helpful, please give it a ⭐ and share with others who might benefit!


Keep learning and coding! 🚀
---


## 📜 License
This repository is licensed under the MIT License. See the LICENSE file for more information.


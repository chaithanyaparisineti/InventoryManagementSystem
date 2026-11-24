# 📦 Inventory Management System

A robust, full-stack Java Dynamic Web Application designed to manage products, suppliers, and real-time inventory flow with stock-in/stock-out operations and audit history tracking.

---

## 🚀 Key Features

* **🔐 Admin Authentication**: Secure login and session handling for administrative operations.
* **📦 Product Management**: Complete CRUD (Create, Read, Update, Delete) for inventory products.
* **🚚 Supplier Management**: Manage supplier information linked directly with product catalogs.
* **📊 Real-time Stock Control**:
  * **Stock IN**: Add stock with automatic inventory incrementation.
  * **Stock OUT**: Deduct stock with inventory validation (prevents negative/insufficient stock).
* **📜 Transaction History**: Full audit trail recording every inventory movement with timestamps, product details, and transaction type.

---

## 🛠️ Technology Stack

| Layer | Technology |
|---|---|
| **Backend** | Java (JDK 17+), Jakarta Servlets 6.0, Jakarta Server Pages (JSP) 3.1 |
| **Database** | MySQL 8.0, JDBC (MySQL Connector/J) |
| **Server** | Apache Tomcat 10.1 |
| **Frontend** | HTML5, CSS3, Responsive Design |
| **Development** | Eclipse IDE for Enterprise Java and Web Developers |

---

## 📂 Project Structure

```
InventoryManagementSystem/
├── src/main/java/com/inventory/
│   ├── controller/          # Jakarta Servlets (Login, Logout, Product, Stock, Supplier)
│   ├── dao/                 # Data Access Objects (JDBC database queries)
│   ├── model/               # JavaBeans / POJOs (Admin, Product, StockHistory, Supplier)
│   └── util/                # DB Connection helper (DBCconnection)
├── src/main/webapp/
│   ├── css/                 # Stylesheets (style.css)
│   ├── WEB-INF/
│   │   ├── lib/             # Required JARs (mysql-connector-j)
│   │   └── web.xml          # Web application deployment descriptor
│   ├── dashboard.jsp        # Main admin dashboard
│   ├── products.jsp         # Product management interface
│   ├── editProduct.jsp      # Product edit form
│   ├── suppliers.jsp        # Supplier management interface
│   ├── editSupplier.jsp     # Supplier edit form
│   ├── stock.jsp            # Stock IN / Stock OUT operation form
│   ├── stock_history.jsp    # Stock transaction history log
│   └── login.jsp            # Admin authentication page
├── database_schema.sql      # Complete MySQL database creation script
└── README.md
```

---

## ⚙️ Setup and Installation

### 1. Database Setup
1. Ensure **MySQL Server 8.0+** is installed and running.
2. Execute the provided SQL script:
   ```bash
   mysql -u root -p < database_schema.sql
   ```
3. Update database credentials in `src/main/java/com/inventory/util/DBCconnection.java` if needed:
   ```java
   private static final String URL = "jdbc:mysql://localhost:3306/inventory_db";
   private static final String USERNAME = "root";
   private static final String PASSWORD = "your_password";
   ```

### 2. Eclipse & Tomcat Configuration
1. Open **Eclipse IDE for Enterprise Java and Web Developers**.
2. Import the project:
   * **File $\rightarrow$ Import $\rightarrow$ Existing Projects into Workspace**
   * Select `InventoryManagementSystem`
3. Configure Apache Tomcat 10.1:
   * In Eclipse, go to the **Servers** tab.
   * Right-click $\rightarrow$ **New $\rightarrow$ Server** $\rightarrow$ select **Apache Tomcat v10.1**.
   * Add `InventoryManagementSystem` to the configured resources.
4. Run the project:
   * Right-click the project $\rightarrow$ **Run As $\rightarrow$ Run on Server**.

### 3. Default Login Credentials
* **Username**: `chaithanya`
* **Password**: `chaithu1215`

---

## 📝 License
This project is open-source and available under the [MIT License](LICENSE).

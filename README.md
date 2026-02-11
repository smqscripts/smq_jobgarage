# 🏢 smq_jobgarage

Advanced vehicle management system for **ESX** and **ox_inventory**. This script provides a seamless way for jobs to manage their fleet with persistent trunk/glovebox storage and metadata-based keys.

---

## 💎 Features
- 📋 **Job-Restricted Access** - Fully customizable per job and grade.
- 💾 **Inventory Persistence** - Automatically serializes and saves Trunk and Glovebox contents to the database.
- 🔑 **Metadata Keys** - Utilizes `ox_inventory` metadata to bind keys to specific vehicle plates.
- 🛍️ **Integrated Fleet Shop** - Buy job-specific vehicles directly through the garage NPC.
- 🎯 **Target Interaction** - Clean and optimized `ox_target` integration.
- 🚀 **Performance** - Optimized codebase running at **0.00ms** on idle.

---

## 🛠️ Installation

### Database Setup
Execute the following SQL query in your database:

``sql
CREATE TABLE IF NOT EXISTS `job_garages` (
  `plate` varchar(12) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  `job` varchar(50) DEFAULT NULL,
  `vehicle` longtext DEFAULT NULL,
  `trunk` longtext DEFAULT NULL,
  `glovebox` longtext DEFAULT NULL,
  `state` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

Inventory Setup

Add this to ox_inventory/data/items.lua:

Lua
['vehicle_key'] = {
    label = 'Vehicle Key',
    weight = 0,
    stack = false,
    close = true,
    unique = true
},

Links & Support

🎥 YouTube: https://www.youtube.com/watch?v=Bb6phzY8UUc

💬 Discord: https://discord.gg/z7x6dD3yXm

💻 GitHub: https://github.com/smqscripts

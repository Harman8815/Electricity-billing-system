import random

# =====================
# Master Data
# =====================

first_names = ["Aarav","Vivaan","Aditya","Vihaan","Arjun","Reyansh","Ayaan","Krishna","Ishaan","Shaurya",
               "Ananya","Diya","Saanvi","Aadhya","Kiara","Ira","Meera","Navya","Riya","Pari"]

last_names = ["Sharma","Verma","Gupta","Patel","Reddy","Nair","Iyer","Singh","Khan","Das",
              "Mehta","Jain","Agarwal","Bansal","Yadav","Mishra","Kapoor","Joshi","Chatterjee","Pillai"]

cities = [
    ("Mumbai","Maharashtra"),("Delhi","Delhi"),("Bangalore","Karnataka"),("Chennai","Tamil Nadu"),
    ("Kolkata","West Bengal"),("Hyderabad","Telangana"),("Pune","Maharashtra"),("Ahmedabad","Gujarat"),
    ("Jaipur","Rajasthan"),("Lucknow","Uttar Pradesh"),("Kochi","Kerala"),("Bhopal","Madhya Pradesh"),
    ("Chandigarh","Chandigarh"),("Patna","Bihar"),("Indore","Madhya Pradesh"),("Nagpur","Maharashtra"),
    ("Surat","Gujarat"),("Noida","Uttar Pradesh"),("Ludhiana","Punjab"),("Thiruvananthapuram","Kerala")
]

streets = ["MG Road","Brigade Road","Park Street","Ring Road","Link Road","Station Road",
           "Nehru Street","Temple Road","Lake View Road","Gandhi Nagar"]

localities = ["Sector 12","Phase 2","Extension","Colony","Layout","Nagar","Block A","Block B","Society"]

# =====================
# Formatter
# =====================

def format_field(value, length):
    return str(value).ljust(length)[:length]

# =====================
# Record Generator
# =====================

def generate_record(index):
    # cust_id = f"CUST{1000 + index}"
    first = random.choice(first_names)
    last = random.choice(last_names)
    area_code = random.randint(100000, 999999)

    city, state = random.choice(cities)

    house_no = random.randint(1, 999)
    street = random.choice(streets)
    locality = random.choice(localities)

    address_line_1 = f"H.No {house_no} {street}"
    address_line_2 = f"{locality}"

    units = random.randint(100, 5000)
    status = random.choice(["active", "inactive"])

    record = (
        format_field(first, 15) +
        format_field(last, 15) +
        format_field(area_code, 7) +
        format_field(address_line_1, 30) +
        format_field(address_line_2, 30) +
        format_field(city, 20) +
        format_field(units, 10) +
        format_field(status, 10)
    )

    return record

# =====================
# File Generation
# =====================

with open("customer_fixed_200.txt", "w") as f:
    for i in range(200):
        f.write(generate_record(i) + "\n")
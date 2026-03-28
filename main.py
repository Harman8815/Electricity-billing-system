import random
import csv

FIRST_NAMES = ["Aman","Riya","Karan","Neha","Rahul","Priya","Arjun","Sneha","Vikram","Anjali"]
LAST_NAMES = ["Sharma","Verma","Patel","Singh","Gupta","Nair","Reddy","Iyer","Yadav","Das"]
CITIES = ["Indore","Bangalore","Ahmedabad","Delhi","Lucknow","Kochi","Hyderabad","Chennai","Patna","Kolkata"]

def generate_master_data(n):
    data = []
    for _ in range(n):
        first = random.choice(FIRST_NAMES)
        last = random.choice(LAST_NAMES)
        city = random.choice(CITIES)
        area = str(random.randint(100000, 999999))
        address = f"Area-{random.randint(1,999)}"
        prev = random.randint(50, 300)
        curr = prev + random.randint(10, 100)

        data.append([
            first,
            last,
            area,
            address,
            city,
            prev,
            curr
        ])
    return data

def write_master_csv(data):
    with open("master.csv", "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([
            "first_name",
            "last_name",
            "area_code",
            "address_line",
            "city",
            "prev_read",
            "curr_read"
        ])
        writer.writerows(data)

def pad(value, length):
    return str(value).ljust(length)[:length]

def create_customer_file(data):
    with open("customer.dat", "w") as f:
        for row in data:
            first, last, area, address, city, prev, curr = row
            units = curr - prev

            record = (
                pad(first, 15) +
                pad(last, 15) +
                pad(area, 7) +
                pad(address, 30) +
                pad(city, 20) +
                pad(units, 10)
            )
            f.write(record + "\n")

def create_meter_file(data):
    with open("meter.dat", "w") as f:
        for row in data:
            _, _, _, _, _, prev, curr = row

            record = (
                pad(prev, 6) +
                pad(curr, 6)
            )
            f.write(record + "\n")

def create_bill_file(data, rate=5):
    with open("bill.dat", "w") as f:
        for row in data:
            first, last, _, _, _, prev, curr = row
            units = curr - prev
            amount = units * rate

            record = (
                pad(first, 15) +
                pad(last, 15) +
                pad(units, 6) +
                pad(amount, 8)
            )
            f.write(record + "\n")

def main():
    n = 100
    data = generate_master_data(n)

    write_master_csv(data)
    create_customer_file(data)
    create_meter_file(data)
    create_bill_file(data)

if __name__ == "__main__":
    main()
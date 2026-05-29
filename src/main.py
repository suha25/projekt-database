#!/usr/bin/env python3
"""
Job Application Tracker - Terminal Based
Uses .env for DB credentials. Matches tracker database schema exactly.
"""

import mysql.connector
from dotenv import load_dotenv
import os
import getpass
from datetime import date

# ──────────────────────────────────────────────
# LOAD ENV & CONNECT
# ──────────────────────────────────────────────

load_dotenv(dotenv_path='.env')

def connect_db():
    try:
        conn = mysql.connector.connect(
            host=os.getenv('DB_HOST', 'localhost'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD'),
            database=os.getenv('DB_NAME', 'tracker')
        )
        return conn
    except mysql.connector.Error as e:
        print(f"✗ Database connection failed: {e}")
        raise SystemExit(1)


# ──────────────────────────────────────────────
# HELPERS
# ──────────────────────────────────────────────

def hr(char="─", width=58):
    print(char * width)

def prompt_date(label, required=True):
    while True:
        val = input(f"  {label} (YYYY-MM-DD){'' if required else ' [Enter to skip]'}: ").strip()
        if not val and not required:
            return None
        try:
            return date.fromisoformat(val)
        except ValueError:
            print("    ✗ Invalid date. Use YYYY-MM-DD.")

def prompt_int(label, required=True):
    while True:
        val = input(f"  {label}: ").strip()
        if not val and not required:
            return None
        try:
            return int(val)
        except ValueError:
            print("    ✗ Please enter a valid number.")

def pause():
    input("\n  Press Enter to continue...")


# ──────────────────────────────────────────────
# STATUS CONSTANTS (matches seeded data)
# 1 = Pending | 2 = Interview | 3 = Rejected
# ──────────────────────────────────────────────

DEFAULT_STATUS_ID = 1  # Pending


# ──────────────────────────────────────────────
# AUTH
# ──────────────────────────────────────────────

def login(conn):
    cursor = conn.cursor(dictionary=True)
    hr()
    print("  LOGIN")
    hr()
    email    = input("  Email:    ").strip()
    password = getpass.getpass("  Password: ")

    cursor.execute(
        "SELECT user_id, first_name, last_name FROM p_User WHERE gmail=%s AND p_password=%s",
        (email, password)
    )
    row = cursor.fetchone()
    cursor.close()

    if row:
        print(f"\n  ✓ Welcome back, {row['first_name']} {row['last_name']}!")
        return row
    else:
        print("  ✗ Invalid email or password.")
        return None


def register(conn):
    cursor = conn.cursor()
    hr()
    print("  REGISTER")
    hr()
    first    = input("  First name: ").strip()
    last     = input("  Last name:  ").strip()
    email    = input("  Email:      ").strip()
    password = getpass.getpass("  Password:   ")

    try:
        cursor.execute(
            """INSERT INTO p_User (first_name, last_name, gmail, p_password)
               VALUES (%s, %s, %s, %s)""",
            (first, last, email, password)
        )
        conn.commit()
        user_id = cursor.lastrowid
        cursor.close()
        print(f"\n  ✓ Account created! Your user ID is {user_id}.")
        return {"user_id": user_id, "first_name": first, "last_name": last}
    except mysql.connector.Error as e:
        print(f"  ✗ Registration failed: {e}")
        cursor.close()
        return None


# ──────────────────────────────────────────────
# QUERY 1 – ADD NEW APPLICATION (INSERT)
# ──────────────────────────────────────────────

def add_application(conn, user):
    cursor = conn.cursor(dictionary=True)
    hr()
    print("  ADD NEW APPLICATION")
    hr()

    # Show companies
    cursor.execute("SELECT company_id, company_name, industry FROM Company ORDER BY company_name")
    companies = cursor.fetchall()
    print("\n  Companies:")
    for c in companies:
        print(f"    [{c['company_id']}] {c['company_name']} — {c['industry'] or '—'}")

    company_id = prompt_int("Enter company ID")

    # Validate company exists
    cursor.execute("SELECT company_id FROM Company WHERE company_id = %s", (company_id,))
    if not cursor.fetchone():
        print("  ✗ Invalid company ID.")
        cursor.close()
        pause()
        return

    # Show statuses
    cursor.execute("SELECT status_id, status_name FROM Status ORDER BY status_id")
    statuses = cursor.fetchall()
    print(f"\n  Status (default: [{DEFAULT_STATUS_ID}] Pending):")
    for s in statuses:
        print(f"    [{s['status_id']}] {s['status_name']}")

    status_input = input(f"  Enter status ID [Enter for Pending]: ").strip()
    status_id    = int(status_input) if status_input else DEFAULT_STATUS_ID

    contact_person   = input("  Contact person   [Enter to skip]: ").strip() or None
    contact_email    = input("  Contact email    [Enter to skip]: ").strip() or None
    application_date = prompt_date("Application date")
    interview_date   = prompt_date("Interview date", required=False)
    deadline         = prompt_date("Deadline",       required=False)
    notes            = input("  Notes            [Enter to skip]: ").strip() or None

    try:
        # Query 1: INSERT INTO JobApplication
        cursor.execute("""
            INSERT INTO JobApplication
                (contact_person, contact_email, interview_date,
                 application_date, notes, deadline,
                 user_id, status_id, company_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (contact_person, contact_email, interview_date,
              application_date, notes, deadline,
              user['user_id'], status_id, company_id))
        conn.commit()
        print(f"\n  ✓ Application added (ID: {cursor.lastrowid}).")
    except mysql.connector.Error as e:
        print(f"  ✗ Error inserting application: {e}")

    cursor.close()
    pause()


# ──────────────────────────────────────────────
# QUERY 4 – VIEW ALL APPLICATIONS (Stored Procedure)
# ──────────────────────────────────────────────

def view_applications(conn, user):
    cursor = conn.cursor(dictionary=True)
    hr()
    print("  MY APPLICATIONS")
    hr()

    try:
        # Calls the stored procedure: GetUserApplications(p_user_id)
        cursor.callproc("GetUserApplications", [user['user_id']])
        rows = []
        for result in cursor.stored_results():
            rows = result.fetchall()

        if not rows:
            print("  No applications found.")
        else:
            print(f"\n  {'ID':<5} {'Company':<20} {'Status':<12} {'Applied':<13} {'Interview':<13} {'Deadline'}")
            hr()
            for r in rows:
                print(
                    f"  {r['application_id']:<5} "
                    f"{r['company_name']:<20} "
                    f"{r['status_name'] or '—':<12} "
                    f"{str(r['application_date']):<13} "
                    f"{str(r['interview_date']) if r['interview_date'] else '—':<13} "
                    f"{str(r['deadline']) if r['deadline'] else '—'}"
                )
    except mysql.connector.Error as e:
        print(f"  ✗ Error calling procedure: {e}")

    cursor.close()
    pause()


# ──────────────────────────────────────────────
# UPDATE STATUS
# ──────────────────────────────────────────────

def update_status(conn, user):
    cursor = conn.cursor(dictionary=True)
    hr()
    print("  UPDATE APPLICATION STATUS")
    hr()

    cursor.execute("""
        SELECT ja.application_id, c.company_name, s.status_name
        FROM JobApplication ja
        JOIN Company c ON ja.company_id = c.company_id
        LEFT JOIN Status s ON ja.status_id = s.status_id
        WHERE ja.user_id = %s
        ORDER BY ja.application_date DESC
    """, (user['user_id'],))
    apps = cursor.fetchall()

    if not apps:
        print("  No applications to update.")
        cursor.close()
        pause()
        return

    for a in apps:
        print(f"  [{a['application_id']}] {a['company_name']} — {a['status_name'] or '—'}")

    app_id = prompt_int("Enter application ID to update")

    # Verify ownership
    cursor.execute(
        "SELECT application_id FROM JobApplication WHERE application_id=%s AND user_id=%s",
        (app_id, user['user_id'])
    )
    if not cursor.fetchone():
        print("  ✗ Application not found or does not belong to you.")
        cursor.close()
        pause()
        return

    cursor.execute("SELECT status_id, status_name FROM Status ORDER BY status_id")
    statuses = cursor.fetchall()
    print("\n  Available statuses:")
    for s in statuses:
        print(f"    [{s['status_id']}] {s['status_name']}")

    new_status = prompt_int("New status ID")

    try:
        cursor.execute(
            "UPDATE JobApplication SET status_id=%s WHERE application_id=%s",
            (new_status, app_id)
        )
        conn.commit()
        print("  ✓ Status updated successfully.")
    except mysql.connector.Error as e:
        print(f"  ✗ Error updating status: {e}")

    cursor.close()
    pause()


# ──────────────────────────────────────────────
# DELETE APPLICATION
# ──────────────────────────────────────────────

def delete_application(conn, user):
    cursor = conn.cursor(dictionary=True)
    hr()
    print("  DELETE APPLICATION")
    hr()

    cursor.execute("""
        SELECT ja.application_id, c.company_name, ja.application_date
        FROM JobApplication ja
        JOIN Company c ON ja.company_id = c.company_id
        WHERE ja.user_id = %s
        ORDER BY ja.application_date DESC
    """, (user['user_id'],))
    apps = cursor.fetchall()

    if not apps:
        print("  No applications found.")
        cursor.close()
        pause()
        return

    for a in apps:
        print(f"  [{a['application_id']}] {a['company_name']} — Applied: {a['application_date']}")

    app_id  = prompt_int("Enter application ID to delete")
    confirm = input(f"  Confirm delete application {app_id}? (yes/no): ").strip().lower()

    if confirm != "yes":
        print("  Cancelled.")
        cursor.close()
        pause()
        return

    try:
        cursor.execute(
            "DELETE FROM JobApplication WHERE application_id=%s AND user_id=%s",
            (app_id, user['user_id'])
        )
        conn.commit()
        if cursor.rowcount:
            print(f"  ✓ Application {app_id} deleted.")
        else:
            print("  ✗ Application not found or does not belong to you.")
    except mysql.connector.Error as e:
        print(f"  ✗ Error: {e}")

    cursor.close()
    pause()


# ──────────────────────────────────────────────
# QUERY 2 – DAYS WAITING PER APPLICATION (DATEDIFF)
# ──────────────────────────────────────────────

def get_days_waiting_for_each_job(cursor, user_id):
    try:
        cursor.execute("""
            SELECT p_User.first_name, p_User.last_name,
                   JobApplication.application_id,
                   DATEDIFF(JobApplication.interview_date, JobApplication.application_date)
                       AS days_waiting_for_interview
            FROM JobApplication
            JOIN p_User ON JobApplication.user_id = p_User.user_id
            WHERE JobApplication.interview_date IS NOT NULL
              AND JobApplication.user_id = %s
            ORDER BY JobApplication.application_date DESC
        """, (user_id,))

        results = cursor.fetchall()
        if results:
            print(f"\n  {'App ID':<8} {'Days Waiting':<15} Name")
            hr()
            for row in results:
                print(f"  {row[2]:<8} {row[3]:<15} {row[0]} {row[1]}")
        else:
            print("  No applications with interview dates found.")
    except mysql.connector.Error as e:
        print(f"  ✗ Error executing query: {e}")


def days_waiting_menu(conn, user):
    cursor = conn.cursor()
    hr()
    print("  DAYS WAITING PER INTERVIEW")
    hr()
    get_days_waiting_for_each_job(cursor, user['user_id'])
    cursor.close()
    pause()


# ──────────────────────────────────────────────
# QUERY 3 – APPLICATIONS PER COMPANY (COUNT + GROUP BY)
# ──────────────────────────────────────────────

def apps_per_company(conn):
    cursor = conn.cursor()
    hr()
    print("  APPLICATIONS PER COMPANY (all users)")
    hr()

    try:
        cursor.execute("""
            SELECT Company.company_name,
                   COUNT(JobApplication.application_id) AS application_count
            FROM JobApplication
            JOIN Company ON JobApplication.company_id = Company.company_id
            GROUP BY Company.company_name
            ORDER BY application_count DESC
        """)
        rows = cursor.fetchall()
        if rows:
            print(f"\n  {'Company':<30} Applications")
            hr()
            for row in rows:
                print(f"  {row[0]:<30} {row[1]}")
        else:
            print("  No data found.")
    except mysql.connector.Error as e:
        print(f"  ✗ Error: {e}")

    cursor.close()
    pause()


# ──────────────────────────────────────────────
# QUERY 5 – GET STATUS BY APPLICATION ID (Function)
# ──────────────────────────────────────────────

def get_status_by_id(conn, user):
    cursor = conn.cursor()
    hr()
    print("  CHECK STATUS BY APPLICATION ID")
    hr()

    # Show user's application IDs for reference
    cursor.execute(
        "SELECT application_id FROM JobApplication WHERE user_id = %s ORDER BY application_id",
        (user['user_id'],)
    )
    apps = cursor.fetchall()
    if apps:
        ids = ", ".join(str(a[0]) for a in apps)
        print(f"  Your application IDs: {ids}")

    app_id = prompt_int("Enter application ID")

    try:
        # Calls the MySQL function: GetApplicationStatus(app_id)
        cursor.execute("SELECT GetApplicationStatus(%s)", (app_id,))
        row = cursor.fetchone()
        if row and row[0]:
            print(f"\n  Status: {row[0]}")
        else:
            print("  No status found for that application ID.")
    except mysql.connector.Error as e:
        print(f"  ✗ Error calling function: {e}")

    cursor.close()
    pause()


# ──────────────────────────────────────────────
# COMPANY MANAGEMENT
# ──────────────────────────────────────────────

def list_companies(conn):
    cursor = conn.cursor()
    hr()
    print("  ALL COMPANIES")
    hr()
    cursor.execute(
        "SELECT company_id, company_name, industry, website FROM Company ORDER BY company_name"
    )
    rows = cursor.fetchall()
    if rows:
        print(f"\n  {'ID':<5} {'Name':<25} {'Industry':<20} Website")
        hr()
        for row in rows:
            print(f"  {row[0]:<5} {row[1]:<25} {row[2] or '—':<20} {row[3] or '—'}")
    else:
        print("  No companies found.")
    cursor.close()
    pause()


def add_company(conn):
    cursor = conn.cursor()
    hr()
    print("  ADD COMPANY")
    hr()
    name     = input("  Company name:            ").strip()
    industry = input("  Industry [Enter to skip]: ").strip() or None
    website  = input("  Website  [Enter to skip]: ").strip() or None

    try:
        cursor.execute(
            "INSERT INTO Company (company_name, industry, website) VALUES (%s, %s, %s)",
            (name, industry, website)
        )
        conn.commit()
        print(f"  ✓ Company added (ID: {cursor.lastrowid}).")
    except mysql.connector.Error as e:
        print(f"  ✗ Error: {e}")

    cursor.close()
    pause()


# ──────────────────────────────────────────────
# MENUS
# ──────────────────────────────────────────────

def auth_menu(conn):
    while True:
        hr("═")
        print("  JOB APPLICATION TRACKER")
        hr("═")
        print("  [1] Login")
        print("  [2] Register")
        print("  [0] Exit")
        hr()
        choice = input("  Choose: ").strip()

        if choice == "1":
            user = login(conn)
            if user:
                return user
        elif choice == "2":
            user = register(conn)
            if user:
                return user
        elif choice == "0":
            print("\n  Goodbye!\n")
            raise SystemExit(0)
        else:
            print("  ✗ Invalid choice.\n")


def main_menu(conn, user):
    while True:
        hr("═")
        print(f"  JOB TRACKER  ·  {user['first_name']} {user['last_name']}")
        hr("═")
        print("  ── Applications ──────────────────────────────────")
        print("  [1] View my applications           (Query 4 – Procedure)")
        print("  [2] Add new application            (Query 1 – INSERT)")
        print("  [3] Update application status")
        print("  [4] Delete application")
        print()
        print("  ── Analytics ─────────────────────────────────────")
        print("  [5] Days waiting per interview     (Query 2 – DATEDIFF)")
        print("  [6] Applications per company       (Query 3 – COUNT/GROUP BY)")
        print("  [7] Check status by application ID (Query 5 – Function)")
        print()
        print("  ── Companies ─────────────────────────────────────")
        print("  [8] List all companies")
        print("  [9] Add company")
        print()
        print("  [0] Logout")
        hr()
        choice = input("  Choose: ").strip()

        if   choice == "1": view_applications(conn, user)
        elif choice == "2": add_application(conn, user)
        elif choice == "3": update_status(conn, user)
        elif choice == "4": delete_application(conn, user)
        elif choice == "5": days_waiting_menu(conn, user)
        elif choice == "6": apps_per_company(conn)
        elif choice == "7": get_status_by_id(conn, user)
        elif choice == "8": list_companies(conn)
        elif choice == "9": add_company(conn)
        elif choice == "0":
            print(f"\n  Logged out. Goodbye, {user['first_name']}!\n")
            break
        else:
            print("  ✗ Invalid choice.\n")


# ──────────────────────────────────────────────
# ENTRY POINT
# ──────────────────────────────────────────────

def main():
    print("\n  Connecting to database...")
    conn = connect_db()
    print("  ✓ Connected.\n")
    try:
        while True:
            user = auth_menu(conn)
            main_menu(conn, user)
    finally:
        conn.close()

if __name__ == "__main__":
    main()
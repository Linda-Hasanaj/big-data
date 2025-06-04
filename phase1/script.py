import pyodbc
from datetime import datetime

try:
    conn = pyodbc.connect(
        "Driver={SQL Server};"
        "Server=FJOLLA\\SQLEXPRESS;"
        "Database=DWH_BankDB;"
        "Trusted_Connection=yes;"
    )

    cursor = conn.cursor()
    cursor.execute("EXEC autodataflow;")
    conn.commit()
    print(f"[{datetime.now()}] Procedura 'autodataflow' u ekzekutua me sukses.")

except Exception as e:
    print(f"[{datetime.now()}] Gabim gjatë ekzekutimit: {e}")

finally:
    try:
        cursor.close()
        conn.close()
    except:
        pass
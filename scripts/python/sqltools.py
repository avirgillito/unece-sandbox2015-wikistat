import sqlite3

def connect(dbpath):
    conn = sqlite3.connect(dbpath)
    cur = conn.cursor()
    return (conn, cur)

def commit_changes(conn):
    conn.commit()  

def close(conn, cur):
    cur.close()
    conn.close()
        
def execute_modifier(cur, sql):
    cur.execute(sql)
    

    


#def create_table():
#print create_create_sql(2000,1,1,2000,1,3)


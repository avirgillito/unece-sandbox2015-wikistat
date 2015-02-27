# The imports are in the function body so that only importing the function does not break down.

def create_create_sql(start_year, start_month, start_day, end_year, end_month, end_day):    
    from datetime import datetime
    from datetime import timedelta
    d1 = datetime(start_year, start_month, start_day)
    d2 = datetime(end_year, end_month, end_day)
    
    #monday1 = (d1 - timedelta(days=d1.weekday()))
    #monday2 = (d2 - timedelta(days=d2.weekday()))
    #nweeks = (monday2 - monday1).days/7
        
    d = d1
    
    sql = "create table all_data(id int"
    while True:
        if d < d2:
            sql += ", " + d.strftime('%Y_%m_%d') + " int"
            d = d + timedelta(1,0,0) # get next day
            continue
        else: 
            sql += ")"
            return sql
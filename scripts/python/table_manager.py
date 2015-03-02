#import create_create_sql
import sys
import os
import inspect
import sqlite3

from datetime import datetime
from datetime import timedelta

# a convoluted way to import a sister file while execfiling this one (necessitated by using virtualized python)
sys.path.append(os.path.dirname(inspect.getframeinfo(inspect.currentframe()).filename))
from create_create_sql import create_create_sql
import sqltools
import date_convertor

def create_data_table(cur, start_date, end_date):
    sql = create_create_sql(start_date, end_date)
    sqltools.execute_modifier(cur, sql)

def create_project_table(cur):
    sql = "create table project (id int primary key, name text)"
    sqltools.execute_modifier(cur, sql)
    
def create_article_table(cur):
    sql = "create table article (id int primary key, proj int, name text)"
    sqltools.execute_modifier(cur, sql)
    
def init_db(cur, start_date, end_date):
    drop_data_table(cur)
    drop_article_table(cur)
    create_data_table(cur, start_date, end_date)
    create_article_table(cur)
    
    
def drop_data_table(cur):
    drop_table(cur, "all_data")

def drop_article_table(cur):
    drop_table(cur, "article")
    
def drop_project_table(cur):
    drop_table(cur, "project")
   
def drop_table(cur, table):
    sql = "drop table %s" % table    
    sqltools.execute_modifier(cur, sql)

def insert_article(cur, article_name, article_id, proj_id):
    sql = "insert into article (id, proj, name) values ( %s, %s, %s)" % (article_id, proj_id, article_name)  
    sqltools.execute_modifier(cur, sql)
    
def insert_project(cur, project_name, proj_id):
    sql = "insert into project (id, proj, name) values ( %s, %s, %s)" % (article_id, proj_id, article_name)  
    sqltools.execute_modifier(cur, sql)
    

def insert_new_article(cur, line_number, visits):    
    # a keys entry and a values entry - in even and odd positions respectively    
    sql = "insert into all_data (id, "
    sql += ''.join([ "%s, " % (date_convertor.date2col(d), ) for d, n in visits])
    # remove the last comma
    sql = sql[:-2]
    sql += ") values (%s, " % (line_number,)
    sql += ''.join([ "%s, " % (n, ) for d, n in visits])
    sql = sql[:-2]
    sql += ")"
    sqltools.execute_modifier(cur, sql)
    

def create_create_sql(d1, d2):    
    #d1 = datetime(start_year, start_month, start_day)
    #d2 = datetime(end_year, end_month, end_day)
    
    #monday1 = (d1 - timedelta(days=d1.weekday()))
    #monday2 = (d2 - timedelta(days=d2.weekday()))
    #nweeks = (monday2 - monday1).days/7
        
    d = d1
    
    sql = "create table all_data(id int"
    while True:
        if d < d2:
            sql += ",%s int" % (date_convertor.date2col(d),)
            d = d + timedelta(1,0,0) # get next day
            continue
        else: 
            sql += ")"
            return sql
    
    
#def create_table():
#print create_create_sql(2000,1,1,2000,1,3)


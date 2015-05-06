#import create_create_sql
import sys
import os
import inspect
import sqlite3

from datetime import datetime

# a convoluted way to import a sister file while execfiling this one (necessitated by using virtualized python)
sys.path.append(os.path.dirname(inspect.getframeinfo(inspect.currentframe()).filename))
import sqltools
import date_convertor

#def create_data_table(cur, start_date, end_date):
#    sql = create_create_sql(start_date, end_date)
#    sqltools.execute_modifier(cur, sql, ())

def create_hit_table(cur):
    sql = "create table hit (art int, hour int, hits int)"
    sqltools.execute_modifier(cur, sql, ())
    
def create_project_table(cur):
    sql = "create table project (id int primary key, name text)"
    sqltools.execute_modifier(cur, sql, ())
    
def create_article_table(cur):
    sql = "create table article (id int primary key, proj int, name text)"
    sqltools.execute_modifier(cur, sql, ())
    
def init_db(cur):
    drop_hit_table(cur)
    drop_article_table(cur)
    drop_project_table(cur)
    create_hit_table(cur)
    create_article_table(cur)
    create_project_table(cur)
    
    
def drop_hit_table(cur):
    drop_table(cur, "hit")

def drop_article_table(cur):
    drop_table(cur, "article")
    
def drop_project_table(cur):
    drop_table(cur, "project")
   
def drop_table(cur, table):
    # here the table is an SQL object and cannot be substituted by a placeholder in the execute statement - hence we construct it in advance
    sql = "drop table if exists %s" % (table,)       
    sqltools.execute_modifier(cur, sql, ())

def insert_article(cur, article_name, article_id, proj_id):
    #sql = "insert into article (id, proj, name) values ( %s, %s, '%s')"
    sql = "insert into article (id, proj, name) values ( ?, ?, ?)"
    param_tuple = (article_id, proj_id, article_name)      
    sqltools.execute_modifier(cur, sql, param_tuple)
    
def insert_project(cur, proj_name, proj_id):
    #sql = "insert into project (id, name) values ( %s, '%s')"
    sql = "insert into project (id, name) values ( ?, ?)"
    param_tuple = (proj_id, proj_name)
    print sql
    sqltools.execute_modifier(cur, sql, param_tuple)
    
def insert_new_hits(cur, article_id, visits):    
    # a keys entry and a values entry - in even and odd positions respectively        
    for v in visits:
        sqltools.execute_modifier(cur, "insert into hit (art, hour, hits) values (?, ?, ?)", (article_id, v[0], v[1]))
    
    #sql = "insert into all_data (id, "
    #sql += ''.join([ "%s, " % (date_convertor.date2col(d), ) for d, n in visits])
    ## remove the last comma
    #sql = sql[:-2]
    #sql += ") values (%s, " % (line_number,)
    #sql += ''.join([ "%s, " % (n, ) for d, n in visits])
    #sql = sql[:-2]
    #sql += ")"
    #sqltools.execute_modifier(cur, sql, ())


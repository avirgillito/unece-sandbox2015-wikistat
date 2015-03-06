import sqlite3
import bz2
import datetime
import sys
import os
import inspect
import codecs

sys.path.append(os.path.dirname(inspect.getframeinfo(inspect.currentframe()).filename))
import table_manager
import sqltools
import date_convertor

epoch = datetime.datetime(1970,1,1)

'''
    DESTROYS ALL EXISTING DATA
    
    start_date is the start date of the whole database, end_date is the end date
    current_date is the first date of the month - all offsetting will be relative to this date
    all dates should be  datetime.datetime objects.
    
    project ids are generated on the fly - expected to be few
    an article id is the line number on which the entry appears
'''
def populate_initial(dbpath, infile, current_date):
    # We work with the naive datetime implementation which, like utc has no daylight saving time.
    # It still has leap years.
    
    offset_at_first_day = (current_date - epoch).days * 24
    (conn, cur) = sqltools.connect(dbpath)
    #(conn_art, cur_art) = sqltools.connect(dbpath_art)
    #(conn_hits, cur_hits) = sqltools.connect(dbpath_hits)
    
    #table_manager.init_db(cur_art)
    #table_manager.init_db(cur_hits)
    table_manager.init_db(cur)
    
    #reader = codecs.getreader("utf-8")
    bin = bz2.BZ2File(infile , 'r')
    #bin = file(infile , 'r')    
    
    #bin = reader(bz2.BZ2File(infile,'r'))
    #bin = reader(open(infile,'r'))
    
    projects = {}
    proj_id_reached = 0 
    line_number = 0  
    while True:
        line_number += 1        
        try:
            line = bin.readline()
            line = line.decode("utf-8")
        except UnicodeDecodeError, e:
            print line_number
            continue
                       
        if line == "":
            break
        if line[0] == "#":
            continue
        parts = line.split()
        proj = parts[0]
        
        newproject = False
        if proj not in projects:
            newproject = True
            proj_id_reached += 1
            proj_id = proj_id_reached
            projects[proj] = proj_id
        else:
            proj_id = projects[proj]
        name = parts[1]        
        detailed = parts[3]        
        hits = date_convertor.convert_all(detailed, offset_at_first_day)
        
        if newproject:
            #table_manager.insert_project(cur_art, proj, proj_id)            
            table_manager.insert_project(cur, proj, proj_id)            
        #table_manager.insert_article(cur_art, name, line_number, proj_id)
        table_manager.insert_article(cur, name, line_number, proj_id)
        #table_manager.insert_new_hits(cur_hits, line_number, hits)
        table_manager.insert_new_hits(cur, line_number, hits)
    #sqltools.commit_changes(conn_art)
    #sqltools.commit_changes(conn_hits)
    sqltools.commit_changes(conn)
    #sqltools.close(conn_art, cur_art)
    #sqltools.close(conn_hits, cur_hits)
    sqltools.close(conn, cur)
        
        
        
        
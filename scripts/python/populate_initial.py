import sqlite3
import bz2
import datetime

sys.path.append(os.path.dirname(inspect.getframeinfo(inspect.currentframe()).filename))
import table_manager
import sqltools
import date_convertor

'''
    Destroys all existing data!
    start_date is the start date of the whole database, end_date is the end date
    current_date is the first date of the month - all offsetting will be relative to this date
    
    project ids are generated on the fly - expected to be few
    an article id is the line number on which the entry appears
'''
def populate_initial(dbpath, table_name, infile, start_date, end_date, current_date):
    (conn, cur) = sqltools.connect(dbpath)
    table_manager.init_db(cur)
    
    bin = bz2.BZ2File(infile , 'r')
    
    projects = {}
    proj_id_reached = 0 
    line_number = 0
    while True:
        line = bin.readline()
        line_number += 1
        if line == "":
            break
        if line[0] == "#":
            continue
        parts = line.split()
        proj = parts[0]
        newproject = False
        if proj not in projects:
            proj_id_reached += 1
            proj_id = proj_id_reached
            projects[proj_id] = proj
            newproject = True
        else:
            proj_id = projects[proj]
        name = parts[1]        
        detailed = parts[3]
        visits = date_convertor.convertall(detailed, current_date)
        
        if newproject:
            table_manager.insert_project(cur, proj, proj_id)            
        table_manager.insert_article(cur, name, line_number, proj_id)
        table_manager.insert_new_article(cur, line_number, visits)
    
    sqltools.commit_changes()
    sqltools.close()
        
        
        
        
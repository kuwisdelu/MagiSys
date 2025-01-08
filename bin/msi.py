#!/usr/bin/env python3

import os
from badwulf.cli import dbmanager
from badwulf import tools

nodes = {
	"01": "Magi-01",
	"02": "Magi-02",
	"03": "Magi-03"}

app = dbmanager("MSI Research", 
	dbpath=os.getenv("MAGI_DBPATH", default="/Volumes/Magi/Datasets"),
	dbname="MSI",
	version = "0.0.0",
	date = "2024-01-07",
	description = "MSI Research database",
	program = "msi",
	metadir = "MSIResearch")

if tools.is_known_host(nodes.values()):
	app.remote_dbhost = "Magi-03.local"
	app.remote_dbpath = "/Volumes/MagiFS/Datasets"
	app.server = None
	app.server_username = None
else:
	app.remote_dbhost = "Magi-03"
	app.remote_dbpath = "/Volumes/MagiFS/Datasets"
	app.server = "login.khoury.northeastern.edu"
	app.server_username = os.getenv("MAGI_LOGIN", default=None)

app.main()

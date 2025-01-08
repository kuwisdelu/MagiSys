#!/usr/bin/env python3

import os
from badwulf.cli import clmanager
from badwulf import tools

nodes = {
	"01": "Magi-01",
	"02": "Magi-02",
	"03": "Magi-03"}

app = clmanager("Magi",
	nodes = nodes,
	version = "0.0.0",
	date = "2024-01-07",
	description = "Magi cluster @ NEU",
	program = "magi")

if tools.is_known_host(nodes.values()):
	app.username = os.getlogin()
	app.server = None
	app.server_username = None
else:
	app.username = os.getenv("MAGI_USER", default="viteklab")
	app.server = "login.khoury.northeastern.edu"
	app.server_username = os.getenv("MAGI_LOGIN", default=None)

app.main()

import os
import sys
from badwulf.cli import clmanager
from badwulf import tools

program = "magi"

nodes = {
	"01": "Magi-01",
	"02": "Magi-02",
	"03": "Magi-03"}

head = "Magi-01"

prefix = os.getenv("MAGI_PREFIX")
if prefix is None:
	sys.exit(f"{program}: $MAGI_PREFIX is not set")

if tools.is_known_host(nodes.values()):
	user = os.getlogin()
	server = None
	server_user = None
else:
	user = os.getenv("MAGI_USER", default="viteklab")
	server = "login.khoury.northeastern.edu"
	server_user = os.getenv("MAGI_LOGIN")

app = clmanager("Magi",
	nodes = nodes,
	date = "2025-09-10",
	description = "Magi cluster @ NEU",
	readme = os.path.join(prefix, "MagiSys", "README.md"),
	program = program,
	head = head,
	xfer = head,
	restrict = True,
	username = user,
	server = server,
	server_username = server_user)

if __name__ == "__main__":
	app.main()

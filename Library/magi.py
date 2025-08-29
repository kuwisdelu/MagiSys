import os
from badwulf.cli import clmanager
from badwulf import tools

program = "magi"

nodes = {
	"01": "Magi-01",
	"02": "Magi-02",
	"03": "Magi-03"}

prefix = os.getenv("MAGI_PREFIX")
if prefix is None:
	sys.exit(f"{program}: $MAGI_PREFIX is not set")

app = clmanager("Magi",
	nodes = nodes,
	date = "2025-08-28",
	description = "Magi cluster @ NEU",
	readme = os.path.join(prefix, "MagiSys", "README.md"),
	program = program)

if tools.is_known_host(nodes.values()):
	app.username = os.getlogin()
	app.server = None
	app.server_username = None
else:
	app.username = os.getenv("MAGI_USER", default="viteklab")
	app.server = "login.khoury.northeastern.edu"
	app.server_username = os.getenv("MAGI_LOGIN")

if __name__ == "__main__":
	app.main()

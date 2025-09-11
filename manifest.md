# Magi cluster

Maintainer: Kylie Ariel Bemis <k.bemis@northeastern.edu>

Revised: 10 September 2025

## Nodes

- Magi-01
	+ Head node
	+ M2 Ultra Mac Studio
	+ 16 p-cores / 8 e-cores
	+ 192 GB unified memory
	+ 8 TB storage
	+ WGK6THH9JR
	+ a4:fc:14:15:95:cb

- Magi-02
	+ Compute node
	+ M2 Ultra Mac Studio
	+ 16 p-cores / 8 e-cores
	+ 192 GB unified memory
	+ 4 TB storage
	+ RCNQ99YFVK
	+ a4:fc:14:18:4b:83

## Storage

- MagiSysCache
	+ RAID0 SSD array
	+ 16 TB cache storage

- Dogma
	+ RAID10 HDD array
	+ 24 TB archival storage

## Software

- Available on Magi compute nodes

- Cluster management tools
	+ magi
	+ magidb

- Developer tools
	+ git
	+ brew
	+ clang
	+ conda

- X11
	+ XQuartz
	+ https://www.xquartz.org

- LaTeX and pandoc
	+ MacTeX
	+ https://tug.org/mactex/
	+ https://pandoc.org

all:
	g++ -O2 -std=c++11 solver.cpp -o solver

clean:
	(rm -rf a.out solver data/domains.csv data/results.csv data/all.db)

run:
	./aggregate data/list.csv data/domains.csv data/all.db
	./solver data/domains.csv data/results.csv

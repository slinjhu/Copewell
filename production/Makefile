all:
	g++ -O2 -std=c++11 solver.cpp -o solver

clean:
	(rm -rf a.out solver dataout/*.csv)

run:
	make clean
	make
	./aggregate data/list.csv dataout
	./solver dataout/domains.csv dataout/results.csv
	python extract.py
	open map/index.html

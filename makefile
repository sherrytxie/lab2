all: lab2 tests

lab2: lab2.ml
	ocamlbuild -pkg unix lab2.byte

lab2_tests: lab2_tests.ml
	ocamlbuild -pkg unix lab2_tests.byte	

tests: lab2_tests
	./lab2_tests.byte

clean:
	rm -rf _build *.byte

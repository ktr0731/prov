package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"sort"
	"strings"

	yaml "gopkg.in/yaml.v2"
)

var (
	b = flag.Bool("brew", false, "passed packages are brew package")
	c = flag.Bool("cask", false, "passed packages are cask package")
)

type Brew struct {
	Brew []string `yaml:"brew"`
	Cask []string `yaml:"cask"`
}

func main() {
	flag.Parse()

	if !*b && !*c {
		log.Fatal("please set -brew or -cask flag")
	}

	f, err := os.Open(flag.Arg(0))
	checkErr(err)

	var brew Brew
	bytes, err := ioutil.ReadAll(f)
	checkErr(err)
	f.Close()

	err = yaml.Unmarshal(bytes, &brew)
	checkErr(err)

	if flag.NArg() < 2 {
		switch {
		case *b:
			showBrew(&brew)
			fallthrough
		case *c:
			showCask(&brew)
		}
	} else {
		switch {
		case *b:
			brew.Brew = append(brew.Brew, flag.Args()[1:]...)
			sortSlice(brew.Brew)
			brew.Brew = toUnique(brew.Brew)
		case *c:
			brew.Cask = append(brew.Cask, flag.Args()[1:]...)
			sortSlice(brew.Cask)
			brew.Cask = toUnique(brew.Cask)
		}
		out, err := yaml.Marshal(&brew)
		checkErr(err)

		f, err := os.Create(flag.Arg(0))
		checkErr(err)
		defer f.Close()

		_, err = f.Write(out)
		checkErr(err)
	}
}

func showBrew(brew *Brew) {
	fmt.Println(strings.Join(brew.Brew, "\n"))
}

func showCask(brew *Brew) {
	fmt.Println(strings.Join(brew.Cask, "\n"))
}

func sortSlice(s []string) {
	sort.StringSlice(s).Sort()
}

func toUnique(s []string) []string {
	res := make([]string, 0, len(s))
	encountered := map[string]bool{}
	for i := 0; i < len(s); i++ {
		if encountered[s[i]] {
			continue
		}
		encountered[s[i]] = true
		res = append(res, s[i])
	}
	return res
}

func checkErr(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

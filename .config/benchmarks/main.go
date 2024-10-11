package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"regexp"

	"github.com/bitfield/script"
	"github.com/jaypipes/ghw"
	"github.com/jaypipes/ghw/pkg/baseboard"
	"github.com/jaypipes/ghw/pkg/chassis"
)

var battery bool
var debug bool
var benchmarkPath string
var rx = regexp.MustCompile(`[\s+,.]`)

func main() {

	ucd, err := os.UserConfigDir()
	if err != nil {
		log.Fatal("Diretório de configuração do usuário não pode ser determinado ", err.Error())
	}
	flag.BoolVar(&battery, "battery", false, "Testa a duração da bateria")
	flag.BoolVar(&debug, "debug", false, "Mostra logs de debug")
	flag.StringVar(&benchmarkPath, "benchmarkDir", filepath.Join(ucd, "benchmarks"), "diretório onde logs de performance são gravados")

	err = os.Setenv("GHW_DISABLE_WARNINGS", "1")
	if err != nil {
		fmt.Println("erro setando variavel GHW_DISABLE_WARNINGS")
		os.Exit(1)
	}

	benchmarkDir := rx.ReplaceAllString(getPath(), "")
	if benchmarkDir != "" {
		os.MkdirAll(benchmarkDir, os.ModePerm)
	}

	outputDir := filepath.Join(benchmarkPath, benchmarkDir)

	cpu, err := ghw.CPU()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("cores %d threads %d\n", cpu.TotalCores, cpu.TotalThreads)

	cpuSingleThread := runSysbench(1, "cpu")
	cpuSingleThreadFile := filepath.Join(outputDir, "cpu_single_thread.txt")
	script.Echo(cpuSingleThread).WriteFile(cpuSingleThreadFile)
	script.Echo(cpuSingleThread).Match("events per second").Stdout()

	cpuTotalThreads := runSysbench(int(cpu.TotalCores), "cpu")
	cpuTotalThreadsFile := filepath.Join(outputDir, "cpu_multi_thread.txt")
	script.Echo(cpuTotalThreads).WriteFile(cpuTotalThreadsFile)
	script.Echo(cpuTotalThreads).Match("events per second").Stdout()

	memory := runSysbench(int(cpu.TotalCores), "memory")
	memoryFile := filepath.Join(outputDir, "memory.txt")
	script.Echo(memory).WriteFile(memoryFile)
	fmt.Print("    ")
	script.Echo(memory).Match("transferred").Stdout()
}


func runSysbench(nuTh int, testMode string) string {
	p, _ := script.Exec(fmt.Sprintf("sysbench  --threads=%d %s run", nuTh, testMode)).String()
	return p
}

func getPath() string {
	chassisInfo, err := ghw.Chassis()
	if err != nil {
		log.Fatal(err)
		return ""
	}
	cpu, err := ghw.CPU()
	if err != nil {
		log.Fatal(err)
		return ""
	}

	baseboardInfo, err := ghw.Baseboard()

	prefix := getType(chassisInfo)
	base := getVendor(chassisInfo, baseboardInfo)
	suffix := getSuffix(chassisInfo, baseboardInfo)

	if debug {
		fmt.Printf("N Cores / N threads %d / %d, \n", cpu.TotalCores, cpu.TotalThreads)
		fmt.Println("chassisInfo.SerialNumber", chassisInfo.SerialNumber)
		fmt.Println("chassisInfo.Type", chassisInfo.Type)
		fmt.Println("chassisInfo.TypeDescription", chassisInfo.TypeDescription)
		fmt.Println("chassisInfo.Vendor", chassisInfo.Vendor)
		fmt.Println("chassisInfo.Version", chassisInfo.Version)

		fmt.Println("baseboarfd.Product", baseboardInfo.Product)
		fmt.Println("baseboarfd.SerialNumber", baseboardInfo.SerialNumber)
		fmt.Println("baseboarfd.Vendor", baseboardInfo.Vendor)
		fmt.Println("baseboarfd.Version", baseboardInfo.Version)
	}

	return fmt.Sprintf("%s_%s_%s", prefix, base, suffix)
}

func getSuffix(chassis *chassis.Info, bb *baseboard.Info) string {
	var r string
	if r = checkAttr(chassis.Version); r != "" {
		return r
	}
	if r = checkAttr(bb.Product); r != "" {
		return r
	}

	return r
}

func getVendor(chassis *chassis.Info, bb *baseboard.Info) string {
	var r string
	if r = checkAttr(chassis.Vendor); r != "" {
		return r
	}
	if r = checkAttr(bb.Vendor); r != "" {
		return r
	}

	return r
}

func getType(chassis *chassis.Info) string {
	var r string
	if r = checkAttr(chassis.TypeDescription); r != "" {
		return r
	}
	return ""
}

func checkAttr(name string) string {
	if name == "Default" {
		return ""
	}
	if name == "string" {
		return ""
	}
	if name == "Default string" {
		return ""
	}
	return name
}

type info struct {
	summary string
	desc    string
}

#!/usr/bin/env python
import cpuinfo
import subprocess
import psutil, re, os

def cpu_info():
    info = cpuinfo.get_cpu_info()  
     
    return info['brand_raw'].replace(' ', '_'), psutil.cpu_count(logical=False), psutil.cpu_count(logical=True)


    
def run_sysbench(nu_th, test_mode):
    try:
        result = subprocess.run(['sysbench', f'--threads={nu_th}', test_mode, 'run' ], stdout=subprocess.PIPE, text=True)
        return result
    except Exception as e:
        print(f'Erro: {e}')
        return None
        
def cpu_benchmark():
    cpu_name, cores, threads = cpu_info()
    t1 = run_sysbench(1, 'cpu')
    t2 = run_sysbench(cores, 'cpu')
    t3 = run_sysbench(threads, 'cpu')
    t4 = run_sysbench(threads, 'memory')
    write_test(cpu_name, t1, "cpu_single_thread")
    write_test(cpu_name, t2, "cpu_n_cores")
    write_test(cpu_name, t3, "cpu_n_threads")
    write_test(cpu_name, t4, "memory")


def write_test(cpu_name, t, tname):
    try:
        os.makedirs(cpu_name, exist_ok=True)
        with open(os.path.join(cpu_name, tname+'.txt'), 'w') as f:
            f.write(t.stdout)
    except Exception as e:
        print(f'Erro ao gravar testes: {cpu_name} {e} ')
        return        
    


if __name__ == '__main__':
    cpu_benchmark()

#!/usr/bin/env -S v run

import os

fn split_lines(content string) [][]string {
	mut lines := [][]string{}
	for line in content.split('\n') {
		trimed_line := line.trim_space()
		if trimed_line.len > 0 {
			lines << trimed_line.fields()
		}
	}
	return lines
}

fn main() {
	println('pipupdate v0.0.2 by Zhuo Nengwen at 2022-06-03')
	println('Outdated packages checking...')

	pips := os.execute('pip list --outdated')
	if pips.exit_code == 0 {
		fields := split_lines(pips.output)
		for item in fields {
			if item.len == 4 {
				match item[3] {
					'sdist', 'wheel' {
						package := item[0]
						if package != 'crit' {
							println('\n$package updating...')
							os.system('pip install -U $package')
						}
					}
					else {}
				}
			}
		}
	}

	println('\nPackage requirements checking...')
	checkes := os.execute('pip check')
	if checkes.exit_code == 1 {
		fields := split_lines(checkes.output)
		for item in fields {
			if item.len > 0 {
				package := item[0]
				println('\n$package restoring...')
				os.system('pip install -U $package')
			}
		}
	}
}

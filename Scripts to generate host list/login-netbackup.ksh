#!/usr/bin/expect

spawn ssh tranp@142.148.9.175
expect "password"
send "Tpytp3k6!\r"
interact
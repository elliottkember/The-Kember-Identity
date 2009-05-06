package require Tcl 8.5
package require md5 2


set digits {0 1 2 3 4 5 6 7 8 9 A B C D E F}

# any init will do
set hx [::md5::md5 -hex {}]

while 1 {
    set hy [::md5::md5 -hex $hx]
    if {$hx eq $hy} break
    # bernoulli-like shift with random last hex
    set idx [expr {int(floor(16*rand()))}]
    set hx [string range $hx 1 end][lindex $digits $idx]
}

puts "Found it! It is '$hx'"

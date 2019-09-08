#! /bin/bash
.
# Copyright (C) 2019  Hëck Lawert

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

clear

function runVMs {
	{
	echo 0
	virsh start Master
	sleep 0.25
	echo 25
	virsh start Infra
        sleep 0.25
	echo 50
	virsh start Node1
        sleep 0.25
	echo 75
	virsh start Node2
        sleep 0.25
	echo 100
        }| whiptail --gauge "Iniciando VMs ..." 6 60 0
}

function shutVMs {
        {
        echo 0
        virsh shutdown Master --mode acpi > /dev/null 2>&1
        sleep 0.25
	echo 25
        virsh shutdown Infra --mode acpi > /dev/null 2>&1
        sleep 0.25
	echo 50
        virsh shutdown Node1 --mode acpi > /dev/null 2>&1
        sleep 0.25
	echo 75
        virsh shutdown Node2 --mode acpi > /dev/null 2>&1
        sleep 0.25
	echo 100
        } | whiptail --gauge "Apagando VMs ..." 6 60 0
}

function checkVMs {
	{
    		for ((i = 0 ; i <= 100 ; i+=5)); do
        		sleep 0.1
        		echo $i
    		done
	} | whiptail --gauge "Comprobando VMs..." 6 50 0
	p=$(virsh list)
}

while [ 1 ]
do
CHOICE=$(
whiptail --title "Kemicalshift-Manager-KVM" --menu "Make your choice" 16 100 9 \
	"1)" "Iniciar VMs."   \
	"2)" "Apagar VMs."  \
	"3)" "Ver VMs iniciadas." \
	"4)" "Salir"  3>&2 2>&1 1>&3	
)

case $CHOICE in
	"1)")   
		runVMs
		p=$(virsh list)
		y=20
		x=78
		result="Se han iniciado las siguientes máquinas:\n\n$p"
	;;
	"2)")   
		shutVMs
		y=8
		x=78
		result="Se han apagado todas las VMs"
	;;

	"3)")   
	        checkVMs
		y=20
		x=78
		result="$p"
        ;;

	"4)") exit   
        ;;

esac
whiptail --title "Kemicalshift-Manager-KVM" --msgbox "$result" "$y" "$x" 
done
exit

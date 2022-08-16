###################################################
#     Darrollador: Joel Giannini                  #
#     Verificar archivos de port-in/ port-out     #
#     Parametros: int o qa                        #
###################################################

#Declaracion de variables
h=`date "+%H" `
m=`date "+%M" `
s=`date "+%S" `
dia=`date "+%d" `
mes=`date "+%m" `
anio=`date "+%Y" ` 
archivo_salida="importacionPortedOver_"$anio$mes$dia"_000.txt"
USER=epapdev
PASS=eagle1
SERVER=10.32.6.208
PUERTO=22
USER1=x300744
PASS1=W$2p_ax1
SERVER1=10.75.65.66
SERVER2=10.75.65.67
PUERTO=22


##############
#Funcion menu#
##############
menu(){
while :
do
clear
# MENU#

echo "   _ \               |       _)                /       _ \          |   "
echo "  |   |  _ \    __|  __|      |  __ \         /       |   |  |   |  __| "
echo "  ___/  (   |  |     |        |  |   |       /        |   |  |   |  |   "
echo " _|    \___/  _|    \__|     _| _|  _|     _/        \___/  \__,_| \__| "
echo "by Joel giannini"

echo "--------------------------------------------------"
echo " * * * * * * * * * opciones * * * * * * * * * * "
echo "--------------------------------------------------"
echo "[1] Verificar archivos de port-in/ port-out "
echo "[2] ingresar lineas al BDO"
echo "[3] Contingencia diaria Reversiones de Portin"
echo "[4] Cambiar prestadora"
echo "[5] Reiniciar portnumappprod1" 
echo "[6] Reiciciar portnumappprod2"
echo "[7] Ingresar Documentacion al ABD"
echo "[8] Salir"
echo "--------------------------------------------------"

echo "Elegi una opcion [1-8]:"
read yourch
while [ $yourch -lt 1 ] || [ $yourch -gt 8 ]
do
echo "opcion erronea, ingresar numero de opcion entre [1-8]"
read yourch
done

case $yourch in
1) Verificar_lineas_port_in_port_out ;;
2) Ingreso_linea_bscs ;;
3) cont_reversion_portin ;;
4) cambiar_prestador ;;
5) Reiniciar_pornumappprod1 ;;
6) Reiniciar_pornumappprod2 ;;
7) Ingresar_doc_bdo ;;
8) echo "Hasta la vista baby!!!" ; echo "" ; echo "" ; exit 0 ;;
esac
done
}



#############################################
# Funcion Verificar_lineas_port_in_port_out #
#############################################

Verificar_lineas_port_in_port_out(){
clear
echo "--------------------------------------------------"
echo "  Analisis de archivos "
echo "--------------------------------------------------"


cd /opt/app/provision

echo '----------------------------------------------------------------'
echo 'se va a verificar el archivo 'resportedALIMP_$anio$mes$dia*.txt
echo '----------------------------------------------------------------'

echo | awk '/ERR/{print $0}' resportedALIMP_$anio$mes$dia*.txt

echo '----------------------------------------------------------------'
echo 'se va a verificar el archivo 'resportedALIMN_$anio$mes$dia*.txt
echo '----------------------------------------------------------------'

echo | awk '/NOK/{print}' resportedALIMN_$anio$mes$dia*.txt

echo '----------------------------------------------------------------'
echo 'se va a verificar el archivo ' resportedALEXS_$anio$mes$dia*.txt
echo '----------------------------------------------------------------'


echo | awk '/ERR/{print $0}' resportedALEXS_$anio$mes$dia*.txt

echo '----------------------------------------------------------------'
echo 'se va a verificar el archivo ' resportedALEXB_$anio$mes$dia*.txt
echo '----------------------------------------------------------------'


echo | awk '/ERR/{print $0}' resportedALEXB_$anio$mes$dia*.txt

echo '----------------------------------------------------------------'
echo 'se va a verificar el archivo ' resportedRVEX_$anio$mes$dia*.txt
echo '----------------------------------------------------------------'

echo | awk '/ERR/{print $0}' resportedRVEX_$anio$mes$dia*.txt


echo '----------------------------------------------------------------'
echo 'se va a verificar el archivo ' resportedRVIM_$anio$mes$dia*.txt
echo '----------------------------------------------------------------'

echo | awk '/ERR/{print $0}' resportedRVIM_$anio$mes$dia*.txt


echo '----------------------------------------------------------------'
echo 'se va a verificar el archivo ' resportedBJEX_$anio$mes$dia*.txt
echo '----------------------------------------------------------------'

echo | awk '/ERR/{print $0}' resportedBJEX_$anio$mes$dia*.txt




Pausa
}

#######
#Pausa#
#######
Pausa ()
{
echo "Presione una tecla para volver al menu principal"
read
rest=$?
if [ "$rest" -eq 0 ];
then
menu
fi
}

Ingreso_linea_bscs(){
clear
echo "Ingresar lineas a los archivos del BDO elija una opcion:"

echo "##########################################################" 
echo "#    Port-Out                    Port-in                 #"
echo "# 1) = Suspencion           4) = Portin con lineas EP    #"
echo "# 2) = Baja                 5) = Portin sin lineas EP    #"
echo "# 3) = Reversion            6) = Reversion Port-Int      #"
echo "#                                                        #"
echo "#           7) = Volver al munu Principal                #"
echo "##########################################################" 

echo "Ingrese una opcion entre [1-7]"
read selec

while [ $selec -lt 1 ] || [ $selec -gt 7 ]
do
echo "opciórronea, ingresar numero de opcion entre  [1-7]:"
read selec
done

case $selec in
1) susp;;
2) baja;;
3) reversion;;
4) canum;;
5) lineas_sin_exp_per;;
6) reversion_portin;;
7) menu;;
esac
}

susp ()
{
cd /opt/app/provision
archivo=`ls -ltr portedALEXS_* | tail -1 | awk '{print $9}'`
fin="s"
cp $archivo /home/x300742/bin
echo "Se copio el archivo "$archivo" Como copia de seguridad"
echo "a la ruta /home/x300742/bin"
	while [ $fin = "s" ]
		do
		echo "ingrese una linea:"
		read linea
		aux=`grep $linea $archivo |awk -F"|" '{ print $4 }' | uniq`
		sinarch=`grep $linea portedALEXS_* | tail -1`	
			if [ "$sinarch" = "" ];
				then
				echo "La linea $linea no se puede agregar al archivo porque nunca fue enviada anteriormente en ningun archivo portedALEXS"
				echo "En caso de necesitar agregarla, hacerlo de forma manual."
				
				echo "Desea agregar otra linea? s/n"
				read fin
					while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
					done
			
			elif [ "$linea" = "$aux" ];
				then
				echo "la linea $linea no se puede agregar al archivo porque ya existe"
				echo "Desea agregar otra linea? s/n"
				read fin
					while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
					done
			else

				grep $linea portedALEXS_* | awk '{NR=1};{print}' | awk -F":" '{ print $2}' | awk -F"|" '{ print $1 "|" $2 "|" $3 "|" $4 "|" $5 "|" $6 "|" $7 "|" $8 "|" $9 "|"$10"|" $11}' | uniq >> $archivo
				
				echo "Desea agregar otra linea? s/n"
				read fin
				while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
				done
			fi
	done

cd
	
clear
Ingreso_linea_bscs
}

baja ()
{
cd /opt/app/provision
archivo=`ls -ltr portedALEXB_* | tail -1 | awk '{print $9}'`
fin="s"
cp $archivo /home/x300742/bin
echo "Se copio el archivo "$archivo" Como copia de seguridad"
echo "a la ruta /home/x300742/bin"
	while [ $fin = "s" ]
		do
		echo "ingrese una linea:"
		read linea
		aux=`grep $linea $archivo | awk -F"|" '{ print $4 }' | uniq`
		sinarch=`grep $linea portedALEXB_* | tail -1`	
			if [ "$sinarch" = "" ];
				then
				echo "La linea $linea no se puede agregar al archivo porque nunca fue enviada anteriormente en ningun archivo portedALEXS"
				echo "En caso de necesitar agregarla, hacerlo de forma manual."
				
				echo "Desea agregar otra linea? s/n"
				read fin
					while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
					done
			
			elif [ "$linea" = "$aux" ];
				then
				echo "la linea $linea no se puede agregar al archivo porque ya existe"
				echo "Desea agregar otra linea? s/n"
				read fin
					while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
					done
			else

				grep $linea portedALEXB_* | awk '{NR=1};{print}' | awk -F":" '{ print $2}' | awk -F"|" '{ print $1 "|" $2 "|" $3 "|" $4 "|" $5 "|" $6 "|" $7 "|" $8 "|" $9 "|"$10"|" $11}' | uniq >> $archivo
				
				echo "Desea agregar otra linea? s/n"
				read fin
				while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
				done
			fi
	done

cd
	
clear
Ingreso_linea_bscs
}


reversion ()
{
cd /opt/app/provision
archivo=`ls -ltr portedRVEX* | tail -1 | awk '{print $9}'`
fin="s"
cp $archivo /home/x300742/bin
echo "Se copio el archivo "$archivo" Como copia de seguridad"
echo "a la ruta /home/x300742/bin"
	while [ $fin = "s" ]
		do
		echo "ingrese una linea:"
		read linea
		aux=`grep $linea $archivo | awk -F"|" '{ print $4 }' | uniq`
		sinarch=`grep $linea portedRVEX* | tail -1`	
			if [ "$sinarch" = "" ];
				then
				echo "La linea $linea no se puede agregar al archivo porque nunca fue enviada anteriormente en ningun archivo portedALEXS"
				echo "En caso de necesitar agregarla, hacerlo de forma manual."
				
				echo "Desea agregar otra linea? s/n"
				read fin
					while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
					done
			
			elif [ "$linea" = "$aux" ];
				then
				echo "la linea $linea no se puede agregar al archivo porque ya existe"
				echo "Desea agregar otra linea? s/n"
				read fin
					while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
					done
			else

				grep $linea portedRVEX_* | awk '{NR=1};{print}' | awk -F":" '{ print $2}' | awk -F"|" '{ print $1 "|" $2 "|" $3 "|" $4 "|" $5 "|" $6 "|" $7 "|" $8 "|" $9 "|"$10"|" $11}' | uniq >> $archivo
				
				echo "Desea agregar otra linea? s/n"
				read fin
				while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
				done
			fi
	done

cd
	
clear
Ingreso_linea_bscs
}

canum ()
{
cd /opt/app/provision
archivo=`ls -ltr portedALIMP_* | tail -1 | awk '{print $9}'`
archivo2=`ls -ltr portedALIMN_* | tail -1 | awk '{print $9}'`
fin="s"
cp $archivo /home/x300742/bin
echo "Se copio el archivo "$archivo" Como copia de seguridad"
echo "a la ruta /home/x300742/bin"
	while [ $fin = "s" ]
		do
		echo "ingrese una linea:"
		read linea
		aux=`grep $linea $archivo | awk -F"|" '{ print $4 }' | tail -1`
		aux2=`grep $linea $archivo2 | awk -F"|" '{ print $4 }' | tail -1`
		sinarch=`grep $linea portedALIMP* | tail -1`	
		sinarch2=`grep $linea portedALIMN* | tail -1`
		lnea=`ls -ltr | grep $linea portedALIMP_* | awk '{NR=1};{print}' | awk -F":" '{ print $2}' | tail -1`
		numlnea=`ls -ltr | grep -n $linea portedALIMN_* | awk '{NR=1};{print}' | awk -F":" '{ print $2}' | tail -1`
			if [ "$sinarch" = "" ] && [ "$sinarch2" = "" ];
				then
				echo "La linea $linea no se puede agregar al archivo porque nunca fue enviada anteriormente en ningun archivo "
				echo "En caso de necesitar agregarla, hacerlo de forma manual."
				
				echo "Desea agregar otra linea? s/n"
				read fin
					while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
					done
			
			elif [ "$linea" = "$aux" ] && [ "$linea" != "$aux2" ];
				then
				echo "ingrese linea EP" 
				read lineaep
				b=`grep $linea portedALIMP_* | awk '{NR=1};{print}' | awk -F":" '{ print $2}' | awk -F"|" '{ print $11 }' | uniq | tail -1`
				a=`grep  $linea  portedALIMP_* | awk '{NR=1};{print}' | awk -F":" '{ print $2}' | awk -F"|" '{ print $1 "|" $2 "|" $3 "|" $4 "|" $5 "|" $6 "|" $7 "|" $8 "|" $9 }' | uniq | tail -1`
				reemplazo=$a"|"$lineaep"|"$b
				sed -i "s/${lnea}/${reemplazo}/" $archivo
				echo "La linea $linea ya se encontraba en el archivo portedALIMP del dia de hoy."
				echo "se reemplazo la linea:"
				echo "$lnea"
				echo "por la linea"
				echo "$reemplazo"
				echo "Desea agregar otra linea? s/n"
				read fin
					while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
					done
			
			elif [ "$linea" = "$aux2" ] && [ "$linea" != "$aux" ];
				then
				echo "ingrese linea EP" 
				read lineaep
				b=`grep $linea portedALIMN* | awk '{NR=1};{print}' | awk -F":" '{ print $2}' | awk -F"|" '{ print $11 }' | uniq | tail -1`
				a=`grep $linea portedALIMN* | awk '{NR=1};{print}' | awk -F":" '{ print $2}' | awk -F"|" '{ print $1 "|" $2 "|NP|" $4 "|" $5 "|" $6 "|" $7 "|" $8 "|" $9 }' | uniq | tail -1`
				agregada=$a"|"$lineaep"|"$b
				echo "$agregada" >> $archivo
				sed -i "${numlnea}d" $archivo2
				echo "La linea se encontraba en el archivo $archivo2"
				echo "Esta se borro del mismo y se inserto en el archivo $archivo"
				echo "Desea agregar otra linea? s/n"
				read fin
					while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
					done
			else

				b=`grep $linea portedALIM* | awk '{NR=1};{print}' | awk -F":" '{ print $2}' | awk -F"|" '{ print $11 }' | tail -1`
				a=`grep $linea portedALIM* | awk '{NR=1};{print}' | awk -F":" '{ print $2}' | awk -F"|" '{ print $1 "|" $2 "|NP|" $4 "|" $5 "|" $6 "|" $7 "|" $8 "|" $9 }' | tail -1`
				echo "ingrese linea EP" 
				read lineaep
				echo $a"|"$lineaep"|"$b >> $archivo
				echo "se agrego la linea en el archivo $archivo"
				echo "Desea agregar otra linea? s/n"
				read fin
				while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
				done
			fi
	done
}

lineas_sin_exp_per ()
{
cd /opt/app/provision
archivo=`ls -ltr portedALIMN_* | tail -1 | awk '{print $9}'`
fin="s"
cp $archivo /home/x300742/bin
echo "Se copio el archivo "$archivo" Como copia de seguridad"
echo "a la ruta /home/x300742/bin"
	while [ $fin = "s" ]
		do
		echo "ingrese una linea:"
		read linea
		aux=`grep $linea $archivo | awk -F"|" '{ print $4 }' | uniq`
		sinarch=`grep $linea portedALIMN_* | tail -1`	
			if [ "$sinarch" = "" ];
				then
				echo "La linea $linea no se puede agregar al archivo porque nunca fue enviada anteriormente en ningun archivo portedALEXS"
				echo "En caso de necesitar agregarla, hacerlo de forma manual."
				
				echo "Desea agregar otra linea? s/n"
				read fin
					while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
					done
			
			elif [ "$linea" = "$aux" ];
				then
				echo "la linea $linea no se puede agregar al archivo porque ya existe"
				echo "Desea agregar otra linea? s/n"
				read fin
					while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
					done
			else

				grep $linea portedALIMN_* | awk '{NR=1};{print}' | awk -F":" '{ print $2}' | awk -F"|" '{ print $1 "|" $2 "|" $3 "|" $4 "|" $5 "|" $6 "|" $7 "|" $8 "|" $9 "|"$10"|" $11}' | uniq >> $archivo
				
				echo "Desea agregar otra linea? s/n"
				read fin
				while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
				done
			fi
	done

cd
	
clear
Ingreso_linea_bscs
}


reversion_portin ()
{
cd /opt/app/provision
archivo=`ls -ltr portedALIMN_* | tail -1 | awk '{print $9}'`
fin="s"
cp $archivo /home/x300742/bin
echo "Se copio el archivo "$archivo" Como copia de seguridad"
echo "a la ruta /home/x300742/bin"
	while [ $fin = "s" ]
		do
		echo "ingrese una linea:"
		read linea
		aux=`grep $linea $archivo | awk -F"|" '{ print $4 }' | uniq`
		sinarch=`grep $linea portedRVIM_* | tail -1`	
			if [ "$sinarch" = "" ];
				then
				echo "La linea $linea no se puede agregar al archivo porque nunca fue enviada anteriormente en ningun archivo portedALEXS"
				echo "En caso de necesitar agregarla, hacerlo de forma manual."
				
				echo "Desea agregar otra linea? s/n"
				read fin
					while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
					done
			
			elif [ "$linea" = "$aux" ];
				then
				echo "la linea $linea no se puede agregar al archivo porque ya existe"
				echo "Desea agregar otra linea? s/n"
				read fin
					while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
					done
			else

				grep $linea portedRVIM_* | awk '{NR=1};{print}' | awk -F":" '{ print $2}' | awk -F"|" '{ print $1 "|" $2 "|" $3 "|" $4 "|" $5 "|" $6 "|" $7 "|" $8 "|" $9 "|"$10"|" $11}' | uniq >> $archivo
				
				echo "Desea agregar otra linea? s/n"
				read fin
				while [ "$fin" != "s" ] && [ "$fin" != "n" ]
					do
					echo "Valor incorrecto ingrese s/n"
					read  fin
				done
			fi
	done

cd
	
clear
Ingreso_linea_bscs
}

cont_reversion_portin ()
{
cd /opt/app/provision
archivo=`ls -ltr portedRVIM_$anio$mes$dia*proc | awk '{print $9}'`
cat $archivo | awk -F"|" '{ print "dlt_sub (dn 54"$4") ent_sub (dn 54"$4", rn "$5", tp 2)" }'

cp $archivo /home/x300742/bin
cd /home/x300742/bin

cat $archivo | awk -F"|" '{ print "dlt_sub (dn 54"$4") ent_sub (dn 54"$4", rn "$5", tp 2)" }' > $archivo_salida
rest=$?
if [ "$rest" -eq 0 ];
then
echo "se genero el archivo correctamente"
else
echo "el archivo no se genero correctamente"
fi

lftp -u ${USER},${PASS} sftp://${SERVER} << CMD
set xfer:clobber on
cd /var/TKLC/epap/free/pdbi_import
put $archivo_salida $archivo_salida
bye
CMD

rm $archivo
Pausa
}

cambiar_prestador ()
{
clear
rm $archivo_salida
fin="s"
while [ $fin = "s" ]
	do
	echo "ingrese la linea"
	read lineaRVIN
	echo "############################################"
	echo "# PRESTADORAS                              #"
	echo "#                                          #"
	echo "# Claro = 5555            Personal = 5777  #"
	echo "# Movistar = 5666         Nexte = 5888     #"
	echo "############################################"
	echo "ingrese prestadora (el valor a ingresar debe ser numerico como se puede apreciar en el cuadro de arriba )"
	read prestadora

echo -e  "dlt_sub (dn 54"$lineaRVIN") \n ent_sub (dn 54"$lineaRVIN", rn "$prestadora", pt 2)"  >> $archivo_salida
	echo "Desea agregar otra linea? s/n"
	read fin

		while [ "$fin" != "s" ] && [ "$fin" != "n" ]
			do
			echo "Valor incorrecto ingrese s/n"
			read  fin
		done
clear
done

rest=$?
if [ "$rest" -eq 0 ];
then
echo "se genero el archivo correctamente"
else
echo "el archivo no se genero correctamente"
fi

lftp -u ${USER},${PASS} sftp://${SERVER} << CMD
set xfer:clobber on
cd /var/TKLC/epap/free/pdbi_import
put $archivo_salida $archivo_salida
bye
CMD


Pausa
}

Reiniciar_pornumappprod1 ()
{
clear


ssh x300744@10.75.65.66 "/etc/init.d/sco restart"
exit

Pausa
}

Reiniciar_pornumappprod2 ()
{
clear


ssh x300744@10.75.65.67 "/etc/init.d/sco restart"
exit

Pausa
}

Ingresar_doc_bdo(){
clear
echo "Para ingresar los archivos al BDO elija una opcion:"

echo "##########################################################"
echo "#                   MENU:                                #"
echo "#        1) = Portin           2) = Reversion            #"
echo "#           3) = Volver al munu Principal                #"
echo "##########################################################"

echo "Ingrese una opcion entre [1-7]"
read selec

while [ $selec -lt 1 ] || [ $selec -gt 7 ]
do
echo "opciórronea, ingresar numero de opcion entre  [1-7]:"
read selec
done

case $selec in
1) insertar_doc;;
2) insertar_doc_rev;;
3) menu;;
esac
}



insertar_doc  ()
{
clear
fin="s"
ftp_site=10.245.83.254
username=joel
passwd=1234
ftp_site2=10.75.65.67
ftp_site3=10.75.65.66
username2=x300742
username3=x300743
passwd2='W$2p_ax1'
cd /opt/app/capture
while [ $fin = "s" ]
        do
        echo "ingrese tramite"
        read tramite
		

ftp -inv <<EOF
open $ftp_site
user $username $passwd


get $tramite"_Portin.pdf"
get $tramite"_Documento.pdf"
get $tramite"_Poder.pdf"
get $tramite"_Portin.jpg"
get $tramite"_Documento.jpg"
get $tramite"_Poder.jpg"


close
bye
EOF



lftp -u ${username2},${passwd2} sftp://${ftp_site2} << CMD
set xfer:clobber on
cd /opt/app/capture
put $tramite"_Poder.pdf"
put $tramite"_Documento.pdf"
put $tramite"_Portin.pdf"
put $tramite"_Poder.jpg"
put $tramite"_Documento.jpg"
put $tramite"_Portin.jpg"
bye
CMD









echo $tramite >> tramites.txt
        echo "Desea agregar otro tramite? s/n"
        read fin

                while [ "$fin" != "s" ] && [ "$fin" != "n" ]
                        do
                        echo "Valor incorrecto ingrese s/n"
                        read  fin
                done


clear
done

lftp -u ${username3},${passwd2} sftp://${ftp_site3} << CMD
set xfer:clobber on
put tramites.txt
bye
CMD
pwd
rm tramites.txt
ssh x300743@10.75.65.66 "sh uploadDocBDO.sh"
}

insertar_doc_rev  ()
{
clear
fin="s"
ftp_site=10.245.83.254
username=joel
passwd=1234
ftp_site2=10.75.65.67
ftp_site3=10.75.65.66
username2=x300742
username3=x300743
passwd2='W$2p_ax1'
cd /opt/app/capture
while [ $fin = "s" ]
        do
        echo "ingrese tramite"
        read tramite
		

ftp -inv <<EOF
open $ftp_site
user $username $passwd


get $tramite"_Reversion.pdf"
get $tramite"_Documento.pdf"
get $tramite"_DDJJ.pdf"
get $tramite"_Reversion.jpg"
get $tramite"_Documento.jpg"
get $tramite"_DDJJ.jpg"


close
bye
EOF



lftp -u ${username2},${passwd2} sftp://${ftp_site2} << CMD
set xfer:clobber on
cd /opt/app/capture
put $tramite"_Reversion.pdf"
put $tramite"_Documento.pdf"
put $tramite"_DDJJ.pdf"
put $tramite"_Reversion.jpg"
put $tramite"_Documento.jpg"
put $tramite"_DDJJ.jpg"
bye
CMD









echo $tramite >> pdfs.txt
        echo "Desea agregar otro tramite? s/n"
        read fin

                while [ "$fin" != "s" ] && [ "$fin" != "n" ]
                        do
                        echo "Valor incorrecto ingrese s/n"
                        read  fin
                done


clear
done

lftp -u ${username3},${passwd2} sftp://${ftp_site3} << CMD
set xfer:clobber on
put pdfs.txt
bye
CMD
pwd
rm pdfs.txt
ssh x300743@10.75.65.66 "sh subeRVEX.sh"
}
menu

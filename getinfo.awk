#!/usr/bin/awk -f

function wipe_paras()
{
device_name=""
fru_number=""
location_code=""
wwn_number=""
ccid_number=""
mem_size=""
}

function baseinfo_print()
{
	printf("%s,%s,%s,",host_name,type_model,machine_sn)
}

{

while (1)
{

	starthere=0

#####################################################
#   fcs                                             #
#####################################################

	wipe_paras()
	if ($0 ~ /^  fcs.*Adapter/) 
	{
		device_name=$1
		starthere=1
		while (getline)
		{
                        if ($0 ~ /FRU/) fru_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Network Address/) wwn_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Customer Card ID Number/) ccid_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Hardware Location Code/) location_code=substr($0,37,length($0)-36)
			if ($0 ~ /^  [a-zA-Z]/) break 
#			else print
		}
		baseinfo_print()
		print "HBA" "," device_name "," fru_number "," location_code "," wwn_number "," ccid_number

	}

#####################################################
#   ent                                             #
#####################################################

	wipe_paras()
	if ($0 ~ /^  ent.*Adapter/) 
	{
		device_name=$1
		starthere=1	
		while (getline)
		{
                        if ($0 ~ /FRU/) fru_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Network Address/) wwn_number=substr($0,37,length($0)-36)
#                        if ($0 ~ /Customer Card ID Number/) ccid_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Hardware Location Code/) location_code=substr($0,37,length($0)-36)
			if ($0 ~ /^  [a-zA-Z]/) break
#			else print

		}
		baseinfo_print()
		print "Ethernet" "," device_name "," fru_number "," location_code "," wwn_number "," ccid_number
	}

#####################################################
#   mem                                             #
#####################################################

        wipe_paras()
        if (tolower($0) ~ /memory dimm/)
        {
                starthere=1
                while (getline)
                {
                        if ($0 ~ /FRU/) fru_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Size/) mem_size=substr($0,37,length($0)-36)
                        if ($0 ~ /Customer Card ID Number/) ccid_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Hardware Location Code/) location_code=substr($0,37,length($0)-36)
                        if ($0 ~ /^$/) break
#                       else print
                }
                baseinfo_print()
                print "Memory" "," device_name "," fru_number "," location_code "," mem_size "," ccid_number

        }

#####################################################
#   cpu						    #
#####################################################

        wipe_paras()
        if ($0 ~ /PROC/)
        {
                starthere=1
                while (getline)
                {
                        if ($0 ~ /FRU/) fru_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Customer Card ID Number/) ccid_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Hardware Location Code/) location_code=substr($0,37,length($0)-36)
                        if ($0 ~ /^$/) break
#                       else print
                }
                baseinfo_print()
                print "CPU" "," device_name "," fru_number "," location_code "," "," ccid_number

        }

#####################################################
#   backplane					    #
#####################################################

        wipe_paras()
        if ($0 ~ /SYSTEM BACKPLANE/)
        {
                starthere=1
                while (getline)
                {
                        if ($0 ~ /FRU/) fru_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Customer Card ID Number/) ccid_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Hardware Location Code/) location_code=substr($0,37,length($0)-36)
                        if ($0 ~ /^$/) break
#                       else print
                }
                baseinfo_print()
                print "backplane" "," device_name "," fru_number "," location_code "," "," ccid_number
	}

#####################################################
#   Power Supply				    #
#####################################################

        wipe_paras()
        if ($0 ~ /IBM AC PS/)
        {
                starthere=1
                while (getline)
                {
                        if ($0 ~ /FRU/) fru_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Customer Card ID Number/) ccid_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Hardware Location Code/) location_code=substr($0,37,length($0)-36)
                        if ($0 ~ /^$/) break
#                       else print
                }
                baseinfo_print()
                print "backplane" "," device_name "," fru_number "," location_code "," "," ccid_number
	}


#####################################################
#   end						    #
#####################################################

#####################################################
#   7311-D20                                    #
#####################################################

        wipe_paras()
        if ($0 ~ /Reliance/)
        {
                starthere=1
                while (getline)
                {
                        if ($0 ~ /Hardware Location Code/) location_code=substr($0,37,length($0)-36)
                        if ($0 ~ /^$/) break
#                       else print
                }
                baseinfo_print()
                print "7311" "," location_code
        }


#####################################################
#   end                                             #
#####################################################

	if (starthere == 0) {if(getline) {} else break}
}
}

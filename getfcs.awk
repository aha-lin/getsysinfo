#!/usr/bin/awk -f

{
print "machine_type,machine_model,machine_sn,device_type,device_name,fru_number,location_code,wwn_number,ccid_number"
getline
while (1)
{
#####################################################
#   fcs                                             #
#####################################################

	starthere=0
	if ($0 ~ /^  fcs.*Adapter/) 
	{
		device_name=$1
		starthere=0	
		while (getline)
		{
			if ($0 ~ /FRU/) fru_number=substr($0,37,length($0)-36)
			if ($0 ~ /Network Address/) wwn_number=substr($0,37,length($0)-36)
			if ($0 ~ /Customer Card ID Number/) ccid_number=substr($0,37,length($0)-36)
			if ($0 ~ /Hardware Location Code/) location_code=substr($0,37,length($0)-36)
			if ($0 ~ /^  [a-zA-Z]/) { starthere=1;break } 

		}
		print machine_type "," machine_model "," machine_sn "," "HBA" "," device_name "," fru_number "," location_code "," wwn_number "," ccid_number
	}
	else 
	{
		if (starthere==0)
		{
	   	if (getline) {} else break
		}
	}
#####################################################
#   ent                                             #
#####################################################
        starthere=0
        if ($0 ~ /^  ent.*Adapter/)
        {
		print $0
                device_name=$1
                starthere=0
		while (getline)
                {
                        if ($0 ~ /FRU/) fru_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Network Address/) wwn_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Customer Card ID Number/) ccid_number=substr($0,37,length($0)-36)
                        if ($0 ~ /Hardware Location Code/) location_code=substr($0,37,length($0)-36)
                        if ($0 ~ /^  [a-zA-Z]/) { starthere=1;break }

                }
                print machine_type "," machine_model "," machine_sn "," "HBA" "," device_name "," fru_number "," location_code "," wwn_number "," ccid_number

        }
        else
        {
                if (starthere==0)
                {
                if (getline) {} else break
                }
        }


}
}

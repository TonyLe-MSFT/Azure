#Example Use keyvault to create the password as a secret and retrieve it. Protects you from storing plaintext passwords in scripts
#Use the command "az keyvault create --name "Nameofkeyvault" --resource-group "nameofResourceGroup" --location eastus

kv=demovaulttl
secret=vmrootkey2
pass="`az keyvault secret show --name $secret --vault-name $kv --query value --output tsv`"

#Set the name of the user you wish to ADD or CHANGE (will ADD if not available)

user=demoadmin
# pass="s0mep@ssw0rd"

#Set name of file that has the list of HOSTS and RESOURCEGROUP (space separate) i.e.
# vmname1 resourcegroup1

file=~/hostlist.txt

while IFS=' ' read -r f1 f2
do 
	host=$f1
	rg=$f2
	echo "Attempting to update passwd for $host in Resource Group $rg"
	
	az vm user update --resource-group $rg --name $host --username $user --password "${pass}"

	# Optional below to delete the enablevmaccess extension after running
	# az vm extension delete -g $rg --vm-name $host -n enablevmaccess

done < hostlist.txt

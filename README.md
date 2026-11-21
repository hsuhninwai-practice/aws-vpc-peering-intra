# aws-vpc-peering-intra

**************************************
        Account preparing
**************************************

# mkdir -p ~/.aws
# nano ~/.aws/credentials

Check your account credentials and let it be two accounts for frontend and backend.

And, check the accounts using this command.
# aws sts get-caller-identity --profile frontend-network-acc
# aws sts get-caller-identity --profile backend-network-acc

**************************************
       Running Flow
**************************************

1. Create the following workspace in HCL terraform(CLI version) 
   fe-network-ws
   fe-security-ws
   fe-compute-ws
   be-network-ws
   be-security-ws
   be-compute-ws
   vpc-peering-intra-region-ws

2. Run on fe-network-ws
# cd fe-network-ws
# terraform init
# terraform plan
# terraform apply
!! Check the ouput from HCL fe-network-ws workspace

3. Run on fe-security-ws
# cd fe-security-ws
# terraform init
# terraform plan
# terraform apply
!! Check the ouput from HCL fe-security-ws workspace

4. Run on fe-compute-ws
# cd fe-compute-ws
# terraform init
# terraform plan
# terraform apply
!! Check the ouput from HCL fe-compute-ws workspace

5. Run on be-network-ws
# cd be-network-ws
# terraform init
# terraform plan
# terraform apply
!! Check the ouput from HCL be-network-ws workspace

6. Run on be-security-ws
# cd be-security-ws
# terraform init
# terraform plan
# terraform apply
!! Check the ouput from HCL be-security-ws workspace

7. Run on be-compute-ws
# cd be-compute-ws
# terraform init
# terraform plan
# terraform apply
!! Check the ouput from HCL be-compute-ws workspace

8. Run on vpc-peering-intra-region-ws
# cd vpc-peering-intra-region-ws
# terraform init
# terraform plan
# terraform apply
!! Check the ouput from HCL vpc-peering-intra-region-ws workspace

## Complete the instances create!

**************************************
        Testing from backend
**************************************

# cd be-compute-ws

# aws ec2 describe-instances --region ap-southeast-1 --profile backend-network-acc \
  --query "Reservations[].Instances[?State.Name!='terminated'].[InstanceId, Tags[?Key=='Name']|[0].Value, KeyName, PrivateIpAddress, PublicIpAddress, State.Name]" \
  --output table --no-cli-pager

# terraform state pull | jq -r '.resources[] | select(.type=="tls_private_key") | .instances[0].attributes.private_key_openssh' > ~/.ssh/be-key.pem

# chmod 600 ~/.ssh/be-key.pem

# ssh-keygen -y -f ~/.ssh/be-key.pem

# ls -l ~/.ssh/be-key.pem

# ssh-add ~/.ssh/be-key.pem

# ssh-add -l

# ssh -J ubuntu@<be_bastion_ip>,ubuntu@<be_private_intance01_ip> ubuntu@<be_private_intance02_ip>

# ping -c 4 <fe_private_instance02_ip>

# ssh -J ubuntu@<be_bastion_ip>,ubuntu@<be_private_intance01_ip> ubuntu@<be_private_intance03_ip>

# ping -c 4 <fe_private_instance03_ip>

**************************************
        Testing from frontend
**************************************

# cd fe-compute-ws

# aws ec2 describe-instances --region ap-southeast-1 --profile frontend-network-acc \
  --query "Reservations[].Instances[?State.Name!='terminated'].[InstanceId, Tags[?Key=='Name']|[0].Value, KeyName, PrivateIpAddress, PublicIpAddress, State.Name]" \
  --output table --no-cli-pager

# terraform state pull | jq -r '.resources[] | select(.type=="tls_private_key") | .instances[0].attributes.private_key_openssh' > ~/.ssh/fe-key.pem

# chmod 600 ~/.ssh/fe-key.pem

# ssh-keygen -y -f ~/.ssh/fe-key.pem

# ls -l ~/.ssh/fe-key.pem

# ssh-add ~/.ssh/fe-key.pem

# ssh-add -l

# ssh -J ubuntu@<fe_bastion_ip>,ubuntu@<fe_private_intance01_ip> ubuntu@<fe_private_intance02_ip>

# ping -c 4 <be_private_instance02_ip>

# ssh -J ubuntu@<fe_bastion_ip>,ubuntu@<fe_private_intance01_ip> ubuntu@<fe_private_intance03_ip>

# ping -c 4 <be_private_instance03_ip>
# installing sops
curl -LO https://github.com/getsops/sops/releases/download/v3.8.1/sops-v3.8.1.linux.amd64
sudo mv sops-v3.8.1.linux.amd64 /usr/local/bin/sops
chmod +x /usr/local/bin/sops

# installing age
curl -LO https://github.com/FiloSottile/age/releases/download/v1.1.1/age-v1.1.1-linux-amd64.tar.gz
tar -xzf age-v1.1.1-linux-amd64.tar.gz
sudo mv age/age /usr/local/bin
sudo mv age/age-keygen /usr/local/bin

# clean up
rm -r ./age
rm age-v1.1.1-linux-amd64.tar.gz

chmod +x deploy_encrypted_secrets.sh encrypt_secrets.sh

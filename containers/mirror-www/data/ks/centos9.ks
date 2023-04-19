url  --noverifyssl --url='http://10.0.0.21/iso/CentOS-Stream-9-20230410.0-x86_64-dvd1/BaseOS/'

#graphical
skipx
text
reboot

keyboard --xlayouts='us'
lang en_US.UTF-8
firstboot --disable
timezone --utc America/New_York

auth --passalgo=sha512 --useshadow
selinux --enforcing
firewall --enabled --service=ssh

%addon com_redhat_kdump --disable
%end

ignoredisk --only-use=nvme0n1
autopart
clearpart --none --initlabel

# change crypted pw with: `openssl passwd -6`
rootpw --iscrypted '$6$yM7SWujaKpBi1cU1$y3UFyvmXnNocHSwGxmehV3dvtUJ6dyPgcpZ8kfLf4TRvFMr8GI02VTAzngRW5UFdySTMo7iIDu2zHvovbFoSC1'
#rootpw homelab123

%post
install -o root -g root -m 0750 -d /root/.ssh/
install -o root -g root -m 0640 <(curl -sfL https://github.com/jasonsfuller.keys) /root/.ssh/authorized_keys 
%end

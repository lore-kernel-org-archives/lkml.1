Return-Path: <linux-kernel-owner+w=401wt.eu-S1764232AbZDCLiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764232AbZDCLiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763389AbZDCLig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:38:36 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:7591 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761888AbZDCLid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:38:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=XMayDvfPqsVK2vk3FqztxN2WiEiJbTL169t6bixhKc+Oy1GpA+vlUWWFVtgDQ7/Lwb
         QtO/QSKlw7csNYnRo330F3BCVSKqrtUMymbvnhZFNIbfxWWbtv8J0su8JLEbt6UFwGUd
         +i13Df+HfI6OmrCRo+GqOaBsvSHoF0Md+tglI=
Message-ID: <49D5F532.9020507@gmail.com>
Date: Fri, 03 Apr 2009 13:38:26 +0200
From: Till Kamppeter <till.kamppeter@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Google Summer of Code 2009: Student applies to create a Better IPTables
 Management Tool
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

at the Linux Foundation we got the application shown below.

The student wants to create a better IPTables management tool. I do not 
know whether the kernel developers are really the best people to mentor 
him, but I have also no idea who else could mentor him and whether he 
should p[erhaps post the same application at another org and if yes, 
where. I appreciate your help very much.

The student did not include his e-mail address in the application. To
contact him directly you need to apply as a mentor on
http://socghop.appspot.com/ (this does not oblige you to actually mentor
a student) and select the Linux Foundation (organization link ID: LF) as 
the mentoring organization. If you do so, you can still be a mentor or 
admin at other orgs in parallel but not apply as a student any more. 
Note that student application deadline is TODAY, Friday, April 3, noon 
PDT or 7pm UTC, so contact him well before that date if you want to 
recommend him to apply at an additional org.

    Till

-------------------------------------------------------------------------

Title:  	 Proposal For Better IPTables Management Tool
Student: 	ashish sinha
Mentor: 	No mentor assigned
Possible Mentors: 	None
Abstract:
It focuses on helping the user to perceive what a specific chains of 
rules in a specific table does to a usr's pkt. It helps the user to 
modify the chains according to his wish . the first req. could be 
fulfilled with incorporation of RuleCheckingEngine into the tool. The 
second would require us to chk for the contradictory /already existing 
rules. There's an attempt to make the tool intelligent through 
autogeneration of speclzed rules.
Content:




·         I am Ashish Sinha , currently pursuing graduation course 
(Bachelor in Infrmation Technology) from Indian Institute Of Information 
Technology, Allahabad,India. most of the coding is done on the linux 
platform.However the linux distros keep changing.Currently I am using 
Backtrack Linux 4.0 . As far as the hardware is concerned , its based 
upon Intel x86 architecture T2250 @ 1.73Ghz whith 1 Gb physical memory.I 
have been coding  in C/C++ since  my high school days . In my graduation 
years, I have gained an expertise over Java 2. Most of the coding is 
done in  Java becauses of its ease of use and portability features. As 
fas as java projects are concerned ,   I have successfully made an 
Online Examination Tool for my university which helps in faculties in 
uploading the test paper and its time and date . The registered student 
are sent the notifications automatically and the exam takes place on the 
agreed date and time with questions soretd in random order foe each 
login.Me along with my teammates have been successful in making a Cross 
Lingual Information retrieval Engine . It helps the user to query and 
search in different languages. One of my career milestones ,is the 
graphics project in C++  using OpenGL API . It has been recommended for 
a copyright. Right now, the application for the same has been filed.  I 
have successfully subscribed to the mailing list with my email id: 
imsinha@gmail.com.

I have been following  GCC open source projects during my graduation. 
One of my projects was  about enhancing the GCC compiler to detect the 
vulnerabilities in a C Code through static source code analysis .It 
mainly concentrates upon the Taint Analysis and Value Range propagation 
algorithms to detect the vulnerable use of some dubious functions in C 
like strcpy(), strcat(), memcpy() ,malloc(),calloc(),realloc() etc.   My 
tool would be able to detect errors like arithmetic overflow, stack 
overflow , heap overflow and out of bounds access in an array. I am 
taking the SSA Tree Web generated by the compiler as the input and then 
applying the Patterson’s Value Propagation and Taint Analysis Algorithms.
I had also worked as a  project coordinator for  “ Application Design 
Tool  “ which is soon to be released as an open-source for further 
development .Its a university project from software-engineering 
helpdesk. This tools aims to capture the software engineering process 
which a designer follows while making his apps . It helps in maintaining 
the documentation of the project through version controls and also 
detects the changes which have been made to the source when compiled , 
so that it could be supported by the appropriate documentation. This 
habbit of maintaining documentation would help the new developers to 
track the progress and reverse engineer it more quickly. I intend to 
develop a tool for BetterIp table management . The tool focuses on 
helping the user to perceive what a particular chains of rules in a 
particular table does to a user specified packet. Moreover it should 
help the user to modify the chains according to the needs to of user.
I have been managing the networking related activities of my college 
since three years. Being system administrator for such a long amount of 
time , it implicitly enriches me with  an experience of working on 
variety of Linux distros ranging from Fedora 3-10 , Red Hat Linux 
Enterprise , SUSE , Centos , Backtrack Linux , Ubuntu and etc.  So 
working on Linux operating system  isn’t  a problem as far as I am 
concerned . Its my system administration knowledge and experience which 
provides me with an edge over others . I have been greatly involved in 
configuration and maintenance  of the firewalls , web servers running on 
Apache , the database in LDAP and the Squid Web proxy . As the project 
aims for better IPtables management tool , I can contribute with my hard 
earned 3 years experience  in maintenance of firewalls . For example , 
my tool will offer certain additional  security options to the user to 
guard against activities like  IP spoofing in which an attacker can 
pretend to  have a private IP , thus trying to infiltrate  into the 
network and following the DROP policy as default.Another  valuable 
suggestion would be to help users to troubleshoot the common problems 
associated with iptables like helping the users in troubleshooting with 
the installation of  iptables , enabling the forwarding (/bin/echo "1" > 
/proc/sys/net/ipv4/ip_forward). By giving these  additional guidance and 
solutions to the common problems faced during iptables configuration , 
the user would needn’t be looking on the internet for every miniscule 
problems and hence making the tool intelligent enough to cater to these 
problems.  There are hundreds of people around the world who have the 
knowledge regarding the iptables but it’s the experience of the 
developers in firewalling which would be helping in making a successful 
and intelligent  tool .The project is unique in itself as there are no 
such tools right now available which help the users in managing the 
iptables with "minimum redundancy". Hence , it s an effort to improve 
the management of the iptables through the develpopment of an 
intelligent tool which has some kind of power of autogeneration of rules 
depending upon the user's internal IP range , special services like Web 
server which are running . If the info is provided to the tool , then it 
will automatically generate the rules regarding DNAT prerouting reqd for 
Webserver requests arriving from external network and also helps us in 
negating IP spoofing.

Proposal for development of Tool for Better IPtables management

The tool focuses on helping the user to perceive what a particular 
chains of rules in a particular table does to a user specified packet. 
Moreover it should help the user to modify the chains according to the 
needs to of user.  Hence the overall tool use cases are directly 
identified as:

1  .)   User perceives what a particular chain does to the packet 
specified with the details like protocol , source ip , destination ip , 
Ethernet it’s arriving upon . The tools helps the user to either select 
all the rules in the chain or some particular rules and tells the impact 
of the application of selected rules upon the incoming/outgoing packet . 
The response of the tool could be in terms of whether the packet was 
ACCEPTED, DROP, REJECTED or forwarded to some other chain.

2   . )  The user specifies the packet with relevant details and asks 
the tool to                                  modify the particular chain 
to accept/drop/reject these kinds of packets. User has the flexibility 
of specifying the range of source ip’s and range of destination ip’s 
while providing the details of the packet.

In order to simplify the working of this tool, we can decide upon the 
various attributes which a rule could have .They are mainly reflected 
with the number of switches which are possible to be applied in a rule. 
For example the set of attributes of a rule are :

Attribute                                                        Switch

Table 
  -t ,

Chain                                                          -A INPUT

Rule Id                                                        -A => 
CurrentRuleID++

SourceIP                                                     -s

  DestinationIP                                             -d

  InputInterface                                            -i

  OutputInterface                                          -o

InputPort                                                    -sport

OutputPort                                                 -dport

Protocol                                                      -p (TCP/ICMP)

State 
                                                   -m state - - 
state(ESTABLISHED /NEW/RELATED)

Target                                                         -j 
(ACCEPT/DROP/REJECT)

Hence an abstract class CRule would have the above listed attributes as 
their

component data members and some pure virtual methods (get() and set()) 
to help user modify the attributes. It should be noted that user needn’t 
specify each and every attribute of the  rule but the mandatory ones 
like table, chain ,target .Hence a validity of a user specified rule 
could be checked by ensuring that the mandatory attributes are duly 
supplied by the user. This way the tool helps user to make rules . Now 
the question comes regarding the storage of these rules in a way so that 
the information may be efficiently retrieved while rule checking. If all 
the rule sets are stored at one place , then we have to check across 
rules belonging  to different tables , thus decreasing our efficiency.

The class hierarchy could be given as :
 
     Table
 
___________|___________________
                                                       | 
             |                            |
 
Mangle                      Filter                            NAT

 
________________________|_______________

 
                  |                            | 
       |
 
           Input                      Output                     Forward

                                         ________________|__________

                                        |                       | 
         |
                                                      Rule1 
    Rule2          Rule n

The top of the hierarchy there should be an abstract CTable Class .The 
three subsequent subclasses would implement the CTables  class in their 
own way . Each of the tables would have different set of rules 
corresponding to each chain present in the table . For example , the 
Filter Table  would have 3 sets of rules for Input ,Forward  and Output 
Chain respectively. Each set comprises of number of rules which are 
merely instances of CRule Class described above. This kind of class 
hierarchy would help us to check the rules belonging to a particular 
chain and particular Table  only. We need not deal with other rules 
residing in other chains.

The first usecase  requirements could be met by having RuleChecking 
Engine incorporated into the tool. The user selects some rules in a 
particular chain discussed above or the entire chain and specifies the 
sample packet’s details such as source ip , destination ip, interface , 
Protocol. Then it’s left to the job of RuleChecking Engine to match the 
attributes of  each and every rule selected by the user to the 
attributes of the sample packet provided by the user , If it matches 
then the Engine should display the target attribute . If it doesn’t get 
matched , then  it depends upon the default policy followed by the 
chain.  The packet is Accepted/Drop in accordance with the default 
policy of the chain. As from security point of view , normally drop 
should be followed as a Default Policy specially to negate the 
IPspoofing kind of attacks. In order to make the rule matching 
efficient, the engine should switch over to next rule as soon as an 
attribute in the rule doesn’t match with their corresponding details 
supplied in the sample packet. There is no need of matching all the 
attributes of the rules.



Implementation of the Second Usecase :

The second usecase helps user modify the chains according to his own 
needs .In order to identify the possible cases where the packet could be 
filtered out , we need to have a look at the whole course of chains 
though which the intended packet has to go through. The passage followed 
could be broken in series of steps:

1 . Mangle Table Prerouting chains

2 . NAT Table Prerouting

3. If the data is intended for firewall ,

then go though Mangle Table INPUT chain àfilter table Input Chain àLocal 
Processing àmangle Table Output Chain à filter Table Output Chain

Else it needs to be forwarded then it passes through

àmangleTable forward Chain à Filter Table forward Chain .

3. Then it passes though Mangle Table PostroutingChain à NAT postrouting



These are the possible paths which a packet can traverse after arriving 
at the firewall.

There are four cases possible :

1.    Existence of some contradictory rules which work against the 
wishes of user .

For example : if one of our rules is

iptables -A INPUT  -i eth0 -j ACCEPT



while the user wants that  packets arriving at eth0 and having ip 
172.16.1.1/24 should be rejected.





2.    Existence of matching rules which work in accordance with user’s 
wishes but the attributes defined in the particular rule are the subset 
of the attributes provided in the sample packet .

For example: iptables –A input –I eth0 –j REJECT

Attributes are( input, eth0, reject)

User’s wish is to packets arriving at eth0 and having ip 172.16.1.1/24 
should be rejected.

Attributes  are (input,eth0,sourceip,reject)





3.    No rules  found whose all attributes match with those of sample 
packet provided .

4.    Rule found whose attributes match with all the sample packet’s 
attribute



Case 1:

  In order to modify the existing rules , we need to have a knowledge 
about those rules in the chain which may be prohibiting  the flow of 
packet through the firewall, where user wants the specified packet to 
pass through the firewall. It also certainly possible that user can ask 
to modify rules such that the certain type of packet doesn’t pass 
through the firewall, hence in this case we need to look for points in 
the different chains  where the packet may be ACCEPTED by a certain rule.



For example: if one of our rules is

iptables -A INPUT  -i eth0 -j ACCEPT



while the user wants that  packets arriving at eth0 and having ip 
172.16.1.1/24 should be rejected.

The corresponding rule would be :

Iptables –A INPUT –I eth0 –s 172.16.1.1/24  –j REJECT



Even though this rule is being appended in the INPUT chain , it would 
not help because the RULE 1 when checked makes the packet ACCEPTED. 
Hence we need to look forward to these set of conflicting rules.

In order to accomplish the task of finding the set of conflicting rule 
sets , we revert back to our RuleChecking Engine .The sample packets 
with relevant attributes had already been supplied by the user. Now the 
Rule Checking engine would be responsible for checking every rule in the 
chain and verifying that whether the attributes of the concerned rule 
match with the attributes specified in the sample packet , if yes then 
is the decision taken by the rule is in contradiction with the user’s 
wish. If it is so, then the user should be prompted to reconsider its 
decision as it violates a previously existing rule set. The prompt is 
necessary because it may happen that user may not be aware of the 
previous rules in the iptables. Hence in the above example, a prompt 
regarding violation of already existing contradictory rule “iptables -A 
INPUT  -i eth0 -j ACCEPT” would be generated to user and the final 
decision would be dependent upon the user’s wish.

If the answer is NO , then its probably belongs to Case 2.

Case 2:

This  basically refers to the case when the user wish is already been 
taken care of by a less specific rule mentioned in the set . Hence no 
need to add a new rule . It’s already performing the same job. This is 
an example of a case where we had checked for redundancy of the existing 
rules. If a new rule would have been added , the job would have been 
done in the same fashion but redundancy of the rules would be present in 
the iptables.



Case 3:

If there are no rules whose all attributes match with those of sample 
packet provided , then we have to simply add the rule corresponding to 
the user wishes. In the previous example:

Iptables –A INPUT –I eth0 –s 172.16.1.1/24  –j REJECT

This rule is simple added into the INPUT chain of Filter Table.



Case 4:

If a rule whose attributes are matching with the attributes of the 
sample packet and there exist no such attribute in the sample packet 
whose counterpart isn’t present in the particular rule , then this means 
the rule regarding the user’s wish has been already added into the 
IPtable. Hence no need to add an extra new rule which is just a replica 
of an existing rule.



This is precisely the algorithm which we I wish to implement .I have 
already provided the implementation details of the proposal. My 
experience would help this tool to be more usable from the users point 
of view  as I intend to take an idea of the user’s network as an input 
from the user . This idea of user’s network would cover details like the 
private IP addresses and their subnet mask  and special services running 
on the internal network such as Web server .This information would help 
tool in following ways:

1.)  It helps to generate the rules regarding the NAT Tables 
automatically since the any HTTP request arriving from an external 
network with port 80 would be then requiring DNAT prerouting where the 
destination address of the packet would be changed to the ip address of 
the web server . Note that the ip address information has been collected 
already before. Hence the tool would help on autogeneration of rules 
depending upon the user’s internal network. Some kind of Metaprogramming 
stuff.



2.) It also helps me in negating IP spoofing . Suppose the user 
specifies the internal ip address as 172.16.1.1/255.255.255.0 . Now if 
any request from the source ip lying in the range 172.16.1.1/255.255.0.0 
  and arriving at the Ethernet connected to the external world would 
require the firewall to drop such packets .

Hence the tool would automatically generate a rule to be added into the 
Forward chain of Filter table

Iptables –A Forward –s 172.16.1.1/24  -I eth0 –j DROP



3.) DNS uses tcp for zone transfers, we might this need of rule sets on 
certains systems







//incoming DNS replies

iptables -A INPUT -i eth1 -p udp -s 172.16.1.5 --sport 53 -m state 
--state ESTABLISHED -j ACCEPT

iptables -A INPUT -i eth1 -p udp –s 172.16.1.6 --sport 53 -m state 
--state ESTABLISHED -j ACCEPT



//outgoing DNS requests

iptables -A OUTPUT –o eth1 -p udp -d 172.16.1.5 --dport 53 -m state 
--state NEW,ESTABLISHED -j ACCEPT

iptables -A OUTPUT -o eth1 -p udp -d 172.16.1.6 --dport 53 -m state 
--state NEW,ESTABLISHED -j ACCEPT



where 172.16.1.5 and 172.16.1.6 are the two name servers.



Eth1 are the Ethernet interfaces .



4 . Allowing FTP outband



iptables -A INPUT  -i eth1 -p tcp --sport 21 -m state --state 
ESTABLISHED -j ACCEPT

iptables -A OUTPUT -o eth1 -p tcp --dport 21 -m state --state 
NEW,ESTABLISHED -j ACCEPT



5.  Allowing SMTP outband

iptables -A INPUT  -I eth1  -p tcp --sport 25 -m state --state 
ESTABLISHED -j ACCEPT

iptables -A OUTPUT -o eth1 -p tcp --dport 25 -m state --state 
NEW,ESTABLISHED -j ACCEPT

All these kind of rules would be autogenerated after taking the idea of 
the internal network from the user .

The rough timeline for project could be stated as:

April 20-May 23 . Refining my designs with the help of mentor.

May23- July 5. Ensuring the usecase 1 is implemented.

July 5-July25. Ensuring the  second usecase is  implemented.

July25-August 10 – Testing of the code with the help of developers.

I intend to develop it on Java platform using the Swing Library.At the 
current period ,I can devote an hour or so . But when the summer 
holidays begin , then I can fulfill the promise of spending 40 hrs per 
week to the project.


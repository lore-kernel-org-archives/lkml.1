Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbZDAHxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbZDAHxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 03:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbZDAHxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 03:53:31 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59252 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbZDAHxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 03:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=roQQm50MkUNSb7N4Y26sqrEnsnnmECVg2AUJzMZvLbv+JH9C0CdMcByyE7xeWpSA9E
         QMJgVsPBo9ImUJ//zaegResnh/T2UlZ/HADOqc0yu2WiBQ0tLosePfxxA6+GEkjPmErO
         OTW4a7E+gTEcD74rrWseeJqvnhuMsLYePT5GM=
Message-ID: <49D31D73.8000301@gmail.com>
Date: Wed, 01 Apr 2009 09:53:23 +0200
From: Till Kamppeter <till.kamppeter@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Google Summer of Code 2009: Student applies to optimize netfilter
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

at the Linux Foundation we got the application shown below. For me it 
looks like a good application which should be considered and not fail 
due to lack of a suitable mentor.

The student wants to optimize netfilter, which is clearly a kernel 
project. So I need a kernel developer who does the mentoring of this 
student, preferably from the area of netfilter.

It would be also nice to know perhaps if he should better also apply at 
other mentoring organizations and at which once to find a mentor more 
easily.

The student did not include his e-mail address in the application. To 
contact him directly you need to apply as a mentor on 
http://socghop.appspot.com/ (this does not oblige you to actually mentor 
a student) and select the Linux Foundation (link ID: LF) as the 
mentoring organization. If you do so, you can still be a mentor or admin 
at other orgs in parallel but not apply as a student any more. Note that 
student application deadline is Friday, April 3, noon PDT or 7pm UTC, so 
contact him well before that date if you want to recommend him to apply 
at an additional org.

    Till

-------------------------------------------------------------------------

Title:  	 Optimized netfilter implementation
Student: 	Shreyas Bhatewara
Mentor: 	No mentor assigned
Possible Mentors: 	None
Abstract:
netfilter is used for packet filtering and mangling and thus is used to 
implement firewalls. Since every packet passing networking stack must be 
processed by netfilter it is extremely important to ensure that this 
code is not the bottleneck of the pipeline. This project will attempt to 
improve the packet classification in netfilter in order to improve its 
performance. The project will strive at understanding expensive 
operations in packet filtering and suggest optimized improvements for 
the same
Content:


     * Name  : Shreyas N Bhatewara
     * University / current enrollment  : University of Texas at Dallas
     * Short bio / overview of your background  :

I completed my bachelor in Computer Engineering from University of Pune. 
I got quite interested in Linux and kernel programming during my senior 
year project (Driver verifier and Fault injection test harness for 
Linux). After completion of bachelor degree I worked for a couple of 
years in area of networking, systems, Linux/Solaris kernel, Device 
driver development, C and C++. I got to work on many interesting 
projects during this time 
(http://utdallas.edu/~snb071000/profession.html). Most of the 
development was for clients of the company. I started my Masters in 
Computer Science in Fall 2007. I was an intern at VMware for 7 months in 
2008. I learned a lot their and enjoyed my work thoroughly.

     * Tell us your IRC nick with which you will use the group's IRC 
channel  : shreyasbforu
     * Your Coding Skills :

My coding skill set include the following:

Programming Languages: C, C++, Java, SQL(Oracle), COBOL, Lisp, ML, 
Prolog, VC++, HTML, DHTML, XML, ASP, PHP, J2EE

Scripting: shell script, awk, sed, javascript

Tools: Wireshark, Dtrace, SVN/CVS/Perforce systems, GNU make and system, 
iperf, netperf

Microprocessor arch.: i386, 8085, 8086, 80386, 8051 Micro controller.

Operating Systems: MS- DOS, Unix. Linux and Solaris – Kernel and user 
space programming.

Fields of Interests: Computer Networks, Distributed/Cluster Computing, 
Operating Systems, High performance computing and storage.



In your application let us know

     * What platform do you use to code? Hardware specifications and 
operating system :

I used to code in C, C++. For Intel architectures (32 and 64 bit). For 
Linux and Solaris OSs.

     * Did you ever code in C or C++/Perl/python/..., yes/no? what is 
your experience?

Yes I have coded in C/C++ for more than 8 years. (3 years 
professionally, others academically).

I have not coded much in Perl/python, I learned them once though.

     * If you apply for a project on our ideas list, have you experience 
in the areas listed under "Desired knowledge"?

Yes, I do have the desired knowledge (C, netfilter/iptables, Linux 
kernel, build system) for this project.

Set yourself up

     * Set up your platform to build a Bazaar/GIT/Subversion snapshot of 
the current state of the project you are interested in.
     * If you need help, ask on the mailing list of the appropriate 
group, or in the IRC.
     * Report success on the mailing list or IRC.

You and Us

     * Were you involved in development in the project's group in the 
past? What was your contribution?

No, I was not.

     * Were you involved in other OpenSource development projects in the 
past? which, when and in what role?

No, I was not. This will be my first time.

     * Why have you chosen your development idea and what do you expect 
from your implementation?

Performance optimization has always enticed me. I have spent a lot of 
time optimizing a Solaris NIC device driver which I had ported from 
Linux. I used Dtrace, lockstat and other tools for profiling. I did 
quite a good job at it. I have also taken courses related to synthesis, 
optimization and computer networking in my Masters program. I am hoping 
to apply some knowledge from those courses too.

Secondly I know much about Linux networking stack to have a comfort 
level for this project. I am confident that I will get upto speed and 
conclusively complete this project.

I need not even mention this but at the basic I expect from my 
implementation not to break anything which exists right now. I will test 
thoroughly to ensure so. Further I expect to find faster alternatives to 
current packet classification code. May be multiple filtering rules can 
be combined in some efficient way. I expect to improve the performance 
of net filters



Your Project

     * What do you want to achieve?

I expect to find faster alternatives to current packet classification 
code. May be multiple filtering rules can be combined in some efficient 
way. I expect to improve the performance of netfilters when multiple 
rules are applied at the same time. If there is some syntactic/semantic 
redundancy of operations being performed to apply these rules, I will 
try to eliminate it.

     * If you have chosen an idea from our list, why did you choose this 
specific idea?

Performance optimization has always enticed me. I have spent a lot of 
time optimizing a Solaris NIC device driver which I had ported from 
Linux. I used Dtrace, lockstat and other tools for profiling. I did 
quite a good job at it. I have also taken courses related to synthesis, 
optimization and computer networking in my Masters program. I am hoping 
to apply some knowledge from those courses too.

Secondly I know much about Linux networking stack to have a comfort 
level for this project. I am confident that I will get upto speed and 
conclusively complete this project.

     * What makes you suited to carry the project?

My past experience in working with similar projects, my educational 
background and my enthusiasm for the work at hand makes me a good 
candidate for this project. Although I do not know how exactly I can 
improve the netfilter performance as of now, I think I am in good 
position to understand and propose a solution to the problem during the 
project. I understand how open source communities work, and what role an 
individual developer plays. I also understand the high quality of code 
required to get into the code base.

     * How much time do you plan to invest in the project before, during 
and after the Summer of Code (We expect full time 40h/week during GSoC, 
but better make this explicit)?

I expect to invest 40 hours or more during the project. Even after the 
end of the project I will strive to be answerable to the suggested 
changes and if possible get the code into the main tree. I look forward 
to this project as an opportunity to start working for an open source 
community for a long term.

     * Please provide a schedule of how this time will be spent on 
subtasks of the project. While this is only preliminary, you will be 
required to provide a detailed plan latest at the beginning of GSoC and 
during the project you will issue weekly progress reports against that plan.

According to my knowledge the preliminary schedule will be as follows.

Week 1: Understanding the netfilter implementation thoroughly and 
getting acquainted with the code base and build system. Devote time to 
understand work done until now towards performance improvement and 
design decisions thus taken.

Week 2: Setup environment to measure performance and profile netfilter 
code, understand the metric involved, establish benchmarks.

Week 3-8 : Research alternatives for packet classification code. 
Implement them, profile the modified code. Conclude and again think for 
improvements.

Week 9 and 10: Testing and bugfixing. Send out a code review request 
(may be to the netfilter-devel list)

Week 11: Improvements & incorporating suggestions from code review. 
Start Documentation.

Week 12: Documenting and packaging deliverables.

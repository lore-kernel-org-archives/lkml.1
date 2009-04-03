Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbZDCRIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbZDCRIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbZDCRI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:08:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:55674 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbZDCRIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=gvLZRmFBsvN0FkVIPaoedQkBGXWpid3aUaEkoF8MyGZMWvRQ9XRlt25hYiRDZpi+MD
         0l/8zop1B9rycsi9Nclxk6baVFRQihm2nEtjrnRHDlmIOCKy2Q/Ej2EJKkt51GlQNa5p
         dwpWdzPbvLMx9xXIXDGxBBt3yi/x81zaZOdGo=
Message-ID: <49D64283.7030002@gmail.com>
Date: Fri, 03 Apr 2009 19:08:19 +0200
From: Till Kamppeter <till.kamppeter@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Google Summer of Code 2009: Student application
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

at the Linux Foundation we got the application shown below.

This looks like being best mentored by a kernel developer.

The student did not include his e-mail address in the application. To
contact him directly you need to apply as a mentor on
http://socghop.appspot.com/ (this does not oblige you to actually mentor
a student) and select the Linux Foundation (organization link ID: LF) as
the mentoring organization. If you do so, you can still be a mentor or
admin at other orgs in parallel but not apply as a student any more.

Note that student application deadline is TODAY, Friday, April 3, noon
PDT or 7pm UTC, so contact the student well before that date if you want 
to recommend him to apply at an additional org.

    Till

-------------------------------------------------------------------------

Title:  	IEC 68831-6 support for the new FireWire stack
Student: 	Mircea Gherzan
Mentor: 	No mentor assigned
Possible Mentors: 	None
Abstract:
IEC 68831-6 (AMDTP) is the standard for most (semi-) professional 
FireWire audio interfaces. Currently, support in Linux for such devices 
is provided by the FFADO daemon, which relies on libraw1394 library.

This project sets the goal of partly moving into the kernel (as a 
FireWire driver with an ALSA interface) what FFADO currently implements 
in userspace.

THe impact: huge! It will push Linux even further in becoming a top 
choice as a music recording and production platform!
Content:
About myself

I'm a final year student in Computer Science at the Techical University of
Bucharest, Romania (graduation: June 2009). Because of my results, I was 
invited
to work as an Undergraduate Teaching Assistant (UTA) in the CS department,
being part of the following teams:
* Operating Systems (Spring 2008, Spring 2009)
* Object Oriented Programming (Fall 2007, Fall 2008)
* Data Structures (Spring 2009)

I have completed the following internships:
* Vodafone Romania (Summer 2007) - UNIX scripting and development 
(CORBA, Oracle
   Call Interface)
* BitDefender (Summer 2008) - part of the Core Libraries team, I was 
doing C++
   coding and profiling for a high-performance web-server of internal use.

I am currently an intern at Ixia, part of the IxOS Linux team, doing kernel
programming (device drivers, networking, CryptoAPI).

I am looking forward to completing a M.Sc. Degree at the Techical 
University of
Dreden (Germany), for they have a very powerful group in Operating Systems.

I am present on the #ffado channel with the nickname mike85.
Coding skills and setup

I use Debian Sid since a couple of years. My development machine is a T500
ThinkPad with an Ricoh R5C832 FireWire controller. I could have access 
to some
other machines with other type of controllers, if need be.

I have a strong command of C, C++, Java and Linux system programming. I 
am also
familiar with kernel programming and some hardware aspects related to it 
(like
DMA, IO operations), for I am doing it now part of my internship and I 
have also
_practiced_ it at the university. I also have embedded programming 
skills, one
of my projects being a Bluetooth-controlled rover (AVR based) whose 
sources and
schematics now serve as learning material for younger students.

Apart from kernel/system programming, I am also familiar with various
technologies, like RMI, CORBA, RPC, RMI, OpenMP, MPI and with some scripting
languages (perl, python). I am comfortable with git (using it a lot at 
school)
and svn.

I therefore think I have the desired knowledge to complete the project.
Me and the FireWire community

My involvement in the Linux kernel community has been limited to testing and
submitting bug reports on the kernel bugzilla.

Two years ago I started an open source project: MoTorr, a J2ME based 
BitTorrent
client. The project is hosted on SourceForge.

I have chosen this this development idea because I wanted to do some 
FireWire
work as a SoC project. However, no FireWire related ideas were posted on the
Linux Foundation wiki, so I contacted Stefan Richter (a leading Linux 
firewire
developer) directly.

The Juju stack in the Linux kernel is quite new and there are a lot of 
TODOs.
Initially I wanted to provide an IPv4 implementation, but Stefan pointed
out some other areas that need work in the stack. One of them was 
implementing
the IEC 61883-6 standard (Audio and Music Data Transport Protocol), the one
being used by prosumer and professional grade FireWire audio interfaces.

I chose AMDTP because I am a music hobbyist and I would like to have the 
same
capabilities and perfomance on Liunx with my Casio digital piano as I 
used to
have once upon a time under Windows with ASIO.

A major factor in deciding for this specific project was the enthusiastic
feedback I got from the firewire and FFADO developers upon my initial 
inquiry.

Another important plus for selecting this project is the AMDTP driver 
for the
old FireWire stack, written by Kristian Høgsberg, that got removed in 
mainline
in 2.6.16: the code is quite well documented and will help a lot in the
design and development.

Also, the project poses some interesting challanges in terms of:
* latency and overall performance of the implentation
* interface design
* modularity
* code-sharing/integration with with the existing 61883 bits (firedtv 
driver)

I expect my project to meet the needs of audiophiles and users of (semi-)
professional audio equipment.

Thinking on the big picture, the project would be a great leap in 
consolidating
the position of Linux as a reliable and capable platform for audio 
recording and
production.
The project

It aims to produce a kernel module implementing IEC 61883-6 (AMDTP) with an
ALSA interface and an independent configuration interface.

The added value of the proposed approach over the current architecture
is significant:
* the ALSA interface brings immediate compatibility
* the overhead of the userpace API will dissapear
* the timing cam be improved and the impact of the sizing mismatch between
   firewire and audio buffers reduced.

I think I am suited to carry this project because
* I have some experience in kernel programming
* I know the basics of the concepts involved (streaming, MIDI, formats)
* my music production capability will directly benefit from the project.

Naturally, I am willing to invest at least 40h/week in the project 
during GSoC.
However, this number might increase, for I am aware of the problems 
arising in
kernel development and testing such code, but I am willing work as much as
required to keep up with the schedule and providy quality code.
A minor exception would be the first week, where I will probably assign only
30 hours: it is the last week of my intership at Ixia.

I see this project as my opportunity of becoming part of the kernel
community and therefore it is quite obvious that I  will continue to 
contribute
after the Summer of Code ends.

Some technical considerations:
* I will probably avoid the mess of ioctl()-style configuration
     * either a sysfs-based setup, OR
     * a new, custom fs implementation (amdtpfs)
* the streaming mechanism should be exposed via an interface
     * make it easy to add support for device that slightly deviate from IEC
     * however, in the GSoC I will only write an implementation for the IEC,
       as I do not have the required hardware
* streams to be supported:
     * raw PCM
     * IEC 958 (S/PDIF) / IEC 60958 (AES/EBU)
     * MIDI
Preliminary Schedule

A final schedule will be discussed on the firewire and FFADO lists upon
acceptance. During the development I will be active on the FFADO, 
firewire and
ALSA developer lists.

* Before May 23rd:
     * get more familiar with Juju, FFADO and ALSA code
     * buy the IEC standard and read it in detail
     * buy a Maudio FireWire 410 interface
     * discuss the ideas even more on the mailing lists
     * start coding (why not?) if consesus on the mailing lists has been 
reached
     * set up a blog, wiki page and other communication means, if necessary
* May 23rd - June 1st:
     * design the interface to be implemented by the various stream 
mechanism
     * deliverable: kernel patch (header)
* June - July 15th:
     * write the firewire module
     * write the ALSA interface
     * deliverables: kernel patches for alsa-kernel and ieee1394-linux
* July 15th - August 10th:
     * modify and reduce FFADO to a "ffado-light" version that provides
       configuration and control over the interfaces
     * deliverable: FFADO patches
* August 10th onward:
     * fine tuning, bugfixing
     * testing with a RT-kernel
     * writing documentation
* After GSoC:
     * code clean-ups, refactoring, etc
Additional info: 	http://swarm.cs.pub.ro/~mgherzan/soc_fw.txt



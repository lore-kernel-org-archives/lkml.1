Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbXFWMR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbXFWMR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 08:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbXFWMRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 08:17:20 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:59488 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750987AbXFWMRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 08:17:20 -0400
From: Grozdan Nikolov <microchip@chello.be>
To: linux-kernel@vger.kernel.org
Subject: How innovative is Linux?
Date: Sat, 23 Jun 2007 14:17:15 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231417.16086.microchip@chello.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello gentlemen and ladies.

As a Linux user for many years now (regulars user, not a programmer), I want 
to congratulated you all for the great work you all have done in making Linux 
widely supported and compatible with a lot of hardware. Recently, I was on a 
search to see how the Linux kernel itself compares to other Unix kernels 
(*BSD, Solaris, AIX, etc) in terms of *real* innovation. After reading 
various articles on the net about technology used in Linux and the other 
Unixes, especially after reading the Solaris Vs Linux articles written by Dr. 
Nikolai Bezroukov - 
http://www.softpanorama.org/Articles/solaris_vs_linux.shtml and 
http://www.softpanorama.org/People/Torvalds/index.shtml , I came to the 
conclusion (and correct me if I'm wrong on that) that Linux is not innovative 
at all when compared to the real Unixes in terms of technology. From what I 
understand from the articles is that Linux rips off a lot of technologies 
originally invented by other Unixes but it does very little original 
innovation on its own. How come?

Isn't *real* innovation important anymore in Linux? Or did Linux became a 
commercial "fast buck bitch" for various corporations like IBM, Intel, Red 
Hat, etc and *real* innovation has stalled? A lot of stuff is ported to 
Linux, but all of this stuff isn't Linux' own innovation rather existing 
technology from other companies/Unixes. Solaris invented ZFS, dtrace, RPC, 
PAM, NFS, RBAC, etc, FreeBSD invented jails (lightweight in-kernel virtual 
machines), IBM/AIX invented volume manager... just to name a few. Linux' 
record in innovation looks extremely unconvincing for such a mature stage of 
development (over 10 years). What has Linux invented on its own? Ext and Ext2 
were a rip off from the Unix UFS/FFS, in the early years Linux didn't even 
had its own TCP/IP stack, the recently announced BTRFS is a rip off of ZFS,  
the Linux kernel tracing tool is a joke compared to dtrace in Solaris and is 
hardly a Linux *real* innovation, etc

Further, I'm concerned of the state Linux is now in. Linux doesn't have a well 
defined API interface thus for its change in almost every "stable" kernel 
release. In terms of technological innovation it isn't close to one of the 
BSD kernels or Solaris, it just tries to mimic them. How about making Linux 
fully POSIX/SVR4 compliant so that the Open Group can certified it as a 
*real* Unix and not a rip off? How about innovating something new that no one 
in the Unix camp has invented? How about defining a API that doesn't change 
so often thus breaking a lot of stuff? How about having some sort of 
quality-assurance program to ensure that the code in the Linux kernel is of 
*very* high quality?

I also though that Linux' main role was to replace Windows and 
corporate/proprietary lock-in but instead of doing that it began to replace 
its own fathers and mothers (the other Unixes) and became a easy exploit for 
$$$ hungry IPO's looking for a fast buck and a high fly. Seems to me that 
*real* innovation in Linux isn't important anymore but the thing that has 
become more important for Linux is commercial exploits and slaughter of other 
fellow Unixes, even though Linux is inferior to their innovative technology. 
To put it simple, Linux gets all the credits and recognition while the Unix 
camps are doing the *real* innovative work.

I apologize if this mail looks more like a rant, but I really need these 
questions answered because if not, I will be left in a state of shame that 
Linux, in the early years was such a beautiful thing, but as time passed by, 
it just became one big commercial exploit without *real* innovation.

Please CC me as I'm not subscribe to this mailing list,

Thanks!

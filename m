Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbXFNGQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbXFNGQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbXFNGQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:16:52 -0400
Received: from barikada.upol.cz ([158.194.242.200]:50130 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbXFNGQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:16:51 -0400
To: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: regression tracking (Re: Linux 2.6.21)
In-Reply-To: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
References: <20070426040806.GJ3468@stusta.de> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org> <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: jed (x86_64-pc-linux-glibc-debian)
X-Mailer: slrn
Date: Thu, 14 Jun 2007 08:29:14 +0200
Message-Id: <E1HyipW-0005wJ-0Q@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Newsgroups: gmane.linux.kernel
* Date: Sun, 29 Apr 2007 10:50:22 -0700 (PDT)

* From: Linus Torvalds
>
> On Sun, 29 Apr 2007, Andi Kleen wrote:
>> 
>> Besides the primary point of bug tracking is not to be friendly
>> to someone, but to (a) fix the bugs and (b) know how many bugs
>> there for a given release. Any replacement would need to solve
>> this problem too.
>> 
>> Email does not solve it as far as I can see.
>
> Email fixes a _lot_ more bugs than bugzilla does. 
>
> End of story. I don't think anybody who cannot accept that UNDENIABLE FACT 
> should even participate in this discussion. Wake up and look at all the 
> bugs we fix - most of them have never been in bugzilla.
>
> That's a FACT.
>
> Don't go around ignoring reality.

I'm seeing this long (198) thread and just have no idea how it has
ended (wiki? hand-mailing?).

Just two general questions to Adrian.

1) You was maintainer of the woody backports, isn't it[0]? Why you didn't
proposed (used) Debian's BTS as alternative to bugzilla, and how you did
your regression tracking?

What exactly doesn't fit? Full control by e-mail, comprehensive
management, ML handling/redirection, tagging, sorting, searching? Finally,
reportbug tool and web-inteface?

2) Your decision to stop activity, was that with debian because Sarge was
release with known security hole in the kernel[1]?

I'm just wonder.

[0] google: "woody backports Adrian Bunk"

[1] Message-ID: <20070331194728.GA31853@powerlinux.fr>
    Xref: news.gmane.org gmane.linux.debian.devel.kernel:27730
    [Just take your news readers and have fun with Gmane!]
    [For those, who don't know what it is -- web :]
    Archived-At: <http://permalink.gmane.org/gmane.linux.debian.devel.kernel/27730>
--*--
    Unfortunately this message is from a man, who was punished in very
    unfair manner by "fellow developers". I'm not trying to rise this
    issue (sorry, if i'm trolling), just want to say, that life can be
    very unfair, when some wrong people are in power...
    
    Message-ID: <20070529053026.GA28352@powerlinux.fr>
    Xref: news.gmane.org gmane.linux.debian.devel.project:12330
    Archived-At: <http://permalink.gmane.org/gmane.linux.debian.devel.project/12330>
____

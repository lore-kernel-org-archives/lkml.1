Return-Path: <linux-kernel-owner+w=401wt.eu-S1760092AbXFQNC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbXFQNC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 09:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbXFQNCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 09:02:20 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:54720
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060AbXFQNCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 09:02:19 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexandre Oliva <aoliva@redhat.com>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <200706142246.57583.dhazelton@enter.net>
	<878xal2a0q.fsf@graviton.dyn.troilus.org>
	<200706150127.18069.dhazelton@enter.net>
	<87sl8tzaj1.fsf@graviton.dyn.troilus.org>
	<20070615124039.GB21120@elte.hu>
	<87fy4tz8dc.fsf@graviton.dyn.troilus.org>
	<20070615143003.GA8775@elte.hu>
	<87zm31xo3q.fsf@graviton.dyn.troilus.org>
	<20070615154200.GA17172@elte.hu>
	<orps3xx83o.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070617084610.GD6267@elte.hu>
From: Michael Poole <mdpoole@troilus.org>
Date: Sun, 17 Jun 2007 09:02:18 -0400
In-Reply-To: <20070617084610.GD6267@elte.hu> (Ingo Molnar's message of "Sun\, 17 Jun 2007 10\:46\:10 +0200")
Message-ID: <871wgaybs5.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Alexandre Oliva <aoliva@redhat.com> wrote:
>
>> On Jun 15, 2007, Ingo Molnar <mingo@elte.hu> wrote:
>> 
>> > it is a false statement on your part that the executable "does not 
>> > function properly" if it lacks that part. Try it: take out the harddisk 
>> > from the Tivo (it's a bog standard IDE harddisk), put into a nice Linux 
>> > PC, mount it, modify a bit in the kernel image header and it will likely 
>> > still boot just fine on that PC.
>> 
>> Ok, try this: take the disk out, remove/replace/modify the signature, 
>> put the disk back in, and tell me what it is that fail to run.
>
> you mean back into the Tivo? That is not support for what you claimed. 
> You claimed the "executable does not function properly" if it lacks that 
> part (and you did not qualify your statement with anything). That was a 
> false statement, because it still works fine in just about any 
> bog-standard PC. A true statement would be: "the modified executable 
> does not function properly _in the Tivo_". It still works fine on a 
> general purpose PC.

I claimed that.  Unless I missed something, Alexandre did not.

Ability to run on a standard PC is irrelevant.  Tivo distributes the
executable for the specific purpose of running on their hardware.
Having the signature accepted by the hardware is a critical aspect of
the executable.  That purpose and function are what make the signature
part of the work based on Linux.

Courts consider purpose and intent when analyzing actions; except when
one has bought the best available legal system, they would not follow
your logic.  (The role the signature plays in controlling access to a
copyrighted work, per DMCA, might also separately identify it as part
of the work based on Linux.)

If I wished to distribute a kernel with extended functionality from a
C file but not the C source files, under your logic I need not give
them out -- a user could modify the binary and run it on a general
purpose PC.  Right?  At most it would take clever linker tricks to
make the change small enough.

As to the suggestion that vendors would use another kernel: I would
not mind.  A huge fraction of the interesting and useful work in open
source kernels happens in Linux (first or only).  Using any third
party software is a trade-off of what you get versus what you give up.

Michael Poole

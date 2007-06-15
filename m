Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbXFOQHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbXFOQHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbXFOQHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:07:43 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:44890
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbXFOQHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:07:42 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Daniel Hazelton <dhazelton@enter.net>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706142246.57583.dhazelton@enter.net>
	<878xal2a0q.fsf@graviton.dyn.troilus.org>
	<200706150127.18069.dhazelton@enter.net>
	<87sl8tzaj1.fsf@graviton.dyn.troilus.org>
	<20070615124039.GB21120@elte.hu>
	<87fy4tz8dc.fsf@graviton.dyn.troilus.org>
	<20070615143003.GA8775@elte.hu>
	<87zm31xo3q.fsf@graviton.dyn.troilus.org>
	<20070615154200.GA17172@elte.hu>
From: Michael Poole <mdpoole@troilus.org>
Date: Fri, 15 Jun 2007 12:07:41 -0400
In-Reply-To: <20070615154200.GA17172@elte.hu> (Ingo Molnar's message of "Fri\, 15 Jun 2007 17\:42\:00 +0200")
Message-ID: <87vedpxktu.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Michael Poole <mdpoole@troilus.org> wrote:
>
>> > I.e. you cannot just cleverly define "source code" to include 
>> > something unrelated and then pretend that it's all in one work. And 
>> > that's exactly what the GPLv3 does: it creatively defines the 
>> > hardware's key into the 'source code' of the software and then asks 
>> > for that to be provided _not_ because somehow the key derives from 
>> > the software (it clearly does not), but as a "compensation" for the 
>> > right to redistribute! I.e. it's trying to extend its scope to some 
>> > item that is not part of the software. See?
>> 
>> No.  The GPL does not care about the hardware's key, as I pointed out 
>> in the part of my email that you cut out.  The GPL cares about the key 
>> used to generate an integral part of the executable form of the GPLed 
>> work.  The executable does not function properly if it lacks that 
>> part. [...]
>
> it is a false statement on your part that the executable "does not 
> function properly" if it lacks that part. Try it: take out the harddisk 
> from the Tivo (it's a bog standard IDE harddisk), put into a nice Linux 
> PC, mount it, modify a bit in the kernel image header and it will likely 
> still boot just fine on that PC.

Tivo did not program or sell the hard drive to be used in an arbitrary
Linux PC.  They sold the hard drive to be used in their hardware, with
a Linux kernel specifically modified for that.  Without the right
digital signature, it does not do the same thing: it is *incomplete*.
That is eminently a software issue.  Hardware limitations -- whether
they be RAM size or requirement for a certain digital signature -- are
beside the point.

The requirement that I "modify a bit in the kernel image header" is
also one of the most pathetic cop-outs I have seen.  What makes that
binary format the preferred form for modification of Linux?

Michael Poole

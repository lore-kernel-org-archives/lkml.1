Return-Path: <linux-kernel-owner+w=401wt.eu-S1760523AbXFQS26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523AbXFQS26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 14:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbXFQS2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 14:28:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbXFQS2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 14:28:50 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Poole <mdpoole@troilus.org>, Daniel Hazelton <dhazelton@enter.net>,
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
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 17 Jun 2007 15:28:20 -0300
In-Reply-To: <20070617084610.GD6267@elte.hu> (Ingo Molnar's message of "Sun\, 17 Jun 2007 10\:46\:10 +0200")
Message-ID: <orwsy2h1vf.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 17, 2007, Ingo Molnar <mingo@elte.hu> wrote:

> * Alexandre Oliva <aoliva@redhat.com> wrote:

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

> you mean back into the Tivo? That is not support for what you claimed. 
> You claimed the "executable does not function properly" if it lacks that 
> part (and you did not qualify your statement with anything). That was a 
> false statement, because it still works fine in just about any 
> bog-standard PC. A true statement would be: "the modified executable 
> does not function properly _in the Tivo_". It still works fine on a 
> general purpose PC.

I stand """corrected""".  It doesn't matter, because the TiVo is where
the combination of the executable with the signature shipped, and,
see, I didn't talk about modifying the executable, what I wrote about
above was modifying the signature alone.  See?

> But you didnt really want to make use of Tivo's free software 
> enhancements, right? Lets face the sad truth: the overwhelming majority 
> of Tivo 'modders' wanted to hack the PVR not to enhance the Tivo, they 
> more likely wanted to watch pay-per-view content without the pay bit and 
> they perhaps wanted to get around service restrictions that the Tivo 
> implements (and through which it funds lower-than-production-cost for 
> the PVR).  So the 'rights' you are trying to protect are invented 
> 'rights' of mostly _freeloaders_ in fact.

Sony Betamax anyone?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}

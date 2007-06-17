Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbXFQIqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbXFQIqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 04:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbXFQIqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 04:46:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53501 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269AbXFQIq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 04:46:29 -0400
Date: Sun, 17 Jun 2007 10:46:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Michael Poole <mdpoole@troilus.org>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070617084610.GD6267@elte.hu>
References: <200706142246.57583.dhazelton@enter.net> <878xal2a0q.fsf@graviton.dyn.troilus.org> <200706150127.18069.dhazelton@enter.net> <87sl8tzaj1.fsf@graviton.dyn.troilus.org> <20070615124039.GB21120@elte.hu> <87fy4tz8dc.fsf@graviton.dyn.troilus.org> <20070615143003.GA8775@elte.hu> <87zm31xo3q.fsf@graviton.dyn.troilus.org> <20070615154200.GA17172@elte.hu> <orps3xx83o.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orps3xx83o.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexandre Oliva <aoliva@redhat.com> wrote:

> On Jun 15, 2007, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > it is a false statement on your part that the executable "does not 
> > function properly" if it lacks that part. Try it: take out the harddisk 
> > from the Tivo (it's a bog standard IDE harddisk), put into a nice Linux 
> > PC, mount it, modify a bit in the kernel image header and it will likely 
> > still boot just fine on that PC.
> 
> Ok, try this: take the disk out, remove/replace/modify the signature, 
> put the disk back in, and tell me what it is that fail to run.

you mean back into the Tivo? That is not support for what you claimed. 
You claimed the "executable does not function properly" if it lacks that 
part (and you did not qualify your statement with anything). That was a 
false statement, because it still works fine in just about any 
bog-standard PC. A true statement would be: "the modified executable 
does not function properly _in the Tivo_". It still works fine on a 
general purpose PC.

In fact, you couldnt even modify the binary on the Tivo, because the 
Tivo is not a general purpose PC, it is a PVR. You'd have to put the 
disk into a PC to modify the binary. And then you'd have to put it back 
into the Tivo. So even in this silly example of yours you _already_ have 
to have a general purpose programmable system where the free software 
runs fine, and even under your strained and invalid interpretation of 
the GPLv2, your "rights" to modify the software are very well present on 
that general purpose system.

But you didnt really want to make use of Tivo's free software 
enhancements, right? Lets face the sad truth: the overwhelming majority 
of Tivo 'modders' wanted to hack the PVR not to enhance the Tivo, they 
more likely wanted to watch pay-per-view content without the pay bit and 
they perhaps wanted to get around service restrictions that the Tivo 
implements (and through which it funds lower-than-production-cost for 
the PVR). So the 'rights' you are trying to protect are invented 
'rights' of mostly _freeloaders_ in fact. The 'Tivo community' was 
conjured up after the fact. So even in this supposedly golden and 
hand-picked DRM example of RMS, the whole story stinks from beginning to 
end and has all the classic earmarks of detached-from-the-real-world 
religious extremism in the works ...

and the whole effort is totally pointless anyway. Consumers are already 
voting with their feet against DRM restrictions. So the only DRM victims 
of the GPLv3 attack measures will be the _good_ uses of DRM. People will 
be able to use tamper-proof, vendor-upgradable hardware based on 
FreeBSD, but not based on any GPLv3 kernel. Nobody will care about 
content DRM at that point anymore, and all that remains is a license 
that is crippled for the _good_ uses. Smart move to advance free 
software, eh? Really, RMS should have kept hacking code a bit longer so 
that he doesnt become that totally detached from the rest of us.

	Ingo

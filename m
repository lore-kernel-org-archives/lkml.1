Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbXFQXNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbXFQXNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757752AbXFQXM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:12:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbXFQXM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:12:57 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>, Rob Landley <rob@landley.net>,
       Bron Gondwana <brong@fastmail.fm>, Al Viro <viro@ftp.linux.org.uk>
Subject: mea culpa on the meaning of Tivoization (was: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3)
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614235004.GA14952@elte.hu> <20070615041149.GA6741@brong.net>
	<orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615072322.GA7594@brong.net>
	<orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616021630.GA30660@brong.net>
	<orhcp8s402.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616103130.GD32405@brong.net>
	<orhcp7rfd6.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616233251.GA17270@brong.net>
	<ork5u3mjkf.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070617122025.5a444e62@the-village.bc.nu>
	<orsl8qh1mq.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070617211853.400712e0@the-village.bc.nu>
	<orodjefgrc.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070617222123.0412f740@the-village.bc.nu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 17 Jun 2007 20:11:13 -0300
In-Reply-To: <20070617222123.0412f740@the-village.bc.nu> (Alan Cox's message of "Sun\, 17 Jun 2007 22\:21\:23 +0100")
Message-ID: <orabuyfa7i.fsf_-_@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 17, 2007, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> > That accurately describes the FCC wireless rules.
>> 
>> AFAIK the FCC mandates not permitting the user to tinker.  It doesn't
>> mandate the vendor to retain this ability to itself.

> In practical terms it does since a recall/replacement in the event of
> rule changes is a bit impractical

Indeed.  But that's not a legal requirement, it's an economic reason.

"But I need to make a profit" or "But I need to reduce costs" is no
excluse to disrespect the GPL.


>> Therefore, per the above, FCC doesn't mandate tivoization.

> I'm sure you can find a definition to sort your goals whatever.

Are you per chance implying that I'm twisting the definition of
tivoization?


You know...  I now believe that would be correct.  I have indeed
twisted the definition of tivoization, and I'm sorry about that.
Which is not to say that I agree that the FCC or any other law
mandates tivoization, or that tivozation is a good thing or that it is
permitted by GPLv2.  Please read on.


After long conversations with RMS about the section on poisoned apples
and tivoization in my draft article about GPLv3 (Corresponding Sources
is the name of the section in
http://fsfla.org/svnwiki/blogs/lxo/draft/gplv3-snowwhite) I had come
to the conclusion that Tivoization amounted to:

  denying the user of the computer the freedom to run modified
  versions of the Free Software in it, while retain this ability to
  oneself.

This understanding of mine had been strengthened by my understanding
of the wording and the rationale of GPLv3dd3, the wording about
technical restrictions in the rationales published along with
GPLv2dd2, and the various speeches in which the term was presented.

Nevertheless, I consulted with him and others highly involved in the
development of GPLv3 about some of the discussions going on here, and
got responses over the past few hours that surprised me.  A lot.

So I've just went back to that discussion about my article, and to
various other cases in which RMS, Eben Moglen and others presented
Tivoization, the rationales, and so on, and I came to the conclusion
that I had experienced a subtle but very significant misunderstanding.

I'm now convinced that a more appropriate definition would be:

  denying the user of the computer the freedom to run modified
  versions of the Free Software in it, by not sharing information as
  to how it could be accomplished.


This difference is very significant, and even more so for this
discusion, because it contradicts some of what I claimed before about
forms to use GPLed software where regulations require the user to be
unable to modify the software.


Let me start with an example: I bought a wireless router some time
ago, and it had a GNU+Linux distribution installed in it.  No source
code or written offer for source code, though.

Now, if I called the vendor next day and asked for the source code,
and they responded "sorry, I can't give you that.  I threw it all
away, such that I wouldn't be able to give it to you.", they would
still be disrespecting my freedoms, as well as the license, right?

You see where I'm going?  Now, if they gave me the source code, but I
still couldn't install modified versions, because they introduced
technical measures with the purpose of denying me this possibility,
then the inability to modify the program wouldn't be caused by
something like a physical impossibility (something like ROM), but
rather by an active measure to trample my ability to adapt the program
and run it for any purpose.

So, if I called them to ask how to install and run modified versions
of the GPLed programs, and they responded "sorry, I can't give you
that.  I threw it all away, such that I wouldn't be able to give it to
you.", they would still be disrespecting my freedoms, as well as the
license.

The reasons as to why they'd want to disrespect the freedoms don't
matter.  It could be "making a profit", "complying with the law",
"abiding by contractual restrictions", anything.  Imposing
restrictions to the exercise of the freedoms is not in line with the
spirit of the GPL, as such restrictions render the Software non-Free.


The conclusion?  Throwing keys away, or using split-key techniques, as
I have suggested as potential alternatives to ROM for compliance with
GPLv3 are not meant to be permitted by GPLv3.  There might be
practical advantages to compromising and permitting these techniques,
but that would amount to endorsing disrespect for users' freedoms, and
more, betraying those who licensed their works under GPLv1+ or v2+
with an intent to not permit these practices.  I don't think FSF is
willing to be part of this, and this is how it should be.

As for those who didn't mean the GPL this way, they can always grant
additional permissions, or simply refrain from enforcing the license
in these cases.


I apologize for my terrible misunderstanding, and for spreading it.

Hopefully this message will reach everyone I have misled.

I've tried to Cc: everyone who'd received copies of my mistaken claims
directly from me.  If I left you out by accident, please holler ;-)

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}

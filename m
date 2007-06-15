Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbXFOKeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbXFOKeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 06:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbXFOKeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 06:34:11 -0400
Received: from keil-draco.com ([216.193.185.50]:50261 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbXFOKeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 06:34:10 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Bernd Paysan <bernd.paysan@gmx.de>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 06:33:51 -0400
User-Agent: KMail/1.9.6
Cc: Theodore Tso <tytso@mit.edu>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org> <20070615052432.GC14911@thunk.org> <200706151202.13708.bernd.paysan@gmx.de>
In-Reply-To: <200706151202.13708.bernd.paysan@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150633.51857.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 06:02:11 Bernd Paysan wrote:
> On Friday 15 June 2007 07:24, Theodore Tso wrote:
> > On Thu, Jun 14, 2007 at 08:20:19PM -0300, Alexandre Oliva wrote:
> > > So, you see, your statement above, about wanting to be able to use
> > > other people's improvements, cannot be taken without qualification.
> >
> > No.  Linus and other Linux kernels might *want* to take other people's
> > improvements, but thanks to Richard Stallman's choices for GPLv3, they
> > can *not* legally take other people's improvements without violating
> > the GPLv3 license.  That's not their fault, it's the fault of people
> > who wrote the GPLv3 license, promulgated the GPLv3 license, and who is
> > attempting to convince everyone that the GPLv3 license is the only
> > valid license for Right Thinking FSF automatons to use.
>
> Ah no, it's their fault. The GPLv2 always was clear that there will be some
> future releases of the GPL, and that you should keep "upgrading" possible.

Not true at all. The GPLv2 leaves it up to the person placing their work under 
the GPLv2 license that its up to them whether they want the license on 
their "covered work" to be able to be changed. That the boilerplate includes 
this clause is pretty pointless - anyone can easily remove the "or, at your 
option, any later version" clause and render section 9 meaningless as applies 
to their work.

> > There are plenty of things that I might *want* to do, that I am
> > legally prohibited from doing.  that doesn't change the fact that I
> > might want to do it.  The fact that GPLv3 is incompatible with GPLv2
> > is a tragedy, in the Greek sense.
>
> The GPLv2 tries hard to be compatible with any further versions of the GPL
> as possible, by allowing people to choose which license you take, and by
> making sure that no man in the middle can restrict this choice. If people
> deliberately select to use "GPLv2 only", who's to blame? RMS? Come on,
> that's bullshit. It's *Linus Torvalds* who made Linux incompatible with
> GPLv3, nobody else - ok, Al Viro with his tagged GPLv2 files (and honestly,
> I think this is just another Linus misinterpretation about the GPL, and he
> really didn't do it, because he couldn't).

Incorrect. Read section 9 of the GPLv2. It's pretty clear that the "any later 
version" clause is optional. Whats more is that since the modern linux kernel 
*IS* a "composite work" composed of Linus' original code with changes 
contributed by other people - Linus retains copyright to the work as a whole. 
This means that he can license it in any manner he chooses, as long as it 
doesn't affect the copyrights (or licensing) of the people that have 
contributed changes. I don't have to go to the US copyright law for this - 
Linus released Linux under the GPL, others made changes and sent them back 
saying "You let me have access to your code under the GPL, I've made some 
changes that make it better. You can have my changes under the GPL." QED: 
Linus still holds copyright to Linux and can license it in any way he 
chooses. This is limited because of the license he accepted when adding the 
changes back to his code. He may have locked the kernel, as a whole, to 
version 2 of the GPL - but that is his right. There is nothing he has done 
that has stopped people from having their code included that is still "v2 or 
later". 

> This thread was fun, but I think all arguments have been repeated often
> enough. I try to give up. I suggest everyone who has some assertions about
> what the GPLv2 does read it through and find the place where it says so.
> Unfortunately, I haven't seen GPL citations from the Linus-fanboy curve,
> only suggestions that the GPL "does not say something" which it clearly
> does.

Because there has been no need to quote the GPLv2 until it became clear that 
people were going to keep claiming it stated things it did not. Since then 
I've started quoting the relevant sections of it.

But I agree with you - the thread was fun. And then I realized that the 
discussion was going nowhere at all. So I'm going to answer the last few 
messages in my inbox and then start filtering messages with this topic off 
without reading them.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbXFSGVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbXFSGVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 02:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbXFSGVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 02:21:24 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50265 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbXFSGVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 02:21:23 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Tue, 19 Jun 2007 02:21:08 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706182035420.3593@woody.linux-foundation.org> <or7iq05w6g.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or7iq05w6g.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706190221.09067.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 June 2007 01:51:19 Alexandre Oliva wrote:
> On Jun 19, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > The GPLv2 is the one that allows more developers.
> >
> > The GPLv2 is the one that is acceptable to more people.
>
> Based on my understanding that the anti-tivoization provisions are
> *the* objectionable issue about GPLv3 for those of you who dislike
> GPLv3, this is circular reasoning:
>
>   anti-tivoization is bad
>   => we reject licenses with it
>   => there are fewer developers willing to develop with such licenses
>   => anti-tivoization is bad

The logic is close to:
   => License forbids X
   => developer has requirement for X in license, can't add to project
   => License forbidding X is bad

When it comes to TiVO the reason the developers "required" the "tivoization" 
was because the company itself demanded it. The reason: providers of the 
content their device works with demanded it.

> > Face it, the "open source" crowd is the *bigger* crowd.
>
> I really don't know about that.  I can believe it may be so in LKML.

Actually, it is. Every "Free Software" developer that I personally know could 
care less about the FSF's motives - until they impact them. Since they don't 
care what the FSF does, publishes, etc... they cannot be termed "Free 
Software" developers (using the definition of the term "Free Software" 
provided by the FSF). In fact, almost all of them will state either: "I work 
on Open Source software" or "I develop FOSS stuff".

> > I haven't really seen a single one. Last I did the statistic, I asked the
> > top ~25-30 kernel developers about their opinion. NOT A SINGLE ONE
> > preferred the GPLv3.
>
> Wow, that's a really big sample among all Free Software and Open
> Source developers out there.  And not even a little bit biased at
> that.

Yes, the sample could be considered "biased" - jst as a sample taken among the 
GCC developers could be considered "biased" towards the other end of the 
spectrum.

> > So I have actual *numbers* on my side. What do you have, except for a
> > history of not actually understanding my arguments?
>
> Which is worse, not understanding or repeatedly snipping out and
> addressing unrelated points?

It's time to quote a very ancient source: "Don't point out the speck in your 
neighbors eye when you cannot see the log in your own"

In other words - you've done the same and more.

>
> Let's please try again.
>
> I'll try to keep it simple, since you can't seem to be able to grasp
> the entire argument, and keep disregarding essential parts, disputing
> unrelated points and jumping to the conclusions that you've disputed
> the point I was trying to make.
>
> I'll present it in parts, as an attempt to stop you from making this
> mistake, that I'm sure is not intentional.
>
> The first part is in this e-mail.
>
>
> Dispute this:
>
> non-tivoized hardware => users can scratch their itches => more
> contributions from these users
>
> tivoized hardware => users can't scratch their itches => fewer
> contributions from these users

Linus doesn't have to. Statistically the number of people that will even think 
of modifying the code running on a "tivoized" device is minute - at most 5% 
of the users of such a device. Of those people the ones with the skill to 
actually do the work is an even smaller number - figure 2.5 to 3% of them. Of 
those  with the skill, probably about 10% of them are actually *good* enough 
at it for their changes to be useful. Of that number, figure that only 25%, 
at most, will contribute the changes back.

Apply that to a sample case:
"tivoized" device total users: 1,000,000
people that think about modifying: 50,000 (5%)
people with skill: 1500 (3%)
people who are good enough for the changes to be useful: 150 (10%)
those who will contribute them back: 38 (25%)

Now a normal companies software department is anywhere from 10 to 50 people. 
Large companies can employ more - IBM employs hundreds.

What you are arguing is that people should abandon a firm set of developers 
that is proven to be large for the potential at adding, at most, 38 
developers per million users of the device. If that number was more than 1000 
per device I'd agree. The numbers don't support your argument.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.

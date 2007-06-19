Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbXFSG2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbXFSG2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 02:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbXFSG2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 02:28:42 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50309 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbXFSG2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 02:28:41 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: mea culpa on the meaning of Tivoization
Date: Tue, 19 Jun 2007 02:28:27 -0400
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>, Rob Landley <rob@landley.net>,
       Bron Gondwana <brong@fastmail.fm>, Al Viro <viro@ftp.linux.org.uk>
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <200706182325.22067.dhazelton@enter.net> <ortzt44gqt.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <ortzt44gqt.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706190228.27543.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 June 2007 02:10:02 Alexandre Oliva wrote:
> On Jun 19, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > I haven't looked at it, in depth, today but one of the problems I
> > saw was the apparent loopholes in the text. No specifics, but I
> > remember thinking "a lawyer would have a field day with this -
> > dozens of ways they could sidestep these issues"
>
> *Pretty* *please* file comments about the apparent loopholes at
> gplv3.fsf.org/comments

To do that I'd have to go back, take the time to re-read the GPLv3 *in* 
*depth*, think about each paragraph of each section individually...

Like I said, I just got a general impression that a lawyer would have a 
field-day with it.

> > What I was getting at, here, is that the GPLv3 isn't backwards
> > compatible with GPLv2,
>
> It couldn't possibly be.  The whole point of upgrading the GPL is such
> that it complies better with its spirit of defending the freedoms, so
> as to keep free software free.  This can only be accomplished with
> additional restrictions that stop practices that deny users'
> freedoms.
>
> Relaxing the provisions, a necessary condition for compatibility,
> wouldn't make for better defenses.
>
> > because you aren't allowed to remove rights from the GPLv3. Remember,
> > there are rights encoded in the GPLv3 that don't appear in v2.
>
> I'm not sure what you mean by "rights" in the two sentences above.
> You know you can grant additional permissions, so I assume that's not
> what you mean, even more so because you *can* indeed take them out.
> Is it "conditions", "restrictions" or some such, that in turn
> translate into freedoms for downstream users, or is it about the
> granted rights per se?

Sorry, bad choice of words. There are "guarantees" encoded into every license. 
There are some encoded into the GPLv3 that aren't encoded into the GPLv2. You 
can't remove or restrict those guarantees without violating the license. And 
removing those guarantees would be the only way to make the GPLv3 fully 
compatible with the GPLv2.

> > In fact, if you want to use GPLv3 code in a GPLv2 project you have
> > to use GPLv3. For some projects, like the Linux Kernel, the upgrade
> > is impossible to accomplish.
>
> Impossible is a bit too strong.  I understand it would take a huge
> amount of work though, so I sympathize with "it wouldn't be worth it",
> even if, in my scale of moral values, I'd disagree.

In this case I wasn't speaking literally. I should have been a lot more 
specific there - it should say "practically impossible". 

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.

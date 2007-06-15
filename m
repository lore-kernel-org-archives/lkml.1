Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbXFOBBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbXFOBBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbXFOBAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:00:49 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50073 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbXFOBAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:00:48 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 21:00:33 -0400
User-Agent: KMail/1.9.6
Cc: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706141617.46734.dhazelton@enter.net> <or645q9qgw.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or645q9qgw.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706142100.33478.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 17:27:27 Alexandre Oliva wrote:
> On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > <somewhat sarcastic>
> > And the companies that produce devices that come with Linux and/or
> > other GPL'd software installed and place limits such that only
> > people that have purchased that hardware have access to the
> > "modified" source running on the device are following the letter,
> > and the spirit, of the GPL.
>
> WAIT, WAIT, THAT'S... :-)
>
> > Before you start yelling I'm wrong, think about it this way: they
> > make the source available to the people that they've given binary
> > versions to, and there is nothing stopping one of those people from
> > making the source available to the rest of the world.
>
> The *only* in your sentence betrayed you.
>
> If they place the limits such that nobody else can access the sources,
> they're in violation of the license.

Nope. There is *NO* requirement *ANYWHERE* in the GPL, no matter the version, 
that says you have to *DISTRIBUTE* the source to *ANYONE* except those that 
you have given a binary to. Go read the licenses.

>
> If they merely refrain from distributing the sources to others, but
> still enable the recipients to do so, this is not a violation of the
> license.

Exactly what I said. "only the people that have purchased the hardware have 
access to the modified sources"

That is *EXACTLY* what a number of companies have done - Acer (yes, the laptop 
company) has done that. They sell laptops running Linux, but unless you have 
purchased one of them you can't download the sources (or even replacement 
binaries) for the version of linux they put on their machines. (From Acer, 
that is)

However, as I also said, there is nothing stopping one of those people from 
making those "modified sources" available to the rest of the world. (I have 
yet to find someone that has done that with the Acer specific stuff, but...) 

> But then IANAL.
>
> > *AND* the GPL has never been about making the source available to
> > everyone - just to those that get the binaries.
>
> Exactly.  Not even to the upstream distributor.  That's where Linus'
> theory of tit-for-tat falls apart.

Yes, it does. However, the practicality is that there is nothing *stopping* 
the person upstream from getting a copy of the source and incorporating the 
modifications they contain in a new version.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.

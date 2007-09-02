Return-Path: <linux-kernel-owner+w=401wt.eu-S1758492AbXIBR5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbXIBR5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 13:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXIBR5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 13:57:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55960 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbXIBR5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 13:57:45 -0400
Message-ID: <46DAF995.8020301@garzik.org>
Date: Sun, 02 Sep 2007 13:57:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: espie@nerim.net
CC: linux-kernel@vger.kernel.org
Subject: Re: GPL weasels and the atheros stink
References: <20070902140306.GA27317@lain.home>
In-Reply-To: <20070902140306.GA27317@lain.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(more serious reply now ensues)

Marc Espie wrote:
> After reading the current email exchanges, I've become convinced
> there is something VERY fishy going on, and some people there have 
> hidden agendas.
> 
> Look at the situation: Reyk Floeter writes some code, puts it
> under a dual licence, and goes on vacation.
> 
> While he's away, some other people (Jiri, for starters) tweak the
> copyright and licence on the file he's mostly written. Without asking

Dude, you have got to put down the conspiracy juice.

NOTHING IS IN STONE, because nothing has been committed to my 
repository, much less torvalds/linux-2.6.git.

A patch was posted, people complained, corrections were made.  That's 
how adults handle mistakes.  Mistakes were made, and mistakes were 
rectified.


> Reyk. Without even having the basic decency to wait for him to be
> around.

Demonstrably false:  you cannot make that claim until the code is 
actually committed to Linux.


> The only possible issue is related to paranoia: if this file stays
> dual-licenced, some of its code may escape from the GPL shrine, and
> become available to the cuddly BSD people... but since their licence
> doesn't protect anything, it could used by the Evil Empire of Microsoft,
> or SCO, or whoever is the villain of the month.

This is a classic straw man:  http://en.wikipedia.org/wiki/Straw_man

_You_ are paranoid about these changes, and you project your fears upon 
us.  None of this applies to the vast majority of Linux engineers.


> Woah. You guys kill me. If you want to protect against that, just make
> sure the code you want to protect stays inside its own file! But frankly,
> removing Reyk's licence, or heck, making it `second class' (the file was
> originally under this licence) shows incredibly poor ethics. (I'll let

So I guess when that was corrected, and a mistake was admitted and 
corrected, it shows good ethics?


> actual lawyers comment on the legality of that, but some informed sources
> tell me this is also downright illegal in most places).

Removing the copyright and license ON NON-DUAL-LICENSED CODE -- yes, 
that was wrong, and it was fixed.

But for dual-licensed code, it is fine.  The license text explicitly 
permits selection of one OR the other license.


> Linux is so proud of its numerous drivers... I think that it's a story of

<guffaw>  As a major Linux driver author and maintainer, I can tell you 
they are just as grotty as any other piece of code.


> pride: some people can't bear the fact that sometimes, some interesting
> development happens outside of linux first. I'm very proud of my fellow
> members of the OpenBSD project, who managed to get some wireless cards to
> work WITHOUT any nwi binary blob, and BEFORE the linux people managed to
> get them to work.

Good engineers just don't have time for shite like this.  And our 
wireless guys are good engineers, just like Reyk.


> So, now, it's down to dirty fighting. Absorbing and `relicensing' and 
> evolving code.  Have you all been bitten my RMS paranoia (that leads to
> this `interesting GPLv3) ?

You've missed the last ten years or so of Linux kernel development, 
haven't you?

Linux kernel peeps are traditionally not fans of the FSF (and that is an 
understatement in some cases).

Next time, please look at the facts before letting Theo lead you like a 
mind-numbed robot.

	Jeff




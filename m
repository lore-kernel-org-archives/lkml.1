Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZC2LLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZC2LLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 07:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZC2LL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 07:11:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33889 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZC2LL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 07:11:27 -0400
Date: Sun, 29 Mar 2009 13:11:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Cyril Hrubi? <metan@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, thommycheck@gmail.com,
       milan@ucw.cz
Subject: Re: 2.6.29-rc1 on zaurus (spitz)
Message-ID: <20090329111120.GD2886@elf.ucw.cz>
References: <20090128113809.GA29424@elf.ucw.cz> <dc2200690902121322l4e16cf84h25d2871ca80c37a3@mail.gmail.com> <20090222135651.GD1387@ucw.cz> <20090222142345.GA21948@flint.arm.linux.org.uk> <20090314162439.GC1496@ucw.cz> <20090317191946.GA13630@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317191946.GA13630@flint.arm.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Sat, Mar 14, 2009 at 05:24:39PM +0100, Pavel Machek wrote:
> > > > About hda timeouts... I remember seeing them under older kernels, too,
> > > > under loads such as kernel compile... plus keypresses tend to get lost
> > > > under high loads :-(.
> > > 
> > > Really, what we need is for someone to step up to take on sorting out
> > > Zaurus.  Looking at this thread, it seems there's very few people here
> > > willing.  Also, I think Richard Purdie has moved on from Zaurus stuff.
> > > 
> > > I know there are a small number of people on linux-arm-kernel who have
> > > access to some Zaurus platforms, but I don't know what they are.  Really,
> > > you should be posting to that list if you seriously want help, because
> > > I doubt they're subscribed to LKML.
> > 
> > linux-arm-kernel seems subscriber-only :-(.
> 
> Yes.
> 
> > Anyway, new problem blocking testing is that somewhere between
> > 2.6.29-rc3 and -rc7, pcmcia support stopped working => hda is no
> > longer detected.
> 
> lalala, I'm not listening.

lalala... I think I tried to subscribe to linux-arm-kernel, but all I
got is automated reply and no flood of messages. Is subscription
moderated, too?


								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbXFNTzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbXFNTzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXFNTzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:55:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60385 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbXFNTzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:55:32 -0400
Date: Thu, 14 Jun 2007 21:55:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614195517.GA4933@elte.hu>
References: <466A3EC6.6030706@netone.net.tr> <200706132121.04532.dhazelton@enter.net> <orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br> <200706132304.21984.dhazelton@enter.net> <20070614112329.3645c397@the-village.bc.nu> <20070614103846.GA7902@elte.hu> <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexandre Oliva <aoliva@redhat.com> wrote:

> On Jun 14, 2007, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > I think the proper limit is the boundary where the limit of the 
> > software is - because that's the only sane and globally workable way 
> > to stop the power-hungry.
> 
> But see, I'm not talking about getting permission to hack the 
> hardware.  I'm only talking about getting permission to hack the Free 
> Software in it.
> 
> It's your position that mingles the issues and permits people to use 
> the hardware to deprive users of freedom over the software that 
> they're entitled to have.

where does this false sense of entitlement come from? The hardware maker
ows you nothing but what is written into the GPLv2. Not more, not less.

(In fact, most hardware makers that utilize free software today give
back _substantially more_ to the community than the license requires!
For example they are currently the largest employers of free software
developers - although nothing in the license forces them to do so. Why?
Because the economic rules that the GPLv2 creates are healthy.)

you are not "entitled" to dictate the hardware's design (or any other 
copyrighted work's design), even if the license gives you the power to 
do so. By your argument we'd have to put the following items into the 
license too:

 - free on-site training for free software developers about the 
   hardware's inner workings. (It is justified to teach free software
   the same know-how as in-house engineers of the hardware maker. 
   Without this, users are hindered in their freedom to use and 
   effectively modify (fix) the software.)

 - free access to all the hardware diagnostics tools that the hardware 
   maker has. (Without that it might be impossible to modify the 
   software as efficiently as the hardware maker's own engineers can do 
   it.)

 - free samples of the hardware to be sent to free software developers,
   upon request. (The hardware maker's own engineers have free access to 
   samples. Otherwise free software users might not get the same level 
   of driver support as the hardware maker can achieve.)

 - free access to the hardware manufacturing equipment. (If i wish to 
   modify the free software in a way that requires more RAM than the 
   hardware has, i need access to the manufacturing equipment to produce 
   a new version of the hardware that can run that free software. The 
   hardware maker has this right and flexibility to modify the software, 
   so i should have that same right too.)

see how quickly your argument becomes totally ludicrous, if brought to 
its logical conclusion?

This "right to modify" and "have the same rights as the hardware maker" 
arguments are _totally_ bogus, they were made up after the fact, just 
because quite apparently RMS had a fit over Tivo and started this verbal 
(and legal) vendetta. The FSF is now attempting to rewrite history and 
pretends that this "always was in the GPLv2" and applies this newly 
thought up concept to the GPLv3 in a way that substantially departs from 
the spirit of the GPLv2. Which spirit the GPLv2 explicitly promised to 
uphold in Section 9. Which could make any contrary section of the GPLv3 
unenforceable, when applied to "GPLv2 or later" licensed software.

	Ingo

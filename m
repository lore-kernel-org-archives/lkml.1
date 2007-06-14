Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbXFNUcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbXFNUcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXFNUcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:32:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36229 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbXFNUcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:32:46 -0400
Date: Thu, 14 Jun 2007 21:32:30 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexandre Oliva <aoliva@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614203230.GS21478@ftp.linux.org.uk>
References: <466A3EC6.6030706@netone.net.tr> <200706132121.04532.dhazelton@enter.net> <orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br> <200706132304.21984.dhazelton@enter.net> <20070614112329.3645c397@the-village.bc.nu> <20070614103846.GA7902@elte.hu> <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614195517.GA4933@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614195517.GA4933@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 09:55:17PM +0200, Ingo Molnar wrote:
> This "right to modify" and "have the same rights as the hardware maker" 
> arguments are _totally_ bogus, they were made up after the fact, just 
> because quite apparently RMS had a fit over Tivo and started this verbal 
> (and legal) vendetta. The FSF is now attempting to rewrite history and 
> pretends that this "always was in the GPLv2" and applies this newly 
> thought up concept to the GPLv3 in a way that substantially departs from 
> the spirit of the GPLv2. Which spirit the GPLv2 explicitly promised to 
> uphold in Section 9. Which could make any contrary section of the GPLv3 
> unenforceable, when applied to "GPLv2 or later" licensed software.

That, BTW, is perhaps the worst problem with v2 (inherited by v3).
WTF _is_ "the spirit of the license" and who gets to decide if two
licenses are in the same spirit?  As soon as we get to "well, original
authors of the license are the final authority on that", we are
in the "I've always said ..." country.

Look, humans _suck_ at revision control, especially that of our
intentions and opinions.  It doesn't even require malice, all
ancedotes about spouses/mothers-in-law/etc. nonwithstanding.

We all easily fall into belief that we had always meant what we mean
now; that even if we said something different, it was just a poor
wording; that if we had known what we know now, we would certainly
had come to the same conclusions we have come to now.

"In the same spirit" is just about the weakest requirement in that
area.  I.e. the most prone to drift, especially when one is an ideologist
and thus has severely decayed integrity to start with.  Call it a
professional disease of crystal ball users - or a prerequisite for
playing a visionary, if you will ;-/

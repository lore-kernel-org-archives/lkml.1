Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbZKKUP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbZKKUP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757475AbZKKUPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:15:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757417AbZKKUPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:15:55 -0500
Date: Wed, 11 Nov 2009 12:14:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
In-Reply-To: <1257970010.11985.17.camel@mulgrave.site>
Message-ID: <alpine.LFD.2.01.0911111211270.31845@localhost.localdomain>
References: <20091110034831.GB26809@elte.hu>  <20091110041452.GA25575@suse.de> <1257863388.4184.220.camel@mulgrave.site>  <20091110193747.GB12686@suse.de> <1257965424.11985.9.camel@mulgrave.site>  <alpine.LFD.2.01.0911111153390.31845@localhost.localdomain>
 <1257970010.11985.17.camel@mulgrave.site>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Nov 2009, James Bottomley wrote:
> 
> So, now that you're showing an interest in all of this, how about I send
> you the final update hook to add to your tree?  It will produce less
> latency than the cron job I run on kernel.org to pull your tree into one
> I have here ever twenty minutes or so and run the hooks.

Quite frankly, I'd much rather not run hooks on my tree directly. The less 
that can possibly get screwed up with my kernel.org tree, the happier I 
am. So in many ways, I really prefer the whole "done separately by others" 
approach.

But hey, send the hook to me, and I'll think about it.

		Linus

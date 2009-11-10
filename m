Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZKJRWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZKJRWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZKJRWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:22:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49391 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbZKJRWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:22:23 -0500
Date: Tue, 10 Nov 2009 18:22:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
Message-ID: <20091110172202.GB25581@elte.hu>
References: <20091110034831.GB26809@elte.hu>
 <20091110041452.GA25575@suse.de>
 <20091110042032.GD29454@elte.hu>
 <1257863432.4184.223.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257863432.4184.223.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2009-11-10 at 05:20 +0100, Ingo Molnar wrote:
> > * Greg KH <gregkh@suse.de> wrote:
> > 
> > > > I've attached the full commit below. The prereq commits are not 
> > > > uptream yet, and they dont carry a -stable backporting tag as the 
> > > > -stable relevance was not anticipated at that point yet. They will 
> > > > all be upstream in the next merge window when Linus merges the 
> > > > relevant tree - and then all these tags become visible to the 
> > > > -stable team's scripts.
> > > > 
> > > > What do you think about this new -stable tagging variant? To me it 
> > > > looks quite intuitive, less error-prone and it is more informative 
> > > > as well. Furthermore, it gives us some freedom to mark commits as 
> > > > backport candidates later on. I kept them oneliners for the purpose 
> > > > of making them all self-sufficient tags.
> > > 
> > > I agree.
> > 
> > Ok - thanks for the confirmation - i've pushed out the first such 
> > commit. (Let me know if there's any problem with it down the line - it 
> > will be a few weeks, in the next merge window, until it truly 
> > 'activates' for -stable.)
> 
> Can you give me the commit id in your tree so I can run a few tests?

Let me re-quote what you quoted above:

> > > > I've attached the full commit below. [...]

	Ingo

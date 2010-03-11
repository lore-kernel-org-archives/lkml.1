Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047Ab0CKSTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:19:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52161 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933606Ab0CKSTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:19:13 -0500
Date: Thu, 11 Mar 2010 19:18:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: increase CONFIG_NODES_SHIFT max to 10
Message-ID: <20100311181832.GB12235@elte.hu>
References: <alpine.DEB.2.00.1003101537330.30724@chino.kir.corp.google.com>
 <20100311132354.GA26600@elte.hu>
 <20100311140623.GA9346@suse.de>
 <20100311141533.GB31225@elte.hu>
 <20100311175804.GA32333@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311175804.GA32333@suse.de>
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


* Greg KH <gregkh@suse.de> wrote:

> On Thu, Mar 11, 2010 at 03:15:33PM +0100, Ingo Molnar wrote:
> > 
> > * Greg KH <gregkh@suse.de> wrote:
> > 
> > > > erm. Alas I cannot merge it in the x86 tree without that fix being 
> > > > upstream. Why for v2.6.35 - shouldnt that be v2.6.34?
> > > 
> > > If it needs to go in before .35, or it should go through Ingo's trees, I 
> > > have no objection.
> > 
> > It does not 'need' to be in .34 but if the fix is trivial enough then you 
> > could give it a try?
> 
> The fix is trivial, I'll queue it up.

Thanks Greg!

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbXI1RxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbXI1RxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXI1Rww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:52:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56040 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753128AbXI1Rww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:52:52 -0400
Date: Fri, 28 Sep 2007 10:46:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-Id: <20070928104642.0f3a4573.akpm@linux-foundation.org>
In-Reply-To: <20070928132138.GG18163@shadowen.org>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky>
	<20070928084003.GA18882@elte.hu>
	<20070928020132.f6c6f528.akpm@linux-foundation.org>
	<20070928092235.GA31180@shadowen.org>
	<20070928093902.GA28455@elte.hu>
	<20070928100024.GB18163@shadowen.org>
	<20070928104935.GA606@elte.hu>
	<20070928132138.GG18163@shadowen.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 14:21:38 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> On Fri, Sep 28, 2007 at 12:49:35PM +0200, Ingo Molnar wrote:
> > 
> > * Andy Whitcroft <apw@shadowen.org> wrote:
> > 
> > > On Fri, Sep 28, 2007 at 11:39:02AM +0200, Ingo Molnar wrote:
> > >
>
> [bunfight]
>

oy, knock it off.

> Anyhow.  I have already added a --check/--no-check option which controls

-strict?

> the more subjective tests which will be in the next release; though its
> likely the option name will be something more useful by then.
> 
> The only question is whether this should default to on.  You are voting
> off.  I personally think on.
> 
> Andrew?  Randy?  Joel?
> 

off, I'd say.  That way people are more likely to use it.  Or, more
accurately, will have less excuses to not use it.


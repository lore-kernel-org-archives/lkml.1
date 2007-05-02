Return-Path: <linux-kernel-owner+w=401wt.eu-S2993459AbXEBQiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993459AbXEBQiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993507AbXEBQiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:38:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993459AbXEBQh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:37:59 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal>
	<20070502104413.GC4392@one.firstfloor.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 02 May 2007 12:37:28 -0400
In-Reply-To: <20070502104413.GC4392@one.firstfloor.org>
Message-ID: <y0my7k7uqpj.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andi Kleen <andi@firstfloor.org> writes:

> [...] The SystemTAP project also plan to use this type of
> > infrastructure to trace sites hard to instrument. The Linux Kernel
> > Markers has the support of Frank C. Eigler, author of their current
> > marker alternative [...]
> 
> All of the above don't use mainline kernels.
> That doesn't constitute using it.

Systemtap does run on mainline kernels.

> > "kprobes remains a vital foundation for SystemTap.  But markers are
> > attactive as an alternate source of trace/debug info.  Here's why:
> > [...]"
> 
> Talk is cheap. Do they have working code to use it? [...]

We had been waiting on the chicken & egg semaphore.  LTTNG has working
code yesterday (months ago); systemtap will have it "tomorrow" (a week
or few).


- FChE

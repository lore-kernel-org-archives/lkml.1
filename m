Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197Ab0A0K3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0A0K3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023Ab0A0K3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:29:36 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41421 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab0A0K3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:29:35 -0500
Date: Wed, 27 Jan 2010 15:59:23 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC Patch 2/2][Bugfix][x86][hw-breakpoint] Fix return-code to
	notifier chain in hw_breakpoint_handler
Message-ID: <20100127102923.GB3460@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20091226182833.GC9494@in.ibm.com> <20091231003808.GC23808@nowhere> <20091231190217.GC3676@in.ibm.com> <20100110031857.GB15195@nowhere> <4B4B78D1.2080606@siemens.com> <20100116194058.GA31079@in.ibm.com> <20100120060159.GA4859@in.ibm.com> <4B596C8E.2020600@siemens.com> <20100122092127.GB7127@in.ibm.com> <20100125222139.GF5087@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100125222139.GF5087@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 11:21:41PM +0100, Frederic Weisbecker wrote:
> On Fri, Jan 22, 2010 at 02:51:27PM +0530, K.Prasad wrote:
> > > >> Such a behaviour shouldn't be affected by the above change...your
> > > >> confirmation would help!
> > > >>
> > > > 
> > > > Hi Jan,
> > > > 	I presume that the above explanation makes the role of this
> > > > patch/bugfix clear.
> > > > 
> > > > Kindly let me know if you have any further queries.
> > > > 
> > > 
> > > Nope. There should be really no conflicts of your optimization with kvm.
> > > 
> > > Jan
> > > 
> > > -- 
> > 
> > Hi Jan,
> > 	Thanks for the confirmation.
> > 
> > Hi Frederic,
> > 	Can you pull these fixes in? (LKML references:
> > 20091226182725.GB9494@in.ibm.com and 20091226182833.GC9494@in.ibm.com).
> 
> 
> I got a deeper look at these patches and answered with some comments.
> 
> If you address these, I can apply for .34 (because it's about optimizations
> and not fixes).
>

Sure, please apply them against a version that you deem appropriate.

Thanks,
K.Prasad
 

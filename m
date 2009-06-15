Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZFOMsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZFOMsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbZFOMs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:48:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51791 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZFOMs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:48:27 -0400
Date: Mon, 15 Jun 2009 08:48:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] tracing: some fixes for 2.6.31
In-Reply-To: <20090615122152.GA6044@nowhere>
Message-ID: <alpine.DEB.2.00.0906150848100.16299@gandalf.stny.rr.com>
References: <4A35B84B.40904@cn.fujitsu.com> <20090615122152.GA6044@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 15 Jun 2009, Frederic Weisbecker wrote:

> On Mon, Jun 15, 2009 at 10:56:11AM +0800, Li Zefan wrote:
> > Some small but not trival fixes for 2.6.31:
> > 
> > [PATCH 1/4] tracing: fix a typo in tracing_cpumask_write()
> > [PATCH 2/4] tracing: replace a GFP_ATOMIC with GFP_KERNEL allocation
> > [PATCH 3/4] tracing/filters: operand can be negative
> > [PATCH 4/4] tracing/filters: strloc should be unsigned short
> > ---
> >  kernel/trace/trace.c               |    8 ++++----
> >  kernel/trace/trace_events_filter.c |    9 +++++++--
> >  2 files changed, 11 insertions(+), 6 deletions(-)
> > 
> > 
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com> for
> the whole series. Thanks!

Yeah, I got a few patches over the weekend, I'll go and pull these and the 
others in.

Thanks,

-- Steve


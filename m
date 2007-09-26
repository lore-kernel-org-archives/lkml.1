Return-Path: <linux-kernel-owner+w=401wt.eu-S1762960AbXIZVUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762960AbXIZVUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761100AbXIZVUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:20:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41839 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953AbXIZVUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:20:18 -0400
Subject: Re: v2.6.23-rc4-rt1 / new project URL
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1189427714.21778.15.camel@twins>
References: <1188593944.9647.15.camel@chaos>
	 <1189427714.21778.15.camel@twins>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 23:16:50 +0200
Message-Id: <1190841410.18147.41.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve, 

On Mon, 2007-09-10 at 14:35 +0200, Peter Zijlstra wrote:
> On Fri, 2007-08-31 at 22:59 +0200, Thomas Gleixner wrote:
> > We're pleased to announce the release of the v2.6.23-rc4-rt1 kernel,
> > which can be downloaded from a new place:
> >  
> >    http://www.kernel.org/pub/linux/kernel/projects/rt/
> >  
> > The move to kernel.org is experimental for now, we'll keep it if it
> > works out fine.
> > 
> > Changes since 2.6.23-rc2-rt2:
> > 
> > - update to -rc4
> > - update to 2.6.23-rc4-hrt1
> > 
> > - UP compile fixes back merged (Kevin Hilman / Steven Rostedt)
> > - various latency tracer fixes (Steven Rostedt)
> > - softirq migration fixes (Steven Rostedt)
> > - ARM futex cmpxchg in atomic support (Khem Raj)
> > - ARM raw lock fix (Kevin Hilman)
> > - loadavgrt fix (Luis Claudio R. Goncalves)
> > - mellanox driver fix (Michael S. Tsirkin)
> > 
> > A bunch of patches are postponed for -rt2 (they are neither ignored
> > nor forgotten):
> > 
> > - simple_irq change (Kevin Hilman): needs more thought
> > - RCU updates (Paul McKenney): needs proper integration
> > - latency tracer changes (Daniel Walker): needs review
> > - PICK_OP changes (Daniel Walker): needs review
> 
> This one seems to have slipped through the cracks:
>   http://lkml.org/lkml/2007/8/16/135

Seems to be missed again :-/


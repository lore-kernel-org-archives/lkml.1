Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbZFYMtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbZFYMtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 08:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZFYMtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 08:49:35 -0400
Received: from www.tglx.de ([62.245.132.106]:49588 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbZFYMtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 08:49:35 -0400
Date: Thu, 25 Jun 2009 14:48:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
In-Reply-To: <20090625092409.GC23547@elte.hu>
Message-ID: <alpine.LFD.2.00.0906251445200.2767@localhost.localdomain>
References: <1245760130.3776.6.camel@localhost.localdomain> <20090623195656.GC8777@elte.hu> <1245876060.3038.7.camel@localhost.localdomain> <alpine.LFD.2.00.0906242253270.2767@localhost.localdomain> <20090625092409.GC23547@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, Ingo Molnar wrote:

> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Thu, 25 Jun 2009, Jaswinder Singh Rajput wrote:
> > > On Tue, 2009-06-23 at 21:56 +0200, Ingo Molnar wrote:
> > > 
> > >       248064467  L1-data-Cache-Load-Referencees  (scaled from 23.27%)
> > >       283542921  dL1-loads             (scaled from 23.28%)
> > 
> > Where is the point of this? dL1-loads is a completely non 
> > intuitive artificial abbreviation.
> 
> blame me :)
> 
> I found L1-data-Cache-Load-References way too long and i asked for 
> suggestions and came up with my list of abbreviations.
> 
> I found 'dL1' intuitive because we use 'dTLB' and 'iTLB' as well.

:)
 
> How about L1-data-loads ?

Yeah, something like that would be nice. The ones Roland
suggested are fine as well.

Thanks,

	tglx

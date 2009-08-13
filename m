Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZHMXth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZHMXth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 19:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZHMXtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 19:49:36 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:44947 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbZHMXtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 19:49:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19076.42632.201737.880314@cargo.ozlabs.ibm.com>
Date: Fri, 14 Aug 2009 09:49:28 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@gmail.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perf_counters issue with PERF_SAMPLE_GROUP
In-Reply-To: <1250065963.10001.30.camel@twins>
References: <7c86c4470908110841wca07382gf7487c0ed55909f2@mail.gmail.com>
	<1250006744.10001.29.camel@twins>
	<7c86c4470908111240s58385748wdb3c3e4a0d66a1ea@mail.gmail.com>
	<1250024143.7091.7.camel@laptop>
	<7c86c4470908111408x256e294i13ac90035fd8f5c8@mail.gmail.com>
	<1250065963.10001.30.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> On Tue, 2009-08-11 at 23:08 +0200, stephane eranian wrote:
> 
> > > Not really, Paul did it like that initially and we've been consistently
> > > doing it like that -- changing it now is a bit late.
> > >
> > 
> > But aren't you going to change the cpu, pid target stuff we discussed a couple
> > of weeks ago anyway?
> 
> Right, I'd like to, but Ingo doesn't. I haven't heard back from Paul on
> this.

Sorry, got distracted.  What are we proposing to change exactly?

Paul.

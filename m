Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbZCJQ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbZCJQ0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbZCJQ0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:26:33 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:14920 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753746AbZCJQ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:26:32 -0400
X-BigFish: VPS-37(zz1432R62a3L98dR936eQ1805Mzzzzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 8,
X-WSS-ID: 0KGATNQ-01-0AW-01
Date: Tue, 10 Mar 2009 17:26:16 +0100
From: Robert Richter <robert.richter@amd.com>
To: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
Message-ID: <20090310162616.GI10085@erda.amd.com>
References: <20090121185021.GA8852@elte.hu> <20090309013902.GK10085@erda.amd.com> <18869.40904.382716.827097@cargo.ozlabs.ibm.com> <20090310094457.GU10085@erda.amd.com> <18870.21428.868208.447605@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <18870.21428.868208.447605@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Mar 2009 16:26:16.0684 (UTC) FILETIME=[EFCBA2C0:01C9A19C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.03.09 22:49:08, Paul Mackerras wrote:
> Robert Richter writes:
> 
> > Ok, maybe I mixed too much the architectural with the x86 model
> > specific implementation. My impression is that there is data in
> > generic structures what should be better private for the model or
> > architecture. However, I have to figure out the details here.
> 
> The details of the x86 support have changed quite a lot since the v6
> patch was posted, I believe.  Are you looking at the v6 patch, or at
> Ingo's tip:perfcounters/core branch?

I am using the tip branch, but took the v6 thread to discuss this.

> 
> Ingo - maybe it's time to post a v7 patch?

For me it's fine to work with the branch if patches are posted to the
mailing list for review.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


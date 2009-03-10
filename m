Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZCJLt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZCJLt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZCJLtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:49:17 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:54782 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbZCJLtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:49:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18870.21428.868208.447605@cargo.ozlabs.ibm.com>
Date: Tue, 10 Mar 2009 22:49:08 +1100
From: Paul Mackerras <paulus@samba.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
In-Reply-To: <20090310094457.GU10085@erda.amd.com>
References: <20090121185021.GA8852@elte.hu>
	<20090309013902.GK10085@erda.amd.com>
	<18869.40904.382716.827097@cargo.ozlabs.ibm.com>
	<20090310094457.GU10085@erda.amd.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter writes:

> Ok, maybe I mixed too much the architectural with the x86 model
> specific implementation. My impression is that there is data in
> generic structures what should be better private for the model or
> architecture. However, I have to figure out the details here.

The details of the x86 support have changed quite a lot since the v6
patch was posted, I believe.  Are you looking at the v6 patch, or at
Ingo's tip:perfcounters/core branch?

Ingo - maybe it's time to post a v7 patch?

Paul.

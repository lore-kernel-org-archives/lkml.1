Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbYLEH5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbYLEH5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 02:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYLEH5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 02:57:38 -0500
Received: from ozlabs.org ([203.10.76.45]:59895 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbYLEH5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 02:57:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18744.57057.243817.407691@cargo.ozlabs.ibm.com>
Date: Fri, 5 Dec 2008 18:57:21 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
In-Reply-To: <1228461385.18899.13.camel@twins>
References: <20081204225345.654705757@linutronix.de>
	<18744.29747.728320.652642@cargo.ozlabs.ibm.com>
	<20081205063131.GB12785@elte.hu>
	<20081205070329.GA30874@elte.hu>
	<1228461385.18899.13.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> So, while most people would not consider two consecutive read() ops to
> be close or near the same time, due to preemption and such, that is
> taken away by the fact that the counters are task local time based - so
> preemption doesn't affect thing. Right?

I'm sorry, I don't follow the argument here.  What do you mean by
"task local time based"?

Paul.


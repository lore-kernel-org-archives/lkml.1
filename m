Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYLJEpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYLJEpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 23:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbYLJEo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 23:44:59 -0500
Received: from ozlabs.org ([203.10.76.45]:37626 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255AbYLJEou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 23:44:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18751.18735.539555.111549@drongo.ozlabs.ibm.com>
Date: Wed, 10 Dec 2008 15:44:31 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, eranian@gmail.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Subject: Re: [patch] Performance Counters for Linux, v2
In-Reply-To: <87skoxc6qo.fsf@basil.nowhere.org>
References: <20081208012211.GA23106@elte.hu>
	<7c86c4470812082237ne58c814s7218cc663f3b49e9@mail.gmail.com>
	<20081209134636.GA1926@elte.hu>
	<18750.61143.101922.949701@cargo.ozlabs.ibm.com>
	<87skoxc6qo.fsf@basil.nowhere.org>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen writes:

> When you say counting you should also include "event ring buffers with
> metadata", like PEBS on Intel x86. 

I'm not familiar with PEBS.  Maybe it's something different again,
neither sampling nor counting, but a third thing?

Paul.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYLHOl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYLHOl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYLHOlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:41:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34762 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbYLHOlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:41:46 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v2
From: Andi Kleen <andi@firstfloor.org>
References: <20081208012211.GA23106@elte.hu>
	<18748.37739.383961.318233@drongo.ozlabs.ibm.com>
	<20081208113318.GA14723@elte.hu>
Date: Mon, 08 Dec 2008 15:41:57 +0100
In-Reply-To: <20081208113318.GA14723@elte.hu> (Ingo Molnar's message of "Mon, 8 Dec 2008 12:33:18 +0100")
Message-ID: <87k5aan2yy.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> This means that the only correct technical/mathematical argument is to 
> talk about "levels of noise" and how they compare and correlate - and 
> i've seen no actual measurements or estimations pro or contra. Group 
> readout of counters can reduce noise for sure, but it is wrong for you to 
> try to turn this into some sort of all-or-nothing property. Other sources 
> of noise tend to be of much higher of magnitude.

Ingo, could you please describe how PEBS and IBS fit into your model?

Thanks.

-Andi

-- 
ak@linux.intel.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbYLJRK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbYLJRK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYLJRKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:10:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48653 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbYLJRKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:10:47 -0500
To: Rob Fowler <rjf@renci.org>
Cc: eranian@gmail.com, linux-arch@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>,
       Arjan van de Veen <arjan@infradead.org>
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
From: Andi Kleen <andi@firstfloor.org>
References: <20081204225345.654705757@linutronix.de>
	<7c86c4470812051836t37e86565w3b92fd06fc905430@mail.gmail.com>
	<493FEDE9.5080209@renci.org>
Date: Wed, 10 Dec 2008 18:11:06 +0100
In-Reply-To: <493FEDE9.5080209@renci.org> (Rob Fowler's message of "Wed, 10 Dec 2008 11:27:21 -0500")
Message-ID: <87d4g0c5w5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Fowler <rjf@renci.org> writes:
>
> -- Can it supplant or support oprofile by supporting the tools (Code Analyst, etc) that
>     depend on it?

There's no need to supplant/support oprofile really because at least
short term oprofile will not go away.

-Andi

-- 
ak@linux.intel.com

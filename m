Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYEYWXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYEYWXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 18:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbYEYWW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 18:22:57 -0400
Received: from www.tglx.de ([62.245.132.106]:45343 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYEYWW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 18:22:56 -0400
Date: Mon, 26 May 2008 00:21:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marin Mitov <mitov@issp.bas.bg>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re:[PATCH -v4] x86: enable preemption in delay
In-Reply-To: <200805252108.25011.mitov@issp.bas.bg>
Message-ID: <alpine.LFD.1.10.0805260006110.3295@apollo.tec.linutronix.de>
References: <200805252108.25011.mitov@issp.bas.bg>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008, Marin Mitov wrote:
> Hi Steven,

Please do not trim CC lists without a good reason. [Restored it]

> look at this patch, proposed by me and Ingo few month ago.
> I think it solves the problem you had fond, but unfortunately
> it had been lost (not included in the mainline).

Yep, and it might be simply because the mail thread ended with:

http://lkml.org/lkml/2007/11/20/426

> hi Marin,
>
> here's the patch we are carrying in x86.git at the moment - could you 
> please update it with v3 of your code, and send us the patch (with the 
> patch metadata kept intact, like you see it below)? Thanks,
>
>      Ingo

And there was no response. I just checked my x86 quilt archives and it
simply went into the "wait for update" category and got dropped
unfortunately.

Thanks,

	tglx

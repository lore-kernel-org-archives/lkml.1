Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYKJSPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYKJSPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYKJSPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:15:23 -0500
Received: from relay1.sgi.com ([192.48.179.29]:47304 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753036AbYKJSPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:15:23 -0500
Message-ID: <49187A8F.5010502@sgi.com>
Date: Mon, 10 Nov 2008 10:16:47 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: introduce new API, without changing anything
References: <20081029152849.3883d072.sfr@canb.auug.org.au> <20081107093911.GD7787@elte.hu> <20081107122400.GA20777@elte.hu> <200811082024.20157.rusty@rustcorp.com.au> <20081108122833.GH8354@elte.hu>
In-Reply-To: <20081108122833.GH8354@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
...
> Mike, could you please double-check that the version that is in 
> tip/cpus4096 [622e0ed] is the final version you need, and that if you 
> base subsequent patches on it it works as expected?
...
I'm checking this out, so far it looks good.

> and once that patch hits upstream, we could restructure/rebase the 
> commits in cpus4096-v2 ontop of upstream and spread them out properly. 
> Does that sound optimal?

Yes, thanks.  I'm doing the x86 portion now.  Rusty is doing the other
arch and core changes.



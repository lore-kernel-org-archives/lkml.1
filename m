Return-Path: <linux-kernel-owner+w=401wt.eu-S1761352AbYEHJ4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352AbYEHJ4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbYEHJ4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:56:14 -0400
Received: from www.tglx.de ([62.245.132.106]:52377 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbYEHJ4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:56:13 -0400
Date: Thu, 8 May 2008 11:55:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: the purge :-)
In-Reply-To: <20080508112130.fd574b50.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.1.10.0805081152310.3318@apollo.tec.linutronix.de>
References: <20080508112130.fd574b50.sfr@canb.auug.org.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Stephen Rothwell wrote:
> Hi all,
> 
> Having published my expectations of what should be in linux-next, I am
> no implementing what I think is what I said.  :-)
> 
> This is open to discussion (including suggestions about other trees).
> 
> The following trees are being excluded from today because I think that
> they contain changes that:
> 	- have not been published/reviewed/tested sufficiently
> 	- are not currently intended for 2.6.26 or 2.6.27.
> (not all reasons apply to all trees).  Please don't take offense, I am
> just trying to obey my own guidelines.
> 
> ldp
> x86_latest
> sched_latest
> 
> Ingo, I assume that things will migrate from {x86,sched} latest to
> for-akpm (for-next?) over time.

We are working on refactoring our x86 work flow. We'll give you
notice, when the dust of the demolition has settled.

Thanks,
	tglx

Return-Path: <linux-kernel-owner+w=401wt.eu-S933221AbYBMRTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbYBMRTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYBMRTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:19:05 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:39119 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbYBMRTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:19:02 -0500
Message-ID: <47B32664.7050201@qualcomm.com>
Date: Wed, 13 Feb 2008 09:18:28 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Paul Jackson <pj@sgi.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, gregkh@suse.de, rusty@rustcorp.com.au
Subject: Re: [git pull] CPU isolation extensions (updated)
References: <47AE6A8B.6030908@qualcomm.com> <20080209212156.ecc72fee.pj@sgi.com> <47AE76B8.6060304@qualcomm.com> <20080213105804.GE32241@elte.hu>
In-Reply-To: <20080213105804.GE32241@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Max Krasnyansky <maxk@qualcomm.com> wrote:
> 
>> Ingo said a few different things (a bit too large to quote). 
> 
> [...]
>> And at the end he said:
>>> Also, i'd not mind some test-coverage in sched.git as well.
> 
>> I far as I know "do not mind" does not mean "must go to" ;-). [...]
> 
> the CPU isolation related patches have typically flown through 
> sched.git/sched-devel.git, so yes, you can take my "i'd not mind" 
> comment as "i'd not mind it at all". That's the tree that all the folks 
> who deal with this (such as Paul) are following. So lets go via the 
> normal contribution cycle and let this trickle through with all the 
> scheduler folks? I'd say 2.6.26 would be a tentative target, if it holds 
> up to scrutiny in sched-devel.git (both testing and review wise). And 
> because Andrew tracks sched-devel.git it will thus show up in -mm too.

Sounds good. Can you pull my tree then ? Or do you want me to resend the patches.
The tree is here:
	git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.git
Take the for-linus branch.
Or as I said please let me know and I'll resend the patches.

Thanx
Max

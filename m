Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665Ab0BEH34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 02:29:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49800 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933555Ab0BEH3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 02:29:54 -0500
Date: Fri, 5 Feb 2010 08:29:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: upcoming percpu changes
Message-ID: <20100205072931.GD9320@elte.hu>
References: <20100205161648.086375b9.sfr@canb.auug.org.au>
 <4B6BB13C.2090108@kernel.org>
 <20100205070903.GA9320@elte.hu>
 <4B6BC948.5030401@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6BC948.5030401@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo.
> 
> On 02/05/2010 04:09 PM, Ingo Molnar wrote:
> > Has the review feedback from Frederic and hpa been addressed? (and have they 
> > acked the solution?) That was the only controversial bit i remember.
> 
> Al Viro said that, until sparse is improved, the only solution would be to 
> work around in the rather ugly way as posted in the original patches.  As 
> Frederic and hpa preferred not having the workaround and there were only 
> three instances in the kernel tree, I just left them alone so sparse 
> warning will trigger spuriously on those three locations.
> 
> Thanks.

Ok, good!

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764241AbZDBBKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764241AbZDBBKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 21:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbZDBBKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 21:10:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35078 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbZDBBKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 21:10:32 -0400
Date: Thu, 2 Apr 2009 03:09:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Robert Richter <robert.richter@amd.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, x86@kernel.org
Subject: Re: [PULL] x86 cpumask updates (plus a few generic pre-req cpumask
	cleanups)
Message-ID: <20090402010925.GA20869@elte.hu>
References: <200904021039.22979.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904021039.22979.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> (This is Ingo's cpus4096 branch which has been in linux-next for some weeks,
>  with a trivial merge.)

Yes, that branch was fine and is ready. Thanks Rusty!

Linus, please pull if it looks good to you too.

The gitk output looks pretty nice here - this was one of our 
long-living topic branches.

This was admittedly an accident: there was a single thread of 
contributions/contributors only in this area - thus the history is 
nicely linear/serialized and there's no overlap and no criss-cross 
merging.

In future trees we'll try to achieve this same structure, and not so 
accidentally, even in areas were there's a lot of out-of-order 
execution.

	Ingo

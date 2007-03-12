Return-Path: <linux-kernel-owner+w=401wt.eu-S965535AbXCLLIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965535AbXCLLIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965540AbXCLLIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:08:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35442 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965535AbXCLLIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:08:51 -0400
Date: Mon, 12 Mar 2007 12:08:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Message-ID: <20070312110833.GA12835@elte.hu>
References: <200703111457.17624.kernel@kolivas.org> <200703122022.43021.kernel@kolivas.org> <1173692286.20540.12.camel@Homer.simpson.net> <200703122127.41942.kernel@kolivas.org> <1173697024.8014.19.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173697024.8014.19.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> The test scenario was one any desktop user might do with every 
> expectation responsiveness of the interactive application remain 
> intact. I understand the concepts here Con, and I'm not knocking your 
> scheduler. I find it to be a step forward on the one hand, but a step 
> backward on the other.

ok, then that step backward needs to be fixed.

> > We are getting good interactive response with a fair scheduler yet 
> > you seem intent on overloading it to find fault with it.
> 
> I'm not trying to find fault, I'm TESTING AND REPORTING.  Was.

Con, could you please take Mike's report of this regression seriously 
and address it? Thanks,

	Ingo

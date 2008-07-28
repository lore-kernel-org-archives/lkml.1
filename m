Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbYG1Idn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbYG1Idn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 04:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYG1Idf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 04:33:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53587 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYG1Ide (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 04:33:34 -0400
Date: Mon, 28 Jul 2008 10:33:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>
Subject: Re: [git pull] cpus4096 fixes
Message-ID: <20080728083311.GA30302@elte.hu>
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org> <200807281042.12860.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807281042.12860.rusty@rustcorp.com.au>
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

> Hey, since Mike put his Signed-off-by above mine and didn't put a From 
> line when he took my patch, WFT am I taking responsibility? :)

hm, Mike, please dont do that. You changed Rusty's patch but the way we 
do that is to preserve the original change and then do a delta patch. If 
you dont want to split a commit you should keep the original From and 
mention your own changes in the changelog. I know this was all in the 
rush to meet -rc1, but still.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbYITLcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbYITLcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 07:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYITLcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 07:32:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38335 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbYITLcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 07:32:04 -0400
Date: Sat, 20 Sep 2008 13:31:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip FIXED] ftrace: add nop tracer
Message-ID: <20080920113151.GA30234@elte.hu>
References: <1221818803-9616-1-git-send-email-steven@uplinklabs.net> <20080919142326.29834d11.akpm@linux-foundation.org> <f488382f0809191635o45f3ed17vc23380eab41b2878@mail.gmail.com> <20080920061659.GF25713@elte.hu> <f488382f0809200033x10d43767j95e5958a2715d14c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f488382f0809200033x10d43767j95e5958a2715d14c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Noonan <steven@uplinklabs.net> wrote:

> > yeah. Feel free to send a separate patch that implements Andrew's 
> > clean-up suggestion. I agree that pro>con.
> 
> How about this patch gets applied to -tip and I submit one that drops 
> the ifdefs on this and the other tracers?

yeah - it's been part of tip/master since yesterday.

	Ingo

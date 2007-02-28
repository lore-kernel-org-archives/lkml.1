Return-Path: <linux-kernel-owner+w=401wt.eu-S1750971AbXB1Hn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971AbXB1Hn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 02:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXB1Hn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 02:43:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59477 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbXB1Hn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 02:43:28 -0500
Date: Wed, 28 Feb 2007 08:36:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: regression: forcedeth.c hang
Message-ID: <20070228073619.GA32542@elte.hu>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070225175247.GB12392@stusta.de> <20070227083918.GC30376@elte.hu> <20070227090106.GA2749@elte.hu> <20070227093817.GA5007@elte.hu> <20070227112521.GA9440@elte.hu> <Pine.LNX.4.64.0702270741300.12485@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702270741300.12485@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 27 Feb 2007, Ingo Molnar wrote:
> > 
> > update: Jeff sent me 3 pending forcedeth.c fixes, and they indeed 
> > fix the regression. The one that fixed it is:
> 
> Ok, that was included in the bunch I just pulled and pushed out, so 
> hopefully this one is resolved. Pls verify.

yep, can confirm that it's now fixed upstream too.

	Ingo

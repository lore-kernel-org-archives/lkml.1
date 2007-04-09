Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbXDIRu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbXDIRu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXDIRu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:50:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40702 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbXDIRuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:50:24 -0400
Date: Mon, 9 Apr 2007 19:50:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dave Dillow <dave@thedillows.org>,
       ray-gmail@madrabbit.org, amanda-hackers@amanda.org,
       amanda-users@amanda.org
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
Message-ID: <20070409175009.GB10189@elte.hu>
References: <200704010100.19016.gene.heskett@verizon.net> <200704091133.44684.gene.heskett@gmail.com> <20070409160047.GA609@elte.hu> <200704091305.08779.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704091305.08779.gene.heskett@gmail.com>
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


* Gene Heskett <gene.heskett@gmail.com> wrote:

> > Andrew has already sent a revert patch to Linus and it's in -rc6. 
> > The commit is below.
>
> Is this not the patch that reverts it?  I want the patch that put it 
> in, because that will be a one time churn and be done with it, 
> hopefully for good. [...]

any patch can be reverse-applied by doing "patch -R ...".

	Ingo

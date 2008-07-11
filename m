Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYGKJCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYGKJCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbYGKJCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:02:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40101 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbYGKJCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:02:06 -0400
Date: Fri, 11 Jul 2008 11:01:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: IOMMU cleanups
Message-ID: <20080711090149.GA22533@elte.hu>
References: <1215739425-28399-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080711082303.GA6955@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711082303.GA6955@il.ibm.com>
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


* Muli Ben-Yehuda <muli@il.ibm.com> wrote:

> On Fri, Jul 11, 2008 at 10:23:41AM +0900, FUJITA Tomonori wrote:
> > This patchset cleans up IOMMU stuff, including a sequel to the GART
> > cleanups:
> > 
> > http://lkml.org/lkml/2008/7/9/488
> > 
> > This is against tip/master.
> 
> I heartily endorse this patchset. Thanks for doing it!

thanks - the series looks really nice and i've applied it to 
tip/x86/gart.

I've also added:

  Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

... if you dont mind.

	Ingo

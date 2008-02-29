Return-Path: <linux-kernel-owner+w=401wt.eu-S1761505AbYB2UdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761505AbYB2UdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYB2Uc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:32:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47246 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752236AbYB2Uc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:32:57 -0500
Date: Fri, 29 Feb 2008 21:32:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       vatsa <vatsa@linux.vnet.ibm.com>, Kei Tokunaga <ktokunag@redhat.com>
Subject: Re: A strange behavior of sched_fair
Message-ID: <20080229203202.GA27212@elte.hu>
References: <47C5E977.2010401@jp.fujitsu.com> <1204277686.6243.52.camel@lappy> <1204279909.6243.64.camel@lappy> <20080229194213.GA21249@elte.hu> <47C8692D.1030701@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C8692D.1030701@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com> wrote:

> Hi Ingo, Peter,
>
> Thanks for the patch, Peter.  I modified it a bit to compile and 
> confirmed the issue did not occur on my ia64 box.  I am attaching the 
> revised patch below.

thanks, queued it up. Could you send me your Tested-by (and Acked-by) 
lines?

	Ingo

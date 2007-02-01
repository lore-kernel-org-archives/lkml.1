Return-Path: <linux-kernel-owner+w=401wt.eu-S1422761AbXBARkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422761AbXBARkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 12:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422760AbXBARkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 12:40:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422761AbXBARko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 12:40:44 -0500
Date: Thu, 1 Feb 2007 18:38:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.19-rt6, yum/rpm
Message-ID: <20070201173855.GA29309@elte.hu>
References: <20061205171114.GA25926@elte.hu> <4582CAD6.9040404@ru.mvista.com> <20061215161952.GA29191@elte.hu> <45C20CC6.2070201@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C20CC6.2070201@ru.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:

> >could you resend them to me please?
> 
>    Seeing that GENERIC_TIME has been thrown out from the -rt patch, 
> [...]

hm, i did that accidentally during a rebase. That was certainly not 
meant to be a persistent condition.

	Ingo


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbXE2GP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbXE2GP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 02:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbXE2GPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 02:15:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45568 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbXE2GPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 02:15:49 -0400
Date: Tue, 29 May 2007 08:15:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Yu <raise.sail@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v14
Message-ID: <20070529061544.GA28523@elte.hu>
References: <20070523120616.GA23407@elte.hu> <4658F1D6.3070706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4658F1D6.3070706@gmail.com>
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


* Li Yu <raise.sail@gmail.com> wrote:

> Ingo Molnar wrote:
> >i'm pleased to announce release -v14 of the CFS scheduler patchset.
> >
> >The CFS patch against v2.6.22-rc2, v2.6.21.1 or v2.6.20.10 can be 
> >downloaded from the usual place:
> >   
> >      http://people.redhat.com/mingo/cfs-scheduler/
> >  
> I tried this on 2.6.21.1, Good work!

thanks :)

> [...] in update_stats_enqueue(), It seem that these statements in two 
> brances of "if (p->load_weight > NICE_0_LOAD)" are same, is it on 
> purpose?

what do you mean?

	Ingo

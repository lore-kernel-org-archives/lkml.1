Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbXKZVAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbXKZVAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbXKZVAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:00:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38090 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbXKZVAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:00:04 -0500
Date: Mon, 26 Nov 2007 21:59:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3,
	v2.6.23.9, v2.6.22.13, v2.6.21.7
Message-ID: <20071126205947.GA24167@elte.hu>
References: <20071119151756.GA25446@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119151756.GA25446@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0052]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> By popular demand, here is release -v24 of the CFS scheduler patch.
> 
> It is a full backport of the latest & greatest scheduler code to 
> v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7. The patches can be 
> downloaded from the usual place:
> 
>     http://people.redhat.com/mingo/cfs-scheduler/

update: there's now a CFS-v24 patch available for v2.6.23.9 as well.

	Ingo

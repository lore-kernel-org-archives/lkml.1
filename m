Return-Path: <linux-kernel-owner+w=401wt.eu-S1945977AbXEAUnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945977AbXEAUnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945975AbXEAUnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:43:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38338 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423578AbXEAUen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:34:43 -0400
Date: Tue, 1 May 2007 22:34:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@in.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH CFS V7] Fix warnings in sched and sched_debug
Message-ID: <20070501203430.GA25481@elte.hu>
References: <20070501043000.14787.54833.sendpatchset@balbir-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501043000.14787.54833.sendpatchset@balbir-laptop>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Balbir Singh <balbir@in.ibm.com> wrote:

> The first patch I sent out did not have a sign-off; I had trouble with 
> my patch tools.
> 
> This patch fixes all warnings seen on powerpc during compilation of 
> the CFS patch. It also fixes errors (side-effect of the warnings), 
> where some of the data is printed as negative values.
> 
> Applies on top of cfs v7

thanks, applied! Your fixes should show up in -v8.

	Ingo

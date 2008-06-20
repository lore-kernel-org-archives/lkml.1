Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYFTIsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYFTIsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 04:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbYFTIsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 04:48:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37164 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbYFTIso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 04:48:44 -0400
Date: Fri, 20 Jun 2008 10:47:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, "Daniel K." <dk@uw.no>
Subject: Re: [PATCH 00/10] sched: rt bandwidth/group fixes
Message-ID: <20080620084709.GA31502@elte.hu>
References: <20080619122218.971447669@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619122218.971447669@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> my current queue of fixes
> 
> 1-4 are pushed into sched-urgent and should be included in .26 the 
> rest are less critical and should be queued for .27

applied to tip/sched/devel - thanks Peter.

	Ingo

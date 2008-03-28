Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYC1LXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYC1LXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYC1LXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:23:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40521 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbYC1LXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:23:11 -0400
Date: Fri, 28 Mar 2008 12:22:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
Message-ID: <20080328112256.GA3817@elte.hu>
References: <20080327132057.449831367@polymtl.ca> <20080327154053.GA5890@elte.hu> <20080327203927.GA19968@Krystal> <20080328094326.GE30863@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328094326.GE30863@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0713]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> if you want to compare apples to apples, try the patch below, which 
> removes the ad-hoc tracepoints.

... new version of that is in sched-devel.git.

	Ingo

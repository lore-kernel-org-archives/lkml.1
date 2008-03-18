Return-Path: <linux-kernel-owner+w=401wt.eu-S940731AbYCSWWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940731AbYCSWWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760520AbYCSU5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:57:52 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:40172 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935539AbYCSU5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:57:49 -0400
Date: Tue, 18 Mar 2008 20:58:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: volanoMark 12% regression with 2.6.25-rc6
Message-ID: <20080318195807.GA26887@elte.hu>
References: <1205831650.3215.569.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205831650.3215.569.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2062]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> Comparing with 2.6.25-rc5, volanoMark has 12% regression with 
> 2.6.25-rc6 on my 8-core stoakley.

could you try sched/latest please? You can pick it up via:

  http://people.redhat.com/mingo/sched-devel.git/README

	Ingo

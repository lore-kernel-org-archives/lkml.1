Return-Path: <linux-kernel-owner+w=401wt.eu-S1763739AbZAORzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763739AbZAORzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759998AbZAORzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:55:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40171 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757915AbZAORy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:54:59 -0500
Date: Thu, 15 Jan 2009 18:54:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, dev@jaysonking.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Performance regression of specjbb2005/aim7 with 2.6.29-rc1
Message-ID: <20090115175443.GF22472@elte.hu>
References: <1231837036.11429.27.camel@ymzhang> <1231839464.14655.12.camel@marge.simson.net> <1231986636.10565.159.camel@minggr.sh.intel.com> <1232036235.8870.75.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232036235.8870.75.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4506]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-01-15 at 10:30 +0800, Lin Ming wrote:
> 
> > Below patch fixes aim7 regression and specjbb2005 regression becomes
> > less than 1.5% on 8-core stokley.
> 
> Ingo, please apply the below.

Applied to tip/sched/urgent, thanks!

	Ingo

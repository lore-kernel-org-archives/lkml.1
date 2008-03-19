Return-Path: <linux-kernel-owner+w=401wt.eu-S942543AbYCSXJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942543AbYCSXJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932842AbYCSVer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:34:47 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:45921 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937722AbYCSVep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:34:45 -0400
Date: Wed, 19 Mar 2008 04:28:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: volanoMark 12% regression with 2.6.25-rc6
Message-ID: <20080319032854.GA20793@elte.hu>
References: <1205831650.3215.569.camel@ymzhang> <20080318195807.GA26887@elte.hu> <1205892420.3215.594.camel@ymzhang> <20080319021555.GA15825@elte.hu> <1205896722.3215.624.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205896722.3215.624.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0066]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> On Wed, 2008-03-19 at 03:15 +0100, Ingo Molnar wrote:
> > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > 
> > > Could you send me a patch against 2.6.25-rc6? Or just send me the 
> > > kernel/sched*.c?
> > 
> > sure - the jist of it should be in the patch below.
> I did a quick test and didn't find much help with the new patch.

could you paste the rc5 and rc6 result lines you get out of Volanomark? 
(to see how much they fluctuate, etc.)

	Ingo

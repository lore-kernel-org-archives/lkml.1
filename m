Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbYBFXfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbYBFXfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757099AbYBFXfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:35:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58136 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599AbYBFXfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:35:03 -0500
Date: Thu, 7 Feb 2008 00:34:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Regression] 2.6.24-git9: RT sched mishandles artswrapper
	(bisected)
Message-ID: <20080206233434.GA12393@elte.hu>
References: <200802010237.59320.rjw@sisk.pl> <200802062318.28172.rjw@sisk.pl> <1202337267.6274.15.camel@lappy> <200802070031.03955.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802070031.03955.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > http://programming.kicks-ass.net/kernel-patches/sched-rt-group/
> > 
> > on top of sched-devel.
> 
> Indeed, with these patches applied the issue is not reproducible any 
> more.

great! I've queued Peter's fixes and enhancements up in sched-devel. 
(not pushed out yet)

	Ingo

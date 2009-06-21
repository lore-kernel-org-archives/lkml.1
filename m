Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZFULNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZFULNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 07:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZFULN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 07:13:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32914 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbZFULNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 07:13:25 -0400
Date: Sun, 21 Jun 2009 13:13:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] [TRIVIAL] Documentation/sched-rt-group: Fix style
	issues & bump version
Message-ID: <20090621111317.GA9543@elte.hu>
References: <1245580359-4465-1-git-send-email-w.sang@pengutronix.de> <20090621104136.GA13503@elte.hu> <20090621110753.GA14208@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090621110753.GA14208@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0058]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wolfram Sang <w.sang@pengutronix.de> wrote:

> On Sun, Jun 21, 2009 at 12:41:36PM +0200, Ingo Molnar wrote:
> > 
> > * Wolfram Sang <w.sang@pengutronix.de> wrote:
> > 
> > > -NOTE: the above example is not fully implemented as of yet (2.6.25). We still
> > > +NOTE: the above example is not fully implemented as of yet (2.6.31). We still
> > 
> > lets just remove the version info, ok?
> 
> Ack. That's way better. Shall I resend?

No need - already applied it with that small bit fixed.

	Ingo

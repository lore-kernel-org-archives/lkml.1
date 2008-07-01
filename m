Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYGAHXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYGAHXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYGAHXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:23:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44429 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYGAHXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:23:10 -0400
Date: Tue, 1 Jul 2008 09:22:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] softlockup: fix watchdog task wakeup frequency
Message-ID: <20080701072259.GC26601@elte.hu>
References: <20080627000805.504878592@saeurebad.de> <20080627120350.GB30872@elte.hu> <87prq3xdjv.fsf@skyscraper.fehenstaub.lan> <20080627124329.GA14576@elte.hu> <87d4m3xbzq.fsf@skyscraper.fehenstaub.lan> <87od5ms7yh.fsf@skyscraper.fehenstaub.lan> <20080630130837.GA332@elte.hu> <87abh26u2m.fsf@skyscraper.fehenstaub.lan> <20080701061146.GE14658@elte.hu> <871w2e6ptn.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871w2e6ptn.fsf@skyscraper.fehenstaub.lan>
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


* Johannes Weiner <hannes@saeurebad.de> wrote:

> > i applied and tested everything that would apply (modulo trivial 
> > conflict resolution) - but not all of your patches applied so if 
> > there's still anything missing please send a delta patch against 
> > this branch. (or against tip/master, which too has all these changes 
> > included)
> 
> #1 is crap, #3 is in the tree and here is #2 against 
> #tip/core/softlockup:

applied to tip/core/softlockup - thanks Johannes.

	Ingo

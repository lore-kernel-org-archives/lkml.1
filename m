Return-Path: <linux-kernel-owner+w=401wt.eu-S1765208AbXGPMUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765208AbXGPMUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759202AbXGPMT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:19:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45743 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758864AbXGPMT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:19:57 -0400
Date: Mon, 16 Jul 2007 14:19:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
Message-ID: <20070716121906.GA18169@elte.hu>
References: <19044.1184539364@lwn.net> <Pine.LNX.4.64.0707161325040.1818@scrub.home> <20070716114734.GA12010@elte.hu> <Pine.LNX.4.64.0707161353350.1818@scrub.home> <20070716115744.GA14131@elte.hu> <Pine.LNX.4.64.0707161404240.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707161404240.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Mon, 16 Jul 2007, Ingo Molnar wrote:
> 
> > i'm not sure how your question relates/connects to what i wrote above, 
> > could you please re-phrase your question into a bit more verbose form so 
> > that i can answer it? Thanks,
> 
> Well, you cut out the major question from my initial mail:
> One question here would be, is it really a problem to sleep a little more?

oh, i did not want to embarrass you (and distract the discussion) with 
answering a pretty stupid, irrelevant question that has the obvious 
answer even for the most casual observer: "yes, of course it really is a 
problem to sleep a little more, read the description of the fine patch 
you are replying to" ...

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbXGPOJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbXGPOJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932630AbXGPOJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:09:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58600 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932618AbXGPOJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:09:12 -0400
Date: Mon, 16 Jul 2007 16:09:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
Message-ID: <20070716140904.GA15028@elte.hu>
References: <19044.1184539364@lwn.net> <Pine.LNX.4.64.0707161325040.1818@scrub.home> <20070716114734.GA12010@elte.hu> <Pine.LNX.4.64.0707161353350.1818@scrub.home> <20070716115744.GA14131@elte.hu> <Pine.LNX.4.64.0707161404240.1817@scrub.home> <20070716121906.GA18169@elte.hu> <Pine.LNX.4.64.0707161444510.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707161444510.1817@scrub.home>
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

> One question here would be, is it really a problem to sleep a little 
> more? Another possibility would be to add another sleep function, 
> which uses hrtimer and could also take ktime argument.

i'm not sure how this helps your argument, could you please explain it 
more verbosely? (because when i assumed the obvious, you called it an 
insult - so please dont leave any room for assumptions and remove any 
ambiguity - especially as our communication seems to be marred by what 
appears to be frequent misunderstandings ;-)

	Ingo

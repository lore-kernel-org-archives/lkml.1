Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbXENMEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbXENMEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 08:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbXENMEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 08:04:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57183 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbXENMEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 08:04:13 -0400
Date: Mon, 14 May 2007 14:04:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, efault@gmx.de, tingy@cs.umass.edu,
       linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Message-ID: <20070514120405.GA3364@elte.hu>
References: <20070514083358.GA29775@in.ibm.com> <20070514102929.GL31925@holomorphy.com> <20070514103120.GA23766@elte.hu> <20070514110500.GV19966@holomorphy.com> <20070514112259.GC28348@in.ibm.com> <20070514112016.GW19966@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514112016.GW19966@holomorphy.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* William Lee Irwin III <wli@holomorphy.com> wrote:

> [...] I'm suspicious of EEVDF's timekeeping now as well.

well, EEVDF is a paper-only academic scheduler, one out of thousands 
that never touched real hardware. For nearly every mathematically 
possible scheduling algorithm i suspect there's at least one paper out 
there already describing it ;-) But this time the EEVDF paper got it 
right and you got it wrong. But really, if you want to make an impact on 
how CFS looks like then please try it and send test feedback and/or 
patches - not words. =B-)

	Ingo

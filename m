Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbYC0Jv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbYC0Jv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbYC0Jvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:51:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43162 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263AbYC0Jvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:51:47 -0400
Date: Thu, 27 Mar 2008 10:51:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] documentation: nmi_watchdog=2 works on x86_64 (was:
	2.6.25-rc: complete lockup on boot/start of X (bisected))
Message-ID: <20080327095132.GA15003@elte.hu>
References: <20080302185935.GA6100@joi> <1204485071.6240.56.camel@lappy> <20080302194748.GA6005@joi> <1204487917.6240.64.camel@lappy> <20080323154416.GA6817@joi> <1206287670.6437.113.camel@lappy> <20080323184427.GA6691@joi> <1206299168.6437.119.camel@lappy> <20080323200625.GB6028@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080323200625.GB6028@joi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3791]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> > Care to send a patch to the x86 maintainers? :-)
> 
> ---
> documentation: nmi_watchdog=2 works on x86_64

thanks Marcin, applied.

	Ingo

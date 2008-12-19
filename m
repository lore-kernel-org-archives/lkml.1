Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbYLSVuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbYLSVuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbYLSVuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:50:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48528 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbYLSVuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:50:06 -0500
Date: Fri, 19 Dec 2008 22:49:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: perf_counter.c hw_perf_enable_all() is unused
Message-ID: <20081219214943.GF2351@elte.hu>
References: <1229706687.7625.9.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229706687.7625.9.camel@jaswinder.satnam>
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Hello Ingo,
> 
> In arch/x86/kernel/cpu/perf_counter.c hw_perf_enable_all() is unused.
> 
> Are you keeping it for future reference.

no, i think we can remove it.

	Ingo

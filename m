Return-Path: <linux-kernel-owner+w=401wt.eu-S932774AbXGSUY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbXGSUY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbXGSUYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:24:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38229 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbXGSUYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:24:49 -0400
Date: Thu, 19 Jul 2007 22:24:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch] slub crashes with recent -git
Message-ID: <20070719202443.GA7475@elte.hu>
References: <20070719194234.GA27917@elte.hu> <alpine.LFD.0.999.0707191307220.27249@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707191307220.27249@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 19 Jul 2007, Ingo Molnar wrote:
> > 
> > i had to apply the patch below to make the kernel boot again.
> 
> A better patch should be the appended. Does that work for you too?

yeah, works fine!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo

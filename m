Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbXGPM62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbXGPM62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbXGPM6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:58:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46305 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301AbXGPM6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:58:20 -0400
Date: Mon, 16 Jul 2007 14:58:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched_cacheflush is now unused
Message-ID: <20070716125812.GA30635@elte.hu>
References: <20070716124706.GA14250@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716124706.GA14250@linux-mips.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ralf Baechle <ralf@linux-mips.org> wrote:

> Since Ingo's recent scheduler rewrite which was merged as commit
> 0437e109e1841607f2988891eaa36c531c6aa6ac sched_cacheflush is unused.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

yeah, indeed - i've added your patch to my queue of scheduler patches.

	Ingo

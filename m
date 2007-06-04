Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbXFDKFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbXFDKFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 06:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXFDKFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 06:05:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36210 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbXFDKF3 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 06:05:29 -0400
Date: Mon, 4 Jun 2007 12:04:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joachim Deguara <joachim.deguara@amd.com>
Cc: Matt Mackall <mpm@selenic.com>, "K.R. Foley" <kr@cybsft.com>,
       Linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: patch-2.6.21.3-rt9 misnamed?
Message-ID: <20070604100455.GA11274@elte.hu>
References: <465EE33B.4070502@cybsft.com> <20070531200109.GA8715@elte.hu> <20070601161111.GM11166@waste.org> <200706041127.37244.joachim.deguara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706041127.37244.joachim.deguara@amd.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Joachim Deguara <joachim.deguara@amd.com> wrote:

> > Including 2.6.21.3 in your patch will break ketchup.
> 
> ketchup already breaks with the current rt9 patch.

we'll release -rt10 probably later today, which will fix this. (it will 
be named 2.6.21.3-rt10 and will be against 2.6.21.3)

	Ingo

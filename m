Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbYBQTCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbYBQTCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYBQTCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:02:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45596 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbYBQTCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:02:42 -0500
Date: Sun, 17 Feb 2008 20:02:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] x86 - Move laptop drivers out of x86 Kconfig
Message-ID: <20080217190227.GG19263@elte.hu>
References: <20080208124721.16369.76502.stgit@localhost> <20080217182008.GZ6006@elte.hu> <200802171901.17698.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802171901.17698.carlos@strangeworlds.co.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Carlos Corbacho <carlos@strangeworlds.co.uk> wrote:

> On Sunday 17 February 2008 18:20:08 Ingo Molnar wrote:

> > i suspect this should be merged by the char driver tree which is 
> > affected by the addition of these new entries.
> 
> Where is such a tree, and who's responsible for it though? I grep'ed 
> MAINTAINERS and didn't turn up anyone.

Andrew i suspect in that case?

	Ingo

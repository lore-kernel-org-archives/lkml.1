Return-Path: <linux-kernel-owner+w=401wt.eu-S1764072AbYCDVBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764072AbYCDVBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756500AbYCDVBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:01:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56771 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406AbYCDVBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:01:34 -0500
Date: Tue, 4 Mar 2008 22:01:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: a P4 is a P6 not an i486
Message-ID: <20080304210111.GB31546@elte.hu>
References: <Pine.LNX.4.64.0803041929230.14934@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803041929230.14934@blonde.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1086]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hugh Dickins <hugh@veritas.com> wrote:

> P4 has been coming out as CPU_FAMILY=4 instead of 6: fix MPENTIUM4 
> typo.

thanks Hugh, applied.

	Ingo

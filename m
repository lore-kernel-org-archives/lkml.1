Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbYEPLcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbYEPLcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 07:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYEPLcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 07:32:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49338 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbYEPLcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 07:32:13 -0400
Date: Fri, 16 May 2008 13:31:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] print RT watchdog message
Message-ID: <20080516113156.GB6444@elte.hu>
References: <482CEA9A.7010504@ct.jp.nec.com> <482CF4A9.1020504@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482CF4A9.1020504@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> It's useful to detect which process is killed by RT watchdog.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

applied to -tip, thanks.

	Ingo

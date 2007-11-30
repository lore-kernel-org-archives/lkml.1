Return-Path: <linux-kernel-owner+w=401wt.eu-S933146AbXK3LGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbXK3LGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761073AbXK3LF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:05:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46835 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbXK3LF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:05:56 -0500
Date: Fri, 30 Nov 2007 12:05:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@googlemail.com>
Cc: suresh.b.siddha@intel.com, markus.t.metzger@intel.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       ak@suse.de, akpm@linux-foundation.org, markus.t.metzger@gmail.com,
       mtk-manpages@gmx.net
Subject: Re: [patch 1/2] x86, ptrace: support for branch trace store(BTS)
Message-ID: <20071130110530.GA31659@elte.hu>
References: <a430082a0711300252p62488863od4b1c2a162b9276f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a430082a0711300252p62488863od4b1c2a162b9276f@mail.gmail.com>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus Metzger <markus.t.metzger@googlemail.com> wrote:

> resend using a different mailer

hm, it does not apply to x86.git. You can fetch it via:

 git-pull git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm

	Ingo

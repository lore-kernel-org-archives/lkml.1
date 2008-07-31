Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbYGaKdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbYGaKdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbYGaKdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:33:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44611 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbYGaKdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:33:06 -0400
Date: Thu, 31 Jul 2008 12:32:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Barry Kasindorf <barry.kasindorf@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, Jason Yeh <jason.yeh@amd.com>
Subject: Re: [PATCH 0/24] oprofile: Add IBS support for AMD CPUs
Message-ID: <20080731103249.GF488@elte.hu>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <20080726095221.GB25890@elte.hu> <20080728140257.GO15356@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728140257.GO15356@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 26.07.08 11:52:21, Ingo Molnar wrote:
> > 
> > * Robert Richter <robert.richter@amd.com> wrote:
> > 
> > > Patches #1-3 are not directly related to IBS.
> > > Patch #4 adds generic support of model specific initialization.
> > > Patches #10, #11 add the core implementation of IBS.
> > > Patches #12-24 contain code improvements and small fixes.
> > 
> > cool stuff! I've created the tip/oprofile topic branch for the patches 
> > from you, Barry and Jason and have applied all the current patches (and 
> > followup fixes) to it. Below are the access coordinates and the log 
> > summary.
> > 
> > It's not yet integrated into tip/master - will do some testing first. 
> > I'll send review feedback separately as well, on a per patch basis.
> 
> Ingo,
> 
> thanks for adding the patches to tip/oprofile. I will send you more 
> patches that reflect the comments you made.

thanks. FYI, i've merged tip/oprofile into tip/master 5 days ago, and 
it's been problem-free so far in testing. I'll set up a branch for 
linux-next testing as well.

	Ingo

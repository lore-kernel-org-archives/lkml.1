Return-Path: <linux-kernel-owner+w=401wt.eu-S1759460AbYEMJzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbYEMJzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYEMJzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:55:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35080 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbYEMJzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:55:38 -0400
Date: Tue, 13 May 2008 11:55:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: Move es7000_plat out of mpparse.c
Message-ID: <20080513095528.GB24037@elte.hu>
References: <20080512152434.27570.7396.stgit@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512152434.27570.7396.stgit@thinkpad>
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


* Alexey Starikovskiy <astarikovskiy@suse.de> wrote:

>  arch/x86/kernel/mpparse.c         |   11 ++++++-----
>  arch/x86/mach-es7000/es7000plat.c |    2 ++
>  include/asm-x86/system.h          |    1 -
>  3 files changed, 8 insertions(+), 6 deletions(-)

thanks Alexey, applied.

	Ingo

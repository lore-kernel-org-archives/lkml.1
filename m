Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbXK0K0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbXK0K0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 05:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbXK0K0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 05:26:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38933 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbXK0K0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 05:26:04 -0500
Date: Tue, 27 Nov 2007 11:25:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1 - brick my Dell Latitude D820
Message-ID: <20071127102549.GA6286@elte.hu>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4210.1196147786@turing-police.cc.vt.edu> <20071126232703.c956addc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126232703.c956addc.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Otherwise, please proceed to work out which diff I need to drop and 
> hope like hell that it isn't git-x86..

hm? x86.git is fully bisectable - so a more accurate statement would be 
"and hope that it's x86.git, so that it can be properly bisected" :-) 
For x86.git bisection, pull the 'mm' branch from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

	Ingo

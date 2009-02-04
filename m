Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbZBDNqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbZBDNqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZBDNqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:46:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57374 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbZBDNqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:46:32 -0500
Date: Wed, 4 Feb 2009 14:46:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexey Fisher <bug-track@fisher-privat.net>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Bug #12417] glx performance drop with: "x86: PAT: implement
	track/untrack of pfnmap regions for x86 - v3"
Message-ID: <20090204134612.GB17024@elte.hu>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.dX.QwYiJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pWZw1SZjMCH.A.dX.QwYiJB@chimera>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12417
> Subject		: glx performance drop with: "x86: PAT: implement track/untrack of pfnmap regions for x86 - v3"
> Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
> Date		: 2009-01-06 18:46 (30 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5899329b19100c0b82dc78e9b21ed8b920c9ffb3
> References	: http://marc.info/?l=linux-kernel&m=123126782822696&w=4
> Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> 		  Ingo Molnar <mingo@elte.hu>
> 

this should be fixed in latest -git. Alexey, can you confirm?

	Ingo

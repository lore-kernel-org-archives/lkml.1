Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbZCUTwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbZCUTwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757505AbZCUTuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:50:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49619 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757552AbZCUTut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:50:49 -0400
Date: Sat, 21 Mar 2009 20:50:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>,
       Kevin Shanahan <kmshanah@flexo.wumi.org.au>,
       Kevin Shanahan <kmshanah@ucwb.org.au>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Message-ID: <20090321195024.GA25327@elte.hu>
References: <HPkmj74uawF.A.iqE.M8TxJB@chimera> <fnEpM0mQZjO.A.0nF.v8TxJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fnEpM0mQZjO.A.0nF.v8TxJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12465
> Subject		: KVM guests stalling on 2.6.28 (bisected)
> Submitter	: Kevin Shanahan <kmshanah@ucwb.org.au>
> Date		: 2009-01-17 03:37 (64 days old)
> References	: http://lkml.org/lkml/2009/3/15/51
> Handled-By	: Avi Kivity <avi@redhat.com>

It's still being investigated.

	Ingo

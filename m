Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZBHWNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZBHWNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbZBHWM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:12:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56501 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbZBHWM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:12:57 -0500
Date: Sun, 8 Feb 2009 23:12:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [Bug #12503] [slab corruption] BUG key_jar: Poison overwritten
Message-ID: <20090208221231.GA9160@elte.hu>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.z2G.h30jJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sWhNs83kKPE.A.z2G.h30jJB@chimera>
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
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12503
> Subject		: [slab corruption] BUG key_jar: Poison overwritten
> Submitter	: Ingo Molnar <mingo@elte.hu>
> Date		: 2009-01-15 18:16 (25 days old)
> References	: http://marc.info/?l=linux-kernel&m=123204353425825&w=4
> Handled-By	: David Howells <dhowells@redhat.com>

This slab corruption has not triggered again. It's either a very rare thing (in 
which case there's no realistic way to debug it via this angle), or it got fixed 
meanwhile.

Please close it. Thanks,

	Ingo

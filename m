Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbYKQJgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbYKQJgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 04:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYKQJgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 04:36:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46097 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbYKQJgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 04:36:32 -0500
Date: Mon, 17 Nov 2008 10:36:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11996] Tracing framework regression in 2.6.28-rc3
Message-ID: <20081117093614.GI28786@elte.hu>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera> <Q7OAnAv0V3D.A.GwE.gAGIJB@chimera> <20081117003531.4c8b5679@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117003531.4c8b5679@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Paalanen <pq@iki.fi> wrote:

> On Sun, 16 Nov 2008 17:35:18 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11996
> > Subject		: Tracing framework regression in 2.6.28-rc3
> > Submitter	: Pekka Paalanen <pq@iki.fi>
> > Date		: 2008-11-09 10:13 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122624392229317&w=4
> > Handled-By	: Steven Rostedt <rostedt@goodmis.org>
> 
> Steve, Ingo, did you get into an agreement on the patch? What should 
> I test?

the fix is queued up in tip/tracing/urgent, will send it to Linus 
today or tomorrow.

	Ingo

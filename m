Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbXKPGDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbXKPGDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 01:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbXKPGDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 01:03:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55880 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbXKPGDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 01:03:08 -0500
Date: Fri, 16 Nov 2007 07:02:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mark Knecht <markknecht@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Daniel Walker <dwalker@mvista.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: 2.6.24-rc2-rt1
Message-ID: <20071116060237.GC16273@elte.hu>
References: <1195152030.13982.48.camel@localhost.localdomain> <5bdc1c8b0711151241j5f1b8427w38d2a286eb6ebb7f@mail.gmail.com> <Pine.LNX.4.58.0711152232100.31778@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0711152232100.31778@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Do we still need to have the realtime-lsm.patch? It has been 
> considered obsolete for over a year now. Can we finally remove it.

yeah, we can drop it.

	Ingo

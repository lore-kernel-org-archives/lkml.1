Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbZDCRXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbZDCRXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933224AbZDCRWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:22:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42901 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167AbZDCRWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:22:49 -0400
Date: Fri, 3 Apr 2009 19:21:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ananth@in.ibm.com,
       fche@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [BUGFIX] request for picking fee039a1 up (Re: fee039a1 and
	ccbeed3a dependency)
Message-ID: <20090403172157.GL19982@elte.hu>
References: <20090331031822.GG6411@in.ibm.com> <49D259BD.1010402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D259BD.1010402@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi Linus,
> 
> Since the commit ccbeed3a changed pt_regs, kretprobe has to be
> updated (which was done by commit fee039a1) too.
> 
> Could you pick up the commit fee039a1 from Ingo's -tip tree or
> linux-next?

Yeah - i already sent the tracing tree to Linus which includes this 
bit too.

	Ingo

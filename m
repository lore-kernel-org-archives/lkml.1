Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZHGGud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZHGGud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 02:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbZHGGud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 02:50:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49705 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbZHGGuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 02:50:32 -0400
Date: Fri, 7 Aug 2009 08:50:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg KH <gregkh@suse.de>, Roland Dreier <rdreier@cisco.com>,
       Matt Fleming <matt@console-pimps.org>,
       David Kiliani <mail@davidkiliani.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL][2.6.31] tracing: have recordmcount.pl handle a
	section with only weak functions
Message-ID: <20090807065018.GA4118@elte.hu>
References: <ada4oskfwtp.fsf@cisco.com> <alpine.DEB.2.00.0908061745430.2840@gandalf.stny.rr.com> <20090806222906.GA14792@suse.de> <alpine.DEB.2.00.0908061844300.2840@gandalf.stny.rr.com> <alpine.DEB.2.00.0908061849260.2840@gandalf.stny.rr.com> <adamy6ceeig.fsf@cisco.com> <20090806233208.GA29339@suse.de> <alpine.DEB.2.00.0908062000400.2840@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908062000400.2840@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Steven Rostedt (1):
>       tracing: have recordmcount.pl handle a section with only weak functions
> 
> ----
>  scripts/recordmcount.pl |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

pulled, thanks Steve!

	Ingo

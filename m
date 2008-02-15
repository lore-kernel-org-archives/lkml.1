Return-Path: <linux-kernel-owner+w=401wt.eu-S1765583AbYBOAYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765583AbYBOAYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759915AbYBOAYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:24:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32860 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759413AbYBOAYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:24:00 -0500
Date: Fri, 15 Feb 2008 01:23:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] kprobes: remove sparse warnings from x86
Message-ID: <20080215002344.GA26095@elte.hu>
References: <1202945433.18204.28.camel@brick> <47B4595D.6030900@redhat.com> <1203012094.2748.51.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203012094.2748.51.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > It looks good to me.
> > 
> > Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
> > 
> > Thank you,
> 
> Ingo, could you take this in x86.git?

thanks Harvey, applied.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S932464AbZJFMbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbZJFMbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932430AbZJFMbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:31:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38234 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392AbZJFMbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:31:11 -0400
Date: Tue, 6 Oct 2009 14:30:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] tracing: Perf tracing fixes
Message-ID: <20091006123023.GA18953@elte.hu>
References: <19140.13582.223629.56214@cargo.ozlabs.ibm.com> <1254577650-5623-1-git-send-email-fweisbec@gmail.com> <20091005175411.GA5218@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005175411.GA5218@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0803]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Sat, Oct 03, 2009 at 03:47:28PM +0200, Frederic Weisbecker wrote:
> > Ingo,
> > 
> > Please pull these .33 tracing fixes from
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	tracing/core
> > 
> 
> 
> I've rebased it against latest Linus, you can pull it from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/urgent

Pulled, thanks a lot Frederic!

	Ingo

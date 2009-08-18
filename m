Return-Path: <linux-kernel-owner+w=401wt.eu-S1752081AbZHRHJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbZHRHJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 03:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZHRHJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 03:09:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47774 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbZHRHJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 03:09:26 -0400
Date: Tue, 18 Aug 2009 09:09:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [GIT PULL] tracing fix for 2.6.31
Message-ID: <20090818070910.GB25564@elte.hu>
References: <1250554422-5316-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250554422-5316-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the following tracing fix for .31
> 
> Thanks,
> Frederic.
> 
> 
> The following changes since commit df4ecf1524c7793de3121b2d4e5fc6bcc0da3bfb:
>   Linus Torvalds (1):
>         Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
> 	tracing/urgent
> 
> Zhaolei (1):
>       ftrace: Unify effect of writing to trace_options and option/*
> 
>  kernel/trace/trace.c |   12 ++----------
>  1 files changed, 2 insertions(+), 10 deletions(-)

Pulled into tracing/urgent, thanks!

	Ingo

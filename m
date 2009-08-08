Return-Path: <linux-kernel-owner+w=401wt.eu-S1751263AbZHHOyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbZHHOyD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 10:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbZHHOyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 10:54:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52295 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbZHHOyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 10:54:00 -0400
Date: Sat, 8 Aug 2009 16:53:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [GIT PULL] ring-buffer: Fix memleak in ring_buffer_free()
Message-ID: <20090808145355.GE25931@elte.hu>
References: <4A7C06B9.2090302@gmail.com> <alpine.DEB.2.00.0908071335380.1251@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908071335380.1251@gandalf.stny.rr.com>
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

> Ingo,
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Eric Dumazet (1):
>       ring-buffer: Fix memleak in ring_buffer_free()
> 
> ----
>  kernel/trace/ring_buffer.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Pulled, thanks Steve!

	Ingo

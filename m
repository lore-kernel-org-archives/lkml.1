Return-Path: <linux-kernel-owner+w=401wt.eu-S1751706Ab0AGJ14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab0AGJ14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654Ab0AGJ1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:27:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41122 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab0AGJ1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:27:46 -0500
Date: Thu, 7 Jan 2010 10:27:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Subject: Re: [PATCH 0/2][GIT PULL][2.6.33] ring-buffer: urgent changes
Message-ID: <20100107092732.GA482@elte.hu>
References: <20100107015920.827200859@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107015920.827200859@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
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
> David Sharp (1):
>       ring-buffer: Wrap a list.next reference with rb_list_head()
> 
> Steven Rostedt (1):
>       ring-buffer: Add rb_list_head() wrapper around new reader page next field
> 
> ----
>  kernel/trace/ring_buffer.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Pulled, thanks a lot Steve!

	Ingo

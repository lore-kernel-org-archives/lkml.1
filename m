Return-Path: <linux-kernel-owner+w=401wt.eu-S1762086AbZLKIEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086AbZLKIEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760686AbZLKIEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:04:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58348 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760691AbZLKIEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:04:10 -0500
Date: Fri, 11 Dec 2009 09:04:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL][v2.6.33] ring-buffer: resizing issues
Message-ID: <20091211080406.GA24652@elte.hu>
References: <20091211045003.107725797@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211045003.107725797@goodmis.org>
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
> Steven Rostedt (2):
>       ring-buffer: Use sync sched protection on ring buffer resizing
>       ring-buffer: Move resize integrity check under reader lock
> 
> ----
>  kernel/trace/ring_buffer.c |   29 +++++++++++------------------
>  1 files changed, 11 insertions(+), 18 deletions(-)

Pulled, thanks Steve!

	Ingo

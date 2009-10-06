Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZJFHQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZJFHQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZJFHQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:16:36 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:42432 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbZJFHQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cqQsoXJllQzIGV+lOyR2Xl0JLAJMivmg4HobMcGrvx3LAWqTqcv7PmbOCv4kO1ROWd
         slcM+WM26vIfliwTQItVHnQmHAT3DMrIlnY9O2rGaURuZPyMAxwJcXmZ7XvnhFeP0fnk
         +5Zdf8uPFtqpaNTxbI7LYmgvkT2z0m5lGJjoM=
MIME-Version: 1.0
In-Reply-To: <1254808849-7829-1-git-send-email-tzanussi@gmail.com>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com>
Date: Tue, 6 Oct 2009 09:16:24 +0200
Message-ID: <c62985530910060016k77beedc6ja5b89b9f80b03dbe@mail.gmail.com>
Subject: Re: [PATCH 0/3] a few tracing bugfixes
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       lizf@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/6, Tom Zanussi <tzanussi@gmail.com>:
> Some fixes for a few things I noticed recently.
>
> Tom Zanussi (3):
>   perf trace: Remove unused code in builtin-trace.c
>   perf trace: Update eval_flag() flags array to match interrupt.h
>   tracing/syscalls: Use long for syscall ret format and field
>     definitions
>
>  kernel/trace/trace_syscalls.c       |    4 ++--
>  tools/perf/builtin-trace.c          |    6 ------
>  tools/perf/util/trace-event-parse.c |    9 +++++----
>  3 files changed, 7 insertions(+), 12 deletions(-)

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks a lot!

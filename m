Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbZDIHbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbZDIHbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 03:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbZDIHbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 03:31:42 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:33159 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755936AbZDIHbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 03:31:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar4FAOc/3UlMQW1W/2dsb2JhbACBUsxdgjyBPwY
Date: Thu, 9 Apr 2009 03:26:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com, pq@iki.fi,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/urgent] tracing: consolidate documents
Message-ID: <20090409072638.GA20913@Krystal>
References: <49DD6E2B.6090200@cn.fujitsu.com> <tip-9f690b04fdf3fa5d7d6abab0bfd8628c3b91d503@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <tip-9f690b04fdf3fa5d7d6abab0bfd8628c3b91d503@git.kernel.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 03:26:17 up 40 days,  3:52,  1 user,  load average: 0.67, 0.41,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan (lizf@cn.fujitsu.com) wrote:
> Commit-ID:  9f690b04fdf3fa5d7d6abab0bfd8628c3b91d503
> Gitweb:     http://git.kernel.org/tip/9f690b04fdf3fa5d7d6abab0bfd8628c3b91d503
> Author:     Li Zefan <lizf@cn.fujitsu.com>
> AuthorDate: Thu, 9 Apr 2009 11:40:27 +0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 9 Apr 2009 05:54:42 +0200
> 
> tracing: consolidate documents
> 
> Move tracepoints.txt, ftrace.txt and mmiotrace.txt to the new
> directory trace/.
> 

We should probably move markers.txt while we are at it.

Mathieu

> I didnt find any references to those documents in both source
> files and documents, so no extra work needs to be done.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Pekka Paalanen <pq@iki.fi>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> LKML-Reference: <49DD6E2B.6090200@cn.fujitsu.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  Documentation/{ => trace}/ftrace.txt           |    0
>  Documentation/{tracers => trace}/mmiotrace.txt |    0
>  Documentation/{ => trace}/tracepoints.txt      |    0
>  3 files changed, 0 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/ftrace.txt b/Documentation/trace/ftrace.txt
> similarity index 100%
> rename from Documentation/ftrace.txt
> rename to Documentation/trace/ftrace.txt
> diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/trace/mmiotrace.txt
> similarity index 100%
> rename from Documentation/tracers/mmiotrace.txt
> rename to Documentation/trace/mmiotrace.txt
> diff --git a/Documentation/tracepoints.txt b/Documentation/trace/tracepoints.txt
> similarity index 100%
> rename from Documentation/tracepoints.txt
> rename to Documentation/trace/tracepoints.txt

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

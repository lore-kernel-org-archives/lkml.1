Return-Path: <linux-kernel-owner+w=401wt.eu-S1759103AbZDQDEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103AbZDQDEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 23:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZDQDEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 23:04:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62884 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbZDQDEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 23:04:25 -0400
Date: Thu, 16 Apr 2009 23:04:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: Remove include/trace/kmem_event_types.h
In-Reply-To: <49E7EF37.2080205@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0904162303500.20429@gandalf.stny.rr.com>
References: <49E7EF37.2080205@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 17 Apr 2009, Zhaolei wrote:

> kmem_event_types.h is no longer necessary since tracepoint definitions
> are put into include/trace/events/kmem.h
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  include/trace/kmem_event_types.h |  193 --------------------------------------
>  1 files changed, 0 insertions(+), 193 deletions(-)
>  delete mode 100644 include/trace/kmem_event_types.h
> 
> diff --git a/include/trace/kmem_event_types.h b/include/trace/kmem_event_types.h
> deleted file mode 100644
> index 4ff420f..0000000
> --- a/include/trace/kmem_event_types.h

Thanks,

During my many rewrites of the TRACE_EVENT macros, a git-rm was lost.

-- Steve


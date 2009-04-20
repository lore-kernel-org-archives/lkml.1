Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbZDTRLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbZDTRLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 13:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZDTRLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 13:11:16 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:60359 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbZDTRLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 13:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qqRqYAAFJt4B1b/0a/Yh6LVBZdNOmAGKJkhix73ja1BUa91I3Lt7obSOX6x12RZEcw
         yex6TaHbmv/q8+RUjjG4kBcV+9mnEpeNDeSr///RT0B2Y7lyZjkHSBYAjzr2ky8AFP94
         8zX6J8AxjYSGzIeSWRHzxSStaEPzwktv7vP9Y=
Date: Mon, 20 Apr 2009 19:11:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/1] ftrace, workqueuetrace: Make workqueue
	tracepoints use TRACE_EVENT macro
Message-ID: <20090420171107.GA5974@nowhere>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E82CA7.2040606@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 03:15:51PM +0800, Zhaolei wrote:
> v3: zhaolei@cn.fujitsu.com: Change TRACE_EVENT definition to new format
>     introduced by Steven Rostedt: consolidate trace and trace_event headers
> v2: kosaki@jp.fujitsu.com: print the function names instead of addr, and zap
>     the work addr



Kosaki-san, may I add you Signed-off-by on this one?
Since you participated in this patch.

Thanks.

Frederic.


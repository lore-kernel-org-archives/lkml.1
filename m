Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbZDQG5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbZDQG5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZDQG5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:57:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55864 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbZDQG5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:57:06 -0400
Message-ID: <49E8282A.6010004@cn.fujitsu.com>
Date: Fri, 17 Apr 2009 14:56:42 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 0/1] ftrace, workqueuetrace: Make workqueue tracepoints
 use TRACE_EVENT macro
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090415141250.AC46.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
...
> I understand you mean. thanks.
> My conclusion is follow,
> 
> Conclusion:
>  1/4	resend, but remove __entry->work
>  2/4	resend
>  3/4	remake as your suggestion
>  4/4	remake as your suggestion
>  5/4	dropped
> 
> but unfortunately I don't have enough development time. then,
> I and Zhaolei discuss this issue and we agreed Zaholei develop it.
Hi,

I decide to send 1/4 as a separate patch first.
2/4~4/4 will be a patchset, it will be send after finish codeing and testing.

Thanks
Zhaolei

> 
> Thanks!
> 
> 
> 
> 
> 



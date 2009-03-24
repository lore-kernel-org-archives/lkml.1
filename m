Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbZCXHp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbZCXHp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbZCXHpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:45:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60076 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756268AbZCXHpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:45:09 -0400
Message-ID: <49C88F0B.7070901@cn.fujitsu.com>
Date: Tue, 24 Mar 2009 15:43:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlz?= =?UTF-8?B?YmVja2Vy?= 
	<fweisbec@gmail.com>
Subject: Re: [PATCH][GIT PULL] tracing: fix memory leak in trace_stat
References: <alpine.DEB.2.00.0903210251100.13615@gandalf.stny.rr.com> <20090321094348.GB5594@elte.hu>
In-Reply-To: <20090321094348.GB5594@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> Ingo,
>>
>> Please pull the latest tip/tracing/ftrace tree, which can be found at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
>> tip/tracing/ftrace
>>
>>
>> Steven Rostedt (1):
>>       tracing: fix memory leak in trace_stat
>>
>> ----
>>  kernel/trace/trace_stat.c |   23 +++++++++++++----------
>>  1 files changed, 13 insertions(+), 10 deletions(-)
> 
> Pulled, thanks Steve!
> 
> 	Ingo
>

Hi, Ingo

I found this patch is not in the tip tree.

Thanks, Lai


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZIWSFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZIWSFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 14:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZIWSFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 14:05:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbZIWSFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 14:05:45 -0400
Message-ID: <4ABA63C9.9060708@redhat.com>
Date: Wed, 23 Sep 2009 11:07:05 -0700
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, acme@redhat.com,
       tglx@linutronix.de, postmaster@vger.kernel.org
Subject: Re: mailing list for trace users
References: <1253132182.20020.242.camel@gandalf.stny.rr.com> <20090922.153201.225375909.davem@davemloft.net> <20090923114725.GB4132@elte.hu> <4ABA50C2.6080607@redhat.com> <20090923170033.GA7410@elte.hu>
In-Reply-To: <20090923170033.GA7410@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>>>> What are people's thoughts about creating a linux-trace-users mailing
>>>>> list on vger.kernel.org?
>>>>
>>>> I've created this list.
>>>
>>> Could you please also create the linux-perf-users list, for perf events 
>>> and the perf tool related user questions? (We have asked for this before 
>>> but must have gotten lost somewhere)
>>
>> I thought perf users also talk on the linux tracing list.
> 
> No, there's a lot of non-tracing aspects of performance events. It does 
> profiling, counting, latency analysis, etc.

So, will it include topics about oprofile,readprof too?

>> What will linux-tracing-users cover, only ftrace?
> 
> It would cover whenever users want to talk about tracing.

Hmm, in that case, on which list should I ask 'how can I
use perf-trace?' and 'how can I use perf-record'? :-)
Maybe I'm just a bit confusing ...

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


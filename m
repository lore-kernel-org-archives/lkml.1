Return-Path: <linux-kernel-owner+w=401wt.eu-S1751281AbZIVAr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbZIVAr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 20:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbZIVAr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 20:47:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53577 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbZIVAr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 20:47:57 -0400
Message-ID: <4AB81E70.4060103@cn.fujitsu.com>
Date: Tue, 22 Sep 2009 08:46:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>, postmaster@vger.kernel.org
Subject: Re: mailing list for trace users
References: <1253132182.20020.242.camel@gandalf.stny.rr.com> <20090921191729.GE5018@nowhere>
In-Reply-To: <20090921191729.GE5018@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Wed, Sep 16, 2009 at 04:16:22PM -0400, Steven Rostedt wrote:
>> What are people's thoughts about creating a linux-trace-users mailing
>> list on vger.kernel.org?
>>
>> This would be a place for users of tracers and even perf. For asking
>> questions about how to use the debugfs/tracing directory or the perf
>> tool.
>>
>> This will not be a place for kernel development. Patches for the tracing
>> infrastructure should still go through LKML. This will be a place to ask
>> how-to questions, or any other kind of help questions.
>>
>> LKML can be quite intimidating, and it is not a place to ask help
>> questions anyway. I think adding a linux-trace-users mailing list would
>> be a good idea.
>>
>> Thoughts?
>>
>> -- Steve
> 
> 
> Why not. That could also gather informations from LKML threads by
> Cc'ing it while explaining how to use the tools in random discussions.
> 

+1

And then the mailing list needs to be renamed to linux-trace. And
we need to advertise it, in Documentation, Kconfig?


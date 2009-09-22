Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbZIVTPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbZIVTPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbZIVTPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:15:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbZIVTPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:15:31 -0400
Message-ID: <4AB9221A.8010507@redhat.com>
Date: Tue, 22 Sep 2009 22:14:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>, postmaster@vger.kernel.org
Subject: Re: mailing list for trace users
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>	 <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net>	 <4AB8BA37.4010305@redhat.com> <1253620488.13917.29.camel@marge.simson.net>	 <1253627604.7272.17.camel@marge.simson.net>  <4AB8D930.1090308@redhat.com> <1253646556.7240.4.camel@marge.simson.net>
In-Reply-To: <1253646556.7240.4.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2009 10:09 PM, Mike Galbraith wrote:
> On Tue, 2009-09-22 at 17:03 +0300, Avi Kivity wrote:
>    
>> On 09/22/2009 04:53 PM, Mike Galbraith wrote:
>>      
>>> Parses fine here, and INSTALL_MOD_STRIP=1 made zero difference.  can you
>>> send me that module and .config gzipped up?
>>>
>>>
>>>        
>> Sent privately.
>>      
> I can reproduce with your config, so do don't (thankfully) need to rip
> binary apart looking for tools things.  Will take a look.
>    

Thanks!  While trace/perf still have some rough edges, they've already 
proven incredibly valuable for debugging and performance analysis.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


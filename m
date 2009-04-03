Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbZDCMeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbZDCMeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbZDCMeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:34:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42116 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbZDCMeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:34:19 -0400
Message-ID: <49D60212.70701@redhat.com>
Date: Fri, 03 Apr 2009 15:33:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Masami Hiramatsu <mhiramat@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       kvm@vger.kernel.org, systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
References: <49D4F4B5.9040107@redhat.com> <20090403112639.GC31399@elte.hu> <49D5F80B.7000305@redhat.com> <20090403121202.GI31399@elte.hu> <49D5FE42.5080100@redhat.com> <20090403122654.GA19451@elte.hu>
In-Reply-To: <20090403122654.GA19451@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> Problem is, anyone versed in the kvm emulator will want to run as 
>> far away from this work as possible.
>>     
>
> Are you suggesting that the KVM emulator should never have been 
> merged in the first place? ;-)
>   

Truth always comes out eventually.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


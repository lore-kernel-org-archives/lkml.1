Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbYG0KLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbYG0KLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 06:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbYG0KL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 06:11:26 -0400
Received: from il.qumranet.com ([212.179.150.194]:36489 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYG0KLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 06:11:25 -0400
Message-ID: <488C49CC.8040800@qumranet.com>
Date: Sun, 27 Jul 2008 13:11:24 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Frank Ch. Eigler" <fche@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org
Subject: Re: [patch 0/4] Port KVM-trace to tracepoints -> LTTng ?
References: <20080717155724.897537670@polymtl.ca> <48862A30.7050701@qumranet.com> <y0mabg991c3.fsf@ton.toronto.redhat.com> <488635A7.2030609@qumranet.com> <20080722221204.GA14661@Krystal>
In-Reply-To: <20080722221204.GA14661@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:

  

>> Yes, but the userspace side would collect the format strings as well (just 
>> once) and could put them in the same file.  The aggregation is portable 
>> across kernel versions.
>>
>>     
>
> Yes,
>
> LTTng does exactly all that.
>
>
>   

[snip goodies]

> I'll be more than happy to answer your questions.
>   

What's the merge plan for this?

-- 
error compiling committee.c: too many arguments to function


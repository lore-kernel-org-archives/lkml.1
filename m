Return-Path: <linux-kernel-owner+w=401wt.eu-S933231AbXEKULs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbXEKULs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759196AbXEKULm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:11:42 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:55037 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758977AbXEKULl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:11:41 -0400
Message-ID: <4644CDF7.7080805@simon.arlott.org.uk>
Date: Fri, 11 May 2007 21:11:35 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] spelling fixes: kernel/
References: <4644C79D.40803@simon.arlott.org.uk> <20070511200125.GA6235@elte.hu>
In-Reply-To: <20070511200125.GA6235@elte.hu>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/07 21:01, Ingo Molnar wrote:
> * Simon Arlott <simon@fire.lp0.eu> wrote:
> 
>> kernel/sched.c            |   20 ++++++++++----------
> 
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
> 
>>  * This is how migration works:
>>  *
>> - * 1) we queue a struct migration_req structure in the source CPU's
>> - *    runqueue and wake up that CPU's migration thread.
>> + * 1) we queue a struct migration_req structure in the source CPUs
>> + *    runqueue and wake up that CPUs migration thread.
> 
> the original is correct - this is a possessive form.

Sorry, I converted so many "TLA's" that by the end I probably wasn't paying 
as much attention to them as I should have.

>> - * their home CPUs. So we just add the counter to another CPU's counter,
>> + * their home CPUs. So we just add the counter to another CPUs counter,
> 
> ditto.
> 
> all the other spelling fixes to sched.c are fine, thanks!
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> 	Ingo

-- 
Simon Arlott

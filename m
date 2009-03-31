Return-Path: <linux-kernel-owner+w=401wt.eu-S1761512AbZCaEtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761512AbZCaEtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 00:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZCaEs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 00:48:58 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:59737 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZCaEs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 00:48:57 -0400
Message-ID: <49D1A0B2.5070009@us.ibm.com>
Date: Mon, 30 Mar 2009 21:48:50 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [tip PATCH v6 0/8] requeue pi implementation
References: <20090330213306.606.9540.stgit@Aeon> <alpine.DEB.2.00.0903302208390.3843@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0903302208390.3843@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 
> 
> On Mon, 30 Mar 2009, Darren Hart wrote:
>> Darren Hart (8):
>>       RFC: futex: add requeue_pi calls
>>       RFC: futex: Add requeue_futex() call
>>       RFC: futex: Add FUTEX_HAS_TIMEOUT flag to restart.futex.flags
> 
> I just finished reviewing the first three patches, and I don't see 
> anything wrong with them. I'll review more tomorrow, but just for now, you 
> can add on to the first three:
> 
> Reviewed-by: Steven Rostedt <srostedt@redhat.com>

Thanks Steven!

I presume you mean the FIRST three, as in 0/8, 1/8, and 2/8 as opposed 
to the top three above which would be 6/8, 7/8, and 8/8 ?

> 
> -- Steve
> 
> 
>>       RFC: rt_mutex: add proxy lock routines
>>       RFC: futex: finish_futex_lock_pi()
>>       RFC: futex: futex_lock_pi_atomic()
>>       RFC: futex: futex_top_waiter()
>>       RFC: futex: futex_wait_queue_me()
>>


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

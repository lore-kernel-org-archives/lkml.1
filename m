Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbZCLPWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbZCLPWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbZCLPV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:21:59 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51302 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624AbZCLPV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:21:58 -0400
Message-ID: <49B9287A.1080506@us.ibm.com>
Date: Thu, 12 Mar 2009 08:21:30 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/6] Futex fixes and cleanups
References: <20090312075349.9856.83687.stgit@Aeon> <20090312122233.GA24185@elte.hu>
In-Reply-To: <20090312122233.GA24185@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Darren Hart <dvhltc@us.ibm.com> wrote:
> 
>> Hi Ingo,
>>
>> Here are some assorted futex fixes that I was hoping to get 
>> upstream in preparation for my requeue_pi patchset in the near 
>> future.  They can found at the following git repository:
> 
> applied, thanks Darren!
> 
> I'm wondering, which ones are 2.6.29 must-have's?
> 
> 	Ingo


Hi Ingo,

I'd think only 2 and maybe 5 should be considered for 2.6.29.  Tglx 
mentioned 2, and I'd be fine with 5 waiting until 2.6.30 I think.  The 
rest are cleanups.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

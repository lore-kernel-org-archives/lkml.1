Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYF1L4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYF1L4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 07:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYF1Lz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 07:55:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58948 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYF1Lz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 07:55:56 -0400
Message-ID: <486626C8.7070705@firstfloor.org>
Date: Sat, 28 Jun 2008 13:55:52 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Tim Connors <tconnors@astro.swin.edu.au>
CC: Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
       balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com> <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com> <48640C04.9020600@firstfloor.org> <1214516584.12265.10.camel@twins.programming.kicks-ass.net> <48641A7D.6080204@firstfloor.org> <1214553090.2801.7.camel@twins.programming.kicks-ass.net> <48649F84.4090501@firstfloor.org> <12146524137149-twc@hexane.ssi.swin.edu.au>
In-Reply-To: <12146524137149-twc@hexane.ssi.swin.edu.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Connors wrote:
> Andi Kleen <andi@firstfloor.org> said on Fri, 27 Jun 2008 10:06:28 +0200:
>> Peter Zijlstra wrote:
>>> disappeared then I'd call that a huge usability regression. Basically
>>> making ondemand useless.
>>>
>>> /me checks,..
>>>
>>> Yeah, on F9, my opteron runs at 1GHz when idle, but when I start distcc,
>>> which like said runs on nice 19, the cpu speed goes up to 2.4GHz.
>> Ok distcc is a special case, 
> 
> No it's not. 

You're arguing against the current default of ondemand then.

-Andi

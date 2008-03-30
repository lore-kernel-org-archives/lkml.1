Return-Path: <linux-kernel-owner+w=401wt.eu-S1751663AbYC3ABu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbYC3ABu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 20:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbYC3ABk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 20:01:40 -0400
Received: from proxy1.bredband.net ([195.54.101.71]:51751 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYC3ABk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 20:01:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqdlAFZ17kdT48OPPGdsb2JhbACBWoZViQkBAQEBMJZ8
Message-ID: <47EED858.7010605@coderworld.net>
Date: Sun, 30 Mar 2008 01:01:28 +0100
From: Richard Jonsson <richie@coderworld.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Keyboard weirdness: keys get stuck
References: <47EEA097.5000701@coderworld.net> <47EEC51C.2060806@coderworld.net> <20080329234358.GA28667@linux.vnet.ibm.com>
In-Reply-To: <20080329234358.GA28667@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani skrev:
> On Sat, Mar 29, 2008 at 11:39:24PM +0100, Richard Jonsson wrote:
>> Richard Jonsson skrev:
>>> With 2.6.25-rc6-git-something I have experienced stuck keys. When typing a 
>>>  sentence a character repeats aboooooooout 10 times, or as 'about' above 
>>> ;). I tested with a new kernel today, 2.6.25-rc7-git-something and the 
>>> problem is still present.
>>>
>>> With 2.6.25-rc3 the keyboard is fine, and I've not tried with any kernel 
>>> in between.
>>>
>>> As a side note, timestamps gets mixed up in dmesg output in a 1-2 second 
>>> span. Maybe related?
>>>
>>> This is on a HP dv2140eu laptop, x86_64 SMP. Please cc me if you want 
>>> configuration details or testing to be done.
>>>
>> I should add that while watching a movie I noticed that video stutters 
>> every now and then, on an irregular basis. It lasts for approx a second 
>> each time.
> 
> Can you check if you have CONFIG_GROUP_SCHED enabled? If so, can you
> disable and test?
> 

Yes it's enabled, will try without groupsched.

regards, Richard

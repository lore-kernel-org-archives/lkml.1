Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbZBEAhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbZBEAhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbZBEAhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:37:20 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:8104 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbZBEAhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:37:19 -0500
Message-ID: <498A34B9.9050005@ct.jp.nec.com>
Date: Wed, 04 Feb 2009 16:37:13 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: mm: introduce helper function in fault.c
References: <498A2399.4090503@ct.jp.nec.com> <498A2FAF.60503@zytor.com> <20090205001945.GE15680@elte.hu> <498A3110.2020208@zytor.com> <20090205002402.GF15680@elte.hu>
In-Reply-To: <20090205002402.GF15680@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> Ingo Molnar wrote:
>>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>>> Hiroshi Shimamoto wrote:
>>>>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>>>>
>>>>> Impact: cleanup
>>>>>
>>>>> Introduce helper function fault_in_kernel_address() to make editors happy.
>>>>>
>>>>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>>> Applied to tip:x86/mm, however, I had to apply the patch manually.
>>> that's because the patch was against tip:master - so that's fine, we 
>>> have some other topics that interact. (tip:core/locking in this case) I 
>>> resolved the conflict in tip/master and pushed it out.
>>>
>> Of course.  I mentioned it just as a warning for screwups on my part (in  
>> fact, I briefly pushed a totally bogus version since I had made an edit  
>> but forgotten to "git add" it.)
> 
> ok :) Hiroshi, please double-check the end result in tip:master if you have 
> some time.

OK, thanks. Will look at tip:master.

Hiroshi

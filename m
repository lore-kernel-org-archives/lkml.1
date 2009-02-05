Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbZBEAWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbZBEAWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbZBEAVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:21:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60375 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbZBEAVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:21:52 -0500
Message-ID: <498A3110.2020208@zytor.com>
Date: Wed, 04 Feb 2009 16:21:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: mm: introduce helper function in fault.c
References: <498A2399.4090503@ct.jp.nec.com> <498A2FAF.60503@zytor.com> <20090205001945.GE15680@elte.hu>
In-Reply-To: <20090205001945.GE15680@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> Hiroshi Shimamoto wrote:
>>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>>
>>> Impact: cleanup
>>>
>>> Introduce helper function fault_in_kernel_address() to make editors happy.
>>>
>>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> Applied to tip:x86/mm, however, I had to apply the patch manually.
> 
> that's because the patch was against tip:master - so that's fine, we have 
> some other topics that interact. (tip:core/locking in this case) I resolved 
> the conflict in tip/master and pushed it out.
> 

Of course.  I mentioned it just as a warning for screwups on my part (in 
fact, I briefly pushed a totally bogus version since I had made an edit 
but forgotten to "git add" it.)

	-hpa


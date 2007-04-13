Return-Path: <linux-kernel-owner+w=401wt.eu-S1030455AbXDMXlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455AbXDMXlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030476AbXDMXlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:41:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:19181 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030455AbXDMXll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=BNLqdxD3PmHP5s8CTbtYhGS8BUwGpDwMfiwsjCwQD5rIszJLpREB5znw5KOy20KF7upW85FlrbftXu7bxN2l0x7pTA4pONs/Yk8M8p86rRYhFFOgGSkFLL286Rh16obf06XyGnlAE0vAhCWOINjpvJSsQUaAA2bZeAC8bDUm1Cw=
Message-ID: <462014CA.1040104@googlemail.com>
Date: Sat, 14 Apr 2007 01:39:54 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070207)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu> <46200D47.70108@googlemail.com> <20070413232550.GB15894@elte.hu>
In-Reply-To: <20070413232550.GB15894@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Gabriel C <nix.or.die@googlemail.com> wrote:
>
>   
>>> as usual, any sort of feedback, bugreports, fixes and suggestions 
>>> are more than welcome,
>>>       
>> Compile error here.
>>     
>
> ah, !CONFIG_SMP. Does the patch below do the trick for you? (I've also 
> updated the full patch at the cfs-scheduler URL)
>   

Yes it does , thx :) , only the " warning: unused variable 'j' " left.

> 	Ingo
>   

Regards,

Gabriel


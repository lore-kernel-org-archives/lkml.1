Return-Path: <linux-kernel-owner+w=401wt.eu-S1767660AbXCIXiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767660AbXCIXiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767662AbXCIXiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:38:23 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:54909 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767660AbXCIXiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:38:21 -0500
Message-ID: <45F1EFEC.5060106@vmware.com>
Date: Fri, 09 Mar 2007 15:38:20 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309201257.GA5761@elte.hu> <Pine.LNX.4.64.0703091305090.10832@woody.linux-foundation.org> <20070309213607.GA16796@elte.hu> <20070309231041.GA712@elte.hu>
In-Reply-To: <20070309231041.GA712@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> [...] If that is the case then my ABI worries would indeed be wrong 
>> and i'd owe Zach a big fat apology [and more] for my flames ;-)
>>     
>
> that apology i very much owe to Zach no matter what the outcome of the 
> discussion. Zach, some of my mindless characterisations of the quality 
> of VMI code (and of your intentions) were really out of bound and were 
> unfair, and i'd like to apologize for that :-/
>   

That's fine.  Despite not having an open source hypervisor, we really 
don't have evil intentions, and we really don't want to create tension 
or impede the progress of anyone else.  We think this work has positive 
benefits for Linux, our hypervisor, and others as well.

Some of our code did very much need fixing, and the positive thing we 
can take away from such a heated discussion is that we probably got more 
eyes on our code, maybe trying to find the evil, and instead finding 
bugs or things we could have done better.

At least someone did need to play devil's advocate, as this is an 
important thing to get right for the future direction of Linux, and I 
respect you for doing so, and don't take offense.

Zach

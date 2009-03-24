Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZCXXOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZCXXOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZCXXOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:14:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46325 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbZCXXOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:14:39 -0400
Message-ID: <49C96728.8070808@zytor.com>
Date: Tue, 24 Mar 2009 16:05:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: Re: 2.6.30 Xen merge plan (what's in xen.git)
References: <49C915A3.3020809@goop.org> <20090324174859.GB31117@elte.hu> <49C921A8.3090200@goop.org>
In-Reply-To: <49C921A8.3090200@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> hpa wanted dom0 changes in some cleaner fashion - he knows the 
>> details. (he'll be back in a few days)
> 
> When I spoke to him last week about this he said he was OK with it.  He 
> didn't make any specific (or even general) objections.  Do you know 
> which subsystem he was referring to?
> 

I was mostly objecting to the apic patches -- I'm okay with the latest 
version, as long as they aren't in hot code (I never got the time to 
measure it.)

Other than that: the x86-touching bits seemed okay, the pure xen code... 
well, it's not my problem.

I'll be back on Saturday.

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S968191AbXEHPc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968191AbXEHPc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966388AbXEHPYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:24:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966423AbXEHPUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:20:11 -0400
Message-ID: <46409512.5000502@redhat.com>
Date: Tue, 08 May 2007 11:19:46 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@basil.nowhere.org>
Subject: Re: Please revert 86c0baf123e474b6eb404798926ecf62b426bf3a
References: <20070508134928.GA13212@flint.arm.linux.org.uk> <alpine.LFD.0.98.0705080815480.3974@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705080815480.3974@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Linus Torvalds wrote:
> On Tue, 8 May 2007, Russell King wrote:
>   
>> Shall I invent __CPUINIT to mark data to always be thrown away, or are
>> the x86 folk going to withdraw this patch and do it properly?
>>     
>
> I can certainly revert the patch, but it would probably be better if you 
> were to just start adding the infrastructure you need and send it as a new 
> patch instead (where the revert is part of it, and the __CPUINIT is 
> additional). 
>
>   

I've sent Russell a new patch to test off-list.  He or I will submit a 
fix here after he tests.

P.

> 		Linus
>   

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbYAVPNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbYAVPNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 10:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYAVPNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 10:13:01 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:42404 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbYAVPNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 10:13:00 -0500
Message-ID: <4796081A.7060505@davidnewall.com>
Date: Wed, 23 Jan 2008 01:43:30 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
References: <20080119045918.GA12215@basil.nowhere.org> <4792B191.2060801@davidnewall.com> <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com> <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com> <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122111205.GA25090@elte.hu>
In-Reply-To: <20080122111205.GA25090@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * David Newall <davidn@davidnewall.com> wrote:
>   
>> Andi Kleen wrote:
>>     
>>> You seem to be under the illusion that iBCS2 support works currently
>>> in mainline and that only this patch would break it.
>>>       
>> I cannot imagine what brings you to that conclusion.  Suffice to say 
>> you are entirely and inexplicably wrong.
>>     
>
> it should be very easy for you to prove me wrong then. I've got a very 
> simple question: please tell me, how do i run a binary compiled for an 
> iBCS2 platform under Linux v2.6.23?
>   

You're being silly.  Either that or you're not reading what I write. 
You know perfectly well iBCS2 compatibility doesn't work (anymore.)  The
question, in my mind, is will it ever be made to work again?  I think
the answer should be yes.

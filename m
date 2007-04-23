Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbXDWID6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbXDWID6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbXDWID6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:03:58 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:52541 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbXDWID5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:03:57 -0400
Message-ID: <462C6863.2050003@free.fr>
Date: Mon, 23 Apr 2007 10:03:47 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: tglx@timesys.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, linux.kernel@free.fr
Subject: Re: PREEMPT_RT: 2.6.20-rt8 patch tweaked for 2.6.20.7
References: <4628BD0E.3040206@free.fr> <1177311677.30986.5.camel@localhost.localdomain>
In-Reply-To: <1177311677.30986.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> On Fri, 2007-04-20 at 15:15 +0200, John Sigler wrote:
>
>> I've tweaked patch-2.6.20-rt8(*) so that it applies to 2.6.20.7
>> (*) http://rt.wiki.kernel.org/index.php/Main_Page
>>
>> The original patch can be found here:
>> http://people.redhat.com/mingo/realtime-preempt/older/patch-2.6.20-rt8
>> http://linux.kernel.free.fr/patch-2.6.20-rt8
>>
>> diff to the original patch to show what was tweaked:
>> http://linux.kernel.free.fr/patch-2.6.20-rt8.diff
>>
>> New patch that applies cleanly to 2.6.20.7:
>> http://linux.kernel.free.fr/patch-2.6.20.7-rt8
>>
>> As always, if someone spots something I've done wrong,
>> I'd be happy to fix it in a hurry :-)
>>
>> Ingo, Thomas, are there any fixes that were included in the 2.6.21-rt
>> branch only that need to be back-ported to the 2.6.20-rt branch?
> 
> I've been busy with mainline merge of highres timers lately, so I have
> no good overview of the -rt state at the moment, but I will check on
> this later that week.
> 
> Can you create an entry in the rt-wiki, so people can find your
> patches ?

Sure.

Should I add a link to my patch on the "CONFIG PREEMPT RT Patch" page?
http://rt.wiki.kernel.org/index.php/CONFIG_PREEMPT_RT_Patch#Download

e.g. in the "Download" section, something along the lines of:

"An updated version of the CONFIG_PREEMPT_RT patch (cleanly applies to
kernel 2.6.20.7) is also available."

I should probably mention that is not an officially sanctioned version,
and that it has not received the same scrutiny as other patches?

Regards.

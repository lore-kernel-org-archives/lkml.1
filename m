Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947Ab0ADUL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0ADUL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 15:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877Ab0ADULX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 15:11:23 -0500
Received: from 77.49.214.220.dsl.dyn.forthnet.gr ([77.49.214.220]:40450 "EHLO
	poseidon.vergina.dyndns.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083Ab0ADULW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 15:11:22 -0500
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jan 2010 15:11:22 EST
Message-ID: <4B424903.1000808@asyr.hopto.org>
Date: Mon, 04 Jan 2010 22:01:07 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091229 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: gentoo-user@lists.gentoo.org
CC: Joshua Murphy <poisonbl@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [gentoo-user] RAM installed vs reported
References: <4B3B3043.20400@asyr.hopto.org>	 <200912301208.54359.dirk.heinrichs@online.de>	 <4B3B38F2.6090006@asyr.hopto.org>	 <m3fx6r8a0l.fsf@intrepid.localdomain>	 <4B3CF04E.8070603@asyr.hopto.org>	 <m3vdfmosha.fsf@intrepid.localdomain>	 <4B406CDF.7010301@asyr.hopto.org>	 <m3aawulr8t.fsf@intrepid.localdomain>	 <4B4138AB.3060602@asyr.hopto.org> <c30988c31001040651l8351224l4eb1f1a54610653e@mail.gmail.com> <4B422A86.3070805@asyr.hopto.org>
In-Reply-To: <4B422A86.3070805@asyr.hopto.org>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 01/04/2010 07:51 PM Thanasis wrote the following:
> on 01/04/2010 04:51 PM Joshua Murphy wrote the following:
>> 2010/1/3 Thanasis <thanasis@asyr.hopto.org>:
>>   
>>> on 01/04/2010 01:10 AM Krzysztof Halasa wrote the following:
>>>     
>>>> Thanasis <thanasis@asyr.hopto.org> writes:
>>>>
>>>>       
>>>>> Hmm..., but are EMBEDDED options suitable for a netbook like the A110L ?
>>>>>
>>>> This "EMBEDDED" just means "don't touch these unless you really know
>>>> what you're doing".
>>>>
>>>> BTW I remember using VMSPLIT 2 GB : 2 GB on server-class machines,
>>>> before they were upgraded to x86-64.
>>>>
>>>>       
>>> Do you mean that I should try it? Is there any gain over using
>>> CONFIG_HIGHMEM4G ?
>>>     
>> Likely nothing noticeable, but here's a bit of a good coverage of the topic:
>>
>> http://kerneltrap.org/node/6067
>>
> Thanks, I think I'll give it a try. :-)
I tried option: 2G/2G user/kernel split (for full 2G low memory), but X
would not start. So i reverted back to CONFIG_HIGHMEM4G.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZBGDTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZBGDTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 22:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZBGDTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 22:19:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:35872 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbZBGDTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 22:19:24 -0500
Message-ID: <498CFD95.5070004@kernel.org>
Date: Fri, 06 Feb 2009 19:18:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: state of some x86 acpi patches
References: <4947FF4C.80706@goop.org> <20081216192534.GB843@elte.hu> <alpine.LFD.2.00.0812311821110.3854@localhost.localdomain> <495C677F.6080707@goop.org> <20090102153957.GA1180@elte.hu> <4980EE0C.4070308@goop.org> <49810211.9030808@kernel.org> <498CF8DA.30004@goop.org>
In-Reply-To: <498CF8DA.30004@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Yinghai Lu wrote:
>> Jeremy Fitzhardinge wrote:
>>  
>>> Ingo Molnar wrote:
>>>    
>>>> yes, that end result is the desired state of things. We did run with
>>>> this for several months and resolved all the cases that needed fixing,
>>>> but dropped them when the ACPI tree moved out from under us.
>>>>
>>>> Can resurrect it if Len feels OK about the concept. Len, you shouldnt
>>>> worry about conflicts - we can do it after the ACPI changes of this
>>>> merge window are upstream so there should be no conflict trouble at
>>>> all. How does that sound?
>>>>         
>>> Doesn't look like these changes made it in this time.  Did they get
>>> overlooked, or did some other problem come up?  Or did you want me to
>>> dig them up?
>>>
>>> Thanks,
>>>    J
>>>     
>>
>>
>> please check attached that are updated to today tip/master with ingo's
>> genapic patchset..
>>   
> 
> The look OK, but they didn't get merged into tip/master?
> 
Ingo is too busy...
It seems Len already agreed those patches can go through tip.

Ingo?

YH

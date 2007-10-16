Return-Path: <linux-kernel-owner+w=401wt.eu-S966346AbXJPWK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966346AbXJPWK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966012AbXJPWKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:10:45 -0400
Received: from rtr.ca ([76.10.145.34]:1466 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966023AbXJPWKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:10:43 -0400
Message-ID: <471536E2.9040508@rtr.ca>
Date: Tue, 16 Oct 2007 18:10:42 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression:  2.6.23-rc9 okay, 2.6.23.1 resume problems
References: <4712786B.3040009@rtr.ca> <200710142330.38057.rjw@sisk.pl> <47128C2C.5060502@rtr.ca>
In-Reply-To: <47128C2C.5060502@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Rafael J. Wysocki wrote:
>> On Sunday, 14 October 2007 22:13, Mark Lord wrote:
>>> Since upgrading to 2.6.23.1 from 2.6.23-rc9, resume-from-RAM has been 
>>> misbehaving here.
>>>
>>> It takes much (+5-7 seconds) longer to resume *sometimes*, but not 
>>> all/most of the time.
>>> And sometimes I get get flashing keyboard LEDs and have to hold the 
>>> power button
>>> in for a full hard reset.
>>>
>>> With 2.6.23-rc8/rc9, no such troubles.
>>>
>>> Difficult to reproduce, other than perhaps once a day.
>>> Anybody want to fess up with a likely candidate?
>>
>> Not really, but if you rule out all of the POWERPC and MIPS patches, 
>> there's
>> not much left ...
> 
> Yeah, I didn't see much there either.
> 
> I'll keep an eye on things over the next few days,
> and post again if it persists.
> 
> I was using the powertop patches with -rc9, but not with 2.6.23.1.
> Maybe they helped (???).

It still happens.

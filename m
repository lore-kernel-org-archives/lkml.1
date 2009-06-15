Return-Path: <linux-kernel-owner+w=401wt.eu-S1762776AbZFOP1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762776AbZFOP1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761640AbZFOP1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:27:30 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:35668 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762682AbZFOP13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:27:29 -0400
Message-id: <4A365B89.1020605@acm.org>
Date: Mon, 15 Jun 2009 09:32:41 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-version: 1.0
To: Martin Wilck <martin.wilck@ts.fujitsu.com>
Cc: Chaitanya Lala <clala@riverbed.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regarding patchwork patch #28003
References: <20090611173312.GA7450@clala-laptop> <4A314526.5030704@acm.org>
 <4A36092D.1020805@ts.fujitsu.com>
In-reply-to: <4A36092D.1020805@ts.fujitsu.com>
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Wilck wrote:
> Corey Minyard wrote:
>
>>> I have been facing the issue of the kipmid's CPU usage spiking since 
>>> a long time.
>>> I have tested the patch sent by Martin (limit CPU time spent in 
>>> kipmid (version 4)) and it solves the issue for me.
>>> I do not see any activity/feedback on the patch.
>>> Can I help in some-way to ensure that this patch is merged ?
>>>   
>> I will add this to the patchset I put out for 2.6.30, and if that 
>> goes well it will go into the mainstream kernel.
>
> Thanks a lot!
> I suppose the you will choose last version of the patch that I 
> submitted (http://marc.info/?l=linux-kernel&m=124414141924616&w=2)
>
> Martin
>
Yes, I picked up the latest one you mailed.

I was skeptical, but I have to say that it works very well.  This is 
definitely going in, assuming no one else reports any problems.

I'm dealing with some issues with changes in the serial driver, 
hopefully I'll have those out of the way today and can get a patch set 
out after some testing.

Thanks,

-corey

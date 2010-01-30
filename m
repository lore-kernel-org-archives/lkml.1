Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525Ab0A3TVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0A3TVZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491Ab0A3TVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:21:23 -0500
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:62518 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab0A3TVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:21:22 -0500
Date: Sat, 30 Jan 2010 14:21:37 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: [Bug #15125] hung task - jbd2/dm-1-8 (during raid rebuild)
In-reply-to: <201001250014.36889.rjw@sisk.pl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Message-id: <4B6486C1.9040402@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
 <hE3x9c-4KZM.A.shF.DKMXLB@chimera> <4B5CCE6D.5060402@majjas.com>
 <201001250014.36889.rjw@sisk.pl>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/24/2010 6:14 PM, Rafael J. Wysocki wrote:
> On Sunday 24 January 2010, Michael Breuer wrote:
>    
>> On 1/24/2010 5:04 PM, Rafael J. Wysocki wrote:
>>      
>>> This message has been generated automatically as a part of a report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.32.  Please verify if it still should be listed and let me know
>>> (either way).
>>>
>>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15125
>>> Subject		: hung task - jbd2/dm-1-8 (during raid rebuild)
>>> Submitter	: Michael Breuer<mbreuer@majjas.com>
>>> Date		: 2010-01-10 21:47 (15 days old)
>>> References	: http://marc.info/?l=linux-kernel&m=126316012025978&w=4
>>>
>>>
>>>        
>> Not an easy one to recreate. Should probably remain listed for now.
>>      
> Thanks for the update.
>
> Rafael
>    
Still happening on 2.6.33 rc5.

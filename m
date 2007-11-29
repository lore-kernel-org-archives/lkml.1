Return-Path: <linux-kernel-owner+w=401wt.eu-S934510AbXK2W5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934510AbXK2W5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933703AbXK2W5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:57:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:27530 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934326AbXK2W5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:57:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=x9gcqjddte55obsmaVl1MtbDVAwaVShXYDirWfpqgM4Q3pqX3/aUwLDyvPErT+1gBmvyLZaRjAfjrFoknK+qG/J8LDJmzDUoHmnFgL3eu4ah6OedOxvUPBJTMPRSzWqZ/Gt18Sl1JJqBgcv5WG2/Fk2f4hvy99dTB+Fki7mMq2E=
Message-ID: <474F43C0.6080008@gmail.com>
Date: Fri, 30 Nov 2007 07:57:04 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bjoern Olausson <lkmlist@gmail.com>
CC: jeff@garzik.org, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: sata NCQ blacklist entry
References: <20071107111813.GA9064@dudweiler.stuttgart.redhat.com>	 <4731B5DD.1060203@gmail.com> <5501535d0711290917r16a16b0dx36669de89f829231@mail.gmail.com>
In-Reply-To: <5501535d0711290917r16a16b0dx36669de89f829231@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjoern Olausson wrote:
> On 11/7/07, Tejun Heo <htejun@gmail.com> wrote:
>> Thanks.  We're currently trying to find out what's actually going on
>> with all these drives.  At first, drives which got blacklisted aren't
>> many and made sense (had other problems with NCQ, etc..) but with new
>> generation drives from many vendors showing the same symptom, we aren't
>> too sure now.
>>
>> I'll keep your email in my todo list and add the drive to the blacklist
>> once the problem is verified.
>>
>> Thanks.
> 
> Something new on the NCQ front?
> Just asking if you need someone to test some of your ideas?
> 
> I got the "WDC WD740ADFD-00NLR1"

I now have affected drives on my desk and am gonna try reproduce it.  My
gut feeling says it's timing related problem on controller / driver
side.  Please wait a bit.

> by the way, and OT, did the Plextor DVD-RW drive reach you, Tejun?

No, not yet.  Do you have a tracking number or something?

Thanks.

-- 
tejun

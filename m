Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYBWXxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYBWXxa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 18:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbYBWXxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 18:53:19 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44115 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbYBWXxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 18:53:18 -0500
Message-ID: <47C0B1EA.4010400@garzik.org>
Date: Sat, 23 Feb 2008 18:53:14 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
References: <1203779614.3139.4.camel@localhost.localdomain>	<47C08134.2030205@garzik.org>	<alpine.LFD.1.00.0802231229320.21332@woody.linux-foundation.org> <20080223124445.db779e3c.akpm@linux-foundation.org>
In-Reply-To: <20080223124445.db779e3c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 23 Feb 2008 12:31:02 -0800 (PST) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>>
>> On Sat, 23 Feb 2008, Jeff Garzik wrote:
>>> I know I am probably shooting myself in the foot here, since I am the original
>>> author of mvsas, but...
>>>
>>> Should we be adding new drivers during -rc?
>> I'm personally of the opinion that a new driver that doesn't add anything 
>> but itself (ie no infrastructure changes etc) is fine. I'd rather have a 
>> new, rough driver that might work, than no driver at all, and it's not 
>> like it can cause a regression if you don't enable it.
>>
> 
> Yes, I too think that adding new standalone code in late -rc is OK.

ACK, thanks!

	Jeff




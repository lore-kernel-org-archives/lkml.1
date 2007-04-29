Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbXD2NDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbXD2NDA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 09:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbXD2NDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 09:03:00 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41202 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbXD2NC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 09:02:59 -0400
Date: Sun, 29 Apr 2007 15:01:54 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: linux1394-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/30] Use menuconfig objects - IEEE1394
In-Reply-To: <46333211.6030506@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.61.0704291454050.506@yvahk01.tjqt.qr>
References: <46333211.6030506@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>Jan Engelhardt wrote:
>>On Apr 28 2007 12:41, Stefan Richter wrote:
>>
>>> So, shall I put Jan's patch aside until there is only one stack left?
>>
>> Sort of. [...] when a menu has two or three choices (in this case:
>> larger subsystems), it's rand() for me whether or not to convert
>> to menuconfig. Feel free.
>
> I'll see if anybody out there will voice an opinion, to tip the
> balance one way or another.

Seems like silence. Anyway, your suggestion in 
http://lkml.org/lkml/2007/4/28/108 sounds not bad, and since it's cheap, 
I have the patch for it. (To be posted when I am through with more 
menus.)


Regards,
Jan
-- 

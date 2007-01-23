Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbXAWOXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbXAWOXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933003AbXAWOXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:23:15 -0500
Received: from xylophone.i-cable.com ([203.83.115.99]:44252 "HELO
	xylophone.i-cable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933001AbXAWOXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:23:14 -0500
Message-ID: <009101c73ef9$fdb561d0$28df0f3d@kylecea1512a3f>
From: "kyle" <kylewong@southa.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Steve Cousins" <steve.cousins@maine.edu>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <001801c73e14$c3177170$28df0f3d@kylecea1512a3f> <Pine.LNX.4.64.0701220717200.30260@p34.internal.lan> <45B4D0ED.7030500@maine.edu> <Pine.LNX.4.64.0701221000330.1711@p34.internal.lan>
Subject: Re: change strip_cache_size freeze the whole raid
Date: Tue, 23 Jan 2007 22:22:51 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2180
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I can try and do this later this week possibly.

> Justin.
>>
>> alt-sysrq-T or "echo t > /proc/sysrq-trigger" can be really helpful to
>> diagnose this sort of problem (providing the system isn't so badly
>> stuck that the kernel logs don't get stored).
>>
>> It is probably hitting a memory-allocation deadlock, though I cannot
>> see exactly where the deadlock would be.  If you are able to reproduce
>> it and can get the kernel logs after 'alt-sysrq-T' I would really
>> appreciate it.
>> Justin,Maybe you can try freeze it once more and get the kernel logs 
>> before try Neil's patch ...... :D~Kyle 


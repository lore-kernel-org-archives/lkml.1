Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbXGBRL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbXGBRL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 13:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbXGBRLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 13:11:20 -0400
Received: from mail.tmr.com ([64.65.253.246]:48366 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbXGBRLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 13:11:19 -0400
Message-ID: <46893264.8050908@tmr.com>
Date: Mon, 02 Jul 2007 13:14:12 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Tim Boneko <tim@boneko.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Old bug in tg3 driver unfixed?
References: <46864736.3090108@boneko.de>
In-Reply-To: <46864736.3090108@boneko.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Boneko wrote:
> Hello!
> I am not subscribed to this list so please CC answers to my mail
> address. THX!
> 
> I recently replaced the mainboard of one of my servers with a Tyan
> Tomcat K8E. The onboard gigabit NIC is a Broadcom BCM5721. After
> compiling and loading the tg3 driver in Kernel 2.6.21.5, the interface
> could not be configured: "Device not found".
> While searching the net i found a few other people with the same problem
> but no solution.
> 
> By coincidence i found that a simpe "ifconfig eth1" worked OK and
> afterwards the device could be configured and used as desired. After
> searching this list, i found this posting
> 
Probably unrelated, but what's eth0?

> http://uwsg.iu.edu/hypermail/linux/kernel/0409.0/0224.html
> 
> by someone with obviously the same problem.
> Has some patch of the driver been reversed or is the hardware buggy?
> 
> BTW the chip is connected via PCI Express.
> 
I have that chip in a system, but I didn't find it quickly, it may be at 
another location, unless the controller which shows up as 3C940 on my 
ASUS P4P800 is the Broadcom.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbXE2FZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbXE2FZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 01:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXE2FZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 01:25:09 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:46792 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbXE2FZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 01:25:08 -0400
Date: Mon, 28 May 2007 23:25:02 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Network broken in kernel level.
In-reply-to: <fa.FYU0TmYcs8tw7er8ovzop6Z2Qgc@ifi.uio.no>
To: Wang Penghui <wangpenghui@westea.org>
Cc: linux-kernel@vger.kernel.org
Message-id: <465BB92E.2000005@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.FYU0TmYcs8tw7er8ovzop6Z2Qgc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wang Penghui wrote:
> Hello, list,
> 
> Recently, i have messed up with the follow problem, i have two server
> both with two ethernet cards. Here are them:
> 
> [root@db1 ~]# lspci | grep -i eth
> 05:00.0 Ethernet controller: Marvell Technology Group Ltd. Gigabit
> Ethernet Controller (rev 18)
> 07:04.0 Ethernet controller: Intel Corp. 82541GI/PI Gigabit Ethernet
> Controller (rev 05)
> 
> And they are running MySQL server on both of them. The OS is RHEL 4 with
> the default kernel 2.6.9-5.ELsmp. These days there are lots of error
> message comming out in /var/log/message and dmesg.

That kernel is very old, you should get the latest RHEL errata update 
kernel and see if that helps. There have been hundreds of bugfixes in 
RHEL kernels since that version.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


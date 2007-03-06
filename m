Return-Path: <linux-kernel-owner+w=401wt.eu-S965414AbXCFRsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965414AbXCFRsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965415AbXCFRsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:48:16 -0500
Received: from mail.tmr.com ([64.65.253.246]:58887 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965410AbXCFRsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:48:15 -0500
Message-ID: <45EDA9DF.6030305@tmr.com>
Date: Tue, 06 Mar 2007 12:50:23 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
   scheduler
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org> <200703050453.08154.gene.heskett@gmail.com>
In-Reply-To: <200703050453.08154.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> On Monday 05 March 2007, Nicolas Mailhot wrote:
>> This looks like -mm stuff if you want it in 2.6.22
> 
> This needs to get to 2.6.21, it really is that big an improvement.
> 
As Con pointed out, for some workloads and desired behavour this is not 
as good as the existing scheduler. Therefore it should go in -mm and 
hopefully give the user an option to select which is appropriate.

With luck I'll get to shake out that patch in combination with kvm later 
today.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

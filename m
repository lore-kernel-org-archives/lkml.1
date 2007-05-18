Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbXERIup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbXERIup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 04:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbXERIuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 04:50:39 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:53244 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbXERIui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 04:50:38 -0400
Date: Fri, 18 May 2007 10:49:46 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: DervishD <lkml@dervishd.net>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
Subject: Re: usb-storage nice value
In-Reply-To: <20070518082158.GA2307@DervishD>
Message-ID: <Pine.LNX.4.61.0705181046260.3231@yvahk01.tjqt.qr>
References: <20070517100308.GA14667@DervishD> <464CB2B3.50506@s5r6.in-berlin.de>
 <20070518061512.GA32730@DervishD> <Pine.LNX.4.61.0705180829120.3231@yvahk01.tjqt.qr>
 <20070518082158.GA2307@DervishD>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 18 2007 10:21, DervishD wrote:
>
>> Or try echo 10 >/proc/sys/kernel/dirty_ratio
>
>    Not in my proc :?? Perhaps /proc/sys/vm/dirty_ratio? Mine is 40,
>which I think is too high.

Linus also thinks it is too high; I do not really care what it is set
at, as it depends on the use case.


	Jan
-- 

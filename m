Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbXEXQeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbXEXQeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbXEXQeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:34:04 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54879 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbXEXQeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:34:01 -0400
Date: Thu, 24 May 2007 18:33:00 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] add "notime" boot option
In-Reply-To: <4655BC2D.2070701@oracle.com>
Message-ID: <Pine.LNX.4.61.0705241832500.31549@yvahk01.tjqt.qr>
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
 <Pine.LNX.4.61.0705241812450.31549@yvahk01.tjqt.qr> <4655BC2D.2070701@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 24 2007 09:24, Randy Dunlap wrote:
>> 
>> Wonderful, now we have _three_ options to control time...
>> 
>> time=<bool>
>> printk.time=<bool>
>> notime=<bool>
>
> Currently the middle one is "printk.printk_time".
> And the first and last are just "time" and "notime", without a bool value.
>
> And as I wrote later, I'd be happy to remove #s 1 and 3 and use only the
> middle one, renaming the param so that it _is_ printk.time.

You get my (+) vote for that.



	Jan
-- 

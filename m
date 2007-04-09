Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbXDIQuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbXDIQuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbXDIQuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:50:46 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:60888 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbXDIQuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:50:44 -0400
Date: Mon, 9 Apr 2007 18:49:56 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Gene Heskett <gene.heskett@gmail.com>
cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
In-Reply-To: <200704091137.01336.gene.heskett@gmail.com>
Message-ID: <Pine.LNX.4.61.0704091848150.21426@yvahk01.tjqt.qr>
References: <200704091007.58535.gene.heskett@gmail.com> <461A5204.1050206@garzik.org>
 <200704091137.01336.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 9 2007 11:37, Gene Heskett wrote:
>On Monday 09 April 2007, Jeff Garzik wrote:
>>Gene Heskett wrote:
>>
>>No; device mapper is the kernel portion of LVM2.
>>
>>	Jeff, who actively avoids LVM on home computers
>
>Ya shoulda warned me.  :-)
>
>It should have lots bigger warning labels, in bright red self-illuminating 
>signs, than it does.

Actually, you have to blame some FC developer for making an LVM-based
setup the _default_ for home installs (aka "FC", enterprise is RHEL/¢OS).

>It in fact seems to work well, but it is a major 
>breakage for some common apps, like doing backups...

dm is on 254 for me.. in opensuse with a 2.6.20 that is. I wonder why it
even moves around. However, even then, those who use udev and device names
rather than (major,minor) tuples should not have any problem.


Jan
-- 

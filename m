Return-Path: <linux-kernel-owner+w=401wt.eu-S965379AbXDIPhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379AbXDIPhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965550AbXDIPhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:37:24 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:42596 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965379AbXDIPhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:37:22 -0400
Date: Mon, 09 Apr 2007 11:37:00 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: I give up
In-reply-to: <461A5204.1050206@garzik.org>
To: linux-kernel@vger.kernel.org
Cc: Jeff Garzik <jeff@garzik.org>
Message-id: <200704091137.01336.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704091007.58535.gene.heskett@gmail.com>
 <461A5204.1050206@garzik.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007, Jeff Garzik wrote:
>Gene Heskett wrote:
>> Now the 64k$ question: While running with LVM2 managed disks, is it
>> possible to run without dm_mod, the device-mapper?  If so, please tell
>> me how to achieve this.
>
>No; device mapper is the kernel portion of LVM2.
>
>	Jeff, who actively avoids LVM on home computers

Ya shoulda warned me.  :-)

It should have lots bigger warning labels, in bright red self-illuminating 
signs, than it does.  It in fact seems to work well, but it is a major 
breakage for some common apps, like doing backups...

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Gates' Law: Every 18 months, the speed of software halves. 

   -- From a Slashdot.org post

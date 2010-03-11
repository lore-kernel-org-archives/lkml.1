Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab0CKQ0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 11:26:53 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:37615 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab0CKQ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 11:26:49 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: tytso@mit.edu, Nikanth Karthikesan <knikanth@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Damian Lukowski <damian@tvk.rwth-aachen.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
Date: Thu, 11 Mar 2010 11:26:32 -0500
User-Agent: KMail/1.12.3 (Linux/2.6.33; KDE/4.3.3; i686; ; )
References: <4B947393.2050002@kernel.org> <201003112035.26743.knikanth@suse.de>
 <20100311152551.GG1497@thunk.org>
In-reply-to: <20100311152551.GG1497@thunk.org>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Message-id: <201003111126.32882.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 March 2010, tytso@mit.edu wrote:
>On Thu, Mar 11, 2010 at 08:35:26PM +0530, Nikanth Karthikesan wrote:
>> The real problem, here is just that partitioning-tools should create
>> partitions that can work with both XP as well as Windows7. May be distro
>> installers, should ask the user which compatibility he needs.
>
>4k aligned sectors will *work* with Windows XP, will it not?  It's
>just simply a matter of Windows XP, being really ancient, doesn't
>create properly alligned partitions by default.
>
>And how often are we going to see Windows XP systems with these new 4k
>physical sector drives anyway, where the first OS to touch the
>partition is Windows XP?  And in the case where this does happy, the
>resulting partition will be result in terribly performance for Windows
>XP as well as Linux.
>
>What's the specific scenario which you are trying to solve, and how
>likely is it to occur in real life?

And potentially one more question from a list lurker, Ted.  Where are the 
tools that allow us to check and/or adjust that?  I ask since I have 3 of 
these terrabyte drives in this box now and have no clue how to either check 
to see if we're off, or how to fix it if it is.  And I have called my self 
following this discussion without noting if the tools have been specifically 
named.

Thanks

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)

Authors are easy to get on with -- if you're fond of children.
		-- Michael Joseph, "Observer"

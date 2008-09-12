Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYILNvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYILNvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 09:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYILNu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 09:50:59 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:51724 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYILNu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:50:59 -0400
Date: Fri, 12 Sep 2008 09:50:30 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
In-reply-to: <20080912083927.GA13849@nineveh.local>
To: David Woodhouse <dwmw2@infradead.org>, Greg KH <greg@kroah.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       David Miller <davem@davemloft.net>, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Message-id: <200809120950.30866.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20080910.160505.14060698.davem@davemloft.net>
 <1221171943.4077.59.camel@macbook.infradead.org>
 <20080912083927.GA13849@nineveh.local>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 September 2008, Joseph Fannin wrote:
>On Thu, Sep 11, 2008 at 03:25:43PM -0700, David Woodhouse wrote:
>> On Thu, 2008-09-11 at 15:07 -0700, Greg KH wrote:
>
><snip>
>
>> Now, can we _please_ stop being bloody stupid? If there are _real_
>> problems, like the one I fixed with commit 1cede1af last week, then I'm
>> perfectly happy to deal with them. But stop making crap up.
>
>I CAN'T INSTALL MORE THAN ONE KERNEL PACKAGE > v2.6.26.
>
>IT'S NOT IMAGINARY.
>
>IT USED TO WORK AND YOU BROKE IT.
>
I've been building my own, and currently have about 10 kernels newer than 
2.6.26 sitting in my /boot partition, and they all work.  I'd suggest you 
investigate how you are maintaining your .config(uration)

>--
>Joseph Fannin
>jfannin@gmail.com
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
You would if you could but you can't so you won't.

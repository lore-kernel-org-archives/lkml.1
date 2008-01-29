Return-Path: <linux-kernel-owner+w=401wt.eu-S1762842AbYA2AHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762842AbYA2AHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757561AbYA2AGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:06:53 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:54815 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbYA2AGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:06:49 -0500
Date: Mon, 28 Jan 2008 19:06:44 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <479E3E7A.7000308@rtr.ca>
To: Mark Lord <lkml@rtr.ca>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Message-id: <200801281906.44892.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <200801281359.24050.gene.heskett@gmail.com> <479E3E7A.7000308@rtr.ca>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Mark Lord wrote:
>Gene Heskett wrote:
>> On Monday 28 January 2008, Mark Lord wrote:
>>..
>>
>>> Another way is to use the "make_bad_sector" utility that
>>> is included in the source tarball for hdparm-7.7, as follows:
>>>
>>>   make_bad_sector --readback /dev/sda 474507
>>
>> Apparently not in the rpm, darnit.
>
>..
>
>That's okay.  It should still be in the SRPM source file.
>And it's a tiny download from sourceforge.net:
>
>http://sourceforge.net/search/?type_of_search=soft&type_of_search=soft&words
>=hdparm
>
>Cheers

That's ok, dd seemed to do the job also.

Thanks Mark.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Those who do not understand Unix are condemned to reinvent it, poorly.
		-- Henry Spencer

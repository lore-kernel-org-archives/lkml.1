Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbXDZVCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbXDZVCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbXDZVCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:02:25 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:46981 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbXDZVCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:02:23 -0400
Date: Thu, 26 Apr 2007 17:02:21 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Linux 2.6.21
In-reply-to: <4630FA27.1090203@seclark.us>
To: Stephen.Clark@seclark.us
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <200704261702.21789.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
 <4630E9C8.5060000@garzik.org> <4630FA27.1090203@seclark.us>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007, Stephen Clark wrote:
>Jeff Garzik wrote:
>>IMO, the closer you look, the more warts you find.  Before you starting
>>doing your work with kernel regressions, no one was really tracking it.
>>  I bet you have helped cut down on the regressions, but I have no good
>>way to quantify my gut feeling.
>>
>>Additional comments on developers and fixing regressions:
>>
>>* Sometimes seeing a long list, peoples' eyes glaze over.  Its just
>>human nature.  A long list also gives us no idea of scale, or severity.
>>  I bet a weekly "top 10 bugs and regressions" email would help focus
>>developer attention.
>>
>>* To be effective, lists, either long or top-10, must be pruned if you
>>get a sense that only one user is affected.  [With oopses and BUGs as a
>>clear exception,] many problems benefit from at least two users
>>reporting a bug.
>>
>>* It gets a bit tiresome to field the large number of driver bug reports
>>that eventually turn out to be related to broken interrupt handling
>>somehow.  I think we developers need to get better at showing users how
>>to isolate driver vs. PCI/ACPI/core bugs.  Maybe drivers need to start
>>introducing interrupt delivery tests into their probe code.  Overall,
>>broken interrupt handling manifests in several ways, most of which
>>initially appear symptomatic of a broken driver.
>>
>>	Jeff
>>
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>Please read the FAQ at  http://www.tux.org/lkml/
>
>Jeff,
>
>If hardware worked in the previous version of the kernel can't users expect
> the same hardware to work in this kernel?
>
>Steve

I think that is indeed a reasonable expectation.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
It is exactly because a man cannot do a thing that he is a proper judge of it.
		-- Oscar Wilde

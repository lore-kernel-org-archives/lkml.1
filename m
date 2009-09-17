Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbZIQPjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbZIQPjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZIQPjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:39:13 -0400
Received: from mail-qy0-f181.google.com ([209.85.221.181]:49293 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZIQPjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:39:13 -0400
Message-ID: <4AB2581E.20902@monstr.eu>
Date: Thu, 17 Sep 2009 17:39:10 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
CC: Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
       Greg Ungerer <gerg@uclinux.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [microblaze-uclinux] Re: =?us-ascii?Q?=5Bmicroblaze=2Duclinux=5D=20Re=3A=20=5BPATCH=5D=20Actually=20show=20KiB=20rather=20than=20pages=20in=20=22Freeing=20initrd
References: <20090915165037.GA23702@csclub.uwaterloo.ca> <4AB1E78D.3070007@snapgear.com> <4AB1F9B0.10103@monstr.eu> <20090917152107.GX23700@csclub.uwaterloo.ca>
In-Reply-To: <20090917152107.GX23700@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



lsorense@csclub.uwaterloo.ca wrote:
> On Thu, Sep 17, 2009 at 10:56:16AM +0200, Michal Simek wrote:
>> Greg Ungerer wrote:
>>> Hi Lennart,
>>>
>>> Lennart Sorensen wrote:
>>>> Fix "Freeing initrd memory:" message on h3800, m68knommu and microblaze
>>>> to show kilobytes as claimed rather than number of pages.
>>>>
>>>> Signed-off-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
>>> Looks ok to me. I can take and push the m68knommu part separately.
>>> Or if Andrew wants to take it all as one, here is an:
>>>
>>> Acked-by: Greg Ungerer <gerg@uclinux.org>
>> As Greg wrote. It will be the best to push it separately. IMHO it
>> will be faster. It is up to you. If you want to add it to microblaze
>> branch please send only patch for microblaze.
>>
>> If not.
>>
>> Acked-by: Michal Simek <monstr@monstr.eu>
> 
> Oh right how silly of me.  3 seperate patches would have been nicer I
> guess.  The original code is certainly copied from one place to the others
> although I have no idea which architecture was the first to get it wrong.
> 
> Would everyone prefer I made 3 patches instead and resent them?

Just do it for microblaze

Thanks,
Michal


> 

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian

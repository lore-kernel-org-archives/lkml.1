Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753798AbZALGPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZALGPL (ORCPT <rfc822;akpm@linux-foundation.org>);
	Mon, 12 Jan 2009 01:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZALGO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 01:14:56 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:33360 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751430AbZALGOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:14:55 -0500
Message-ID: <48E9ACC7.3020801@snapgear.com>
Date: Mon, 06 Oct 2008 16:14:31 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090105224007.20e60d02.sfr@canb.auug.org.au>
In-Reply-To: <20090105224007.20e60d02.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Stephen Rothwell wrote:
> Hi Andrew,
> 
> On Mon, 5 Jan 2009 00:43:00 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
>> powerpc-change-u64-s64-to-a-long-long-integer-type.patch
> 
> I am working on this starting from this (Ingo's) patch.  I'll feed stuff
> through the powerpc tree.
> 
>> m68knommu-use-the-new-byteorder-headers.patch
>> m68knommu-set-no_dma.patch
>>
>>   Architecture things.  Will merge.
> 
> I have an m68nommu tree as part of linux-next should these go there?
> (though the last - still outstanding - commit was in November).

I have been away the last few weeks, so nothing has happened
on the m68knommu (or uclinux) git trees. I should be updating
them and getting of some patches to Linus this week (I hope...).

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com

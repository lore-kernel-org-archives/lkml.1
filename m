Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbXFUOZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbXFUOZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 10:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXFUOY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 10:24:59 -0400
Received: from mondriaan.macroscoop.nl ([82.94.9.2]:3271 "EHLO
	mondriaan.macroscoop.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbXFUOY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 10:24:58 -0400
Message-ID: <467A8A20.7000302@macroscoop.nl>
Date: Thu, 21 Jun 2007 16:24:32 +0200
From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706071530.51552.jesse.barnes@intel.com> <200706141418.42082.jbarnes@virtuousgeek.org> <4672681D.7020601@macroscoop.nl> <200706150920.24490.jbarnes@virtuousgeek.org>
In-Reply-To: <200706150920.24490.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
>> What, are you going to report this to GigaByte?
>>     
>
> No, but you should if you haven't already.  I think GigaByte probably 
> gets its BIOS from another BIOS vendor (maybe Intel), so when that 
> vendor provides them with an update, they'll probably provide it on 
> their website.  And from what I understand, an Intel BIOS update is in 
> the works to address this issue for Intel boards, so a GigaByte version 
> may follow shortly.  I don't have an exact timeframe though...
>
>   
I reported this to GigaByte, and lo and behold, they sent me a fixed 
BIOS within 48 hours.
Kudos to Taipeh!

They sent the BIOS image in a private message, so it might take a while 
before it's available
on their website.



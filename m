Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbXFTNzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbXFTNzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 09:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbXFTNz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 09:55:28 -0400
Received: from mondriaan.macroscoop.nl ([82.94.9.2]:2249 "EHLO
	mondriaan.macroscoop.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbXFTNzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 09:55:24 -0400
Message-ID: <467931BD.7080109@macroscoop.nl>
Date: Wed, 20 Jun 2007 15:55:09 +0200
From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706071530.51552.jesse.barnes@intel.com> <Pine.LNX.4.64.0706141625260.26236@p34.internal.lan> <46726727.5090003@macroscoop.nl> <200706151028.41773.jbarnes@virtuousgeek.org>
In-Reply-To: <200706151028.41773.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Friday, June 15, 2007 3:17:11 Pim Zandbergen wrote:
>   
>> Not that it matters much, as the current i810/intel xorg driver does
>> not yet support the GMA3100, so I'm using the vesa driver.
>>     
>
> I *think* the latest trees support that chip.  If you're feeling brave, 
> checkout the latest version of the xf86-video-intel driver from 
> freedesktop.org and give it a try 
As it happens, the Fedora guys just released a new Intel xorg driver RPM
that supports the G33. It works.
> (to get 3d you'll also need newer DRM and AGP bits).
>   
No 3D indeed. The newer DRM and AGP bits probably go into the kernel.

But hey, it's a server. I've got another machine with the exact same 
hardware
running Windows 2003. No video driver support there at all.

Thanks,
Pim


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbXA2Vhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbXA2Vhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 16:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbXA2Vhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 16:37:32 -0500
Received: from smtp20.orange.fr ([80.12.242.27]:30164 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbXA2Vhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 16:37:31 -0500
X-ME-UUID: 20070129213730180.2BF751C000AD@mwinf2011.orange.fr
Message-ID: <45BE6919.8080400@free.fr>
Date: Mon, 29 Jan 2007 22:37:29 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.0.7) Gecko/20060405 SeaMonkey/1.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm2
References: <20070129001207.71ea3470.akpm@osdl.org>
In-Reply-To: <20070129001207.71ea3470.akpm@osdl.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le 29.01.2007 09:12, Andrew Morton a écrit :
> Temporarily at
> 
> 	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm2/
> 
> Will appear later at
> 
> 	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm2/
> 
> 
> 
> - Dropped git-block due to CFQ breakage

Nice, reiser4 does work now. It was broken since 2.6.20-rc3-mm1, see 
http://lkml.org/lkml/2007/1/6/57.

> - Dropped the fsaio patches due to their dependence on git-block.
> 
> - Added the new hrtimers/dynticks patches.  This is an update of the
>   2.6.20-rc4-mm1 patches, now apparently fixed.

thanks
~~
laurent




Return-Path: <linux-kernel-owner+w=401wt.eu-S971148AbXFIAgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971148AbXFIAgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762946AbXFIAfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:35:53 -0400
Received: from mga06.intel.com ([134.134.136.21]:37294 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756558AbXFIAfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:35:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,401,1175497200"; 
   d="scan'208";a="252487246"
Message-ID: <4669D98F.4090602@linux.intel.com>
Date: Fri, 08 Jun 2007 15:34:55 -0700
From: James Ketrenos <jketreno@linux.intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.04
References: <1219bf1ec9ab0dcecc345f9fc3b0f912@pinky>
In-Reply-To: <1219bf1ec9ab0dcecc345f9fc3b0f912@pinky>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> This version brings a some new tests, and a host of changes to fix
> false positives, of particular note:
> 
>   - check for and report #if 0
>   - extend checking of line lengths and spacing for .pl, .sh etc
>   - extends the pointer type checks to multiple levels
>   - updates printk handling to track newlines
>   - adds a wrapped patch detector
>   - drops the leading component of the filenames
>   - extends switch indent handling to switch statmentes rooted in
>     the context
>   - adds foo * bar single pointer checks

I just wanted to say Thank You for putting checkpatch.pl together.

I've only used v0.1 here (its what showed up in wireless-dev) but
it made pruning through the iwlwifi sources to clean things up a 
very manageable task.

Great job so far.

Thanks,
James

Return-Path: <linux-kernel-owner+w=401wt.eu-S376161AbXECQCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376161AbXECQCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376165AbXECQC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:02:29 -0400
Received: from waste.org ([66.93.16.53]:38170 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S376157AbXECQC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:02:28 -0400
Date: Thu, 3 May 2007 11:02:01 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [RELEASE] Lguest for 2.6.21
Message-ID: <20070503160201.GR11166@waste.org>
References: <1178117028.19815.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178117028.19815.14.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 12:43:48AM +1000, Rusty Russell wrote:
> Hi all,
> 
> 	Lguest is a simple hypervisor which runs Linux under Linux, without
> needing VT hardware.
> 
> 	Two people asked if I had a version of lguest which worked on
> other-than-bleeding-edge-mm kernels, so I did a backport of the latest
> version to 2.6.21.
> 
> 	http://lguest.ozlabs.org/lguest-2.6.21-254.patch.gz
> 
> See Documentation/lguest/lguest.txt for how to run,
> drivers/lguest/README for the draft code documentation journey.

Your lguest readme is quite lacking in the area of how to configure a
guest kernel as opposed to the host kernel. More hand-holding, please.

Maybe it's obvious once I've actually applied the patch and run
menuconfig, but I'm loathe to attempt anything that isn't a cake walk
at my current loadavg, especially given the fits of blind rage trying
to do anything nontrivial with Xen tends to provoke in me.

-- 
Mathematics is the supreme nostalgia of our time.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1767502AbXEDANk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767502AbXEDANk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767508AbXEDANj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:13:39 -0400
Received: from ozlabs.org ([203.10.76.45]:53466 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767502AbXEDANi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:13:38 -0400
Subject: Re: [RELEASE] Lguest for 2.6.21
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <20070503160201.GR11166@waste.org>
References: <1178117028.19815.14.camel@localhost.localdomain>
	 <20070503160201.GR11166@waste.org>
Content-Type: text/plain
Date: Fri, 04 May 2007 10:13:23 +1000
Message-Id: <1178237603.23670.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 11:02 -0500, Matt Mackall wrote:
> On Thu, May 03, 2007 at 12:43:48AM +1000, Rusty Russell wrote:
> > 	http://lguest.ozlabs.org/lguest-2.6.21-254.patch.gz
> > 
> > See Documentation/lguest/lguest.txt for how to run,
> > drivers/lguest/README for the draft code documentation journey.
> 
> Your lguest readme is quite lacking in the area of how to configure a
> guest kernel as opposed to the host kernel. More hand-holding, please.

Hi Matt!

	Ah, that's because they are the same kernel.  Turning on CONFIG_LGUEST
builds-in the parts needed to be a guest as well.

Thanks for pointing out that weakness.  I will modify lguest.txt to make
that clear.

Cheers,
Rusty.


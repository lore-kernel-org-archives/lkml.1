Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbXC2MUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbXC2MUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 08:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXC2MUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 08:20:00 -0400
Received: from colin.muc.de ([193.149.48.1]:4445 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbXC2MT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 08:19:59 -0400
Date: 29 Mar 2007 14:19:58 +0200
Date: Thu, 29 Mar 2007 14:19:58 +0200
From: Andi Kleen <ak@muc.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Gerd Hoffmann <kraxel@suse.de>, Alan <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ignore vgacon if hardware not present
Message-ID: <20070329121958.GA35584@muc.de>
References: <1175154408.12230.195.camel@localhost.localdomain> <20070329103602.GB52274@muc.de> <1175166417.12230.206.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175166417.12230.206.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 09:06:57PM +1000, Rusty Russell wrote:
> On Thu, 2007-03-29 at 12:36 +0200, Andi Kleen wrote:
> > On Thu, Mar 29, 2007 at 05:46:48PM +1000, Rusty Russell wrote:
> > > (Did this fall through the cracks?  I don't see it in -mm.  It's
> > > standalone, and saves some silly code in lguest and presumably others).
> > 
> > Normally it should go to some some console maintainer? 
> 
> Hmm, but who?
> 
> > Ok I can add it.
> 
> Thanks.  While you're in a patch-applying mood, how about this?

Ok. Can you do it for x86-64 too?

-Andi

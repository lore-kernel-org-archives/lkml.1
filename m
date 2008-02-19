Return-Path: <linux-kernel-owner+w=401wt.eu-S1763423AbYBSWUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763423AbYBSWUC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:20:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbYBSWTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:19:51 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37005 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666AbYBSWTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:19:50 -0500
Date: Wed, 20 Feb 2008 00:19:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
Message-ID: <20080219221914.GL31955@cs181133002.pp.htv.fi>
References: <200802171025.30590.elendil@planet.nl> <20080217131611.GA1403@cs181133002.pp.htv.fi> <200802192255.02152.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200802192255.02152.elendil@planet.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 10:55:01PM +0100, Frans Pop wrote:
> On Sunday 17 February 2008, Adrian Bunk wrote:
> > The real problem is that the kernel seems to lack functionality you
> > require for doing some work.
> 
> Not sure how you reached that conclusion.
> 
> > Why does your work on the Debian Installer depend on VirtualBox and
> > can't be done with what the kernel already ships?
> 
> Work on the installer does not so much hard depend on VirtualBox (or any 
> other emulator), but can be done much more effectively and efficiently 
> using one.
>...

The "or any other emulator" is exactly where my question is directed at.

Xen, KVM or even qemu come into my mind, but considering how loudly you 
complained about a temporary breakage for VirtualBox there must be a 
reason why your work on the Debian Installer can only be done 
effectively and efficiently with an emulator module that has AFAIK not 
been submitted for inclusion in the kernel.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


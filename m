Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYCCRJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYCCRJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYCCRJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:09:07 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39625 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYCCRJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:09:06 -0500
Date: Mon, 3 Mar 2008 19:07:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Eragon <noliamhere@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reexport init_mm ?
Message-ID: <20080303170729.GE26072@cs181133002.pp.htv.fi>
References: <f6ca9fed0802270029l231c6050sefd90ec2997eda37@mail.gmail.com> <47C6617D.1030700@redhat.com> <df47b87a0802290526h322b5cc6va9621e7329d1ac98@mail.gmail.com> <47C84873.4040208@redhat.com> <df47b87a0803010346r430520b6h7ccaf408f56c0b60@mail.gmail.com> <loom.20080303T155130-460@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <loom.20080303T155130-460@post.gmane.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 03:54:48PM +0000, Eragon wrote:
> 
> I ma sorry, but new linux users (mostly ubuntu) want their system to work out of
> the box. Ruining, at least for the time being, the only decent nvidia drivers
> isn't going to help. nd I don't think gamers, such as myself, will be very happy
> if you proceed with this change. Enemy territory quake wars or other games won't
> work anymore because their 600 $ Geforce 8 cards won't work correctly.
> If I wouldn't be able to play game anymore, with ATI having bad performance on
> linux, I would switch back to windows and I'm not the only one. It's as simple
> as that.
> 
> Great Idea!!

Independent of this specific issue and even ignoring the question 
whether binary-only Linux kernel drivers are legal at all there are a 
few points to note:

First of all, Linux is great for many people and in many cases. But 
buying a computer with a $600 graphics card for gaming under Linux 
doesn't make sense. Simply because having the latest desktop hardware 
perfectly supported and with perfect performance is not yet realistic 
under Linux (and there's more than just the graphics card in a computer).

And binary-only kernel drivers have the problems that noone except for 
the vendor can debug them. Some binary-only graphics drivers are 
well-known for having caused quite a few kernel kernel crashes under 
Linux - and this harms the reputation of Linux as a stable operating 
system.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


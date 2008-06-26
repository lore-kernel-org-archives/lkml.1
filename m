Return-Path: <linux-kernel-owner+w=401wt.eu-S1761954AbYFZTpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761954AbYFZTpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762242AbYFZTpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:45:22 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46598 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760330AbYFZTpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:45:20 -0400
Date: Thu, 26 Jun 2008 22:43:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Michal Simek <monstr@seznam.cz>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com
Subject: Re: Microblaze init port v4
Message-ID: <20080626194301.GD22827@cs181140183.pp.htv.fi>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <20080626150121.GB22025@cs181140183.pp.htv.fi> <4863E4FD.6040803@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4863E4FD.6040803@seznam.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 08:50:37PM +0200, Michal Simek wrote:
> Hi Adrian,
> 
> > On Thu, Jun 26, 2008 at 02:29:29PM +0200, monstr@seznam.cz wrote:
> >> Hi everybody,
> >>
> >> current linux version is 2.6.26-rc8 and I think this is the right time
> >> to send latest patches againts rc8 for Microblaze CPU.
> >> ...
> > 
> > Thanks for your work on getting the architecture included.
> > 
> > I have two questions:
> > 
> > Where can I find a toolchain for compiling a Microblaze kernel?
> I personally use petalogix toolchain from www.petalogix.com.
> 
> > What is the status of Microblaze support in upstream binutils and gcc?
> 
> I don't have any information about. We will discuss with John Williams and guys
> from Xilinx
> what we can do for it.

Thanks!

> M

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


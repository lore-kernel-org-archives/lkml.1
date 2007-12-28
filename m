Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbXL1IxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbXL1IxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 03:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbXL1IxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 03:53:10 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41651 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbXL1IxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 03:53:09 -0500
Date: Fri, 28 Dec 2007 10:52:59 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Working upstream toolchain for avr32?
Message-ID: <20071228085259.GE8911@does.not.exist>
References: <20071213195617.GF21616@stusta.de> <20071214104158.6d256b7b@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071214104158.6d256b7b@dhcp-252-066.norway.atmel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 10:41:58AM +0100, Haavard Skinnemoen wrote:
> On Thu, 13 Dec 2007 20:56:17 +0100
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > AFAIK the latest available AVR32 toolchains are some patched gcc 4.0 and 
> > some patched binutils 2.17, and avr32 is currently the only architecture 
> > in the kernel where upstream of both of them is not capable of building 
> > a kernel for the architecture.
> 
> gcc 4.2 is available from www.atmel.com. But I agree that it's
> unfortunate that avr32 support isn't available upstream.
> 
> > ALthough not technically a requirement, it would be nice if all Linux 
> > kernel archs could be compiled with plain upstream toolchains.
> 
> We're working on it. I believe the legal issues around copyright
> assignment, etc. are mostly sorted out now, so I'm hoping we'll start
> pushing things upstream early next year.

First of all sorry for my late answer.

What you are saying is more or less what I was hoping to hear.  :)

> > Even more since at some point in the future [1] current toolchains might 
> > no longer be able to compile the then current kernels.
> 
> I'm not sure if I understood that, but I guess it's always good to have
> older versions of the toolchain around.

My point was that if there was _only_ support in some older toolchain,
a few years from now there might no longer be a toolchain capable of 
compiling the then-current kernel.

> Haavard

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


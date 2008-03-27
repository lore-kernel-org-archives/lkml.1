Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbYC0KsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbYC0KsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbYC0Kr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:47:56 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35437 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbYC0Krz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:47:55 -0400
Date: Thu, 27 Mar 2008 12:47:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 27
Message-ID: <20080327104745.GA1686@cs181133002.pp.htv.fi>
References: <20080327183357.7c637aed.sfr@canb.auug.org.au> <20080327104224.2b98b561@hskinnemo-gx620.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080327104224.2b98b561@hskinnemo-gx620.norway.atmel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 10:42:24AM +0100, Haavard Skinnemoen wrote:
> On Thu, 27 Mar 2008 18:33:57 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Status of my local build tests is at
> > http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
> > advice about cross compilers/configs that work, we are always open to add
> > more builds.
> 
> AVR32 allnoconfig found a bug, which I've fixed. Could you try enabling
> it again?

BTW:

According to Jan's page, there's still a build error with the defconfig:
  http://l4x.org/k/?d=40450#err

> Haavard

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbXF0Pxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbXF0Pxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762017AbXF0Pwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:52:34 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42173 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761162AbXF0Pwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:52:31 -0400
Date: Wed, 27 Jun 2007 17:52:54 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
Message-ID: <20070627155254.GO1094@stusta.de>
References: <200706271653.58870.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200706271653.58870.a1426z@gawab.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 04:53:58PM +0300, Al Boldi wrote:
> Al Viro wrote:
> > On Wed, Jun 27, 2007 at 11:18:36AM +0200, Zolt?n HUBERT wrote:
> > > And as I understand it, this is (was ?) the whole point of
> > > stable/development kernels. "We" can trust a newer stable
> > > kernel to be a drop-in replacement for an older stable
> > > kernel (from the same series), while development kernels
> > > need time to stabilise with the new whizz-bang-pfouit stuff
> > > that you all so nicely add.
> >
> > "Drop-in" in which sense?  That out-of-tree modules keep working?
> > Not really...
> 
> Al, be reasonable.  There are many out-of-tree GPL modules that won't be 
> accepted into mainline, never mind those that shouldn't be accepted.  But 
> these modules do have a right to not be obsoleted by constant API changes.

"have a right" are strong words.
Who is granting them this right?

> You are effectively inhibiting the development of an out-of-tree GPL module 
> pool, by constantly pulling the rug under that community.
> 
> Do you think this is fair?

Why are these modules not submitted for inclusion into the kernel?

> Thanks!
> Al

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbXELU5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbXELU5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 16:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbXELU5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 16:57:03 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:56560 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbXELU5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 16:57:00 -0400
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
From: Richard Purdie <richard@openedhand.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, LKML <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
In-Reply-To: <20070512094710.43ab1b2f.akpm@linux-foundation.org>
References: <1178096183.5860.25.camel@localhost.localdomain>
	 <20070512111722.GJ7984@stusta.de>
	 <1178983055.5831.3.camel@localhost.localdomain>
	 <20070512094710.43ab1b2f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 12 May 2007 21:56:45 +0100
Message-Id: <1179003405.5831.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 09:47 -0700, Andrew Morton wrote:
> On Sat, 12 May 2007 16:17:35 +0100 Richard Purdie <richard@openedhand.com> wrote:
> 
> > On Sat, 2007-05-12 at 13:17 +0200, Adrian Bunk wrote:
> > > On Wed, May 02, 2007 at 09:56:23AM +0100, Richard Purdie wrote:
> > > >...
> > > > I've asked the LZO author about the comments on lzo_copyright function
> > > > but the code is GPLv2 licensed so is suitable for inclusion in the
> > > > kernel.
> > > 
> > > This sounds as if LZO is GPL incompatible similar to code under
> > > the 4 clause BSD licence.
> > > 
> > > >...
> > > > +/* If you use the LZO library in a product, you *must* keep this
> > > > + * copyright string in the executable of your product.
> > > > + */
> > 
> > I've had a reply from the copyright holder/author saying he's going to
> > change this wording in the next LZO release and that the code *is* GPLv2
> > licensed as per the headers on the files.
> > 
> 
> It would be ideal if the author of that code could send us a
> signed-off-by: as per secton 11 of Documentation/SubmittingPatches.  

Section 11b says I can submit it but I've asked the author about a
signed off by line (he's cc'd) for the alleviation of any doubt.

Cheers,

Richard



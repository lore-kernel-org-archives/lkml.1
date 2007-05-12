Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbXELQro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbXELQro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 12:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbXELQrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 12:47:37 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612AbXELQrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 12:47:37 -0400
Date: Sat, 12 May 2007 09:47:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Purdie <richard@openedhand.com>
Cc: Adrian Bunk <bunk@stusta.de>, LKML <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
Message-Id: <20070512094710.43ab1b2f.akpm@linux-foundation.org>
In-Reply-To: <1178983055.5831.3.camel@localhost.localdomain>
References: <1178096183.5860.25.camel@localhost.localdomain>
	<20070512111722.GJ7984@stusta.de>
	<1178983055.5831.3.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007 16:17:35 +0100 Richard Purdie <richard@openedhand.com> wrote:

> On Sat, 2007-05-12 at 13:17 +0200, Adrian Bunk wrote:
> > On Wed, May 02, 2007 at 09:56:23AM +0100, Richard Purdie wrote:
> > >...
> > > I've asked the LZO author about the comments on lzo_copyright function
> > > but the code is GPLv2 licensed so is suitable for inclusion in the
> > > kernel.
> > 
> > This sounds as if LZO is GPL incompatible similar to code under
> > the 4 clause BSD licence.
> > 
> > >...
> > > +/* If you use the LZO library in a product, you *must* keep this
> > > + * copyright string in the executable of your product.
> > > + */
> 
> I've had a reply from the copyright holder/author saying he's going to
> change this wording in the next LZO release and that the code *is* GPLv2
> licensed as per the headers on the files.
> 

It would be ideal if the author of that code could send us a
signed-off-by: as per secton 11 of Documentation/SubmittingPatches.  

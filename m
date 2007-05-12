Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbXELPR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbXELPR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 11:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXELPRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 11:17:51 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:51767 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbXELPRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 11:17:51 -0400
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
From: Richard Purdie <richard@openedhand.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       torvalds@osdl.org, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070512111722.GJ7984@stusta.de>
References: <1178096183.5860.25.camel@localhost.localdomain>
	 <20070512111722.GJ7984@stusta.de>
Content-Type: text/plain
Date: Sat, 12 May 2007 16:17:35 +0100
Message-Id: <1178983055.5831.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 13:17 +0200, Adrian Bunk wrote:
> On Wed, May 02, 2007 at 09:56:23AM +0100, Richard Purdie wrote:
> >...
> > I've asked the LZO author about the comments on lzo_copyright function
> > but the code is GPLv2 licensed so is suitable for inclusion in the
> > kernel.
> 
> This sounds as if LZO is GPL incompatible similar to code under
> the 4 clause BSD licence.
> 
> >...
> > +/* If you use the LZO library in a product, you *must* keep this
> > + * copyright string in the executable of your product.
> > + */

I've had a reply from the copyright holder/author saying he's going to
change this wording in the next LZO release and that the code *is* GPLv2
licensed as per the headers on the files.

Regards,

Richard




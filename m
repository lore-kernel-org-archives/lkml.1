Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbYBWJjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbYBWJjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 04:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYBWJjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 04:39:12 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57419 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYBWJjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 04:39:11 -0500
To: greg@kroah.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-reply-to: <20080222231934.GA30703@kroah.com> (message from Greg KH on Fri,
	22 Feb 2008 15:19:34 -0800)
Subject: Re: [stable] [patch] fuse: fix permission checking
References: <E1JPxjP-0004sQ-5O@pomaz-ex.szeredi.hu> <20080222231934.GA30703@kroah.com>
Message-Id: <E1JSqqR-00035e-8N@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 23 Feb 2008 10:38:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Feb 15, 2008 at 11:23:47AM +0100, Miklos Szeredi wrote:
> > This is for 2.6.25 and 2.6.24.y, but NOT for 2.6.23.y.
> > 
> > Thanks,
> > Miklos
> > ----
> > 
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > I added a nasty local variable shadowing bug to fuse in 2.6.24, with
> > the result, that the 'default_permissions' mount option is basically
> > ignored.
> 
> When this goes into Linus's tree, can you let us know along with the git
> commit id?

I'd really like to see this in 2.6.24.3.  How much time is left?
Should I bypass Andrew and submit to Linus ASAP?

Thanks,
Miklos

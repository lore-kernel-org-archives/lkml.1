Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbZK3Q7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbZK3Q7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZK3Q7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:59:30 -0500
Received: from kroah.org ([198.145.64.141]:59211 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbZK3Q7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:59:30 -0500
Date: Mon, 30 Nov 2009 08:59:18 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: fix a silly typo
Message-ID: <20091130165918.GA29035@kroah.com>
References: <20091130132432.27394.48685.stgit@localhost.localdomain>
 <20091130161405.GB15572@kroah.com>
 <20091130163937.092f10e9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130163937.092f10e9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 04:39:37PM +0000, Alan Cox wrote:
> On Mon, 30 Nov 2009 08:14:05 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > On Mon, Nov 30, 2009 at 01:24:49PM +0000, Alan Cox wrote:
> > > (Resend #3)
> > > 
> > > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > > ---
> > > 
> > >  drivers/staging/rtl8187se/r8180_core.c  |    2 +-
> > >  drivers/staging/rtl8192su/r8192U_core.c |    2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > This is due to changes in Rusty's tree, not mine.  You aren't the only
> > one constantly sending this patch, Randy is as well.
> 
> Well given Rusty has vanished can you apply it to staging and rusty can
> fix his tree up when he returns, assuming patch doesn't fix it for him.

The patch does not apply to my tree at all, the problem is caused by
stuff done only in Rusty's tree.  He has changed the code here to be
broken, not me, so there's really nothing I can do about it.

Stephen could apply it to linux-next though.

thanks,

greg k-h

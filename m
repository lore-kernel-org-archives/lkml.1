Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbZK3Qhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbZK3Qhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZK3Qhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:37:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34889 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753010AbZK3Qhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:37:42 -0500
Date: Mon, 30 Nov 2009 16:39:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@linux.intel.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: fix a silly typo
Message-ID: <20091130163937.092f10e9@lxorguk.ukuu.org.uk>
In-Reply-To: <20091130161405.GB15572@kroah.com>
References: <20091130132432.27394.48685.stgit@localhost.localdomain>
	<20091130161405.GB15572@kroah.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 08:14:05 -0800
Greg KH <greg@kroah.com> wrote:

> On Mon, Nov 30, 2009 at 01:24:49PM +0000, Alan Cox wrote:
> > (Resend #3)
> > 
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > ---
> > 
> >  drivers/staging/rtl8187se/r8180_core.c  |    2 +-
> >  drivers/staging/rtl8192su/r8192U_core.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> This is due to changes in Rusty's tree, not mine.  You aren't the only
> one constantly sending this patch, Randy is as well.

Well given Rusty has vanished can you apply it to staging and rusty can
fix his tree up when he returns, assuming patch doesn't fix it for him.

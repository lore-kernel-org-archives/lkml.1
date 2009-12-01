Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbZLAB6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbZLAB6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 20:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZLAB6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 20:58:11 -0500
Received: from ozlabs.org ([203.10.76.45]:33705 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbZLAB6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 20:58:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] staging: fix a silly typo
Date: Tue, 1 Dec 2009 12:28:14 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <20091130132432.27394.48685.stgit@localhost.localdomain> <20091130161405.GB15572@kroah.com>
In-Reply-To: <20091130161405.GB15572@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912011228.14927.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009 02:44:05 am Greg KH wrote:
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
> 
> Rusty, I thought you fixed these up?

I did too, but it seems not.  Which is very weird; I don't send replies
until I've actually done something.

Fixed and uploaded.

Sorry,
Rusty.

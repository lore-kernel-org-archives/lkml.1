Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbYHTVIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbYHTVIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYHTVIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:08:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:41665 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbYHTVH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:07:59 -0400
Date: Wed, 20 Aug 2008 14:04:48 -0700
From: Greg KH <greg@kroah.com>
To: Paul Mundt <lethal@linux-sh.org>, "Hans J. Koch" <hjk@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       Uwe.Kleine-Koenig@digi.com, gregkh@suse.de, akpm@linux-foundation.org,
       tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH][RESEND] uio: uio_pdrv_genirq V3
Message-ID: <20080820210448.GA22805@kroah.com>
References: <20080729121015.13443.91824.sendpatchset@rx1.opensource.se> <20080729122806.GB2221@local> <20080729124007.GB902@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729124007.GB902@linux-sh.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 09:40:07PM +0900, Paul Mundt wrote:
> On Tue, Jul 29, 2008 at 02:28:06PM +0200, Hans J. Koch wrote:
> > On Tue, Jul 29, 2008 at 09:10:15PM +0900, Magnus Damm wrote:
> > > From: Magnus Damm <damm@igel.co.jp>
> > > 
> > > This is V3 of uio_pdrv_genirq.c, a platform driver for UIO with
> > > generic IRQ handling code. This driver is very similar to the regular
> > > UIO platform driver, but is only suitable for devices that are
> > > connected to the interrupt controller using unique interrupt lines.
> > 
> > Hi Magnus,
> > I already sent this to Greg on July, 15. I guess this will be merged
> > soon. Greg was probably busy with tons of other stuff during the merge
> > window.
> > 
> Note that I've already pushed the platform bits, so this is the only
> outstanding part.

Now merged into my tree, sorry for the delay.

greg k-h

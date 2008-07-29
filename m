Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbYG2PQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbYG2PQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYG2PQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:16:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:51422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbYG2PQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:16:25 -0400
Date: Tue, 29 Jul 2008 08:13:52 -0700
From: Greg KH <gregkh@suse.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       Uwe.Kleine-Koenig@digi.com, akpm@linux-foundation.org,
       lethal@linux-sh.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH][RESEND] uio: uio_pdrv_genirq V3
Message-ID: <20080729151352.GA18556@suse.de>
References: <20080729121015.13443.91824.sendpatchset@rx1.opensource.se> <20080729122806.GB2221@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729122806.GB2221@local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 02:28:06PM +0200, Hans J. Koch wrote:
> On Tue, Jul 29, 2008 at 09:10:15PM +0900, Magnus Damm wrote:
> > From: Magnus Damm <damm@igel.co.jp>
> > 
> > This is V3 of uio_pdrv_genirq.c, a platform driver for UIO with
> > generic IRQ handling code. This driver is very similar to the regular
> > UIO platform driver, but is only suitable for devices that are
> > connected to the interrupt controller using unique interrupt lines.
> 
> Hi Magnus,
> I already sent this to Greg on July, 15. I guess this will be merged
> soon. Greg was probably busy with tons of other stuff during the merge
> window.

Yeah, it's in my queue, which _sucks_ right now for movement:
	$ mdfrm -c ~/mail/todo
	594 messages in ~/mail/todo

I'm slowly digging out, I have to get through the -stable backlog first:
	$ mdfrm -c ~/mail/todo-stable/
	68 messages in ~/mail/todo-stable/

ah, for more time in a day...

thanks for your patience,

greg k-h

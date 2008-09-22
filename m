Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYIVSug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYIVSug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYIVSu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:50:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:33254 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbYIVSu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:50:27 -0400
Date: Mon, 22 Sep 2008 11:47:00 -0700
From: Greg KH <greg@kroah.com>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acer-wmi: add error checks in module_init
Message-ID: <20080922184700.GC11949@kroah.com>
References: <200809211853.19889.carlos@strangeworlds.co.uk> <20080922155949.GA4283@kroah.com> <200809221854.44615.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809221854.44615.carlos@strangeworlds.co.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 06:54:44PM +0100, Carlos Corbacho wrote:
> On Monday 22 September 2008 16:59:49 Greg KH wrote:
> > On Sun, Sep 21, 2008 at 06:53:19PM +0100, Carlos Corbacho wrote:
> > > On Sunday 21 September 2008 15:29:59 Akinobu Mita wrote:
> > > > This patch fixes these bugs by using platform_device_register_simple()
> > >
> > > [Adding Greg KH to CC - 2nd time lucky...]
> > >
> > > Last I heard, platform_device_register_simple() was in the process of
> > > being deprecated and then slated for future removal. Has this changed?
> >
> > I don't recall this, but someone else might have stated it a while ago.
> 
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-04/msg02070.html
> 
> This was dated a while ago, but has anything changed since then?

Not that I know of, I just forgot about it :)

thanks,

greg k-h

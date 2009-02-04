Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbZBDB3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbZBDB3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbZBDB3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:29:16 -0500
Received: from kroah.org ([198.145.64.141]:53464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755517AbZBDB3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:29:14 -0500
Date: Tue, 3 Feb 2009 17:27:03 -0800
From: Greg KH <greg@kroah.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-usb@vger.kernel.org,
       linux-kernel Kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Yang <leoli@freescale.com>, Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 0/6] USB: Fixes for fsl_qe_udc driver
Message-ID: <20090204012703.GA5940@kroah.com>
References: <20081225141402.GA30689@oksana.dev.rtsoft.ru> <F4CBCB9E-5C58-4F9B-B0B2-623C81DF1339@kernel.crashing.org> <20090107045341.GA15842@kroah.com> <3983606C-7DC0-4D3D-B523-4EE5C2BCB80E@kernel.crashing.org> <20090113164001.GA14370@kroah.com> <20090202155004.GA6764@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090202155004.GA6764@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 06:50:04PM +0300, Anton Vorontsov wrote:
> On Tue, Jan 13, 2009 at 08:40:01AM -0800, Greg KH wrote:
> > On Tue, Jan 13, 2009 at 09:49:39AM -0600, Kumar Gala wrote:
> > > On Jan 6, 2009, at 10:53 PM, Greg KH wrote:
> > >> On Tue, Jan 06, 2009 at 10:44:13PM -0600, Kumar Gala wrote:
> > >>> On Dec 25, 2008, at 8:14 AM, Anton Vorontsov wrote:
> > >>>> Hi all,
> > >>>>
> > >>>> Just resending some fixes that seem to be lost...
> > >>>
> > >>> Greg,
> > >>>
> > >>> What happened w/this patch set?
> > >>
> > >> As it was sent during the hollidays (on Christmas day at that), it's
> > >> still in my "to-review" queue.  I'll get to it in a few days after I
> > >> resync the USB tree with Linus.
> > >
> > > Any update on the review of these 6 patches?
> > 
> > It's in my queue, been busy with "real work" for a bit right now,
> > sorry...
> 
> Hello Greg,
> 
> Can you please look into these patches? I think they all are 2.6.29
> material, since the QE UDC driver is barely usable w/o these fixes.

My appologies, I've now applied them all and will queue them up to Linus
before .29 is out.

thanks,

greg k-h

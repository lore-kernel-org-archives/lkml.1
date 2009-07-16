Return-Path: <linux-kernel-owner+w=401wt.eu-S932729AbZGPQZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbZGPQZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932712AbZGPQZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:25:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:45482 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700AbZGPQZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:25:08 -0400
Date: Thu, 16 Jul 2009 08:52:08 -0700
From: Greg KH <gregkh@suse.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, anthony@codemonkey.ws,
       avi@redhat.com, kvm@vger.kernel.org, chrisw@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] uio: add generic driver for PCI 2.3 devices
Message-ID: <20090716155208.GA2375@suse.de>
References: <20090715201340.GA12279@redhat.com>
 <20090715220829.GB31962@suse.de>
 <20090716140709.GA16321@redhat.com>
 <20090716151254.GD3642@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716151254.GD3642@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 05:12:55PM +0200, Hans J. Koch wrote:
> On Thu, Jul 16, 2009 at 05:07:10PM +0300, Michael S. Tsirkin wrote:
> > On Wed, Jul 15, 2009 at 03:08:29PM -0700, Greg KH wrote:
> > > How about moving that documentation into a place that people will notice
> > > it, like the rest of the UIO documentation?
> > 
> > Greg,
> > 
> > would it make more sense to add this to
> > Documentation/DocBook/uio-howto.xml, or to create
> > Documentation/uio_pci_generic.txt ?
> 
> Hi Michael,
> I'd prefer to have it in uio-howto.xml so that people only have to look in
> one place. In does not have to be very detailled, just a short explanation
> what this driver is all about and a short example how to use it.

I agree, that would be the best place for it.

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbXENUOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbXENUOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbXENUN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:13:59 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35838 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbXENUN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:13:58 -0400
Date: Mon, 14 May 2007 04:48:04 -0700
From: Greg KH <greg@kroah.com>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kristen.c.accardi@intel.com
Subject: Re: pci hotplug patches
Message-ID: <20070514114804.GA5169@kroah.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <20070501084841.GC14364@infradead.org> <20070502035745.GB8877@kroah.com> <20070513205924.GA13985@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513205924.GA13985@infradead.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 09:59:24PM +0100, Christoph Hellwig wrote:
> On Tue, May 01, 2007 at 08:57:45PM -0700, Greg KH wrote:
> > Hm, I'm no longer the PCI Hotplug maintainer, so that's why I haven't
> > added them to my tree.  It would probably be best for everyone involved
> > to send them to her instead :)
> 
> FYI: MAINTAINERS still lists you as the maintainer of the cpqphp driver.

Ick, I'll go fix that up, I don't even have the hardware anymore
(donated it to a local university...)

thanks,

greg k-h

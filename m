Return-Path: <linux-kernel-owner+w=401wt.eu-S1762218AbXIZVos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762218AbXIZVos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbXIZVok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:44:40 -0400
Received: from mail.suse.de ([195.135.220.2]:33870 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339AbXIZVoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:44:39 -0400
Date: Wed, 26 Sep 2007 14:39:31 -0700
From: Greg KH <gregkh@suse.de>
To: Brice Goglin <Brice.Goglin@ens-lyon.org>, Jeff Garzik <jeff@garzik.org>
Cc: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: State of the Linux PCI Subsystem for 2.6.23-rc8
Message-ID: <20070926213931.GA24049@suse.de>
References: <20070926210010.GC1734@kroah.com> <46FAD1EA.6090504@ens-lyon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FAD1EA.6090504@ens-lyon.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 11:40:58PM +0200, Brice Goglin wrote:
> Greg KH wrote:
> > Here's a summary of the current state of the Linux PCI subsystem, as of
> > 2.6.23-rc8.
> >
> > If the information in here is incorrect, or anyone knows of any
> > outstanding issues not listed here, please let me know.
> >
> > List of outstanding regressions from 2.6.22:
> > 	- none known.
> >
> > List of outstanding regressions from older kernel versions:
> > 	- none known.
> >   
> 
> What about http://marc.info/?l=linux-pci&m=119072400008538&w=2 ?

That's not a regression, right?  Tt's probably never worked for that
kind of box :)

I think the pci bus patches that are pending from Jeff Garzik should fix
up these issues.  They are in one of his trees, and in the -mm release,
if you are able to test those.

thanks,

greg k-h

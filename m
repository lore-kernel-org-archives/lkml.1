Return-Path: <linux-kernel-owner+w=401wt.eu-S1764182AbYBTAmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764182AbYBTAmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbYBTAmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:42:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45430 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbYBTAmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:42:14 -0500
Date: Tue, 19 Feb 2008 16:39:51 -0800
From: Greg KH <greg@kroah.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Andreas Jaeger <aj@suse.de>, muli@il.ibm.com, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jdmason@kudzu.us, linux-pci@atrey.karlin.mff.cuni.cz,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [discuss] pci_get_device_reverse(), why does Calgary need this?
Message-ID: <20080220003951.GA4844@kroah.com>
References: <20080213001506.GA13933@kroah.com> <20080213181655.GB8960@kroah.com> <ho3arwq8w7.fsf@reger.suse.de> <200802141311.43103.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802141311.43103.bzolnier@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 01:11:42PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 14 February 2008, Andreas Jaeger wrote:
> > Greg KH <greg@kroah.com> writes:
> > 
> > > How does the patch below look?  I didn't want to remove the whole config
> > > option, as there is more to the logic than just the "reverse order"
> > > stuff there.
> > 
> > I think you miss Documentation - it's mentioned in ide.txt and
> > kernel-parameters.txt,
> 
> + drivers/ide/Kconfig
> 
> Greg, please update the patch (and add my S-o-B while at it).

Now done, thanks.

greg k-h

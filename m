Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbZI2Pda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbZI2Pda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 11:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZI2Pd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 11:33:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:36278 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZI2Pd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 11:33:28 -0400
Date: Tue, 29 Sep 2009 08:30:39 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Peter Huewe <PeterHuewe@gmx.de>, devel@driverdev.osuosl.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] staging/et131x:  adding __init/__exit macros
Message-ID: <20090929153039.GA5020@kroah.com>
References: <200909290134.15295.PeterHuewe@gmx.de> <alpine.LSU.2.00.0909291107410.9280@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0909291107410.9280@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 11:10:01AM +0200, Jiri Kosina wrote:
> On Tue, 29 Sep 2009, Peter Huewe wrote:
> 
> > From: Peter Huewe <peterhuewe@gmx.de>
> > 
> > Trivial patch which adds the __init/__exit macros to the module_init/
> > module_exit functions of ./staging/et131x/et131x_initpci.c
> > 
> > Greg, please have a look at the small patch and either pull it through
> > your staging tree, or please ack' it so Jiri can pull it through the trivial tree.
> 
> Greg -- I'd prefer you taking trivial staging fixes through yoru tree, as 
> I expect we'll be conflicting soon due to the speed of changes in staging 
> area, if you don't have any objections.

No objection at all, I'll queue all of these up later today.

thanks,

greg k-h

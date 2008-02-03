Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbYBCUi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbYBCUi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 15:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYBCUiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 15:38:19 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:59329 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbYBCUiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 15:38:18 -0500
Date: Sun, 3 Feb 2008 21:38:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Hannes Reinecke <hare@suse.de>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [patch] scsi: fix spurious build failures in aic7xxx
Message-ID: <20080203203822.GE2648@uranus.ravnborg.org>
References: <20080202140326.GA6544@elte.hu> <20080202140630.GA7939@elte.hu> <20080202141857.GA8635@elte.hu> <20080202162611.GA24765@uranus.ravnborg.org> <20080202171020.GB12748@elte.hu> <20080203045441.GA12128@elte.hu> <20080203074143.GA19981@uranus.ravnborg.org> <1202066623.3318.95.camel@localhost.localdomain> <20080203200558.GC2648@uranus.ravnborg.org> <1202069700.3318.100.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202069700.3318.100.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > drivers/base/attribute_container.c: * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>
> > drivers/base/transport_class.c: * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>
> > drivers/scsi/raid_class.c: * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>
> > include/linux/attribute_container.h: * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>
> > include/linux/raid_class.h: * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>
> > include/linux/transport_class.h: * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>
> 
> This is less obvious:  The copyrights are historical rather than current
> and also, I was at steeleye when I did that work, so it does deserve to
> be reflected in the file history.  I know it adds confusion from a whom
> do I contact for this file point of view, but it is legally the right
> thing to do.
When I read the above is that the Copyright are assigned to the
person "James Bottomley" with an email address.

If Steeleye deserve copyrights then _I_ would have
explicitly stated the company name too.

	Sam

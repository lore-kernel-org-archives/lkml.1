Return-Path: <linux-kernel-owner+w=401wt.eu-S934313AbXFGRWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934313AbXFGRWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933785AbXFGRWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:22:14 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53839 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480AbXFGRWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:22:12 -0400
Date: Thu, 7 Jun 2007 13:22:11 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
Message-ID: <20070607172211.GA11882@havoc.gtf.org>
References: <20070607162251.5f291325@the-village.bc.nu> <20070607152308.GB6653@havoc.gtf.org> <20070607164409.42635a4a@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607164409.42635a4a@the-village.bc.nu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 04:44:09PM +0100, Alan Cox wrote:
> On Thu, 7 Jun 2007 11:23:08 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
> > On Thu, Jun 07, 2007 at 04:22:51PM +0100, Alan Cox wrote:
> > > The intel-rng printed a nice well formatted message when the port was
> > > disabled. Someone then came along and blindly trashed it by screwing up a
> > > trim down to 80 columns.
> > > 
> > > Put it back into the right format and keep the overlong lines as the
> > > result is also MUCH easier to read in this specific case.
> > > 
> > > Signed-off-by: Alan Cox <alan@redhat.com>
> > 
> > Acked-by: Jeff Garzik <jeff@garzik.org>
> > 
> > I'm not the driver maintainer anymore, so I'm not actually going to push
> > this one.
> 
> Then please send a patch for the MAINTAINERS file

hrm, I thought that had already been fixed, by the new maintainer.

Will do.

	Jeff




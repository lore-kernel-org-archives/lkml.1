Return-Path: <linux-kernel-owner+w=401wt.eu-S1759615AbZBFPs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbZBFPs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758902AbZBFPr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:47:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59843 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758886AbZBFPrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:47:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [Bug #12405] oops in __bounce_end_io_read under kvm
Date: Fri, 6 Feb 2009 16:46:46 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera> <CGyEB0S4BpO.A.eRC.y5YiJB@chimera> <20090206081302.GB31358@lst.de>
In-Reply-To: <20090206081302.GB31358@lst.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902061646.46598.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 February 2009, Christoph Hellwig wrote:
> On Wed, Feb 04, 2009 at 11:58:40AM +0100, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12405
> > Subject		: oops in __bounce_end_io_read under kvm
> > Submitter	: Christoph Hellwig <hch@lst.de>
> > Date		: 2008-12-26 17:36 (41 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123031303400676&w=4
> > Handled-By	: Jens Axboe <jens.axboe@oracle.com>
> 
> Still around.  Btw, I'm not sure it's a regression as I only started
> using virtio_blk heavily during the 2.6.28 cycle.

Well, assuming that it is a regression raises its chances to be fixed faster. ;-)

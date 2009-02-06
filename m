Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbZBFINc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbZBFINc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbZBFINP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:13:15 -0500
Received: from verein.lst.de ([213.95.11.210]:55136 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbZBFINN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:13:13 -0500
Date: Fri, 6 Feb 2009 09:13:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug #12405] oops in __bounce_end_io_read under kvm
Message-ID: <20090206081302.GB31358@lst.de>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera> <CGyEB0S4BpO.A.eRC.y5YiJB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CGyEB0S4BpO.A.eRC.y5YiJB@chimera>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 11:58:40AM +0100, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12405
> Subject		: oops in __bounce_end_io_read under kvm
> Submitter	: Christoph Hellwig <hch@lst.de>
> Date		: 2008-12-26 17:36 (41 days old)
> References	: http://marc.info/?l=linux-kernel&m=123031303400676&w=4
> Handled-By	: Jens Axboe <jens.axboe@oracle.com>

Still around.  Btw, I'm not sure it's a regression as I only started
using virtio_blk heavily during the 2.6.28 cycle.

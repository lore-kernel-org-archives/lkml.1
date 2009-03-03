Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZCCTg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZCCTg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 14:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZCCTgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 14:36:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33086 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbZCCTgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 14:36:12 -0500
Date: Tue, 3 Mar 2009 20:36:10 +0100
From: Jan Kara <jack@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.29-rc6: Reported regressions from 2.6.28
Message-ID: <20090303193609.GE27178@atrey.karlin.mff.cuni.cz>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GVhknozYwrL.A.hiC.rozoJB@chimera>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> Unresolved regressions
> ----------------------
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12551
> Subject		: end_request: I/O error, dev cciss/c0d0, sector 87435720
> Submitter	: Ralf Hildebrandt <ralf.hildebrandt@charite.de>
> Date		: 2009-01-27 06:51 (28 days old)
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12497
> Subject		: new barrier warnings in 2.6.29-rc1
> Submitter	: Christoph Hellwig <hch@lst.de>
> Date		: 2009-01-12 15:46 (43 days old)
> References	: http://marc.info/?l=linux-kernel&m=123177528217154&w=4
> Handled-By	: Jens Axboe <jens.axboe@oracle.com>
  I've just noticed that the above two reports are probably the same bug...
Just that we don't duplicate the effort.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

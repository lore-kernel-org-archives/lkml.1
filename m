Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbZDTLpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbZDTLpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 07:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZDTLov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 07:44:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42988 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbZDTLou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 07:44:50 -0400
Date: Tue, 7 Apr 2009 09:26:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
Message-ID: <20090407072623.GB1408@ucw.cz>
References: <20090402015455.GA14087@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402015455.GA14087@havoc.gtf.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-04-01 21:54:55, Jeff Garzik wrote:
> 
> As I promised in older exofs threads, here is a client for libosd
> _other_ than exofs.  This block driver exports a single OSD object
> as a Linux block device.
> 
> See the comment block at the top of the driver for usage instructions.

I see it is not yet signed off... but maybe docs should go to
documentation directory?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbXFMJFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbXFMJFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 05:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbXFMJEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 05:04:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56148 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752012AbXFMJEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 05:04:53 -0400
Date: Wed, 13 Jun 2007 11:04:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
Message-ID: <20070613090430.GK13747@elf.ucw.cz>
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com> <466E0642.5020506@linux.intel.com> <466E1D51.9070007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466E1D51.9070007@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> I'm not sure about this.  We need better PM framework to support 
> >> powersaving in other controllers and some ahcis don't save much
> >> when only link power management is used,
> > 
> > do you have data to support this?
> 
> Yeah, it was some Lenovo notebook.  Pavel is more familiar with the
> hardware.  Pavel, what was the notebook which didn't save much power
> with standard SATA power save but needed port to be completely turned off?

Thinkpad x60. Some one Kristen probably used while developing the
patch :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

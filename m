Return-Path: <linux-kernel-owner+w=401wt.eu-S1422729AbXCGLJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422729AbXCGLJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422726AbXCGLJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:09:22 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:35602 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422721AbXCGLJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:09:21 -0500
Message-ID: <45EE9D52.9060807@garzik.org>
Date: Wed, 07 Mar 2007 06:09:06 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, pavel@suse.cz,
       linux-pm@lists.osdl.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, luming.yu@intel.com,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Konstantin Karasyov <konstantin.a.karasyov@intel.com>, greg@kroah.com,
       linux-usb-devel@lists.sourceforge.net, Thomas Meyer <thomas.mey@web.de>,
       Meelis Roos <mroos@linux.ee>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Janosch Machowinski <jmachowinski@gmx.de>, vladimir.p.lebedev@intel.com,
       Ash Milsted <thatistosayiseenem@gawab.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [2/6] 2.6.21-rc2: known regressions
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015034.GG3441@stusta.de>
In-Reply-To: <20070305015034.GG3441@stusta.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Subject    : AT keyboard only works with pci=noacpi
> References : http://lkml.org/lkml/2007/3/3/68
> Submitter  : Ash Milsted <thatistosayiseenem@gawab.com>
> Status     : unknown


sounds like a BIOS bug, even though it appears to be a regression?


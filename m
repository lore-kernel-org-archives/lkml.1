Return-Path: <linux-kernel-owner+w=401wt.eu-S1422725AbXCGLHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422725AbXCGLHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422723AbXCGLHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:07:34 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:35564 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422721AbXCGLHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:07:32 -0500
Message-ID: <45EE9CBD.9040807@garzik.org>
Date: Wed, 07 Mar 2007 06:06:37 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>,
       Albert Hopkins <kernel@marduk.letterboxes.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Pavel Machek <pavel@ucw.cz>,
       Marcel Holtmann <marcel@holtmann.org>, linux-pm@lists.osdl.org,
       maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Matt Mackall <mpm@selenic.com>,
       Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org
Subject: Re: [1/6] 2.6.21-rc2: known regressions
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de>
In-Reply-To: <20070305015031.GF3441@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Subject    : forcedeth: skb_over_panic
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8058
> Submitter  : Albert Hopkins <kernel@marduk.letterboxes.org>
> Status     : unknown


I think this is fixed by the recent forcedeth 3-patch patchset?  Can 
Albert or others confirm?

	Jeff



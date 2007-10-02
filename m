Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbXJBSyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbXJBSyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbXJBSyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:54:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53655 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbXJBSyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:54:01 -0400
Message-ID: <470293C7.6080906@garzik.org>
Date: Tue, 02 Oct 2007 14:53:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patch] SCSI aic94xx fix
References: <20071002172151.GA28579@havoc.gtf.org> <1191350862.3530.114.camel@localhost.localdomain>
In-Reply-To: <1191350862.3530.114.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> Sure, I'll state my case:  This is a bug, but it has no affected users,
> nor will it because the aic94xx doesn't work on non-x86 architectures by
> reason of other longstanding bugs (and TODEVICE/FROMDEVICE only matters

False.  It fails to work on _some_ non-x86 platforms.

	Jeff



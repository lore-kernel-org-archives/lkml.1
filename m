Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZEYBhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZEYBhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 21:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZEYBhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 21:37:24 -0400
Received: from xi.wantstofly.org ([80.101.37.227]:32844 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZEYBhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 21:37:23 -0400
Date: Mon, 25 May 2009 03:42:53 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andy Fleming <afleming@freescale.com>,
       "David S. Miller" <davem@davemloft.net>,
       Michael Guntsche <mike@it-loops.com>
Subject: Re: [Bug #13293] Kernel BUG under network load with gianfar
Message-ID: <20090525014253.GA14371@mail.wantstofly.org>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera> <uSztiUhmDDC.A.Y_.99bGKB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <uSztiUhmDDC.A.Y_.99bGKB@chimera>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 24, 2009 at 09:11:52PM +0200, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13293
> Subject		: Kernel BUG under network load with gianfar
> Submitter	: Michael Guntsche <mike@it-loops.com>
> Date		: 2009-05-03 13:36 (22 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0fd56bb5be6455d0d42241e65aed057244665e5e
> References	: http://marc.info/?l=linux-kernel&m=124135824600924&w=4
> Handled-By	: Lennert Buytenhek <buytenh@wantstofly.org>
> Patch		: http://patchwork.kernel.org/patch/25518/

The proposed patch has yet to be ACKed by the maintainer/merged, so
yes, this regression should still be listed.

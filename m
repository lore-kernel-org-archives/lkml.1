Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbYKXNgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbYKXNgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 08:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYKXNgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 08:36:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41839 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbYKXNgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 08:36:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #12031] DRM enabled kernel hangs hard on resume on x60
Date: Mon, 24 Nov 2008 14:36:20 +0100
User-Agent: KMail/1.9.9
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera> <vyitTh0pP2N.A.ATC.i7HKJB@chimera>
In-Reply-To: <vyitTh0pP2N.A.ATC.i7HKJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811241436.21457.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 22 of November 2008, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12031
> Subject		: DRM enabled kernel hangs hard on resume on x60
> Submitter	: Jens Axboe <jens.axboe@oracle.com>
> Date		: 2008-11-12 18:42 (11 days old)
> References	: http://marc.info/?l=linux-kernel&m=122651551216820&w=4
> Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>

I can reproduce this problem on Toshiba Portege R500, with the same symptoms
(please see the bug entry for details).

Well, we have at lease three DRM-related regressions in 2.6.28-rc and no
visible reaction from the developers/maintainers of the code in question. :-(

Thanks,
Rafael

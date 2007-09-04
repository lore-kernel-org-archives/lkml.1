Return-Path: <linux-kernel-owner+w=401wt.eu-S1752375AbXIDBDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbXIDBDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 21:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbXIDBDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 21:03:38 -0400
Received: from www.osadl.org ([213.239.205.134]:60362 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750748AbXIDBDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 21:03:38 -0400
Subject: Re: 2.6.23-rc4-mm1: boot failure on HPC nx6325
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <200709032251.22411.rjw@sisk.pl>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	 <200709022239.14175.rjw@sisk.pl> <1188808600.5698.9.camel@chaos>
	 <200709032251.22411.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 04 Sep 2007 03:03:18 +0200
Message-Id: <1188867798.3271.1.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-03 at 22:51 +0200, Rafael J. Wysocki wrote:
> > Also it would be interesting whether the -hrt patchset on top of rc5 has
> > the same problem:
> > 
> > http://www.tglx.de/projects/hrtimers/2.6.23-rc5/patch-2.6.23-rc5-hrt1.patches.tar.bz2
> 
> This one boots normally.

Thanks. that narrows down the wreckage window substantially.

	tglx



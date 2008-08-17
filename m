Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbYHQMZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbYHQMZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYHQMZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:25:45 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:1688 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbYHQMZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:25:44 -0400
Date: Sun, 17 Aug 2008 15:21:34 +0300
From: Martin Michlmayr <tbm@cyrius.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: [Bug #11333] Rewrite SSB DMA API breaks compilation on ARM
Message-ID: <20080817122134.GG5486@deprecation.cyrius.com>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.N4E.aazpIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sNRO-BDDjQL.A.N4E.aazpIB@albercik>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl> [2008-08-16 21:02]:
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).

This just got fixed by "[ARM] dma-mapping: provide sync_range APIs":
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9dd428680573d7867ee5e40fa3f059a98301d416

-- 
Martin Michlmayr
http://www.cyrius.com/

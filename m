Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbYHQMjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbYHQMjz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYHQMjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:39:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbYHQMjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:39:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [Bug #11333] Rewrite SSB DMA API breaks compilation on ARM
Date: Sun, 17 Aug 2008 14:43:12 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Michael Buesch <mb@bu3sch.de>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.N4E.aazpIB@albercik> <20080817122134.GG5486@deprecation.cyrius.com>
In-Reply-To: <20080817122134.GG5486@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808171443.12941.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of August 2008, Martin Michlmayr wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> [2008-08-16 21:02]:
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> 
> This just got fixed by "[ARM] dma-mapping: provide sync_range APIs":
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9dd428680573d7867ee5e40fa3f059a98301d416

Thanks, closed.

Rafael

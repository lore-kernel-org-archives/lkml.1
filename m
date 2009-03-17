Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbZCQNsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbZCQNsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 09:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbZCQNsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:48:15 -0400
Received: from ns.suse.de ([195.135.220.2]:35344 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbZCQNsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:48:14 -0400
Date: Tue, 17 Mar 2009 14:21:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: ext Hannes Eder <hannes@hanneseder.net>,
       "trivial@kernel.org" <trivial@kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 06/15] NULL noise: drivers/mtd/tests/mtd_*test.c
In-Reply-To: <49B0BE07.5080803@nokia.com>
Message-ID: <alpine.LNX.2.00.0903171421200.11733@jikos.suse.cz>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net> <20090305191457.30062.43881.stgit@f10box.hanneseder.net> <49B0BE07.5080803@nokia.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009, Artem Bityutskiy wrote:

> Hannes Eder wrote:
> > Fix this sparse warnings:
> >   drivers/mtd/tests/mtd_oobtest.c:139:33: warning: Using plain integer as
> > NULL pointer
> >   drivers/mtd/tests/mtd_oobtest.c:192:33: warning: Using plain integer as
> > NULL pointer
> >   drivers/mtd/tests/mtd_oobtest.c:219:41: warning: Using plain integer as
> > NULL pointer
> >   drivers/mtd/tests/mtd_oobtest.c:284:25: warning: Using plain integer as
> > NULL pointer
> >   drivers/mtd/tests/mtd_oobtest.c:525:25: warning: Using plain integer as
> > NULL pointer
> >   drivers/mtd/tests/mtd_oobtest.c:545:25: warning: Using plain integer as
> > NULL pointer
> >   drivers/mtd/tests/mtd_oobtest.c:569:33: warning: Using plain integer as
> > NULL pointer
> >   drivers/mtd/tests/mtd_oobtest.c:589:33: warning: Using plain integer as
> > NULL pointer
> >   drivers/mtd/tests/mtd_oobtest.c:613:33: warning: Using plain integer as
> > NULL pointer
> >   drivers/mtd/tests/mtd_oobtest.c:633:33: warning: Using plain integer as
> > NULL pointer
> >   drivers/mtd/tests/mtd_oobtest.c:673:41: warning: Using plain integer as
> > NULL pointer
> >   drivers/mtd/tests/mtd_oobtest.c:701:33: warning: Using plain integer as
> > NULL pointer
> >   drivers/mtd/tests/mtd_readtest.c:74:41: warning: Using plain integer as
> > NULL pointer
> > 
> > Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> > Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Yes, please, take this patch.

Doesn't seem to be present in current -next/-mmotim, applied to trivial
tree.

-- 
Jiri Kosina

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZC0Kaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZC0Kaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 06:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZC0KaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 06:30:17 -0400
Received: from www.tglx.de ([62.245.132.106]:40816 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbZC0KaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 06:30:16 -0400
Date: Fri, 27 Mar 2009 11:29:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: liqin.chen@sunplusct.com
cc: Will Newton <will.newton@gmail.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 0/13] score - New architecure port to SunplusCT S+CORE
 processor
In-Reply-To: <OF39905543.8F85F55B-ON48257586.000793DC-48257586.0007F946@sunplusct.com>
Message-ID: <alpine.LFD.2.00.0903271125380.3397@localhost.localdomain>
References: <OF39905543.8F85F55B-ON48257586.000793DC-48257586.0007F946@sunplusct.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009, liqin.chen@sunplusct.com wrote:
> > >> > We would like to release a patch for kernel 2.6.29-rc8.
> > >> > This patch include score header files, arch files and serial driver
> > > for
> > >> > spct6600(score core) platform.
> > >> >
> > >> > For the other driver patches, I'll send them one by one in
> > >> > small size latter. Thanks!
> > >> >
> > >> > Would you merge them to the stock kernel?
> > >> >
> > >> > Patch information is slightly bigger, so I placed it on our 
> SunplusCT
> > > web
> > >> > site.
> > >> >
> > > 
> http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch

Please split the patches further into logical and reviewable
pieces. Also each patch needs a patch description which will be the
change log in the git repository and your Signed-off-by line. Also
each patch needs a unique and useful subject line in the mail.

Download references for such patches are useless.

See Documentation/SubmittingPatches

Thanks,

	tglx

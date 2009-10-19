Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbZJSPYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbZJSPYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbZJSPYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:24:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:50460 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756267AbZJSPYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:24:44 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+tHwwx6kat1zZ/WrAbEXJqS1CQeF2HS4ioQ1rd50
	pkeyvIQ0ODq/W9
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH] staging/et131x:  adding __init/__exit macros
Date: Mon, 19 Oct 2009 17:24:44 +0200
User-Agent: KMail/1.9.10
Cc: Jiri Kosina <jkosina@suse.cz>, Alan Cox <alan@linux.intel.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <200909290134.15295.PeterHuewe@gmx.de> <alpine.LSU.2.00.0909291107410.9280@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0909291107410.9280@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910191724.45300.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tuesday 29 September 2009 11:10:01 schrieb Jiri Kosina:
> On Tue, 29 Sep 2009, Peter Huewe wrote:
> > From: Peter Huewe <peterhuewe@gmx.de>
> >
> > Trivial patch which adds the __init/__exit macros to the module_init/
> > module_exit functions of ./staging/et131x/et131x_initpci.c
> >
> > Greg, please have a look at the small patch and either pull it through
> > your staging tree, or please ack' it so Jiri can pull it through the
> > trivial tree.
>
> Greg -- I'd prefer you taking trivial staging fixes through yoru tree, as
> I expect we'll be conflicting soon due to the speed of changes in staging
> area, if you don't have any objections.
>
> Thanks,


Hi Greg,

any updates on this patch?
If I should recreate the patch against the linux-next tree, or your staging 
tree, please tell me.

Same applies to 
[PATCH] staging/cx25821:  adding __init/__exit macros
[PATCH] staging/p9auth:  adding __init/__exit macros
[PATCH] staging/phison:  adding __init/__exit macros
and somewhat also to
[PATCH] staging/panel: prevent driver from calling misc_deregister twice on 
same ressource


Thanks,
Peter



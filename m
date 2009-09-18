Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbZIRKZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbZIRKZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 06:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbZIRKZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 06:25:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:52168 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZIRKZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 06:25:10 -0400
Date: Fri, 18 Sep 2009 12:25:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>, Nicolas Palix <npalix@diku.dk>,
       Mike Frysinger <vapier@gentoo.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] char/hvc: adding __init macro to char/hvc_vio.c
In-Reply-To: <200909170238.40051.PeterHuewe@gmx.de>
Message-ID: <alpine.LNX.2.00.0909181224570.17028@wotan.suse.de>
References: <200908202314.07443.PeterHuewe@gmx.de> <200909170238.40051.PeterHuewe@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009, Peter Huewe wrote:

> > Please have a look at the small patch and either pull it through
> > your tree, or please ack' it so Jiri can pull it through the trivial tree.
> >
> > linux version 2.6.31-rc6 - linus git tree, Do 20. Aug 22:26:06 CEST 2009
> >
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> 
> Hi Jiri,
> this one got merged by Benjamin, so you can drop it from your queue :)
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=948c28fe3001f2c9d852dff2a0b2c69fe7cec91b

Dropped, thanks for letting me know.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbYHDO37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbYHDO37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbYHDO3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:29:41 -0400
Received: from mx1.suse.de ([195.135.220.2]:49024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbYHDO3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:29:40 -0400
Date: Mon, 4 Aug 2008 16:29:39 +0200
From: Karsten Keil <kkeil@suse.de>
To: isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
Message-ID: <20080804142939.GA21702@pingi.kke.suse.de>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de> <1217851439.3454.605.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217851439.3454.605.camel@pmac.infradead.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 01:03:59PM +0100, David Woodhouse wrote:
> On Sat, 2008-08-02 at 16:35 +0200, Karsten Keil wrote:
> > The driver was not so bad at big endian at all, only the optimised fifo
> > read/write functions need a fix, with this fix the driver works on
> > a pegasus PPC machine.
> 
> Great; thanks.
> 
> And the ztdummy parts? 
> 

I on my TODO.

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)

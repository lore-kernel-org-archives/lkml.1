Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbYG0SWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbYG0SWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 14:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbYG0SWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 14:22:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbYG0SWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 14:22:00 -0400
Date: Sun, 27 Jul 2008 20:21:58 +0200
From: Karsten Keil <kkeil@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sean MacLennan <smaclennan@pikatech.com>
Subject: Re: [PATCH] isdn: mISDN HFC PCI support depends on virt_to_bus()
Message-ID: <20080727182158.GA13526@pingi.kke.suse.de>
References: <20080728023732.090aff83.sfr@canb.auug.org.au> <20080727133918.72cbb127@lappy.seanm.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727133918.72cbb127@lappy.seanm.ca>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 01:39:18PM -0400, Sean MacLennan wrote:
> On Mon, 28 Jul 2008 02:37:32 +1000
> "Stephen Rothwell" <sfr@canb.auug.org.au> wrote:
> 
> > On powerpc (allyesconfig build) we get this error:
> > 
> > drivers/isdn/hardware/mISDN/hfcpci.c:1991: error: implicit
> > declaration of function 'virt_to_bus'
> 
> When did mISDN make it into the kernel? And which kernel tree is it in?
> I don't see it in the Linux next tree....

It is there in his master branch.


> 
> I am very interested since we are trying to get mISDN working on the
> Warp. There was no notice that they got 2.6.26 compiling.
> 

Good to hear.

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)

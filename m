Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYIPIkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYIPIkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 04:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYIPIjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 04:39:52 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:44399 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbYIPIjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 04:39:51 -0400
Date: Tue, 16 Sep 2008 11:39:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: tsbogend@alpha.franken.de, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
Message-ID: <20080916083934.GA7397@cs181140183.pp.htv.fi>
References: <20080915204543.GD3994@havoc.gtf.org> <20080915.141442.139271313.davem@davemloft.net> <20080915215307.GA10340@alpha.franken.de> <20080915.151125.93659986.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080915.151125.93659986.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 03:11:25PM -0700, David Miller wrote:
> From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
> Date: Mon, 15 Sep 2008 23:53:08 +0200
> 
> > On Mon, Sep 15, 2008 at 02:14:42PM -0700, David Miller wrote:
> > > Most of those changes were complete and utter CRAP.
> > 
> > thank you, but the fix I've sent (de2104x) isn't crap. The bug breaks the 
> > current debian-installer for Cobalt Qube1, when it tries to get an
> > IP address via dhcp. 
> 
> And why is this bug that has been there for YEARS is appropriate
> to fix outside of the merge window?
>...

Such a fix is even suitable for -stable.

If something is considered suitable for -stable, but not for -rc with 
one month to go before the release of the kernel, then there's something 
wrong in the process.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


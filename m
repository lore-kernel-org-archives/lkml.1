Return-Path: <linux-kernel-owner+w=401wt.eu-S1030658AbXDPOaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030658AbXDPOaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030664AbXDPOaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:30:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52131 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030658AbXDPOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:30:04 -0400
Date: Mon, 16 Apr 2007 16:30:12 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>
Cc: Mike Snitzer <snitzer@gmail.com>, Neil Brown <neilb@suse.de>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070416143012.GC10338@stusta.de>
References: <op.tqqwdfzcftfxs2@localhost.localdomain> <17952.5537.364603.419364@notabene.brown> <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com> <Pine.BSO.4.63.0704161140460.11088@rudy.mif.pg.gda.pl> <170fa0d20704160507w4af4cb92ua259a55789f95c3e@mail.gmail.com> <Pine.BSO.4.63.0704161419260.11088@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.BSO.4.63.0704161419260.11088@rudy.mif.pg.gda.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 04:01:23PM +0200, Tomasz Kłoczko wrote:
>...
> Few days ago I'm swich two backup servers with few TB storage from Linux to 
> Solaris .. only because client want use ZFS .. because ZFS is EXCELENT for 
> this kind tasks (only because it allow save many thousands of 
> <put_your_currency_name> because it allow better utilize the same storage) 
> and trust me .. cases like this will be more .. much more and changing 
> licensing Linux code will be MUCH more easier than reinventing wheel (wich 
> will be reimplemnting ZFS under GPL).

This is a technical mailing list, so let's start with technical 
arguments:

Why did this client want to use ZFS?

Because his boss was convinced by a marketing guy that ZFS was the best 
invention since sliced bread?

Or due to technical limitations in what Linux currently offers 
resulting in ZFS bringing him direct advantages on these servers?

If the latter, what exactly?

> Problem is not on technical area but on licensing and it is plain Linux 
> word problem because neccessary in this case changes on CDDL side will make 
> this code less oppended than now .. so you can (probably ?) forget about 
> GPLing ZFS code (and ZFS it is not all what will good to have from Sol in 
> Linux).
> IMO current Linux licensing less is importand than bringing in possible 
> simpler way things like ZFS to Linux. So best/simpler way will be start 
> change Linux licensing for save all GPL goodies and allow interract with 
> code on license like CDDL.
> 
> Licensing is for allow keep in best possible form Linux. If it can't do 
> this in best possible way it must be change (must evolve .. like many othes 
> things around).

There are at about 10.000 people who contributed to the Linux kernel, 
some of them unreachable or even dead.

AFAIK the only way to relicense the Linux kernel that wouldn't be 
legally questionable in any jurisdiction would be to get each one of 
them to agree to the license change.

IOW, it's more or less practically impossible to relicense the kernel.

If the GPL is a problem for you, FreeBSD might be a good choice for you.

> kloczek

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


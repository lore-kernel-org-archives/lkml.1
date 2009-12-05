Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbZLEKaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbZLEKaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 05:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZLEKay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 05:30:54 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46566 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbZLEKay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 05:30:54 -0500
Date: Sat, 5 Dec 2009 10:30:38 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the pcmcia tree with the arm tree
Message-ID: <20091205103038.GA11140@flint.arm.linux.org.uk>
References: <20091201140310.46dbdc59.sfr@canb.auug.org.au> <20091202115649.GA2150@rainbow> <20091203092525.17d939b3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203092525.17d939b3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 09:25:25AM +1100, Stephen Rothwell wrote:
> Hi Dmitry,
> 
> On Wed, 2 Dec 2009 14:56:49 +0300 Dmitry Artamonow <mad_soft@inbox.ru> wrote:
> >
> > Fix looks good to me, and testing next-20091201 on real device (h3600)
> > shows no problems with pcmcia.
> 
> Thanks for the confirmation.

Since Dominik has been ignoring this issue, and has already asked Linus to
pull his tree with my (unfortunately just discovered buggy) changes in, I'm
going to drop the H3600 PCMCIA changes until something can be sorted out.

There's nothing like communication between maintainers...

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
